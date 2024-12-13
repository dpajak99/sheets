import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarFontFamilyButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarFontFamilyButton({
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
  State<StatefulWidget> createState() => _ToolbarFontFamilyButtonState();
}

class _ToolbarFontFamilyButtonState extends State<ToolbarFontFamilyButton> {
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
        return _FontFamilyDropdownButton(
          opened: isOpen,
          size: widget.size,
          margin: widget.margin,
          fontFamily: widget.value ?? _defaultFont,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 215,
          children: <Widget>[
            const DropdownListMenuItem(
              icon: SheetIcons.docs_icon_add_fonts,
              iconSize: Size(16, 13),
              label: 'Więcej czcionek',
            ),
            const SizedBox(height: 2),
            const DropdownListMenuDivider(),
            const SizedBox(height: 2),
            const DropdownListMenuSubtitle(label: 'MOTYW'),
            const SizedBox(height: 2),
            _FontFamilyOption(
              selected: widget.value == _defaultFont,
              label: 'Domyślna ($_defaultFont)',
              fontFamily: _defaultFont,
              onSelect: _handleFontFamilyChanged,
            ),
            const SizedBox(height: 2),
            const DropdownListMenuSubtitle(label: 'OSTATNIE'),
            const SizedBox(height: 2),
            ..._recentFonts.map((String fontFamily) {
              return _FontFamilyOption(
                selected: widget.value == fontFamily,
                label: fontFamily,
                fontFamily: fontFamily,
                onSelect: _handleFontFamilyChanged,
              );
            }),
            const DropdownListMenuDivider(),
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

class _FontFamilyDropdownButton extends StatelessWidget {
  const _FontFamilyDropdownButton({
    required bool opened,
    required Size size,
    required EdgeInsets margin,
    required String fontFamily,
  })  : _opened = opened,
        _size = size,
        _margin = margin,
        _fontFamily = fontFamily;

  final bool _opened;
  final Size _size;
  final EdgeInsets _margin;
  final String _fontFamily;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (_opened) WidgetState.pressed,
          ...states,
        };

        Color backgroundColor = _resolveBackgroundColor(updatedStates);
        Color foregroundColor = _resolveForegroundColor(updatedStates);

        return Container(
          width: _size.width,
          height: _size.height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          margin: _margin,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _fontFamily,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    package: 'sheets',
                    color: foregroundColor,
                    fontSize: 14,
                    height: 28 / 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Transform(
                transform: _opened ? Matrix4.rotationX(math.pi) : Matrix4.identity(),
                alignment: Alignment.center,
                child: AssetIcon(
                  SheetIcons.docs_icon_arrow_dropdown,
                  width: 8,
                  height: 4,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xb2000000);
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
    return DropdownListMenuItem.select(
      selected: _selected,
      label: _label,
      labelStyle: TextStyle(fontFamily: _fontFamily),
      onPressed: () => _onSelect.call(_fontFamily),
    );
  }
}
