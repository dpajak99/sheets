import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogEditControlMenu extends StatelessWidget {
  const GoogEditControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogMenuItem(
          label: const GoogText('Cofnij'),
          trailing: const GoogText('Ctrl+Z'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_undo),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Ponów'),
          trailing: const GoogText('Ctrl+Y'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_redo),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Wytnij'),
          trailing: const GoogText('Ctrl+X'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_cut),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Kopiuj'),
          trailing: const GoogText('Ctrl+C'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_content_copy),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wklej'),
          trailing: const GoogText('Ctrl+V'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
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
          label: const GoogText('Przenieś'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_drag_move),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: const GoogText('Usuń'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Wartości'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wiersz 1'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Kolumna A'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Komórki z przesunięciem w górę'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Komórki z przesunięciem w lewo'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Uwagi'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Znajdź i zamień'),
          trailing: const GoogText('Ctrl+H'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_find_replace),
          disabled: true,
        ),
      ],
    );
  }
}
