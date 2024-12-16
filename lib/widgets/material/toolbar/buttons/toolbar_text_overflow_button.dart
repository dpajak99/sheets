import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/goog/goog_icon.dart';
import 'package:sheets/widgets/material/goog/goog_palette.dart';
import 'package:sheets/widgets/material/goog/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

// TODO(Dominik): Rename to Text wrap
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
        return GoogToolbarMenuButton(
          margin: margin,
          childPadding: const EdgeInsets.only(top: 10, bottom: 8),
          child: GoogIcon(icon),
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogPalette(
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
      TextOverflowBehavior.overflow => SheetIcons.docs_icon_format_text_overflow_20,
      TextOverflowBehavior.wrap => SheetIcons.docs_icon_format_text_wrap_20,
      TextOverflowBehavior.clip => SheetIcons.docs_icon_format_text_clip_20,
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
    return GoogPaletteItem(selected: _selected, icon: _icon, onPressed: _onPressed);
  }
}
