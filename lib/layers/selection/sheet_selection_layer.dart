import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/selection/sheet_selection_layer_painter.dart';

class SheetSelectionLayer extends StatefulWidget {
  const SheetSelectionLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetSelectionLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetSelectionLayerState extends State<SheetSelectionLayer> {
  late SheetSelectionLayerPainter _layerPainter;

  @override
  void initState() {
    super.initState();
    _layerPainter = SheetSelectionLayerPainter(
      sheetSelection: widget.sheetController.selection.value,
      viewport: widget.sheetController.viewport,
    );
    widget.sheetController.selection.addListener(_updateSelection);
    widget.sheetController.viewport.addListener(_updateViewport);
  }

  @override
  void dispose() {
    widget.sheetController.selection.removeListener(_updateSelection);
    widget.sheetController.viewport.removeListener(_updateViewport);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _layerPainter),
    );
  }

  void _updateSelection() {
    _layerPainter.setSheetSelection(widget.sheetController.selection.value);
  }

  void _updateViewport() {
    _layerPainter.setViewport(widget.sheetController.viewport);
  }
}
