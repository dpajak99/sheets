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
        DropdownListMenuItem(label: 'Nowy', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Otwórz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Importuj', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Utwórz kopię', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Udostepnij', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Wyślij e-mailem', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Pobierz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Zmień nazwę', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Przenieś', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Dodaj skrót do dysku', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Przenieś do kosza', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Historia zmian', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Udostępnij offline', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Szczegóły', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Ograniczenia zabezpieczeń', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Ustawienia', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Drukuj', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
      ],
    );
  }
}
