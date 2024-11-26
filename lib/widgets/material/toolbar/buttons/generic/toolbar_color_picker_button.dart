import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarColorPickerButton extends StatelessWidget {
  const ToolbarColorPickerButton({
    required Size? size,
    required EdgeInsets? margin,
    required Color selectedColor,
    required AssetIconData icon,
    double? iconSize,
    double? colorBoxDy,
    double? colorBoxPadding,
    double? colorBoxHeight,
    bool? opened,
    bool? hasDropdown,
    super.key,
  })  : _size = size ?? const Size(32, 30),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1),
        _selectedColor = selectedColor,
        _icon = icon,
        _iconSize = iconSize ?? 19,
        _colorBoxDy = colorBoxDy ?? 20,
        _colorBoxPadding = colorBoxPadding ?? 4.5,
        _colorBoxHeight = colorBoxHeight ?? 4,
        _opened = opened ?? false,
        _hasDropdown = hasDropdown ?? false;

  const ToolbarColorPickerButton.withDropdown({
    required Size? size,
    required EdgeInsets? margin,
    required Color selectedColor,
    required AssetIconData icon,
    double? iconSize,
    double? colorBoxDy,
    double? colorBoxPadding,
    double? colorBoxHeight,
    bool? opened,
    Key? key,
  }) : this(
          size: size,
          margin: margin,
          selectedColor: selectedColor,
          icon: icon,
          iconSize: iconSize,
          colorBoxDy: colorBoxDy,
          colorBoxPadding: colorBoxPadding,
          colorBoxHeight: colorBoxHeight,
          opened: opened,
          key: key,
        );

  final Size _size;
  final EdgeInsets _margin;
  final Color _selectedColor;
  final AssetIconData _icon;
  final double _iconSize;
  final double _colorBoxDy;
  final double _colorBoxPadding;
  final double _colorBoxHeight;
  final bool _opened;
  final bool _hasDropdown;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (_opened) WidgetState.pressed,
          ...states,
        };

        Color? backgroundColor = _resolveBackgroundColor(updatedStates);
        Color? foregroundColor = _resolveForegroundColor(updatedStates);

        Widget child = SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: AssetIcon(_icon, size: _iconSize, color: foregroundColor),
              ),
              Positioned(
                top: _colorBoxDy,
                left: _colorBoxPadding,
                right: _colorBoxPadding,
                child: Container(
                  height: _colorBoxHeight,
                  decoration: BoxDecoration(color: _selectedColor),
                ),
              ),
            ],
          ),
        );

        if (_hasDropdown) {
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              child,
              const SizedBox(width: 4),
              AssetIcon(
                SheetIcons.dropdown,
                width: 8,
                height: 4,
                color: foregroundColor,
              ),
            ],
          );
        }

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: child,
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}
