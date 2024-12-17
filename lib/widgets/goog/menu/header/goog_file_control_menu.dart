import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
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
          label: GoogText(t.menu.file.kNew),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_spreadsheet_black),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.file.new_options.spreadsheet),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_spreadsheet_green),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.new_options.template),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paintbrush_box),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.open),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_folder),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.import),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_import),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.make_copy),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_file_copy),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.file.share),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_person),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.file.share_options.email),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_add_person),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.share_options.web),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_globe),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.file.email),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_email_outline),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.file.email_options.file),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.email_options.collaborators),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.file.download),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_download),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.file.download_options.xlsx),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.download_options.ods),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.download_options.pdf),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.download_options.html),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.download_options.csv),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.download_options.tsv),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.file.rename),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_rename),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.move),
          leading: const GoogIcon(SheetIcons.docs_icon_folder_move),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.add_to_drive),
          leading: const GoogIcon(SheetIcons.docs_icon_add_to_drive_2021),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.move_to_trash),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_delete_trash),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.file.version_history),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_history_restore),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.file.version_history_options.name_current_version),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.file.version_history_options.see_version_history),
                  disabled: true,
                  iconPlaceholderVisible: false,
                ),
              ],
            );
          },
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.make_available_offline),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_offline_pin),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.file.details),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_info),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.security_limitations),
          leading: const GoogIcon(SheetIcons.docs_icon_policy_18x18),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.settings),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_settings_gear),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.file.language),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_internet_globe),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.file.print),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_print),
          disabled: true,
        ),
      ],
    );
  }
}
