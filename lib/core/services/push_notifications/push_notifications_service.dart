import 'dart:async';

import 'package:evetick/core/services/push_notifications/push_background_handler.dart';
import 'package:evetick/core/services/push_notifications/push_banner_presenter.dart';
import 'package:evetick/core/services/push_notifications/push_notification_router.dart';
import 'package:evetick/core/services/push_notifications/push_tokens_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Push notifications (Firebase Cloud Messaging).
///
///  - app closed / in background: the system shows the push; tapping it
///    opens the notifications screen (and the event, if there is one).
///  - app open: a [PushBanner] is shown instead.
///  - the device token is saved when the user reaches Home ([onHomeReady]),
///    and removed on logout (see AuthRepository.logout).
///
/// In debug builds every step prints a line starting with `[PUSH]`.
class PushNotificationsService {
  PushNotificationsService(this._tokensRepo);

  final PushTokensRepository _tokensRepo;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// A push that opened the app from closed: handled once Home is on screen.
  Map<String, dynamic>? _pendingTap;

  void _log(String message) {
    if (kDebugMode) debugPrint('[PUSH] $message');
  }

  /// Call once from main(), after Firebase.initializeApp.
  /// Never throws: the app must start even if push is not available.
  Future<void> init() async {
    try {
      FirebaseMessaging.onBackgroundMessage(pushBackgroundHandler);

      FirebaseMessaging.onMessage.listen((message) {
        _log('received in foreground: ${message.notification?.title}');
        _showBanner(message);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _log('opened from background: ${message.data}');
        PushNotificationRouter.open(message.data);
      });
      _messaging.onTokenRefresh.listen((token) {
        _log('token refreshed');
        _tokensRepo.saveToken(token);
      });

      final initial = await _messaging.getInitialMessage();
      if (initial != null) _pendingTap = initial.data;

      _log('init OK');
    } catch (e) {
      _log('init FAILED: $e');
    }
  }

  /// Call when the Home screen is shown to a logged in user.
  Future<void> onHomeReady() async {
    _log('onHomeReady');

    final pending = _pendingTap;
    _pendingTap = null;
    if (pending != null) PushNotificationRouter.open(pending);

    await _registerDevice();
  }

  Future<void> _registerDevice() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _log('no signed in user -> token not saved');
      return;
    }
    if (user.isAnonymous) {
      _log('guest account -> token not saved (log in with a real account)');
      return;
    }

    try {
      final settings = await _messaging.requestPermission();
      _log('permission: ${settings.authorizationStatus.name}');
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final token = await _messaging.getToken();
      if (token == null) {
        _log('getToken returned null (no Google Play services?)');
        return;
      }
      // Copy this token into Firebase Console > Messaging > "Send test
      // message" to check the device receives pushes.
      _log('FCM token: $token');

      final saved = await _tokensRepo.saveToken(token);
      _log(saved
          ? 'token saved in users/${user.uid}/fcmTokens'
          : 'token NOT saved (see the line above)');
    } catch (e) {
      _log('register FAILED: $e');
    }
  }

  void _showBanner(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    PushBannerPresenter.show(
      title: notification.title ?? '',
      body: notification.body ?? '',
      onTap: () => PushNotificationRouter.open(message.data),
    );
  }
}
