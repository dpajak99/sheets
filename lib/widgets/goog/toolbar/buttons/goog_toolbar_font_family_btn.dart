import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_select_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarFontFamilyBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarFontFamilyBtn({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Size get size => const Size(97, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _GoogToolbarFontFamilyBtnState();
}

class _GoogToolbarFontFamilyBtnState extends State<GoogToolbarFontFamilyBtn> {
  static const String _defaultFont = 'Arial';
  static const List<String> _supportedFonts = <String>['Arial', 'Times New Roman', 'Courier New', 'Roboto'];
  static const List<String> _recentFonts = _supportedFonts;

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
        return GoogToolbarSelectButton<String>(
          width: widget.size.width,
          height: widget.size.height,
          margin: widget.margin,
          valueParser: (String value) => value,
          selectedValue: widget.value ?? _defaultFont,
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogMenuVertical(
          width: 215,
          children: <Widget>[
            GoogMenuItem(
              leading: const GoogIcon(SheetIcons.docs_icon_add_fonts),
              iconSize: const Size(16, 13),
              label: GoogText(t.menu.font.more_fonts),
            ),
            const SizedBox(height: 2),
            const GoogMenuSeperator(),
            const SizedBox(height: 2),
            GoogMenuSectionHeader(label: GoogText(t.menu.font.theme.toUpperCase())),
            const SizedBox(height: 2),
            _FontFamilyOption(
              selected: widget.value == _defaultFont,
              label: t.menu.font.kDefault(name: _defaultFont),
              fontFamily: _defaultFont,
              onSelect: _handleFontFamilyChanged,
            ),
            const SizedBox(height: 2),
            GoogMenuSectionHeader(label: GoogText(t.menu.font.recent.toUpperCase())),
            const SizedBox(height: 2),
            ..._recentFonts.map((String fontFamily) {
              return _FontFamilyOption(
                selected: widget.value == fontFamily,
                label: fontFamily,
                fontFamily: fontFamily,
                onSelect: _handleFontFamilyChanged,
              );
            }),
            const GoogMenuSeperator(),
            ..._supportedFonts.map((String fontFamily) {
              return _FontFamilyOption(
                selected: widget.value == fontFamily,
                label: fontFamily,
                fontFamily: fontFamily,
                onSelect: _handleFontFamilyChanged,
              );
            }),
          ],
        );
      },
    );
  }

  void _handleFontFamilyChanged(String fontFamily) {
    widget.onChanged.call(fontFamily);
    _dropdownController.close();
  }
}

class _FontFamilyOption extends StatelessWidget {
  const _FontFamilyOption({
    required bool selected,
    required String label,
    required String fontFamily,
    required ValueChanged<String> onSelect,
  })  : _selected = selected,
        _label = label,
        _fontFamily = fontFamily,
        _onSelect = onSelect;

  final bool _selected;
  final String _label;
  final String _fontFamily;
  final ValueChanged<String> _onSelect;

  @override
  Widget build(BuildContext context) {
    return GoogMenuItem(
      leading: _selected ? const GoogIcon(SheetIcons.docs_icon_check) : null,
      label:  GoogText(_label, fontFamily: _fontFamily),
      onPressed: () => _onSelect.call(_fontFamily),
    );
  }
}
