import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_popup.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_button.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class MaterialToolbarFormatButton extends StatefulWidget with MaterialToolbarItemMixin {
  const MaterialToolbarFormatButton({
    required this.onChanged,
    this.width = 32,
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
  final ValueChanged<SheetValueFormat> onChanged;

  @override
  State<StatefulWidget> createState() => _MaterialToolbarFormatButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<SheetValueFormat>>.has('onChanged', onChanged));
  }
}

class _MaterialToolbarFormatButtonState extends State<MaterialToolbarFormatButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return PopupButton(
      button: MaterialToolbarTextButton(
        text: '123',
        pressed: _pressed,
        onTap: () {},
      ),
      onToggle: (bool isOpen) {
        setState(() {
          _pressed = isOpen;
        });
      },
      popupBuilder: (BuildContext context) => _MaterialFormatDropdown(
        onChanged: widget.onChanged,
      ),
    );
  }
}

class _MaterialFormatDropdown extends StatefulWidget {
  const _MaterialFormatDropdown({
    required this.onChanged,
  });

  final ValueChanged<SheetValueFormat> onChanged;

  @override
  State<StatefulWidget> createState() => _MaterialFormatDropdownState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<SheetValueFormat>>.has('onChanged', onChanged));
  }
}

class _MaterialFormatDropdownState extends State<_MaterialFormatDropdown> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: 312,
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          children: <Widget>[
            _SelectableButton(
              label: 'Automatycznie',
              selected: true,
              onTap: () {},
            ),
            _SelectableButton(
              label: 'Zwykły tekst',
              onTap: () => widget.onChanged(SheetStringFormat()),
            ),
            const MaterialToolbarPopupDivider(),
            _SelectableButton(
              label: 'Liczba',
              exampleValue: '1 000,12',
              onTap: () => widget.onChanged(SheetNumberFormat.decimalPattern()),
            ),
            _SelectableButton(
              label: 'Procentowy',
              exampleValue: '10,12%',
              onTap: () => widget.onChanged(SheetNumberFormat.percentPattern()),
            ),
            _SelectableButton(
              label: 'Naukowy',
              exampleValue: '1,01E+03',
              onTap: () => widget.onChanged(SheetNumberFormat.scientificPattern()),
            ),
            const MaterialToolbarPopupDivider(),
            _SelectableButton(
              label: 'Księgowy',
              exampleValue: '(1 000,12) zł',
              onTap: () => widget.onChanged(SheetNumberFormat.currency()),
            ),
            _SelectableButton(
              label: 'Finansowy',
              exampleValue: '(1 000,12)',
              onTap: () => widget.onChanged(SheetNumberFormat.decimalPatternDigits()),
            ),
            // _SelectableButton(
            //   label: 'Waluta',
            //   exampleValue: '1 000,12 zł',
            //   onTap: () => widget.onChanged(SheetNumberFormat.currency()),
            // ),
            // _SelectableButton(
            //   label: 'Waluta (w zaokrągleniu)',
            //   exampleValue: '1 000 zł',
            //   onTap: () => widget.onChanged(SheetNumberFormat('#,##0 zł')),
            // ),
            const MaterialToolbarPopupDivider(),
            _SelectableButton(
              label: 'Data',
              exampleValue: '2008-09-26',
              onTap: () => widget.onChanged(SheetDateFormat('yyyy-MM-dd')),
            ),
            _SelectableButton(
              label: 'Godzina',
              exampleValue: '15:59:00',
              onTap: () => widget.onChanged(SheetDateFormat('HH:mm:ss')),
            ),
            _SelectableButton(
              label: 'Data i godzina',
              exampleValue: '2008-09-26 15:59:00',
              onTap: () => widget.onChanged(SheetDateFormat('yyyy-MM-dd HH:mm:ss')),
            ),
            _SelectableButton(
              label: 'Czas trwania',
              exampleValue: '24:01:00',
              onTap: () => widget.onChanged(SheetDurationFormat.auto()),
            ),
            const MaterialToolbarPopupDivider(),
            _SelectableButton(label: 'Waluta niestandardowa', onTap: () {}),
            _SelectableButton(label: 'Niestandardowa data i godzina', onTap: () {}),
            _SelectableButton(label: 'Niestandardowy format liczbowy', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _SelectableButton extends StatelessWidget {
  const _SelectableButton({
    required this.onTap,
    required this.label,
    this.exampleValue,
    this.selected = false,
  });

  final bool selected;
  final String label;
  final String? exampleValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Google Sans',
                    color: Color(0xff444746),
                  ),
                ),
              ),
              if (exampleValue != null)
                Text(
                  exampleValue!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Google Sans',
                    color: Color(0xff80868B),
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
    properties.add(StringProperty('exampleValue', exampleValue));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}
