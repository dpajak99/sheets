import 'dart:async';
import 'package:flutter/material.dart';

class RepeatActionTimer {
  RepeatActionTimer({
    required this.startDuration,
    required this.nextHoldDuration,
  });

  final Duration startDuration;
  final Duration nextHoldDuration;
  Timer? _holdStartTimer;
  Timer? _holdPressTimer;

  void start(VoidCallback callback) {
    reset();

    _holdStartTimer = Timer(startDuration, () {
      _setHoldPressTimer(callback);
    });
  }

  void reset() {
    _holdStartTimer?.cancel();
    _holdStartTimer = null;

    _holdPressTimer?.cancel();
    _holdPressTimer = null;
  }

  void _setHoldPressTimer(VoidCallback callback) {
    _holdPressTimer = Timer.periodic(nextHoldDuration, (_) => callback());
  }
}
