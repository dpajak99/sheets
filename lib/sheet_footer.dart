import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_widget.dart';

class SheetFooter extends StatelessWidget {
  final SheetController sheetController;
  final MouseListener mouseListener;

  const SheetFooter({
    required this.sheetController,
    required this.mouseListener,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: mouseListener,
      builder: (BuildContext context, _) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text('Mouse position: ${mouseListener.offset}'),
              const SizedBox(width: 16),
              Text('Hovered element: ${mouseListener.hoveredElement}'),
            ],
          ),
        );
      },
    );
  }
}
