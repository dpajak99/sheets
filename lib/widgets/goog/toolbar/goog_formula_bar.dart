import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class GoogFormulaBar extends StatefulWidget {
  const GoogFormulaBar({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _GoogFormulaBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _GoogFormulaBarState extends State<GoogFormulaBar> {
  @override
  Widget build(BuildContext context) {
    return SheetTheme(
      child: Container(
        height: 28,
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xffc0c0c0)),
          ),
        ),
        child: Row(
          children: <Widget>[
            ListenableBuilder(
              listenable: widget.sheetController,
              builder: (BuildContext context, _) {
                return Container(
                  width: 100,
                  padding: const EdgeInsets.only(left: 14, right: 12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.sheetController.selection.stringify(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            height: 1,
                            fontFamily: 'GoogleSans',
                            package: 'sheets',
                          ),
                        ),
                      ),
                      const AssetIcon(
                        SheetIcons.docs_icon_arrow_dropdown,
                        width: 8,
                        height: 4,
                        color: Color(0xff444746),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 3),
              child: VerticalDivider(color: Color(0xffc7c7c7), width: 1, thickness: 1),
            ),
            Expanded(child: _GoogFormulaBarInput(sheetController: widget.sheetController)),
          ],
        ),
      ),
    );
  }
}

class _GoogFormulaBarInput extends StatelessWidget {
  const _GoogFormulaBarInput({
    required SheetController sheetController,
  }) : _sheetController = sheetController;

  final SheetController _sheetController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Row(
        children: <Widget>[
          // Formula bar label
          const AssetIcon(SheetIcons.docs_icon_function_20, size: 14, color: Color(0xff989a99)),
          // Formula bar seperator
          const SizedBox(width: 9),
          // Formula bar input
          Expanded(
            child: ListenableBuilder(
              listenable: _sheetController,
              builder: (BuildContext context, _) {
                return Text(
                  _sheetController.worksheet //
                      .getCell(_sheetController.selection.value.mainCell) //
                      .value //
                      .toPlainText(),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black, fontSize: 13, height: 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
