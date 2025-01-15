import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

/// Defines the orientation for pinned elements:
/// - [vertical]: used for pinned columns (draw a vertical divider).
/// - [horizontal]: used for pinned rows (draw a horizontal divider).
enum PinOrientation {
  vertical,
  horizontal,
}

/// A painter that draws a divider line separating pinned columns or pinned rows
/// from scrollable columns/rows, depending on [orientation].
class SheetPinPainter extends ChangeNotifier implements CustomPainter {
  SheetPinPainter({
    required this.orientation,
    this.lineColor = const Color(0xffc7c7c7),
    this.lineWidth = 5.0,
  });

  /// The color of the divider line.
  final Color lineColor;

  /// The width (thickness) of the divider line.
  final double lineWidth;

  /// Determines whether this painter draws a vertical line (for columns)
  /// or a horizontal line (for rows).
  final PinOrientation orientation;

  /// The calculated position at which to draw the divider.
  /// - If [orientation] is vertical, this represents the x-coordinate (pinnedRight).
  /// - If [orientation] is horizontal, this represents the y-coordinate (pinnedBottom).
  double? _pinnedAxisPosition;

  /// Stores the last known set of visible columns (if any).
  List<ViewportColumn>? _visibleColumns;

  /// Stores the last known set of visible rows (if any).
  List<ViewportRow>? _visibleRows;

  /// Rebuilds this painter from a list of visible columns.
  /// This should be called if [orientation] == [PinOrientation.vertical].
  /// If pinned columns exist, we calculate the maximum [rect.right] among them.
  void rebuildColumns({required List<ViewportColumn> visibleColumns}) {
    _visibleColumns = visibleColumns;

    // Find all pinned columns.
    List<ViewportColumn> pinnedCols = visibleColumns.where((ViewportColumn col) => col.isPinned).toList();

    if (pinnedCols.isEmpty) {
      // If nothing is pinned, the divider might be at 0 or not drawn at all.
      _pinnedAxisPosition = 0;
    } else {
      // Find the rightmost edge among pinned columns.
      _pinnedAxisPosition = pinnedCols.map((ViewportColumn col) => col.rect.right).reduce(max);
    }
    notifyListeners();
  }

  /// Rebuilds this painter from a list of visible rows.
  /// This should be called if [orientation] == [PinOrientation.horizontal].
  /// If pinned rows exist, we calculate the maximum [rect.bottom] among them.
  void rebuildRows({required List<ViewportRow> visibleRows}) {
    _visibleRows = visibleRows;

    // Find all pinned rows.
    List<ViewportRow> pinnedRows = visibleRows.where((ViewportRow row) => row.isPinned).toList();

    if (pinnedRows.isEmpty) {
      // If nothing is pinned, the divider might be at 0 or not drawn at all.
      _pinnedAxisPosition = 0;
    } else {
      // Find the bottom edge among pinned rows.
      _pinnedAxisPosition = pinnedRows.map((ViewportRow row) => row.rect.bottom).reduce(max);
    }
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // If we haven't rebuilt yet or there's no pinned position, do nothing.
    if (_pinnedAxisPosition == null) {
      return;
    }

    // Prepare paint for the divider line.
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw a line depending on orientation.
    switch (orientation) {
      case PinOrientation.vertical:
        // Draw vertical line at x = _pinnedAxisPosition
        double x = _pinnedAxisPosition! + 1;
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );

      case PinOrientation.horizontal:
        // Draw horizontal line at y = _pinnedAxisPosition
        double y = _pinnedAxisPosition! + 1;
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant SheetPinPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.orientation != orientation ||
        oldDelegate._pinnedAxisPosition != _pinnedAxisPosition ||
        oldDelegate._visibleColumns != _visibleColumns ||
        oldDelegate._visibleRows != _visibleRows;
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
