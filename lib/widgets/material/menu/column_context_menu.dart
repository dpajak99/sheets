import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class ColumnContextMenu extends StatelessWidget {
  const ColumnContextMenu({super.key});

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
        DropdownListMenuItem(label: 'Wstaw kolumnę po lewej', icon: SheetIcons.add, disabled: true),
        DropdownListMenuItem(label: 'Wstaw kolumnę po prawej', icon: SheetIcons.add, disabled: true),
        DropdownListMenuItem(label: 'Usuń kolumnę', icon: SheetIcons.delete, disabled: true),
        DropdownListMenuItem(label: 'Wyczyść kolumnę', icon: SheetIcons.close, disabled: true),
        DropdownListMenuItem(label: 'Ukryj kolumnę', icon: SheetIcons.visibility_off, disabled: true),
        DropdownListMenuItem(label: 'Zmień rozmiar kolumny', icon: SheetIcons.aspect_ratio, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Utwórz filtr', icon: SheetIcons.filter_alt, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Sortuj arkusz Od A do Z', icon: SheetIcons.sort_az, disabled: true),
        DropdownListMenuItem(label: 'Sortuj arkusz Od Z do A', icon: SheetIcons.sort_za, disabled: true),
      ],
    );
  }
}
