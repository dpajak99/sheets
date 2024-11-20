import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarColorPickerButton extends StatelessWidget {
  const ToolbarColorPickerButton({
    required Size? size,
    required EdgeInsets? margin,
    required Color selectedColor,
    required AssetIconData icon,
    bool? opened,
    int? level,
    super.key,
  })  : _size = size ?? const Size(32, 30),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1),
        _selectedColor = selectedColor,
        _icon = icon,
        _opened = opened ?? false,
        _level = level ?? 1;

  final Size _size;
  final EdgeInsets _margin;
  final Color _selectedColor;
  final AssetIconData _icon;
  final bool _opened;
  final int _level;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (_opened) WidgetState.pressed,
          ...states,
        };

        Color? backgroundColor = _resolveBackgroundColor(updatedStates);
        Color? foregroundColor = _resolveForegroundColor(updatedStates);

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: AssetIcon(_icon, size: 19, color: foregroundColor),
              ),
              Positioned(
                top: 20,
                left: 4.5,
                right: 4.5,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(color: _selectedColor),
                ),
              ),
            ],
          ),
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
