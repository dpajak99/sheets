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
        DropdownListMenuItem(label: 'Komórki', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Wiersze', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Kolumny', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Arkusz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Tabele', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Wykres', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Tabela przestawna', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Obraz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Rysunek', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Funkcja', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Link', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Pole wyboru', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Menu', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Emotikony', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Elementy inteligentne', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Komentarz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Notatka', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
