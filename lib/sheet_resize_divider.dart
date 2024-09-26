import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/painters/header_resizer_painter.dart';

class VerticalHeadersResizer extends StatelessWidget {
  final SheetController sheetController;

  const VerticalHeadersResizer({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [

      ],
    );
  }

  // return CustomPaint(
  // isComplex: true,
  // painter: ColumnHeadersResizerPainter(sheetController: widget.sheetController),
  // );
}

class VerticalHeaderResizer extends StatefulWidget {
  final ColumnConfig column;

  const VerticalHeaderResizer({
    required this.column,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VerticalHeaderResizerState();
}

class _VerticalHeaderResizerState extends State<VerticalHeaderResizer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ColumnHeaderResizerPainter(column: widget.column),
    );
  }
}