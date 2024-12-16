import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/goog/goog_icon.dart';
import 'package:sheets/widgets/material/goog/goog_palette.dart';
import 'package:sheets/widgets/material/goog/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextAlignVerticalButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarTextAlignVerticalButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TextAlignVertical value;
  final ValueChanged<TextAlignVertical> onChanged;

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextAlignVertical>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<TextAlignVertical>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarTextAlignVerticalButtonState();
}

class _ToolbarTextAlignVerticalButtonState extends State<ToolbarTextAlignVerticalButton> {
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
        return GoogToolbarMenuButton(margin: widget.margin, child: GoogIcon(icon));
      },
      popupBuilder: (BuildContext context) {
        return GoogPalette(
          gap: 1,
          children: <TextAlignVertical>[
            TextAlignVertical.top,
            TextAlignVertical.center,
            TextAlignVertical.bottom,
          ].map((TextAlignVertical textAlign) {
            AssetIconData icon = _resolveIcon(textAlign);
            return _TextAlignOption(
                selected: widget.value == textAlign,
                icon: icon,
                onPressed: () {
                  widget.onChanged(textAlign);
                  _dropdownController.close();
                });
          }).toList(),
        );
      },
    );
  }

  AssetIconData _resolveIcon(TextAlignVertical textAlign) {
    return switch (textAlign) {
      TextAlignVertical.top => SheetIcons.docs_icon_valign_top_20,
      TextAlignVertical.center => SheetIcons.docs_icon_valign_middle_20,
      TextAlignVertical.bottom => SheetIcons.docs_icon_valign_bottom_20,
      (_) => throw Exception('Unknown value: $textAlign'),
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
