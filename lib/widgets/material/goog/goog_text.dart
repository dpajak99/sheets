import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';

class GoogText extends StatelessWidget {
  const GoogText(
    this._text, {
    String? fontFamily,
    String? package,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    TextOverflow? textOverflow,
    Color? color,
    super.key,
  })  : _color = color,
        _fontFamily = fontFamily,
        _package = package,
        _fontSize = fontSize,
        _height = height,
        _fontWeight = fontWeight,
        _textOverflow = textOverflow ?? TextOverflow.ellipsis;

  final String _text;
  final String? _fontFamily;
  final String? _package;
  final double? _fontSize;
  final double? _height;
  final FontWeight? _fontWeight;
  final TextOverflow _textOverflow;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    GoogTextThemeData? textTheme = GoogTextTheme.of(context);

    return Text(
      _text,
      overflow: _textOverflow,
      style: TextStyle(
        fontFamily: _fontFamily ?? textTheme?.fontFamily,
        package: _package ?? textTheme?.package,
        fontSize: _fontSize ?? textTheme?.fontSize,
        height: _height ?? textTheme?.height,
        fontWeight: _fontWeight ?? textTheme?.fontWeight,
        color: _color ?? textTheme?.color,
      ),
    );
  }
}

class GoogTextTheme extends StatefulWidget {
  const GoogTextTheme({
    required this.child,
    this.fontFamily,
    this.package,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.color,
    super.key,
  });

  final Widget child;
  final String? fontFamily;
  final String? package;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;

  static GoogTextThemeData? of(BuildContext context) {
    return context.findAncestorStateOfType<GoogTextThemeData>();
  }

  @override
  State<StatefulWidget> createState() => GoogTextThemeData();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('fontFamily', fontFamily));
    properties.add(StringProperty('package', package));
    properties.add(DoubleProperty('fontSize', fontSize));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<FontWeight?>('fontWeight', fontWeight));
    properties.add(ColorProperty('color', color));
  }
}

class GoogTextThemeData extends State<GoogTextTheme> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  String? get fontFamily => widget.fontFamily;

  String? get package => widget.package;

  double? get fontSize => widget.fontSize;

  double? get height => widget.height;

  FontWeight? get fontWeight => widget.fontWeight;

  Color? get color => widget.color;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('fontFamily', fontFamily));
    properties.add(StringProperty('package', package));
    properties.add(DoubleProperty('fontSize', fontSize));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<FontWeight?>('fontWeight', fontWeight));
    properties.add(ColorProperty('color', color));
  }
}
