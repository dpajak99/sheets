import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart' show ViewportCell;
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/layers/sheet/helpers/background_color_painter.dart';
import 'package:sheets/layers/sheet/helpers/cell_text_painter.dart';
import 'package:sheets/layers/sheet/helpers/pinned_cell_groups.dart';
import 'package:sheets/layers/sheet/helpers/mesh_painter.dart';
import 'package:sheets/layers/sheet/helpers/pinned_border_painter.dart';
import 'package:sheets/layers/sheet/helpers/style_based_painter_builder.dart';

class _Region {
  _Region({required this.cells, required this.clip});

  final List<ViewportCell> cells;
  final Rect clip;
}

class CellsDrawingController extends ChangeNotifier {
  void rebuild() {
    notifyListeners();
  }
}

class SheetCellsLayerPainter extends CustomPainter {
  SheetCellsLayerPainter({
    required this.worksheet,
    required CellsDrawingController drawingController,
    EdgeInsets? padding,
  })  : _padding =
            padding ?? const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        super(repaint: drawingController);

  final Worksheet worksheet;
  final EdgeInsets _padding;

  SheetViewportContentManager get _visibleContent =>
      worksheet.viewport.visibleContent;

  @override
  void paint(Canvas canvas, Size size) {
    _clipCellsLayerBox(canvas, size);
    final PinnedCellGroups groups =
        groupPinnedCells(_visibleContent.cells, worksheet.data);
    final List<_Region> regions = _buildRegions(size, groups);

    for (final _Region region in regions) {
      if (region.cells.isEmpty) continue;
      canvas.save();
      canvas.clipRect(region.clip);
      _paintCells(canvas, region.cells);
      canvas.restore();
    }

    _paintMesh(canvas, regions);

    _paintPinnedBorders(canvas, size);
  }

  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._visibleContent != _visibleContent ||
        oldDelegate._padding != _padding;
  }

  void _clipCellsLayerBox(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth + borderWidth,
        columnHeadersHeight + borderWidth, size.width, size.height));
  }

  List<_Region> _buildRegions(Size size, PinnedCellGroups groups) {
    final double pinnedColumnsWidth = worksheet.data.pinnedColumnsWidth;
    final double pinnedRowsHeight = worksheet.data.pinnedRowsHeight;
    final double pinnedColumnsFullWidth = worksheet.data.pinnedColumnsFullWidth;
    final double pinnedRowsFullHeight = worksheet.data.pinnedRowsFullHeight;

    return <_Region>[
      _Region(
        cells: groups.normal,
        clip: Rect.fromLTWH(
          rowHeadersWidth + pinnedColumnsFullWidth,
          columnHeadersHeight + pinnedRowsFullHeight,
          size.width - pinnedColumnsFullWidth,
          size.height - pinnedRowsFullHeight,
        ),
      ),
      _Region(
        cells: groups.rows,
        clip: Rect.fromLTWH(
          rowHeadersWidth + pinnedColumnsFullWidth,
          columnHeadersHeight,
          size.width - pinnedColumnsFullWidth,
          pinnedRowsHeight,
        ),
      ),
      _Region(
        cells: groups.columns,
        clip: Rect.fromLTWH(
          rowHeadersWidth,
          columnHeadersHeight + pinnedRowsFullHeight,
          pinnedColumnsWidth,
          size.height - pinnedRowsFullHeight,
        ),
      ),
      _Region(
        cells: groups.both,
        clip: Rect.fromLTWH(
          rowHeadersWidth,
          columnHeadersHeight,
          pinnedColumnsWidth,
          pinnedRowsHeight,
        ),
      ),
    ];
  }

  void _paintCells(Canvas canvas, List<ViewportCell> cells) {
    if (cells.isEmpty) {
      return;
    }

    StyleBasedPainterBuilder(
      cells: cells,
      builder: (CellStyle style, List<ViewportCell> cells) {
        BackgroundColorPainter(
          color: style.backgroundColor,
          shapes: cells.map((ViewportCell cell) => cell.rect),
        ).layout(canvas);
      },
    ).build();

    for (ViewportCell cell in cells) {
      _paintCellText(canvas, cell);
    }
  }

  void _paintMesh(Canvas canvas, List<_Region> regions) {
    for (final _Region region in regions) {
      _paintMeshForCells(canvas, region.cells, region.clip);
    }
  }

  void _paintMeshForCells(
    Canvas canvas,
    List<ViewportCell> cells,
    Rect clipRect,
  ) {
    MeshPainter().paint(canvas, cells, clipRect);
  }

  void _paintPinnedBorders(Canvas canvas, Size size) {
    PinnedBorderPainter(worksheet.data).paint(canvas, size);
  }

  void _paintCellText(Canvas canvas, ViewportCell cell) {
    CellTextPainter(_padding).paint(canvas, cell);
  }
}
