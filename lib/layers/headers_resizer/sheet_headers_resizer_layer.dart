import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/headers_resizer/sheet_horizontal_headers_resizer_layer.dart';
import 'package:sheets/layers/headers_resizer/sheet_vertical_headers_resizer_layer.dart';

class HeadersResizerLayer extends StatelessWidget {
  const HeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}
