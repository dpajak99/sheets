import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogViewControlMenu extends StatelessWidget {
  const GoogViewControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogSubmenuItem(
          label: const GoogText('Pokaż'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_view_show),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Pasek formuły'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Linie siatki'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Formuły'),
                  trailing: const GoogText('Ctrl+`'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Zakresy chronione'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Zablokuj'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_freeze_row_column),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Nie blokuj wierszy'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wiersze: 1'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wiersze: 2'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Do wiersza 12'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Nie blokuj kolumn'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Kolumny: 1'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Kolumny: 2'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Do kolumny F'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Grupuj'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_box),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Grupuj'),
                  leading: const GoogText('Alt+Shift+→'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Rozgrupuj'),
                  leading: const GoogText('Alt+Shift+←'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Komentarze'),
          leading: const GoogIcon(SheetIcons.docs_icon_comment_18x18),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Ukryj komentarze'),
                  leading: const GoogText('Ctrl+Alt+Shift+J'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Minimalizuj komentarze'),
                  leading: const GoogText('Ctrl+Alt+Shift+W Ctrl+Alt+Shift+M'),
                  disabled: true,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Pokaż wszystkie komentarze'),
                  leading: const GoogText('Ctrl+Alt+Shift+A'),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Ukryte arkusze'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sheets_tab),
          popupBuilder: (BuildContext context) {
            return const GoogMenuVertical(
              width: 262,
              children: <Widget>[],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Zoom'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_zoom_in),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 95,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('50%'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('75%'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('100%'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('125%'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('150%'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('200%'),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Pełny ekran'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_fullscreen),
          disabled: true,
        ),
      ],
    );
  }
}
