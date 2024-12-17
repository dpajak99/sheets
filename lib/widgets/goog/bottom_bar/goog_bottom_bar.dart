import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/bottom_bar/goog_bottom_bar_button.dart';
import 'package:sheets/widgets/goog/bottom_bar/goog_bottom_bar_tab.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class GoogBottomBar extends StatelessWidget {
  const GoogBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetTheme(
      child: Container(
        height: 36,
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xffF9FBFD)),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 45),
            GoogBottomBarButton(
              onPressed: () {},
              icon: SheetIcons.docs_icon_add_20,
            ),
            const SizedBox(width: 6),
            GoogBottomBarButton(
              onPressed: () {},
              icon: SheetIcons.docs_icon_menu_20,
            ),
            const SizedBox(width: 16),
            GoogBottomBarTab(
              title: t.bottom_bar.tab_name(index: 1),
              selected: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
