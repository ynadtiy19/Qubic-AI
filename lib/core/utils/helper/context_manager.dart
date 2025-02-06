import 'package:flutter/material.dart';

class ContextManager {
  const ContextManager._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get context {
    if (navigatorKey.currentContext == null) {
      throw Exception("Context is not available yet!");
    }
    return navigatorKey.currentContext!;
  }
}
