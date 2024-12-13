import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarExtensionsContextMenu extends StatelessWidget {
  const AppBarExtensionsContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Dodatki', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Makra', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Apps Script', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
      ],
    );
  }
}