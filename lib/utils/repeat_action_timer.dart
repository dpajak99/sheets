import 'dart:async';
import 'package:flutter/material.dart';

class RepeatActionTimer {
  RepeatActionTimer({
    required this.startDuration,
    required this.nextHoldDuration,
  });

  final Duration startDuration;
  final Duration nextHoldDuration;
  Timer? holdStartTimer;
  Timer? holdPressTimer;

  void start(VoidCallback callback) {
    reset();

    holdStartTimer = Timer(startDuration, () {
      _setHoldPressTimer(callback);
    });
  }

  void reset() {
    holdStartTimer?.cancel();
    holdStartTimer = null;

    holdPressTimer?.cancel();
    holdPressTimer = null;
  }

  void _setHoldPressTimer(VoidCallback callback) {
    holdPressTimer = Timer.periodic(nextHoldDuration, (_) => callback());
  }
}
