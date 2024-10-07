import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';

class SheetSectionDetailsBar extends StatefulWidget {
  final SheetController sheetController;

  const SheetSectionDetailsBar({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetSectionDetailsBarState();
}

class _SheetSectionDetailsBarState extends State<SheetSectionDetailsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.only(top: 6, bottom: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffc0c0c0), width: 1),
        ),
      ),
      child: Row(
        children: <Widget>[
          ListenableBuilder(
            listenable: widget.sheetController.selectionController,
            builder: (BuildContext context, _) {
              return Container(
                width: 98,
                padding: const EdgeInsets.only(left: 14, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.sheetController.selectionController.visibleSelection.stringifySelection(),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: const Row(
              children: [
                AssetIcon(SheetIcons.function, size: 16, color: Color(0xff989a99)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
