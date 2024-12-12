import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarFileContextMenu extends StatelessWidget {
  const AppBarFileContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Nowy', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Otwórz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Importuj', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Utwórz kopię', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Udostepnij', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Wyślij e-mailem', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Pobierz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Zmień nazwę', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Przenieś', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Dodaj skrót do dysku', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Przenieś do kosza', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Historia zmian', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Udostępnij offline', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Szczegóły', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Ograniczenia zabezpieczeń', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Ustawienia', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Drukuj', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
