import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_grid_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextRotationButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextRotationButton({
    required TextRotation value,
    required ValueChanged<TextRotation> onChanged,
    super.key,
  })  : _value = value,
        _onChanged = onChanged;

  final TextRotation _value;
  final ValueChanged<TextRotation> _onChanged;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      buttonBuilder: (BuildContext context, bool isOpen) {
        AssetIconData icon = _resolveIcon(_value);
        return ToolbarIconButton.withDropdown(icon: icon, size: size, margin: margin);
      },
      popupBuilder: (BuildContext context) {
        return DropdownGridMenu(
          gap: 1,
          children: TextRotation.values.map((TextRotation textRotation) {
            AssetIconData icon = _resolveIcon(textRotation);
            return _TextRotationOption(
              selected: _value == textRotation,
              icon: icon,
              onPressed: () => _onChanged(_value),
            );
          }).toList(),
        );
      },
    );
  }

  AssetIconData _resolveIcon(TextRotation textRotation) {
    return switch (textRotation) {
      TextRotation.none => SheetIcons.text_rotation_none,
      TextRotation.angleUp => SheetIcons.text_rotation_angleup,
      TextRotation.angleDown => SheetIcons.text_rotation_angledown,
      TextRotation.vertical => SheetIcons.text_rotation_vertical,
      TextRotation.up => SheetIcons.text_rotation_up,
      TextRotation.down => SheetIcons.text_rotation_down,
      (_) => SheetIcons.right_angle,
    };
  }

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);
}

class _TextRotationOption extends StatelessWidget {
  const _TextRotationOption({
    required bool selected,
    required AssetIconData icon,
    required VoidCallback onPressed,
  })  : _selected = selected,
        _icon = icon,
        _onPressed = onPressed;

  final bool _selected;
  final AssetIconData _icon;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return DropdownGridMenuItem(selected: _selected, icon: _icon, onPressed: _onPressed);
  }
}
