import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarDataContextMenu extends StatelessWidget {
  const AppBarDataContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Sortuj arkusz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Sortuj zakres', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Utwórz filtr', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Utwórz widok "grupuj według"', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Utwórz widok filtra', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Dodaj fragmentator', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Chroń arkusze i zakresy', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Zakresy nazwane', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Funkcje nazwane', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Losuj zakres', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Statystyki dotyczące kolumn', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Sprawdzanie poprawności danych', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Czyszczenie danych', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Podziel tekst na kolumny', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Wyodrębnianie danych', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Łączniki danych', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
