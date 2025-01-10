import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/bottom_bar/goog_bottom_bar_button.dart';
import 'package:sheets/widgets/goog/bottom_bar/goog_bottom_bar_tab.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class GoogBottomBar extends StatelessWidget {
  const GoogBottomBar({
    required this.controller,
    super.key,
  });

  final SheetController controller;

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
            ListenableBuilder(
              listenable: controller,
              builder: (BuildContext context, _) {
                return Row(
                  children: <Widget>[
                    for( int i = 0; i < controller.workbook.worksheets.length; i++ )
                      GoogBottomBarTab(
                        title: controller.workbook.worksheets[i].name ?? t.bottom_bar.tab_name(index: i),
                        selected: i == controller.worksheetIndex,
                        onPressed: () {
                          controller.resolve(ChangeWorksheetEvent(i));
                        },
                      ),
                  ]
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('controller', controller));
  }
}
