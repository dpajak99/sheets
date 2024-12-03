import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/layers/headers/sheet_headers_painter.dart';

class SheetHeadersLayer extends StatefulWidget {
  const SheetHeadersLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetHeadersLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetHeadersLayerState extends State<SheetHeadersLayer> {
  late final SheetHorizontalHeadersPainter columnHeadersPainter;
  late final SheetVerticalHeadersPainter rowHeadersPainter;

  @override
  void initState() {
    super.initState();
    columnHeadersPainter = SheetHorizontalHeadersPainter(
      visibleColumns: widget.sheetController.viewport.visibleContent.columns,
      selection: widget.sheetController.selection.value,
    );
    rowHeadersPainter = SheetVerticalHeadersPainter(
      visibleRows: widget.sheetController.viewport.visibleContent.rows,
      selection: widget.sheetController.selection.value,
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
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary(
          child: CustomPaint(isComplex: true, painter: columnHeadersPainter),
        ),
        RepaintBoundary(
          child: CustomPaint(isComplex: true, painter: rowHeadersPainter),
        ),
      ],
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildConfig rebuildConfig = widget.sheetController.value;
    if (rebuildConfig.rebuildHorizontalHeaders) {
      _updateVisibleColumns();
    }
    if(rebuildConfig.rebuildVerticalHeaders) {
      _updateVisibleRows();
    }
  }

  void _updateVisibleColumns() {
    columnHeadersPainter.visibleColumns = widget.sheetController.viewport.visibleContent.columns;
    columnHeadersPainter.selection = widget.sheetController.selection.value;
  }

  void _updateVisibleRows() {
    rowHeadersPainter.visibleRows = widget.sheetController.viewport.visibleContent.rows;
    rowHeadersPainter.selection = widget.sheetController.selection.value;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetHorizontalHeadersPainter>('columnHeadersPainter', columnHeadersPainter));
    properties.add(DiagnosticsProperty<SheetVerticalHeadersPainter>('rowHeadersPainter', rowHeadersPainter));
  }
}
