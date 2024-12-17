import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogFileControlMenu extends StatelessWidget {
  const GoogFileControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogSubmenuItem(
          label: const GoogText('Nowy'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_spreadsheet_black),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Arkusz kalkulacyjny'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_spreadsheet_green),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Z galerii szablonów'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paintbrush_box),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: const GoogText('Otwórz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_folder),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Importuj'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_import),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Utwórz kopię'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_file_copy),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Udostepnij'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_person),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Udostępnij innym'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_person),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Opublikuj w internecie'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_globe),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Wyślij e-mailem'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_email_outline),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Wyślij ten plik emailem'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wyślij emaila do współpracowników'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Pobierz'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_download),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Microsoft Excel (.xlsx)'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('OpenDocument (.ods)'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('PDF (.pdf)'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Strona internetowa (.html)'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wartości rozdzielane przecinkami (.csv)'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: const GoogText('Wartości rozdzielane tabulatorami (.tsv)'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Zmień nazwę'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_rename),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Przenieś'),
          leading: const GoogIcon(SheetIcons.docs_icon_folder_move),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Dodaj skrót do dysku'),
          leading: const GoogIcon(SheetIcons.docs_icon_add_to_drive_2021),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Przenieś do kosza'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Historia zmian'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_history_restore),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Udostępnij offline'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_offline_pin),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Szczegóły'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_info),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Ograniczenia zabezpieczeń'),
          leading: const GoogIcon(SheetIcons.docs_icon_policy_18x18),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Ustawienia'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_settings_gear),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Język'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_internet_globe),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Drukuj'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_print),
          disabled: true,
        ),
      ],
    );
  }
}
