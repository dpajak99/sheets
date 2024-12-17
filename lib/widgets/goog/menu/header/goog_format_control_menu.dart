import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogFormatControlMenu extends StatelessWidget {
  const GoogFormatControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogMenuItem(
          label: const GoogText('Motyw'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paint_palette_theme),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Liczba'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_numbers_123),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(label: const GoogText('Automatycznie'), disabled: true),
                GoogMenuItem(label: const GoogText('Zwykły tekst'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: const GoogText('Liczba'), trailing: const GoogText('1 000,12'), disabled: true),
                GoogMenuItem(label: const GoogText('Procentowy'), trailing: const GoogText('10,12%'), disabled: true),
                GoogMenuItem(label: const GoogText('Naukowy'), trailing: const GoogText('1,01E+03'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: const GoogText('Księgowy'), trailing: const GoogText('(1 000,12) zł'), disabled: true),
                GoogMenuItem(label: const GoogText('Finansowy'), trailing: const GoogText('(1 000,12)'), disabled: true),
                GoogMenuItem(label: const GoogText('Waluta'), trailing: const GoogText('1 000,12 zł'), disabled: true),
                GoogMenuItem(
                    label: const GoogText('Waluta (w zaokrągleniu)'), trailing: const GoogText('1 000 zł'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: const GoogText('Data'), trailing: const GoogText('2008_09_26'), disabled: true),
                GoogMenuItem(label: const GoogText('Godzina'), trailing: const GoogText('15:59:00'), disabled: true),
                GoogMenuItem(
                    label: const GoogText('Data i godzina'), trailing: const GoogText('2008_09_26 15:59:00'), disabled: true),
                GoogMenuItem(label: const GoogText('Data i Czas trwania'), trailing: const GoogText('24:01:00'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: const GoogText('26_09_2008'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: const GoogText('Waluta niestandardowa'), disabled: true),
                GoogMenuItem(label: const GoogText('Niestandardowa data i godzina'), disabled: true),
                GoogMenuItem(label: const GoogText('Niestandardowy format liczbowy'), disabled: true),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Tekst'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_bold),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Pogrubienie'),
                  trailing: const GoogText('Ctrl+B'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_bold),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Kursywa'),
                  trailing: const GoogText('Ctrl+I'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_italic),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Podkreślenie'),
                  trailing: const GoogText('Ctrl+U'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_underline),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Przekreślenie'),
                  trailing: const GoogText('Alt+Shift+5'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_strikethrough),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Wyrównanie'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_left),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Do lewej'),
                  trailing: const GoogText('Ctrl+Shift+L'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_left),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Wyśrodkuj'),
                  trailing: const GoogText('Ctrl+Shift+E'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_center),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Do prawej'),
                  trailing: const GoogText('Ctrl+Shift+R'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_right),
                  disabled: true,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: const GoogText('Do góry'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_top),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Do środka'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_middle),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Do dołu'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_bottom),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Zawijanie'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_wrap),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Przenieś'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_overflow),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Zawijaj'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_wrap),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Przytnij'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_clip),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Obrót'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_angle_up),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: const GoogText('Brak'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_none),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Przechyl do góry'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_angle_up),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Przechyl w dół'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_angle_down),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Ustaw pionowo'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_vertical_stack),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Obróć w górę'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_up),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: const GoogText('Obróć w dół'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_down),
                  disabled: true,
                ),
                const GoogMenuSeperator.expand(),
                GoogSubmenuItem(
                  level: 3,
                  label: const GoogText('Niestandardowy kąt'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_right_angle),
                  popupBuilder: (BuildContext context) {
                    return GoogMenuVertical(
                      width: 87,
                      children: <Widget>[
                        GoogMenuItem(label: const GoogText('-90°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-75°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-60°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-45°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-30°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-15°'), disabled: true),
                        GoogMenuItem(label: const GoogText('0°'), disabled: true),
                        GoogMenuItem(label: const GoogText('15°'), disabled: true),
                        GoogMenuItem(label: const GoogText('30°'), disabled: true),
                        GoogMenuItem(label: const GoogText('45°'), disabled: true),
                        GoogMenuItem(label: const GoogText('60°'), disabled: true),
                        GoogMenuItem(label: const GoogText('75°'), disabled: true),
                        GoogMenuItem(label: const GoogText('90°'), disabled: true),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: const GoogText('Rozmiar czcionki'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_font_text_size),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 87,
              children: <Widget>[
                GoogMenuItem(label: const GoogText('6'), disabled: true),
                GoogMenuItem(label: const GoogText('7'), disabled: true),
                GoogMenuItem(label: const GoogText('8'), disabled: true),
                GoogMenuItem(label: const GoogText('9'), disabled: true),
                GoogMenuItem(label: const GoogText('10'), disabled: true),
                GoogMenuItem(label: const GoogText('11'), disabled: true),
                GoogMenuItem(label: const GoogText('12'), disabled: true),
                GoogMenuItem(label: const GoogText('14'), disabled: true),
                GoogMenuItem(label: const GoogText('18'), disabled: true),
                GoogMenuItem(label: const GoogText('36'), disabled: true),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: const GoogText('Scal komórki'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_merge),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(label: const GoogText('Scal wszystkie'), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: const GoogText('Scal w pionie'), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: const GoogText('Scal w poziomie'), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: const GoogText('Rozdziel'), disabled: true, iconPlaceholderVisible: false),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Przekonwertuj na tabelę'),
          trailing: const GoogText('Ctrl+Alt+T'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_chart),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Formatowanie warunkowe'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paintbrush),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Naprzemienne kolory'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_opacity),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Wyczyść formatowanie'),
          trailing: const GoogText(r'Ctrl+\'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_clear_format),
          disabled: true,
        ),
      ],
    );
  }
}
