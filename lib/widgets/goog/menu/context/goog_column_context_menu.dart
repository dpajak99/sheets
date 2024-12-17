import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogColumnContextMenu extends StatelessWidget {
  const GoogColumnContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 401,
      children: <Widget>[
        GoogMenuItem(
          label: const GoogText('Wytnij'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_cut),
          trailing: const GoogText('Ctrl+X'),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Kopiuj'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_content_copy),
          trailing: const GoogText('Ctrl+C'),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wklej'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          trailing: const GoogText('Ctrl+V'),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: const GoogText('Wklej specjalne'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Tylko wartości'),
                  trailing: const GoogText('Ctrl+Shift+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Tylko formatowanie'),
                  trailing: const GoogText('Ctrl+Alt+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Tylko formuła'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Tylko formatowanie warunkowe'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Tylko sprawdzanie poprawności danych'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Z transpozycją'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Tylko szerkość kolumny'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wszystko oprócz obramowania'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Wstaw kolumnę po lewej'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wstaw kolumnę po prawej'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Usuń kolumnę'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wyczyść kolumnę'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_close),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Ukryj kolumnę'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_hide_invisible),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Zmień rozmiar kolumny'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_resize_box),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Utwórz filtr'),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Sortuj arkusz Od A do Z'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_alphabetical_sort),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Sortuj arkusz Od Z do A'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_alphabetical_sort_reverse),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Formatowanie warunkowe'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paintbrush),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Sprawdzanie poprawności danych'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_check),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Statystyki dotyczące kolumn'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_lightbulb),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Menu'),
          leading: const GoogIcon(SheetIcons.docs_icon_dropdown_arrow_in_oval),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: const GoogText('Elementy inteligentne'),
          leading: const GoogIcon(SheetIcons.docs_icon_docs_smart_chips_18),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Osoby'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Plik'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wydarzenia w kalendarzu'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Miejsce'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Finanse'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Ocena'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Zobacz więcej czynności dotyczących kolumny'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_more_ellipsis_vertical),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Zablokuj kolumny do G'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Grupuj kolumnę'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Pobierz link do tego zakresu'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Losuj w zakresie'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Zdefiniuj zakres nazwany'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Chroń zakres'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
