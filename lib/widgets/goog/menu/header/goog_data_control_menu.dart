import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
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
        GoogSubmenuItem(
          label: GoogText(t.menu.data.sort_sheet),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sort),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 361,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.data.sort_sheet_options.by_column_asc(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.data.sort_sheet_options.by_column_desc(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.data.sort_range),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sort),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 361,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.data.sort_range_options.by_column_asc(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.data.sort_range_options.by_column_desc(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.menu.data.sort_range_options.advanced),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.data.create_filter),
          leading: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.create_filter_view),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_plus),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.add_slicer),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_filter_bars),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.data.protect_sheet),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_lock_close),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.named_ranges),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_tab),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.named_functions),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sigma_function),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.randomize_range),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_shuffle_swap),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.data.column_stats),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_lightbulb),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.data_validation),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_check),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.data.data_cleanup),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_auto_fix_wand),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 361,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.data.data_cleanup_options.cleanup_suggestions),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.data.data_cleanup_options.remove_duplicates),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.data.data_cleanup_options.trim_whitespace),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.split_to_columns),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_split_columns),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.data.data_extraction),
          leading: const GoogIcon(SheetIcons.docs_icon_chip_extraction_18x18),
          disabled: true,
        ),
      ],
    );
  }
}
