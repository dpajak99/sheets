import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_popup.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_button.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class MaterialToolbarFormatButton extends StatefulWidget with MaterialToolbarItemMixin {
  const MaterialToolbarFormatButton({
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

  @override
  State<StatefulWidget> createState() => _MaterialToolbarFormatButtonState();
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
      popupBuilder: (BuildContext context) => const _MaterialFormatDropdown(),
    );
  }
}

class _MaterialFormatDropdown extends StatefulWidget {
  const _MaterialFormatDropdown();

  @override
  State<StatefulWidget> createState() => _MaterialFormatDropdownState();
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
        child: const Column(
          children: <Widget>[
            _SelectableButton(label: 'Automatycznie'),
            _SelectableButton(label: 'Zwykły tekst'),
            MaterialToolbarPopupDivider(),
            _SelectableButton(label: 'Liczba', exampleValue: '1 000,12'),
            _SelectableButton(label: 'Procentowy', exampleValue: '10,12%'),
            _SelectableButton(label: 'Naukowy', exampleValue: '1,01E+03'),
            MaterialToolbarPopupDivider(),
            _SelectableButton(label: 'Księgowy', exampleValue: '(1 000,12) zł'),
            _SelectableButton(label: 'Finansowy', exampleValue: '(1 000,12)'),
            _SelectableButton(label: 'Waluta', exampleValue: '1 000,12 zł'),
            _SelectableButton(label: 'Waluta (w zaokrągleniu)', exampleValue: '1 000 zł'),
            MaterialToolbarPopupDivider(),
            _SelectableButton(label: 'Data', exampleValue: '2008-09-26'),
            _SelectableButton(label: 'Godzina', exampleValue: '15:59:00'),
            _SelectableButton(label: 'Data i godzina', exampleValue: '2008-09-26 15:59:00'),
            _SelectableButton(label: 'Czas trwania', exampleValue: '24:01:00'),
            MaterialToolbarPopupDivider(),
            _SelectableButton(label: 'Waluta niestandardowa'),
            _SelectableButton(label: 'Niestandardowa data i godzina'),
            _SelectableButton(label: 'Niestandardowy format liczbowy'),
          ],
        ),
      ),
    );
  }
}

class _SelectableButton extends StatelessWidget {
  const _SelectableButton({
    required this.label,
    this.exampleValue,
    this.selected = false,
    super.key,
  });

  final bool selected;
  final String label;
  final String? exampleValue;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () {},
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
  }
}
