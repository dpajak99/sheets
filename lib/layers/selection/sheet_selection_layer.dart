import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
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
    widget.sheetController.addListener(_handleSheetControllerChanged);
  }

  @override
  void dispose() {
    widget.sheetController.removeListener(_handleSheetControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _layerPainter),
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildConfig rebuildConfig = widget.sheetController.value;
    if (rebuildConfig.rebuildSelection) {
      _layerPainter.setSheetSelection(widget.sheetController.selection.value);
      _layerPainter.setViewport(widget.sheetController.viewport);
    }
  }
}
