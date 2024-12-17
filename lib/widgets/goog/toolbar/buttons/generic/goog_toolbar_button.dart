import 'package:flutter/material.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogToolbarButton extends StatelessWidget implements StaticSizeWidget {
  GoogToolbarButton({
    required Widget child,
    VoidCallback? onTap,
    bool? selected,
    bool? disabled,
    double? width,
    double? height,
    GoogToolbarButtonStyle? style,
    EdgeInsets? margin,
    EdgeInsets? padding,
    super.key,
  })  : _child = child,
        _onTap = onTap,
        _selected = selected ?? false,
        _disabled = disabled ?? false,
        _width = width ?? 30,
        _height = height ?? 30,
        _style = style ?? GoogToolbarButtonStyle.defaultStyle(),
        _margin = margin ?? const EdgeInsets.all(1),
        _padding = padding ?? const EdgeInsets.only(top: 10, bottom: 9);

  final bool _selected;
  final bool _disabled;
  final double _width;
  final double _height;
  final GoogToolbarButtonStyle _style;
  final Widget _child;
  final VoidCallback? _onTap;
  final EdgeInsets _margin;
  final EdgeInsets _padding;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => Size(_width, _height);

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onTap,
      selected: _selected,
      disabled: _disabled,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Color backgroundColor = _style.backgroundColor.resolve(states);
        Color foregroundColor = _style.foregroundColor.resolve(states);

        return Container(
          width: _width,
          height: _height,
          margin: _margin,
          padding: _padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Align(
            child: GoogTextTheme(
              fontFamily: 'GoogleSans',
              package: 'sheets',
              fontSize: 13,
              height: 1,
              fontWeight: FontWeight.w500,
              color: foregroundColor,
              child: GoogIconTheme(
                color: foregroundColor,
                child: _child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class GoogToolbarButtonStyle {
  const GoogToolbarButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.opacity,
  });

  factory GoogToolbarButtonStyle.defaultStyle() {
    WidgetStateProperty<Color> backgroundColor = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xffd3e3fd);
      } else if (states.contains(WidgetState.pressed)) {
        return const Color(0xffdbdfe4);
      } else if (states.contains(WidgetState.hovered)) {
        return const Color(0xffe2e7ea);
      } else {
        return Colors.transparent;
      }
    });

    WidgetStateProperty<Color> foregroundColor = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF041e49);
      } else if (states.contains(WidgetState.pressed)) {
        return const Color(0xFF444746);
      } else if (states.contains(WidgetState.hovered)) {
        return const Color(0xFF444746);
      } else {
        return const Color(0xFF444746);
      }
    });

    WidgetStateProperty<double> opacity = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return 0.3;
      } else {
        return 1;
      }
    });

    return GoogToolbarButtonStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      opacity: opacity,
    );
  }

  GoogToolbarButtonStyle copyWith({
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? foregroundColor,
    WidgetStateProperty<double>? opacity,
  }) {
    return GoogToolbarButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      opacity: opacity ?? this.opacity,
    );
  }

  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
  final WidgetStateProperty<double> opacity;
}
