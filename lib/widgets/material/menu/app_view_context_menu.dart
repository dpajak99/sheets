import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarViewContextMenu extends StatelessWidget {
  const AppBarViewContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Pokaż', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Zablokuj', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Grupuj', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Komentarze', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Ukryte arkusze', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Zoom', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Pełny ekran', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
