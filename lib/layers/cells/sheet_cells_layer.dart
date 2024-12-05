import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/cells/sheet_cells_layer_painter.dart';

class SheetCellsLayer extends StatefulWidget {
  const SheetCellsLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetCellsLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetCellsLayerState extends State<SheetCellsLayer> {
  late final SheetCellsLayerPainter _layerPainter;

  @override
  void initState() {
    super.initState();
    _layerPainter = SheetCellsLayerPainter(
      viewportContent: widget.sheetController.viewport.visibleContent,
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
    SheetRebuildConfig properties = widget.sheetController.value;
    if (properties.rebuildCellsLayer) {
      _updateVisibleCells();
    }
  }

  void _updateVisibleCells() {
    _layerPainter.update(widget.sheetController.viewport.visibleContent);
  }
}
