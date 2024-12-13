import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GoogIconTheme extends StatefulWidget {
  const GoogIconTheme({
    required this.child,
    this.color,
    this.height,
    this.width,
    super.key,
  });

  final Widget child;
  final double? height;
  final double? width;
  final Color? color;

  static GoogIconThemeData? of(BuildContext context) {
    return context.findAncestorStateOfType<GoogIconThemeData>();
  }

  @override
  State<StatefulWidget> createState() => GoogIconThemeData();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
    properties.add(ColorProperty('color', color));

  }
}

class GoogIconThemeData extends State<GoogIconTheme> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  double? get width => widget.width;

  double? get height => widget.height;

  Color? get color => widget.color;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(ColorProperty('color', color));
  }
}
