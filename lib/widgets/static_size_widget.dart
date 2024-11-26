import 'package:flutter/material.dart';

// ignore_for_file: avoid_implementing_value_types
// ignore_for_file: diagnostic_describe_all_properties
abstract interface class StaticSizeWidget implements Widget {
  Size get size;

  EdgeInsets get margin;
}
