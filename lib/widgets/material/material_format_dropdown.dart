import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialFormatDropdown extends StatefulWidget {
  const MaterialFormatDropdown({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MaterialFormatDropdownState();
}

class _MaterialFormatDropdownState extends State<MaterialFormatDropdown> {
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
            FormatOptionButton(label: 'Automatycznie'),
            FormatOptionButton(label: 'Zwykły tekst'),
            FormatDivider(),
            FormatOptionButton(label: 'Liczba', exampleValue: '1 000,12'),
            FormatOptionButton(label: 'Procentowy', exampleValue: '10,12%'),
            FormatOptionButton(label: 'Naukowy', exampleValue: '1,01E+03'),
            FormatDivider(),
            FormatOptionButton(label: 'Księgowy', exampleValue: '(1 000,12) zł'),
            FormatOptionButton(label: 'Finansowy', exampleValue: '(1 000,12)'),
            FormatOptionButton(label: 'Waluta', exampleValue: '1 000,12 zł'),
            FormatOptionButton(label: 'Waluta (w zaokrągleniu)', exampleValue: '1 000 zł'),
            FormatDivider(),
            FormatOptionButton(label: 'Data', exampleValue: '2008-09-26'),
            FormatOptionButton(label: 'Godzina', exampleValue: '15:59:00'),
            FormatOptionButton(label: 'Data i godzina', exampleValue: '2008-09-26 15:59:00'),
            FormatOptionButton(label: 'Czas trwania', exampleValue: '24:01:00'),
            FormatDivider(),
            FormatOptionButton(label: 'Waluta niestandardowa'),
            FormatOptionButton(label: 'Niestandardowa data i godzina'),
            FormatOptionButton(label: 'Niestandardowy format liczbowy'),
          ],
        ),
      ),
    );
  }
}

class FormatDivider extends StatelessWidget {
  const FormatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Center(
        child: Container(
          height: 1,
          width: double.infinity,
          color: const Color(0xffdadce0),
        ),
      ),
    );
  }
}

class FormatOptionButton extends StatelessWidget {
  const FormatOptionButton({
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
              if( exampleValue != null)
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

class FontsLabel extends StatelessWidget {
  const FontsLabel({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 9, bottom: 12, left: 12, right: 12),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff444746),
          letterSpacing: 11 * (-0.03),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
  }
}
