import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_grid_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextOverflowButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextOverflowButton({
    required TextOverflowBehavior value,
    required ValueChanged<TextOverflowBehavior> onChanged,
    super.key,
  })  : _value = value,
        _onChanged = onChanged;

  final TextOverflowBehavior _value;
  final ValueChanged<TextOverflowBehavior> _onChanged;

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
          children: TextOverflowBehavior.values.map((TextOverflowBehavior textOverflow) {
            AssetIconData icon = _resolveIcon(textOverflow);
            return _TextOverflowOption(
              selected: _value == textOverflow,
              icon: icon,
              onPressed: () => _onChanged(textOverflow),
            );
          }).toList(),
        );
      },
    );
  }

  AssetIconData _resolveIcon(TextOverflowBehavior textOverflow) {
    return switch (textOverflow) {
      TextOverflowBehavior.overflow => SheetIcons.format_text_overflow,
      TextOverflowBehavior.wrap => SheetIcons.format_text_wrap,
      TextOverflowBehavior.clip => SheetIcons.format_text_clip,
    };
  }

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);
}

class _TextOverflowOption extends StatelessWidget {
  const _TextOverflowOption({
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
