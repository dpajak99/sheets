import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogCellContextMenu extends StatelessWidget {
  const GoogCellContextMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 401,
      children: <Widget>[
        GoogMenuItem(
          label: GoogText(t.cell_menu.cut),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_cut),
          trailing: const GoogText('Ctrl+X'),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.copy),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_content_copy),
          trailing: const GoogText('Ctrl+C'),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.paste),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          trailing: const GoogText('Ctrl+V'),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.cell_menu.paste_special),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.values),
                  trailing: const GoogText('Ctrl+Shift+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.formatting),
                  trailing: const GoogText('Ctrl+Alt+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.formulas),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.conditional_formatting),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.data_validation),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.transposed),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.column_width),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.paste_special_options.all_without_borders),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.cell_menu.insert_row_above),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.insert_column_left),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.cell_menu.insert_cells),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.cell_menu.insert_cells_options.cells_and_shift_right),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.insert_cells_options.cells_and_shift_down),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.cell_menu.delete_row),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.delete_column),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.cell_menu.delete_cells),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.cell_menu.delete_cells_options.cells_and_shift_left),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.delete_cells_options.cells_and_shift_up),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.cell_menu.convert_to_table),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_chart),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.create_filter),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.filter_by_cell_value),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.cell_menu.show_edit_history),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_user_edit_history),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.cell_menu.insert_link),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_link),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.comment),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_comment),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.insert_note),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_note),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.tables),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_chart),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.cell_menu.dropdown),
          leading: const GoogIcon(SheetIcons.docs_icon_dropdown_arrow_in_oval),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.cell_menu.smart_chips),
          leading: const GoogIcon(SheetIcons.docs_icon_docs_smart_chips_18),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.cell_menu.smart_chips_options.people),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.smart_chips_options.file),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.smart_chips_options.calendar),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.smart_chips_options.place),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.smart_chips_options.finance),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.smart_chips_options.rating),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.cell_menu.more),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_more_ellipsis_vertical),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.cell_menu.more_options.conditional_formatting),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.more_options.data_validation),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.more_options.get_link_to_cell),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.more_options.define_named_range),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.cell_menu.more_options.protect_range),
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
