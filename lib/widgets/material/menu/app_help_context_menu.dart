import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class AppBarHelpContextMenu extends StatelessWidget {
  const AppBarHelpContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: <Widget>[
        DropdownListMenuItem(label: 'Przeszukaj menu', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Pomoc do arkuszy', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Szkolenia', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Aktualizacje', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Pomóż w ulepszaniu arkuszy', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Polityka prywatności', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Warunki korzystania z usługi', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Lista funkcji', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuItem(label: 'Skróty klawiszowe', icon: SheetIcons.content_paste, disabled: true),
      ],
    );
  }
}
