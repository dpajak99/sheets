import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
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
          label: GoogText(t.row_menu.cut),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_cut),
          trailing: const GoogText('Ctrl+X'),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.copy),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_content_copy),
          trailing: const GoogText('Ctrl+C'),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.paste),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          trailing: const GoogText('Ctrl+V'),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.row_menu.paste_special),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.values),
                  trailing: const GoogText('Ctrl+Shift+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.formatting),
                  trailing: const GoogText('Ctrl+Alt+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.formulas),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.conditional_formatting),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.data_validation),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.transposed),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.column_width),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.paste_special_options.all_without_borders),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.row_menu.insert_row_above),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.insert_row_below),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.delete_row),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.clear_row),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_close),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.hide_row),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_hide_invisible),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.resize_row),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_resize_box),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.row_menu.create_filter),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.row_menu.conditional_formatting),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.row_menu.data_validation),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.row_menu.more),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_more_ellipsis_vertical),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.row_menu.more_options.freeze(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.row_menu.more_options.group),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.row_menu.more_options.get_link_to_range),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.more_options.define_named_range),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.row_menu.more_options.protect_range),
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
