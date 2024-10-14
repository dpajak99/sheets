import 'dart:async';

import 'package:flutter/material.dart';

class PanHoldRecognizer {
  Timer? _holdPressTimer;

  void start(VoidCallback callback) {
    reset();
    _setHoldPressTimer(callback);
  }

  void reset() {
    _holdPressTimer?.cancel();
    _holdPressTimer = null;
  }

  void _setHoldPressTimer(VoidCallback callback) {
    _holdPressTimer = Timer(const Duration(milliseconds: 50), callback);
  }
}
