import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';

class GoogIcon extends StatelessWidget {
  const GoogIcon(
      this._icon, {
        double? width,
        double? height,
        Color? color,
        super.key,
      })  : _color = color,
        _width = width,
        _height = height;

  final AssetIconData _icon;
  final double? _width;
  final double? _height;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    GoogIconThemeData? iconTheme = GoogIconTheme.of(context);

    return AssetIcon(
      _icon,
      color: _color ?? iconTheme?.color,
      width: _width ?? iconTheme?.width,
      height: _height ?? iconTheme?.height,
    );
  }
}

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
