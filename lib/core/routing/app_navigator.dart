import 'package:flutter/material.dart';

/// Lets code without a BuildContext (push notification taps) open screens.
/// Passed to MaterialApp as `navigatorKey`.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
