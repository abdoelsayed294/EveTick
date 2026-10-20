import 'package:evetick/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Runs when a push arrives while the app is in the background or closed.
/// Must be a top-level function. The system already shows the notification
/// (the server sends a `notification` part), so nothing else is needed here.
@pragma('vm:entry-point')
Future<void> pushBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Push received in background: ${message.messageId}');
}
