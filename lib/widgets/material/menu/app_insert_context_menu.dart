import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarInsertContextMenu extends StatelessWidget {
  const AppBarInsertContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Komórki', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Wiersze', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Kolumny', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Arkusz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Tabele', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Wykres', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Tabela przestawna', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Obraz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Rysunek', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Funkcja', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Link', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Pole wyboru', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Menu', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Emotikony', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Elementy inteligentne', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Komentarz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Notatka', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
      ],
    );
  }
}
