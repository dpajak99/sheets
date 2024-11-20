import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_grid_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextAlignHorizontalButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextAlignHorizontalButton({
    required TextAlign value,
    required ValueChanged<TextAlign> onChanged,
    super.key,
  })  : _value = value,
        _onChanged = onChanged;

  static final List<TextAlign> _supportedTextAligns = <TextAlign>[TextAlign.left, TextAlign.center, TextAlign.right];

  final TextAlign _value;
  final ValueChanged<TextAlign> _onChanged;

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
          children: _supportedTextAligns.map((TextAlign textAlign) {
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

  AssetIconData _resolveIcon(TextAlign textAlign) {
    return switch (textAlign) {
      TextAlign.start => SheetIcons.format_align_left,
      TextAlign.left => SheetIcons.format_align_left,
      TextAlign.center => SheetIcons.format_align_center,
      TextAlign.right => SheetIcons.format_align_right,
      TextAlign.end => SheetIcons.format_align_right,
      TextAlign.justify => SheetIcons.format_align_justify,
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
