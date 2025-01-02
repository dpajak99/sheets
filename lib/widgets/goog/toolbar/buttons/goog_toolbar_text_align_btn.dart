import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/menu/goog_palette.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarTextAlignBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarTextAlignBtn({
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
  State<StatefulWidget> createState() => _GoogToolbarTextAlignBtnState();
}

class _GoogToolbarTextAlignBtnState extends State<GoogToolbarTextAlignBtn> {
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
        return GoogToolbarMenuButton(
          margin: widget.margin,
          child: GoogIcon(icon),
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogPalette(
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
      TextAlign.start => SheetIcons.docs_icon_align_left_20,
      TextAlign.left => SheetIcons.docs_icon_align_left_20,
      TextAlign.center => SheetIcons.docs_icon_align_center_20,
      TextAlign.right => SheetIcons.docs_icon_align_right_20,
      TextAlign.end => SheetIcons.docs_icon_align_right_20,
      TextAlign.justify => SheetIcons.docs_icon_align_justify_20,
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
    return GoogPaletteItem(selected: _selected, icon: _icon, onPressed: _onPressed);
  }
}
