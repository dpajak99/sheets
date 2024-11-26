import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_grid_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextAlignHorizontalButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarTextAlignHorizontalButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TextAlign value;
  final ValueChanged<TextAlign> onChanged;

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<TextAlign>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarTextAlignHorizontalButtonState();
}

class _ToolbarTextAlignHorizontalButtonState extends State<ToolbarTextAlignHorizontalButton> {
  static final List<TextAlign> _supportedTextAligns = <TextAlign>[TextAlign.left, TextAlign.center, TextAlign.right];

  late final DropdownButtonController _dropdownController;

  @override
  void initState() {
    super.initState();
    _dropdownController = DropdownButtonController();
  }

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        AssetIconData icon = _resolveIcon(widget.value);
        return ToolbarIconButton.withDropdown(icon: icon, size: widget.size, margin: widget.margin);
      },
      popupBuilder: (BuildContext context) {
        return DropdownGridMenu(
          gap: 1,
          children: _supportedTextAligns.map((TextAlign textAlign) {
            AssetIconData icon = _resolveIcon(textAlign);
            return _TextAlignOption(
              selected: widget.value == textAlign,
              icon: icon,
              onPressed: () {
                widget.onChanged(textAlign);
                _dropdownController.close();
              },
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
