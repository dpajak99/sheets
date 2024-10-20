import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/selection/sheet_selection_layer_painter.dart';

class SheetSelectionLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetSelectionLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetSelectionLayerState();
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
    _layerPainter.sheetSelection = widget.sheetController.selection.value;
  }

  void _updateViewport() {
    _layerPainter.viewport = widget.sheetController.viewport;
  }
}

