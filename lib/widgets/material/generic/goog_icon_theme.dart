import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GoogIconTheme extends StatefulWidget {
  const GoogIconTheme({
    required this.child,
    required this.data,
    super.key,
  });

  final Widget child;
  final GoogIconThemeData data;

  GooglIconThemeState? of(BuildContext context) {
    return context.findAncestorStateOfType<GooglIconThemeState>();
  }

  @override
  State<StatefulWidget> createState() => GooglIconThemeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GoogIconThemeData>('data', data));
  }
}

class GooglIconThemeState extends State<GoogIconTheme> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  GoogIconThemeData get data => widget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GoogIconThemeData>('data', data));
  }
}

class GoogIconThemeData {
  const GoogIconThemeData({
    required WidgetStateProperty<double> size,
    required WidgetStateProperty<Color> color,
  }) : _color = color, _size = size;

  final WidgetStateProperty<double> _size;
  final WidgetStateProperty<Color> _color;
}
