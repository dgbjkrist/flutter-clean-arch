import 'dart:async';
import 'package:flutter/material.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  SessionManager._internal();

  Timer? _inactivityTimer;
  VoidCallback? onSessionTimeout;

  void startTimer({required VoidCallback onTimeout}) {
    onSessionTimeout = onTimeout;
    resetTimer();
  }

  void resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 1), () {
      if (onSessionTimeout != null) {
        onSessionTimeout!();
      }
    });
  }

  void cancelTimer() {
    _inactivityTimer?.cancel();
  }
}
