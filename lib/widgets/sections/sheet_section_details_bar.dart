import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class SheetSectionDetailsBar extends StatefulWidget {
  const SheetSectionDetailsBar({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetSectionDetailsBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetSectionDetailsBarState extends State<SheetSectionDetailsBar> {
  @override
  Widget build(BuildContext context) {
    return SheetTheme(
      child: Container(
        height: 28,
        padding: const EdgeInsets.only(top: 6, bottom: 5),
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
                  width: 98,
                  padding: const EdgeInsets.only(left: 14, right: 12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.sheetController.selection.stringify(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.black, fontSize: 12, height: 1),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xff444746)),
                    ],
                  ),
                );
              },
            ),
            const VerticalDivider(color: Color(0xffc7c7c7), width: 1, thickness: 1),
            Expanded(child: _FormulaBar(sheetController: widget.sheetController)),
          ],
        ),
      ),
    );
  }
}

class _FormulaBar extends StatelessWidget {
  const _FormulaBar({
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
          const AssetIcon(SheetIcons.docs_icon_function_20, size: 16, color: Color(0xff989a99)),
          // Formula bar seperator
          const SizedBox(width: 8),
          // Formula bar input
          Expanded(
            child: ListenableBuilder(
              listenable: _sheetController,
              builder: (BuildContext context, _) {
                return Text(
                  _sheetController.data
                      .getCellProperties(_sheetController.selection.value.mainCell)
                      .editableRichText
                      .toPlainText(),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black, fontSize: 14, height: 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
