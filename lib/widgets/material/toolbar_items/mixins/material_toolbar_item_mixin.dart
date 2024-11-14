import 'package:flutter/material.dart';

mixin MaterialToolbarItemMixin {
  double get width;

  double get height;

  EdgeInsets get margin;

  double get totalWidth => width + margin.horizontal;
}
