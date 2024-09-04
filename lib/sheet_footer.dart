import 'package:flutter/material.dart';
import 'package:sheets/sheet_controller.dart';

class SheetFooter extends StatefulWidget {
  final SheetController sheetController;
  final ValueNotifier<Offset> mousePosition;

  const SheetFooter({
    required this.sheetController,
    required this.mousePosition,
    super.key,
  });

  @override
  State<SheetFooter> createState() => _SheetFooterState();
}

class _SheetFooterState extends State<SheetFooter> {
  late Offset mousePosition;

  @override
  void initState() {
    super.initState();
    mousePosition = widget.mousePosition.value;
    widget.mousePosition.addListener(_handleMousePositionChange);
  }

  @override
  void dispose() {
    widget.mousePosition.removeListener(_handleMousePositionChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text('Mouse position: $mousePosition'),
          const SizedBox(width: 16),
          Text('Hovered element: ${widget.sheetController.getHoveredElement(mousePosition)}'),
        ],
      ),
    );
  }

  void _handleMousePositionChange() {
    setState(() {
      mousePosition = widget.mousePosition.value;
    });
  }
}
