import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class DropdownListMenu extends StatelessWidget {
  const DropdownListMenu({
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
    return _DropdownListMenuLayout(
      width: _width,
      backgroundColor: _backgroundColor,
      borderRadius: _borderRadius,
      padding: _padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _children,
      ),
    );
  }
}

class DropdownListMenuItem extends StatelessWidget {
  const DropdownListMenuItem({
    required String label,
    TextStyle? labelStyle,
    TextAlign? labelAlign,
    AssetIconData? icon,
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
        _labelStyle = labelStyle,
        _labelAlign = labelAlign,
        _icon = icon,
        _trailing = trailing,
        _width = width ?? double.infinity,
        _height = height ?? 32,
        _gap = gap ?? 10,
        _iconSize = iconSize ?? const Size.square(16),
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 14),
        _iconPlaceholderVisible = iconPlaceholderVisible ?? true,
        _disabled = disabled ?? false,
        _onPressed = onPressed;

  const DropdownListMenuItem.select({
    required bool selected,
    required String label,
    TextStyle? labelStyle,
    TextAlign? labelAlign,
    Widget? trailing,
    double? width,
    double? height,
    double? gap,
    Size? iconSize,
    EdgeInsets? padding,
    VoidCallback? onPressed,
    bool? iconPlaceholderVisible,
    bool? disabled,
    Key? key,
  }) : this(
          icon: selected ? SheetIcons.docs_icon_check : null,
          label: label,
          labelStyle: labelStyle,
          labelAlign: labelAlign,
          trailing: trailing,
          width: width,
          height: height,
          gap: gap,
          iconSize: iconSize,
          padding: padding,
          onPressed: onPressed,
          iconPlaceholderVisible: iconPlaceholderVisible,
          disabled: disabled,
          key: key,
        );

  final String _label;
  final TextStyle? _labelStyle;
  final TextAlign? _labelAlign;
  final double _width;
  final double _height;
  final double _gap;
  final Size _iconSize;
  final EdgeInsets _padding;
  final AssetIconData? _icon;
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
        Color backgroundColor = _resolveBackgroundColor(states);
        Color foregroundColor = _resolveForegroundColor(states);

        TextStyle defaultLabelStyle = const TextStyle(
          fontFamily: 'Roboto',
          package: 'sheets',
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w400,
          color: Color(0xff26272a),
        );

        Widget? iconWidget = _icon != null
            ? AssetIcon(_icon, color: foregroundColor, width: _iconSize.width, height: _iconSize.height) //
            : null;

        return Container(
          width: _width,
          height: _height,
          padding: _padding,
          decoration: BoxDecoration(color: backgroundColor),
          child: Row(
            children: <Widget>[
              if (_iconPlaceholderVisible) ...<Widget>[
                SizedBox.fromSize(size: _iconSize, child: Center(child: iconWidget)),
                SizedBox(width: _gap),
              ],
              Expanded(
                child: Text(
                  _label,
                  textAlign: _labelAlign,
                  style: defaultLabelStyle.merge(_labelStyle),
                ),
              ),
              if (_trailing != null) ...<Widget>[
                _trailing,
              ]
            ],
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xFFE8EAED);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xFFF1F3F4);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}

class DropdownListMenuDivider extends StatelessWidget {
  const DropdownListMenuDivider({
    double? weight,
    Color? color,
    EdgeInsets? padding,
    super.key,
  })  : _color = color ?? const Color(0xFFDADCE0),
        _weight = weight ?? 1,
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

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

class DropdownListMenuSubtitle extends StatelessWidget {
  const DropdownListMenuSubtitle({
    required String label,
    TextStyle? labelStyle,
    EdgeInsets? padding,
    AssetIconData? icon,
    super.key,
  })  : _label = label,
        _labelStyle = labelStyle,
        _padding = padding ?? const EdgeInsets.only(top: 9, bottom: 10, left: 12, right: 12),
        _icon = icon;

  final String _label;
  final TextStyle? _labelStyle;
  final EdgeInsets _padding;
  final AssetIconData? _icon;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultLabelStyle = const TextStyle(
      fontFamily: 'Roboto',
      package: 'sheets',
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w500,
      color: Color(0xFF3C4043),
    );

    Widget child = Text(
      _label,
      style: defaultLabelStyle.merge(_labelStyle),
    );

    if (_icon != null) {
      child = Row(
        children: <Widget>[
          child,
          _DropdownListMenuSubtitleButton(icon: _icon, onPressed: () {}),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: _padding,
      child: child,
    );
  }
}

class _DropdownListMenuSubtitleButton extends StatelessWidget {
  const _DropdownListMenuSubtitleButton({
    required AssetIconData icon,
    required VoidCallback onPressed,
    double? size,
  })  : _icon = icon,
        _onPressed = onPressed,
        _size = size ?? 12;

  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _resolveBackgroundColor(states);
        Color? foregroundColor = _resolveForegroundColor(states);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(child: AssetIcon(_icon, size: _size, color: foregroundColor)),
        );
      },
    );
  }

  Color? _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF1F3F4);
    } else {
      return null;
    }
  }

  Color? _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xff444746);
  }
}

class _DropdownListMenuLayout extends StatelessWidget {
  const _DropdownListMenuLayout({
    required double width,
    required Widget child,
    required Color backgroundColor,
    required BorderRadius borderRadius,
    required EdgeInsets padding,
  })  : _width = width,
        _child = child,
        _backgroundColor = backgroundColor,
        _borderRadius = borderRadius,
        _padding = padding;

  final double _width;
  final Widget _child;
  final Color _backgroundColor;
  final BorderRadius _borderRadius;
  final EdgeInsets _padding;

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
        child: _child,
      ),
    );
  }
}
