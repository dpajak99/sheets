import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/text_vertical_align.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_grid_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextAlignVerticalButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextAlignVerticalButton({
    required TextVerticalAlign value,
    required ValueChanged<TextVerticalAlign> onChanged,
    super.key,
  })  : _value = value,
        _onChanged = onChanged;

  final TextVerticalAlign _value;
  final ValueChanged<TextVerticalAlign> _onChanged;

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
          children: TextVerticalAlign.values.map((TextVerticalAlign textAlign) {
            AssetIconData icon = _resolveIcon(textAlign);
            return _TextAlignOption(
              selected: _value == textAlign,
              icon: icon,
              onPressed: () => _onChanged(_value),
            );
          }).toList(),
        );
      },
    );
  }

  AssetIconData _resolveIcon(TextVerticalAlign textAlign) {
    return switch (textAlign) {
      TextVerticalAlign.top => SheetIcons.vertical_align_top,
      TextVerticalAlign.center => SheetIcons.vertical_align_center,
      TextVerticalAlign.bottom => SheetIcons.vertical_align_bottom,
    };
  }

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);
}

class _TextAlignOption extends StatelessWidget {
  const _TextAlignOption({
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
