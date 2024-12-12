import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class CellContextMenu extends StatelessWidget {
  const CellContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: [
        DropdownListMenuItem(
          label: 'Wytnij',
          icon: SheetIcons.content_cut,
          trailing: Text(
            'Ctrl+X',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'GoogleSans',
              package: 'sheets',
              letterSpacing: 0,
              color: Color(0xff80868B),
            ),
          ),
          disabled: true,
        ),
        DropdownListMenuItem(
          label: 'Kopiuj',
          icon: SheetIcons.content_copy,
          trailing: Text(
            'Ctrl+C',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'GoogleSans',
              package: 'sheets',
              letterSpacing: 0,
              color: Color(0xff80868B),
            ),
          ),
          disabled: true,
        ),
        DropdownListMenuItem(
          label: 'Wklej',
          icon: SheetIcons.content_paste,
          trailing: Text(
            'Ctrl+V',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'GoogleSans',
              package: 'sheets',
              letterSpacing: 0,
              color: Color(0xff80868B),
            ),
          ),
          disabled: true,
        ),
        DropdownListMenuItem(label: 'Wklej specjalne', icon: SheetIcons.content_paste, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Wstaw wiersz powyzej', icon: SheetIcons.add, disabled: true),
        DropdownListMenuItem(label: 'Wstaw wiersz ponizej', icon: SheetIcons.add, disabled: true),
        DropdownListMenuItem(label: 'Wstaw komórki', icon: SheetIcons.add, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Usuń wiersz', icon: SheetIcons.delete, disabled: true),
        DropdownListMenuItem(label: 'Usuń kolumnę', icon: SheetIcons.delete, disabled: true),
        DropdownListMenuItem(label: 'Usuń komórki', icon: SheetIcons.delete, disabled: true),
      ],
    );
  }
}
