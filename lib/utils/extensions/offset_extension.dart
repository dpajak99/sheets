import 'package:flutter/material.dart';

extension OffsetExtension on Offset {
  Offset reverse() {
    return Offset(dy, dx);
  }
}