import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarEditContextMenu extends StatelessWidget {
  const AppBarEditContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Cofnij', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Ponów', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Wytnij', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Kopiuj', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Wklej', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Wklej specjalne', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Przenieś', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Usuń', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Znajdź i zamień', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
