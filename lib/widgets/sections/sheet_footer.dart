import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/sections/sheet_footer_action_button.dart';
import 'package:sheets/widgets/sections/sheet_footer_tab.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class SheetFooter extends StatelessWidget {
  const SheetFooter({super.key});

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
            SheetFooterActionButton(
              onPressed: () {},
              icon: SheetIcons.footer_add,
              iconSize: 10,
            ),
            const SizedBox(width: 6),
            SheetFooterActionButton(
              onPressed: () {},
              icon: SheetIcons.footer_menu,
              iconSize: 13,
            ),
            const SizedBox(width: 16),
            SheetFooterTab(
              title: 'Sheet1',
              selected: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
