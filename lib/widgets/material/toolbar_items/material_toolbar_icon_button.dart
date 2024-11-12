import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialToolbarIconButton extends StatelessWidget with MaterialToolbarItemMixin, MaterialToolbarButtonMixin {
  const MaterialToolbarIconButton({
    required this.icon,
    required this.onTap,
    this.width = 30,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    this.active = false,
    this.pressed = false,
    super.key,
  }) : hasDropdown = false;

  MaterialToolbarIconButton.small({
    required this.icon,
    required this.onTap,
    this.width = 24,
    this.height = 24,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    this.active = false,
    this.pressed = false,
    super.key,
  }) : hasDropdown = false;

  MaterialToolbarIconButton.withDropdown({
    required this.icon,
    required this.onTap,
    this.width = 39,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    this.active = false,
    this.pressed = false,
    super.key,
  }) : hasDropdown = true;

  final bool hasDropdown;
  @override
  final bool active;
  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final AssetIconData icon;
  final VoidCallback onTap;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (pressed) WidgetState.pressed,
          ...states,
        };
        Color? backgroundColor = getBackgroundColor(updatedStates);
        Color? foregroundColor = getForegroundColor(updatedStates);

        return Container(
          width: width,
          height: height,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AssetIcon(icon, size: 19, color: foregroundColor),
              if (hasDropdown) ...<Widget>[
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('hasDropdown', hasDropdown));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('pressed', pressed));
  }
}
