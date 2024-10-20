import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/headers_resizer/sheet_horizontal_headers_resizer_layer.dart';
import 'package:sheets/layers/headers_resizer/sheet_vertical_headers_resizer_layer.dart';

class HeadersResizerLayer extends StatelessWidget {
  final SheetController sheetController;

  const HeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: SheetVerticalHeadersResizerLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetHorizontalHeadersResizerLayer(sheetController: sheetController)),
      ],
    );
  }
}
