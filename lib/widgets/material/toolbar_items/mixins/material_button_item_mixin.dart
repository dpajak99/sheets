import 'package:flutter/material.dart';

mixin MaterialToolbarButtonMixin {
  bool get active;

  Color getBackgroundColor(Set<WidgetState> states) {
    if (active) {
      return const Color(0xffD8E2F9);
    } else if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color getForegroundColor(Set<WidgetState> states) {
    if (active) {
      return const Color(0xff0f1e45);
    } else {
      return const Color(0xff444746);
    }
  }
}