import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_list_menu.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarFontFamilyButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarFontFamilyButton({
    required String? value,
    required ValueChanged<String> onChanged,
    super.key,
  })  : _value = value,
        _onChanged = onChanged;

  static const String _defaultFont = 'Arial';
  static const List<String> _supportedFonts = <String>['Arial', 'Times New Roman', 'Courier New', 'Roboto'];
  static const List<String> _recentFonts = _supportedFonts;

  final String? _value;
  final ValueChanged<String> _onChanged;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      buttonBuilder: (BuildContext context, bool isOpen) {
        return _FontFamilyDropdownButton(
          opened: isOpen,
          size: size,
          margin: margin,
          fontFamily: _value ?? _defaultFont,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 215,
          children: <Widget>[
            const DropdownListMenuItem(
              icon: SheetIcons.add_fonts,
              iconSize: Size(16, 13),
              label: 'Więcej czcionek',
            ),
            const SizedBox(height: 2),
            const DropdownListMenuDivider(),
            const SizedBox(height: 2),
            const DropdownListMenuSubtitle(label: 'MOTYW'),
            const SizedBox(height: 2),
            _FontFamilyOption(
              selected: _value == _defaultFont,
              label: 'Domyślna ($_defaultFont)',
              fontFamily: _defaultFont,
              onSelect: _onChanged,
            ),
            const SizedBox(height: 2),
            const DropdownListMenuSubtitle(label: 'OSTATNIE'),
            const SizedBox(height: 2),
            ..._recentFonts.map((String fontFamily) {
              return _FontFamilyOption(
                selected: _value == fontFamily,
                label: fontFamily,
                fontFamily: fontFamily,
                onSelect: _onChanged,
              );
            }),
            const DropdownListMenuDivider(),
            ..._supportedFonts.map((String fontFamily) {
              return _FontFamilyOption(
                selected: _value == fontFamily,
                label: fontFamily,
                fontFamily: fontFamily,
                onSelect: _onChanged,
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Size get size => const Size(97, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);
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
                  SheetIcons.dropdown,
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
