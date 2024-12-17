import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
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
          label: GoogText(t.menu.tools.create_new_form),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_logo_forms),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.tools.spelling),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_spellcheck),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.tools.spelling_options.spell_check),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.tools.spelling_options.personal_dictionary),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.tools.suggestion_controls),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_auto_complete_draw),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 527,
              children: <Widget>[
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_autocomplete), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_formula_suggestions), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_formula_corrections), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_named_functions_suggestions), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_pivot_table_suggestions), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_dropdown_chip_suggestions), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_people_suggestions), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_table_suggestions), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.tools.suggestion_controls_options.enable_data_analysis_suggestions), disabled: true),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.tools.notifications_settings),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_notification_bell),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(label: GoogText(t.menu.tools.notifications_settings_options.edit_notifications), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: GoogText(t.menu.tools.notifications_settings_options.comment_notifications), disabled: true, iconPlaceholderVisible: false),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: GoogText(t.menu.tools.accessibility),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_accessibility_person),
          disabled: true,
        ),
      ],
    );
  }
}
