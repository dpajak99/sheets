import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
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
          label: GoogText(t.menu.insert.cells),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_square_rounded),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.insert.cells_options.cells_and_shift_right),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.cells_options.cells_and_shift_down),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.insert.rows),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_horizontal_rows),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.insert.rows_options.above),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.rows_options.below),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.insert.columns),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_vertical_columns),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.insert.columns_options.left),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.columns_options.right),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: GoogText(t.menu.insert.sheet),
          trailing: const GoogText('Shift + F11'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sheets_tab),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.insert.tables),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_chart),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.insert.chart),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_chart),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.insert.pivot_table),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_pivot_table),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.insert.image),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_photo_image),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.insert.image_options.in_cell),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.image_options.over_cells),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: GoogText(t.menu.insert.drawing),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_drawings),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.insert.function),
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
          label: GoogText(t.menu.insert.link),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_link),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.insert.checkbox),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_checkbox),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.insert.dropdown),
          leading: const GoogIcon(SheetIcons.docs_icon_dropdown_arrow_in_oval),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.insert.emoji),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_emoji),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.insert.smart_chips),
          leading: const GoogIcon(SheetIcons.docs_icon_docs_smart_chips_18),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.insert.smart_chips_options.people),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.smart_chips_options.file),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.smart_chips_options.calendar),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.smart_chips_options.place),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.smart_chips_options.finance),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.insert.smart_chips_options.rating),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.insert.comment),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_comment),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.insert.note),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_note),
          disabled: true,
        ),
      ],
    );
  }
}
