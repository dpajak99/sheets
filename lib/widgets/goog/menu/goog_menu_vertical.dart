import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/popup/sheet_popup.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogMenuVertical extends StatelessWidget {
  const GoogMenuVertical({
    required double width,
    required List<Widget> children,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    super.key,
  })  : _width = width,
        _children = children,
        _backgroundColor = backgroundColor ?? Colors.white,
        _borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(3)),
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 1, vertical: 7);

  final double _width;
  final Color _backgroundColor;
  final BorderRadius _borderRadius;
  final EdgeInsets _padding;
  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
        boxShadow: const <BoxShadow>[MaterialSheetTheme.materialShadow],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: _borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _children,
        ),
      ),
    );
  }
}

class GoogSubmenuItem extends StatefulWidget {
  const GoogSubmenuItem({
    required this.label,
    required this.popupBuilder,
    this.leading,
    this.level = 2,
    this.iconPlaceholderVisible,
    super.key,
  });

  final Widget label;
  final PopupBuilder popupBuilder;
  final Widget? leading;
  final int level;
  final bool? iconPlaceholderVisible;

  @override
  State<GoogSubmenuItem> createState() => _GoogSubmenuItemState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<PopupBuilder>.has('popupBuilder', popupBuilder));
    properties.add(IntProperty('level', level));
    properties.add(DiagnosticsProperty<bool?>('iconPlaceholderVisible', iconPlaceholderVisible));
  }
}

class _GoogSubmenuItemState extends State<GoogSubmenuItem> {
  final DropdownButtonController _controller = DropdownButtonController();

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      level: widget.level,
      controller: _controller,
      popupAlignment: Alignment.topRight,
      activateDropdownBehavior: ActivateDropdownBehavior.manual,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return GoogMenuItem(
          onPressed: _controller.toggle,
          label: widget.label,
          leading: widget.leading,
          iconPlaceholderVisible: widget.iconPlaceholderVisible,
          trailing: const GoogIcon(SheetIcons.docs_icon_arrow_more),
        );
      },
      popupBuilder: widget.popupBuilder,
    );
  }
}

class GoogMenuItem extends StatelessWidget {
  GoogMenuItem({
    required Widget label,
    GoogMenuButtonStyle? style,
    Widget? leading,
    Widget? trailing,
    double? width,
    double? height,
    double? gap,
    Size? iconSize,
    EdgeInsets? padding,
    VoidCallback? onPressed,
    bool? iconPlaceholderVisible,
    bool? disabled,
    super.key,
  })  : _label = label,
        _style = style ?? GoogMenuButtonStyle.defaultStyle(),
        _leading = leading,
        _trailing = trailing,
        _width = width ?? double.infinity,
        _height = height ?? 32,
        _gap = gap ?? 10,
        _iconSize = iconSize ?? const Size.square(16),
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 14),
        _iconPlaceholderVisible = iconPlaceholderVisible ?? true,
        _disabled = disabled ?? false,
        _onPressed = onPressed;

  final Widget _label;
  final GoogMenuButtonStyle _style;
  final double _width;
  final double _height;
  final double _gap;
  final Size _iconSize;
  final EdgeInsets _padding;
  final Widget? _leading;
  final Widget? _trailing;
  final VoidCallback? _onPressed;
  final bool _iconPlaceholderVisible;
  final bool _disabled;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      disabled: _disabled,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Color backgroundColor = _style.backgroundColor.resolve(states);
        Color foregroundColor = _style.foregroundColor.resolve(states);

        return Container(
          width: _width,
          height: _height,
          padding: _padding,
          decoration: BoxDecoration(color: backgroundColor),
          child: Row(
            children: <Widget>[
              if (_iconPlaceholderVisible) ...<Widget>[
                SizedBox.fromSize(
                  size: _iconSize,
                  child: GoogIconTheme(
                    color: foregroundColor,
                    child: Center(child: _leading),
                  ),
                ),
                SizedBox(width: _gap),
              ],
              Expanded(
                child: GoogTextTheme(
                  fontFamily: 'Roboto',
                  package: 'sheets',
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff26272a),
                  child: _label,
                ),
              ),
              if (_trailing != null) ...<Widget>[
                GoogTextTheme(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'GoogleSans',
                  package: 'sheets',
                  color: const Color(0xff80868B),
                  child: _trailing,
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

class GoogMenuIconButton extends StatelessWidget {
  GoogMenuIconButton({
    required AssetIconData icon,
    required VoidCallback onPressed,
    GoogMenuButtonStyle? style,
    double? size,
    EdgeInsets? padding,
    super.key,
  })  : _icon = icon,
        _onPressed = onPressed,
        _style = style ?? GoogMenuButtonStyle.defaultStyle(),
        _size = size ?? 21,
        _padding = padding ?? const EdgeInsets.only(bottom: 4, right: 4, top: 3, left: 3);

  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final GoogMenuButtonStyle _style;
  final double _size;
  final EdgeInsets _padding;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _style.backgroundColor.resolve(states);
        Color? foregroundColor = _style.foregroundColor.resolve(states);

        return Container(
          height: _size,
          width: _size,
          padding: _padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: AssetIcon(_icon, color: foregroundColor),
        );
      },
    );
  }
}

class GoogMenuButtonStyle {
  GoogMenuButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory GoogMenuButtonStyle.defaultStyle() {
    WidgetStateProperty<Color> backgroundColor = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return const Color(0xFFE8EAED);
      } else if (states.contains(WidgetState.hovered)) {
        return const Color(0xFFF1F3F4);
      } else {
        return Colors.transparent;
      }
    });

    WidgetStateProperty<Color> foregroundColor = WidgetStateProperty.all(const Color(0xFF444746));

    return GoogMenuButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor);
  }

  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
}

class GoogMenuSeperator extends StatelessWidget {
  const GoogMenuSeperator({
    double? weight,
    Color? color,
    EdgeInsets? padding,
    super.key,
  })  : _color = color ?? const Color(0xFFDADCE0),
        _weight = weight ?? 1,
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  const GoogMenuSeperator.expand({
    double? weight,
    Color? color,
    EdgeInsets? padding,
    super.key,
  })  : _color = color ?? const Color(0xFFDADCE0),
        _weight = weight ?? 1,
        _padding = padding ?? const EdgeInsets.symmetric(vertical: 8);

  final double _weight;
  final Color _color;
  final EdgeInsets _padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _padding,
      child: Center(
        child: Container(
          height: _weight,
          width: double.infinity,
          color: _color,
        ),
      ),
    );
  }
}

class GoogMenuSectionHeader extends StatelessWidget {
  const GoogMenuSectionHeader({
    required Widget label,
    EdgeInsets? padding,
    AssetIconData? icon,
    super.key,
  })  : _label = label,
        _padding = padding ?? const EdgeInsets.only(top: 9, bottom: 10, left: 12, right: 12),
        _icon = icon;

  final Widget _label;
  final EdgeInsets _padding;
  final AssetIconData? _icon;

  @override
  Widget build(BuildContext context) {
    Widget label = GoogTextTheme(
      fontFamily: 'Roboto',
      package: 'sheets',
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3C4043),
      child: _label,
    );

    if (_icon != null) {
      label = Row(
        children: <Widget>[
          label,
          _GoogMenuSectionHeaderButton(icon: _icon, onPressed: () {}),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: _padding,
      child: label,
    );
  }
}

class _GoogMenuSectionHeaderButton extends StatelessWidget {
  _GoogMenuSectionHeaderButton({
    required AssetIconData icon,
    required VoidCallback onPressed,
    GoogMenuButtonStyle? style,
    double? width,
    double? height,
  })  : _icon = icon,
        _onPressed = onPressed,
        _style = style ?? GoogMenuButtonStyle.defaultStyle(),
        _width = width ?? 24,
        _height = height ?? 22;

  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final GoogMenuButtonStyle _style;
  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _style.backgroundColor.resolve(states);
        Color? foregroundColor = _style.foregroundColor.resolve(states);

        return Container(
          width: _width,
          height: _height,
          padding: const EdgeInsets.only(top: 3, bottom: 7, left: 4, right: 7),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(child: AssetIcon(_icon, color: foregroundColor)),
        );
      },
    );
  }
}
