import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogInsertControlMenu extends StatelessWidget {
  const GoogInsertControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogSubmenuItem(
          label: const GoogText('Komórki'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_square_rounded),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Wstaw komórki z przesunięciem w prawo'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wstaw komórki z przesunięciem w dół'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Wiersze'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_horizontal_rows),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Wstaw wiersz powyżej'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wstaw wiersz poniżej'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Kolumny'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_vertical_columns),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Wstaw kolumnę po lewej'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wstaw kolumnę po prawej'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Arkusz'),
          trailing: const GoogText('Shift + F11'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sheets_tab),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Tabele'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_chart),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Wykres'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_chart),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Tabela przestawna'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_pivot_table),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: const GoogText('Obraz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_photo_image),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Wstaw obraz w komórce'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wstaw obraz nad komórkami'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Rysunek'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_drawings),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Funkcja'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sigma_function),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('SUMA'),
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('ŚREDNIA'),
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('ILE.LICZB'),
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('MAX'),
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('MIN'),
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Wszystkie'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Analizujące'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Bazodanowe'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Data'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Filtrujące'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Finansowe'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Google'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Informacyjne'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Internetowe'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Inżynieryjne'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Logiczne'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Matematyczne'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Operator'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Statystyczne'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Tablicowe'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Teskstowe'),
                  iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Wyszukujące'),
            iconPlaceholderVisible: false,
                  popupBuilder: (BuildContext context) {
                    return const GoogMenuVertical(width: 262, children: <Widget>[]);
                  },
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Więcej informacji'),
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Link'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_link),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Pole wyboru'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_checkbox),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Menu'),
          leading: const GoogIcon(SheetIcons.docs_icon_dropdown_arrow_in_oval),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Emotikony'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_emoji),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Elementy inteligentne'),
          leading: const GoogIcon(SheetIcons.docs_icon_docs_smart_chips_18),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Komentarz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_comment),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Notatka'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_note),
          disabled: true,
        ),
      ],
    );
  }
}
