import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogEditControlMenu extends StatelessWidget {
  const GoogEditControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogMenuItem(
          label: GoogText(t.menu.edit.undo),
          trailing: const GoogText('Ctrl+Z'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_undo),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.edit.redo),
          trailing: const GoogText('Ctrl+Y'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_redo),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.edit.cut),
          trailing: const GoogText('Ctrl+X'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_cut),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.edit.copy),
          trailing: const GoogText('Ctrl+C'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_content_copy),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.edit.paste),
          trailing: const GoogText('Ctrl+V'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.edit.paste_special),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paste),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.values),
                  trailing: const GoogText('Ctrl+Shift+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.formatting),
                  trailing: const GoogText('Ctrl+Alt+V'),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.formulas),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.conditional_formatting),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.data_validation),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.transposed),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.column_width),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.paste_special_options.all_without_borders),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.edit.move),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_drag_move),
          disabled: true,
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.edit.delete),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.edit.delete_options.values),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.delete_options.row(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.delete_options.column(index: 1)),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.delete_options.cells_shift_up),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.delete_options.cells_shift_left),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.edit.delete_options.notes),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.edit.find_and_replace),
          trailing: const GoogText('Ctrl+H'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_find_replace),
          disabled: true,
        ),
      ],
    );
  }
}
