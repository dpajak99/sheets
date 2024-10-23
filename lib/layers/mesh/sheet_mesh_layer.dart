import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/mesh/sheet_mesh_layer_painter.dart';

class SheetMeshLayer extends StatefulWidget {
  const SheetMeshLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetMeshLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetMeshLayerState extends State<SheetMeshLayer> {
  late final SheetMeshLayerPainter _layerPainter;

  @override
  void initState() {
    super.initState();
    _layerPainter = SheetMeshLayerPainter(
      visibleColumns: widget.sheetController.viewport.visibleContent.columns,
      visibleRows: widget.sheetController.viewport.visibleContent.rows,
    );
    widget.sheetController.viewport.visibleContent.addListener(_updateVisibleCells);
  }

  @override
  void dispose() {
    widget.sheetController.viewport.visibleContent.removeListener(_updateVisibleCells);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _layerPainter),
    );
  }

  void _updateVisibleCells() {
    _layerPainter.update(
      widget.sheetController.viewport.visibleContent.columns,
      widget.sheetController.viewport.visibleContent.rows,
    );
  }
}
