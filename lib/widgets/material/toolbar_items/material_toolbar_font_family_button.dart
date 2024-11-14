import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_popup.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class MaterialToolbarFontFamilyButton extends StatefulWidget with MaterialToolbarItemMixin {
  const MaterialToolbarFontFamilyButton({
    required this.selectedFontFamily,
    required this.onChanged,
    this.width = 97,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final String selectedFontFamily;
  final ValueChanged<String> onChanged;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('selectedFontFamily', selectedFontFamily));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _MaterialToolbarFontFamilyButtonState();
}

class _MaterialToolbarFontFamilyButtonState extends State<MaterialToolbarFontFamilyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return PopupButton(
      button: _FontFamilyButton(
        pressed: _pressed,
        fontFamily: widget.selectedFontFamily,
        width: widget.width,
        height: widget.height,
        onTap: () {},
      ),
      onToggle: (bool isOpen) {
        setState(() {
          _pressed = isOpen;
        });
      },
      popupBuilder: (BuildContext context) {
        return _FontDropdown(value: widget.selectedFontFamily, onChanged: widget.onChanged);
      },
    );
  }
}

class _FontFamilyButton extends StatelessWidget with MaterialToolbarButtonMixin {
  const _FontFamilyButton({
    required this.onTap,
    required this.pressed,
    required this.fontFamily,
    this.width = 97,
    this.height = 30,
  });

  final bool pressed;
  final double width;
  final double height;
  final String fontFamily;
  final VoidCallback onTap;

  @override
  bool get active => false;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (pressed) WidgetState.pressed,
          ...states,
        };

        Color backgroundColor = getBackgroundColor(updatedStates);
        Color foregroundColor = getForegroundColor(updatedStates);

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  fontFamily,
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    package: 'sheets',
                    color: foregroundColor,
                    fontSize: 15,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Flip Vertical if pressed
              Transform(
                transform: pressed ? Matrix4.rotationX(pi) : Matrix4.identity(),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(StringProperty('fontFamily', fontFamily));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('pressed', pressed));
  }
}

class _FontDropdown extends StatefulWidget {
  const _FontDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<StatefulWidget> createState() => _FontDropdownState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onChanged', onChanged));
  }
}

class _FontDropdownState extends State<_FontDropdown> {
  late String selectedFontFamily = widget.value;

  @override
  Widget build(BuildContext context) {
    return MaterialToolbarPopup(
      child: Column(
        children: <Widget>[
          const MaterialPopupButton(
            icon: Icons.text_increase,
            text: 'More fonts',
          ),
          const SizedBox(height: 2),
          const MaterialToolbarPopupDivider(),
          const SizedBox(height: 2),
          const MaterialPopupLabel(label: 'Theme'),
          const SizedBox(height: 2),
          _SelectableButton(
            label: 'Domyślna (Arial)',
            fontFamily: 'Arial',
            onTap: _onFontFamilySelected,
          ),
          const SizedBox(height: 2),
          const MaterialPopupLabel(label: 'Ostatnie'),
          const SizedBox(height: 2),
          _SelectableButton(
            label: 'Arial',
            fontFamily: 'Arial',
            onTap: _onFontFamilySelected,
            selected: selectedFontFamily == 'Arial',
          ),
          _SelectableButton(
            label: 'Courier New',
            fontFamily: 'Courier New',
            onTap: _onFontFamilySelected,
            selected: selectedFontFamily == 'Courier New',
          ),
          _SelectableButton(
            label: 'Times New Roman',
            fontFamily: 'Times New Roman',
            onTap: _onFontFamilySelected,
            selected: selectedFontFamily == 'Times New Roman',
          ),
          const MaterialToolbarPopupDivider(),
          _SelectableButton(
            label: 'Arial',
            fontFamily: 'Arial',
            onTap: _onFontFamilySelected,
            selected: selectedFontFamily == 'Arial',
          ),
          _SelectableButton(
            label: 'Courier New',
            fontFamily: 'Courier New',
            onTap: _onFontFamilySelected,
            selected: selectedFontFamily == 'Courier New',
          ),
          _SelectableButton(
            label: 'Times New Roman',
            fontFamily: 'Times New Roman',
            onTap: _onFontFamilySelected,
            selected: selectedFontFamily == 'Times New Roman',
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('selectedFontFamily', selectedFontFamily));
  }

  void _onFontFamilySelected(String fontFamily) {
    setState(() {
      selectedFontFamily = fontFamily;
    });
    widget.onChanged(fontFamily);
  }
}

class _SelectableButton extends StatelessWidget {
  const _SelectableButton({
    required this.label,
    required this.fontFamily,
    required this.onTap,
    this.selected = false,
  });

  final bool selected;
  final String label;
  final String fontFamily;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () => onTap(fontFamily),
      childBuilder: (Set<WidgetState> states) {
        return Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: <Widget>[
              if (selected) const Icon(Icons.check, size: 16, color: Color(0xff444746)) else const SizedBox(width: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    color: const Color(0xff444746),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffe8eaed);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF1F3F4);
    } else {
      return Colors.white;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('fontFamily', fontFamily));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onTap', onTap));
  }
}
