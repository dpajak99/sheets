import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogHelpControlMenu extends StatelessWidget {
  const GoogHelpControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogMenuItem(
          label: GoogText(t.menu.help.search),
          leading: const GoogIcon(SheetIcons.docs_icon_search_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.help.sheets_help),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_help),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.help.training),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_school_graduation),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.help.updates),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_antenna_update),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.help.help_sheets_improve),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_comment_feedback_warning),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.help.privacy_policy),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_article_document),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.help.terms_of_service),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_article_document),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.help.function_list),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sigma_function),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.help.keyboard_shortcuts),
          trailing: const GoogText('Ctrl+/'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_keyboard),
          disabled: true,
        ),
      ],
    );
  }
}
