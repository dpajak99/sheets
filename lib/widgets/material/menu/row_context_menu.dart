import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';

class RowContextMenu extends StatelessWidget {
  const RowContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownListMenu(
      width: 401,
      children: [
        DropdownListMenuItem(
          label: 'Wytnij',
          icon: SheetIcons.docs_icon_arrow_dropdown,
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
          icon: SheetIcons.docs_icon_arrow_dropdown,
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
          icon: SheetIcons.docs_icon_arrow_dropdown,
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
        DropdownListMenuItem(label: 'Wklej specjalne', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Wstaw wiersz powyżej', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Wstaw wiersz poniżej', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Usuń wiersz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Wyczyść wiersz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Ukryj wiersz', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuItem(label: 'Zmień rozmiar wiersza', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
        DropdownListMenuDivider(),
        DropdownListMenuItem(label: 'Utwórz filtr', icon: SheetIcons.docs_icon_arrow_dropdown, disabled: true),
      ],
    );
  }
}
