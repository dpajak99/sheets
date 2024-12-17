import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogDataControlMenu extends StatelessWidget {
  const GoogDataControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogMenuItem(
          label: const GoogText('Sortuj arkusz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sort),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Sortuj zakres'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sort),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Utwórz filtr'),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Utwórz widok filtra'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Dodaj fragmentator'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_filter_bars),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Chroń arkusze i zakresy'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_lock_close),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Zakresy nazwane'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_tab),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Funkcje nazwane'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sigma_function),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Losuj zakres'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_shuffle_swap),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Statystyki dotyczące kolumn'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_lightbulb),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Sprawdzanie poprawności danych'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_check),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: const GoogText('Czyszczenie danych'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_auto_fix_wand),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 361,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Sugestie dotyczące czyszczenia danych'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Usuń duplikaty'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Usuń spacje'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Podziel tekst na kolumny'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_split_columns),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Wyodrębnianie danych'),
          leading: const GoogIcon(SheetIcons.docs_icon_chip_extraction_18x18),
          disabled: true,
        ),
      ],
    );
  }
}
