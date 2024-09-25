import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SheetFooter extends StatelessWidget {
  final SheetControllerOld sheetController;

  const SheetFooter({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return ListenableBuilder(
    //   listenable: sheetController.cursorController,
    //   builder: (BuildContext context, _) {
    //     return Container(
    //       color: Colors.white,
    //       padding: const EdgeInsets.all(8),
    //       child: Row(
    //         children: [
    //           Text('Mouse position: ${sheetController.cursorController.position}'),
    //           const SizedBox(width: 16),
    //           Text('Hovered element: ${sheetController.cursorController.hoveredElement?.value}'),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
