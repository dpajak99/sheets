import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarFormatBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarFormatBtn({
    required this.onChanged,
    super.key,
  });

  final ValueChanged<SheetValueFormat?> onChanged;

  @override
  Size get size => const Size(32, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<SheetValueFormat?>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _GoogToolbarFormatBtnState();
}

class _GoogToolbarFormatBtnState extends State<GoogToolbarFormatBtn> {
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
        return GoogToolbarButton(
          width: 32,
          child: const GoogText('123'),
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogMenuVertical(
          width: 312,
          children: <Widget>[
            _ValueFormatOption(
              label: 'Automatycznie',
              onPressed: () => _handleValueFormatChanged(null),
            ),
            _ValueFormatOption(
              label: 'Zwykły tekst',
              onPressed: () => _handleValueFormatChanged(SheetStringFormat()),
            ),
            const GoogMenuSeperator(),
            _ValueFormatOption(
              label: 'Liczba',
              example: '1 000,12',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.decimalPattern()),
            ),
            _ValueFormatOption(
              label: 'Procentowy',
              example: '10,12%',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.percentPattern()),
            ),
            _ValueFormatOption(
              label: 'Naukowy',
              example: '1,01E+03',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.scientificPattern()),
            ),
            const GoogMenuSeperator(),
            _ValueFormatOption(
              label: 'Księgowy',
              example: '(1 000,12) zł',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.currency()),
            ),
            _ValueFormatOption(
              label: 'Finansowy',
              example: '(1 000,12)',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.decimalPatternDigits()),
            ),
            _ValueFormatOption(
              label: 'Waluta',
              example: '1 000,12 zł',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.currency()),
            ),
            _ValueFormatOption(
              label: 'Waluta (w zaokrągleniu)',
              example: '1 000 zł',
              onPressed: () => _handleValueFormatChanged(SheetNumberFormat.currency(rounded: true)),
            ),
            const GoogMenuSeperator(),
            _ValueFormatOption(
              label: 'Data',
              example: '2008-09-26',
              onPressed: () => _handleValueFormatChanged(SheetDateFormat('yyyy-MM-dd')),
            ),
            _ValueFormatOption(
              label: 'Godzina',
              example: '15:59:00',
              onPressed: () => _handleValueFormatChanged(SheetDateFormat('HH:mm:ss')),
            ),
            _ValueFormatOption(
              label: 'Data i godzina',
              example: '2008-09-26 15:59:00',
              onPressed: () => _handleValueFormatChanged(SheetDateFormat('yyyy-MM-dd HH:mm:ss')),
            ),
            _ValueFormatOption(
              label: 'Czas trwania',
              example: '24:01:00',
              onPressed: () => _handleValueFormatChanged(SheetDurationFormat.auto()),
            ),
          ],
        );
      },
    );
  }

  void _handleValueFormatChanged(SheetValueFormat? valueFormat) {
    widget.onChanged(valueFormat);
    _dropdownController.close();
  }
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
    return GoogMenuItem(
      label: GoogText(_label),
      trailing: _example != null ? GoogText(_example) : null,
      onPressed: _onPressed,
    );
  }
}
