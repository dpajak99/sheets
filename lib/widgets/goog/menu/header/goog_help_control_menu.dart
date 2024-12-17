import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
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
          label: const GoogText('Przeszukaj menu'),
          leading: const GoogIcon(SheetIcons.docs_icon_search_20),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Pomoc do arkuszy'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_help),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Szkolenia'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_school_graduation),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Aktualizacje'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_antenna_update),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Pomóż w ulepszaniu arkuszy'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_comment_feedback_warning),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Polityka prywatności'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_article_document),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Warunki korzystania z usługi'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_article_document),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: const GoogText('Lista funkcji'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_sigma_function),
          disabled: true,
        ),
        GoogMenuItem(
          label: const GoogText('Skróty klawiszowe'),
          trailing: const GoogText('Ctrl+/'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_keyboard),
          disabled: true,
        ),
      ],
    );
  }
}
