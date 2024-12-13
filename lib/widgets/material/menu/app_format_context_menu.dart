import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarFormatContextMenu extends StatelessWidget {
  const AppBarFormatContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Motyw', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Liczba', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Tekst', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Wyrównanie', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Zawijanie', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Obrót', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Rozmiar czcionki', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Scal komórki', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Przekonwertuj na tabelę', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Formatowanie warunkowe', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Naprzemienne kolory', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Wyczyść formatowanie', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
      ],
    );
  }
}