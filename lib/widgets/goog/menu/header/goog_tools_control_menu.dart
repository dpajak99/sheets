import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogToolsControlMenu extends StatelessWidget {
  const GoogToolsControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 401,
      children: <Widget>[
        GoogMenuItem(
          label: const GoogText('Utwórz nowy formularz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_logo_forms),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Pisownia'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_spellcheck),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Sprawdzanie pisowni'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Słownik osobisty'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Opcje sugestii'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_auto_complete_draw),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 527,
              children: <Widget>[
                GoogMenuItem(label: const GoogText('Włącz autouzupełnianie'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugestie dotyczące formuł'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz poprawki formuły'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugeste funkcji nazwanych'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugeste dotyczące tabel przestawnych'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugeste związane z elementami menu'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugeste związane z inteligentnymi elementami dotyczącymi osób'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugeste dotyczące tabel'), disabled: true),
                GoogMenuItem(label: const GoogText('Włącz sugeste dotyczące analizy danych'), disabled: true),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Ustawienia powiadomień'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_notification_bell),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(label: const GoogText('Powiadomienia o edycji'), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: const GoogText('Powiadomienia o komentarzech'), disabled: true, iconPlaceholderVisible: false),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Ułatwienia dostępu'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_accessibility_person),
          disabled: true,
        ),
      ],
    );
  }
}
