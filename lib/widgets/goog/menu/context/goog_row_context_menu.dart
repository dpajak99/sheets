import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogRowContextMenu extends StatelessWidget {
  const GoogRowContextMenu({super.key});

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
          label: const GoogText('Wstaw wiersz powyżej'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wstaw wiersz poniżej'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Usuń wiersz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wyczyść wiersz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_close),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Ukryj wiersz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_hide_invisible),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Zmień rozmiar wiersza'),
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
          label: const GoogText('Formatowanie warunkowe'),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Sprawdzanie poprawności danych'),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Zobacz więcej czynności dotyczących wiersza'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_more_ellipsis_vertical),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Zablokuj dp wiersza 26'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Grupuj wiersz'),
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
