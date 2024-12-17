import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
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
          label: GoogText(t.menu.view.show),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_view_show),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.view.show_options.formula_bar),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.show_options.gridlines),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.show_options.formulas),
                  trailing: const GoogText('Ctrl+`'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.show_options.protected_ranges),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.view.freeze),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_freeze_row_column),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.no_rows),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.k1Row),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.k2Rows),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.up_to_current_row(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.no_columns),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.k1Column),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.k2Columns),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.freeze_options.up_to_current_column(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.view.group),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_box),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.view.group_options.group),
                  leading: const GoogText('Alt+Shift+→'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.group_options.ungroup),
                  leading: const GoogText('Alt+Shift+←'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.view.comments),
          leading: const GoogIcon(SheetIcons.docs_icon_comment_18x18),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.view.comments_options.hide_comments),
                  leading: const GoogText('Ctrl+Alt+Shift+J'),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.view.comments_options.minimize_comments),
                  leading: const GoogText('Ctrl+Alt+Shift+W Ctrl+Alt+Shift+M'),
                  disabled: true,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.menu.view.comments_options.show_all),
                  leading: const GoogText('Ctrl+Alt+Shift+A'),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.view.hidden_sheets),
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
          label: GoogText(t.menu.view.zoom),
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
          label: GoogText(t.menu.view.full_screen),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_fullscreen),
          disabled: true,
        ),
      ],
    );
  }
}
