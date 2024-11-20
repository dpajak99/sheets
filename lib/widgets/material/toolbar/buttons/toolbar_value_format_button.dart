import 'package:flutter/material.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_text_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarValueFormatButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarValueFormatButton({
    required ValueChanged<SheetValueFormat?> onChanged,
    super.key,
  }) : _onChanged = onChanged;

  final ValueChanged<SheetValueFormat?> _onChanged;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      buttonBuilder: (BuildContext context, bool isOpen) {
        return ToolbarTextButton(text: '123', opened: isOpen);
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 312,
          children: <Widget>[
            _ValueFormatOption(
              label: 'Automatycznie',
              onPressed: () => _onChanged(null),
            ),
            _ValueFormatOption(
              label: 'Zwykły tekst',
              onPressed: () => _onChanged(SheetStringFormat()),
            ),
            const DropdownListMenuDivider(),
            _ValueFormatOption(
              label: 'Liczba',
              example: '1 000,12',
              onPressed: () => _onChanged(SheetNumberFormat.decimalPattern()),
            ),
            _ValueFormatOption(
              label: 'Procentowy',
              example: '10,12%',
              onPressed: () => _onChanged(SheetNumberFormat.percentPattern()),
            ),
            _ValueFormatOption(
              label: 'Naukowy',
              example: '1,01E+03',
              onPressed: () => _onChanged(SheetNumberFormat.scientificPattern()),
            ),
            const DropdownListMenuDivider(),
            _ValueFormatOption(
              label: 'Księgowy',
              example: '(1 000,12) zł',
              onPressed: () => _onChanged(SheetNumberFormat.currency()),
            ),
            _ValueFormatOption(
              label: 'Finansowy',
              example: '(1 000,12)',
              onPressed: () => _onChanged(SheetNumberFormat.decimalPatternDigits()),
            ),
            _ValueFormatOption(
              label: 'Waluta',
              example: '1 000,12 zł',
              onPressed: () => _onChanged(SheetNumberFormat.currency()),
            ),
            _ValueFormatOption(
              label: 'Waluta (w zaokrągleniu)',
              example: '1 000 zł',
              onPressed: () => _onChanged(SheetNumberFormat.currency(rounded: true)),
            ),
            const DropdownListMenuDivider(),
            _ValueFormatOption(
              label: 'Data',
              example: '2008-09-26',
              onPressed: () => _onChanged(SheetDateFormat('yyyy-MM-dd')),
            ),
            _ValueFormatOption(
              label: 'Godzina',
              example: '15:59:00',
              onPressed: () => _onChanged(SheetDateFormat('HH:mm:ss')),
            ),
            _ValueFormatOption(
              label: 'Data i godzina',
              example: '2008-09-26 15:59:00',
              onPressed: () => _onChanged(SheetDateFormat('yyyy-MM-dd HH:mm:ss')),
            ),
            _ValueFormatOption(
              label: 'Czas trwania',
              example: '24:01:00',
              onPressed: () => _onChanged(SheetDurationFormat.auto()),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get size => const Size(32, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);
}

class _ValueFormatOption extends StatelessWidget {
  const _ValueFormatOption({
    required String label,
    required VoidCallback onPressed,
    String? example,
  })  : _label = label,
        _onPressed = onPressed,
        _example = example;

  final String _label;
  final String? _example;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return DropdownListMenuItem(
      label: _label,
      trailing: _example != null
          ? Text(
              _example,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'GoogleSans',
                package: 'sheets',
                color: Color(0xff80868B),
              ),
            )
          : null,
      onPressed: _onPressed,
    );
  }
}
