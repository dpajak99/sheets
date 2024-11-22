import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarIconButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarIconButton({
    required AssetIconData icon,
    VoidCallback? onTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    bool? hasDropdown,
    bool? disabled,
    super.key,
  })  : _hasDropdown = hasDropdown ?? false,
        _icon = icon,
        _onTap = onTap,
        _size = size ?? const Size(30, 30),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1),
        _opened = opened ?? false,
        _selected = selected ?? false,
        _disabled = disabled ?? false;

  const ToolbarIconButton.small({
    required AssetIconData icon,
    VoidCallback? onTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    bool? disabled,
    Key? key,
  }) : this(
          hasDropdown: false,
          icon: icon,
          onTap: onTap,
          size: size ?? const Size(24, 24),
          margin: margin,
          opened: opened,
          selected: selected,
    disabled: disabled,
          key: key,
        );

  const ToolbarIconButton.withDropdown({
    required AssetIconData icon,
    VoidCallback? onTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    bool? disabled,
    Key? key,
  }) : this(
          hasDropdown: true,
          icon: icon,
          onTap: onTap,
          size: size ?? const Size(39, 30),
          margin: margin,
          opened: opened,
          selected: selected,
    disabled: disabled,
          key: key,
        );

  final AssetIconData _icon;
  final VoidCallback? _onTap;
  final Size _size;
  final EdgeInsets _margin;
  final bool _opened;
  final bool _selected;
  final bool _hasDropdown;
  final bool _disabled;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      disabled: _disabled,
      onTap: _onTap ?? () {},
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
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AssetIcon(_icon, size: 19, color: foregroundColor),
              if (_hasDropdown) ...<Widget>[
                const SizedBox(width: 4),
                AssetIcon(
                  SheetIcons.dropdown,
                  width: 8,
                  height: 4,
                  color: foregroundColor,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (_selected) {
      return const Color(0xffD8E2F9);
    } else if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    if (_selected) {
      return const Color(0xFF041E49);
    } else {
      return const Color(0xFF444746);
    }
  }
}
