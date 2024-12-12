import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarToolsContextMenu extends StatelessWidget {
  const AppBarToolsContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Utwórz nowy formularz', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Pisownia', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Opcje sugestii', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Ustawienia powiadomień', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Ułatwienia dostępu', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
