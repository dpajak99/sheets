import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';

class SheetMeshLayerPainter extends CustomPainter {
  SheetMeshLayerPainter(this.visibleCells);

  final List<ViewportCell> visibleCells;

  @override
  void paint(Canvas canvas, Size size) {
    if (visibleCells.isEmpty) {
      return;
    }

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Mesh mesh = Mesh();

    for (ViewportCell cell in visibleCells) {
      Rect cellRect = cell.rect;
      Border? border = cell.properties.style.border;

      mesh.add(cellRect, border);
    }

    for (MeshLine line in mesh.lines) {
      Paint paint = Paint()
        ..color = line.side.color
        ..strokeWidth = line.side.width
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square;

      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SheetMeshLayerPainter oldDelegate) {
    return oldDelegate.visibleCells != visibleCells;
  }
}

/// A class representing a "mesh" of horizontal and vertical lines.
/// It can be used for rendering a table-like structure, where each [Rect]
/// adds four lines (top, bottom, left, and right).
///
/// After adding multiple rectangles (e.g., each table cell),
/// you can optimize and merge any overlapping lines by calling [mergeOverlappedLines].
class Mesh {
  Mesh()
      : horizontalLines = <MeshLine>[],
        verticalLines = <MeshLine>[];

  List<MeshLine> horizontalLines;
  List<MeshLine> verticalLines;

  List<MeshLine> get lines => <MeshLine>[...horizontalLines, ...verticalLines];

  /// Adds four lines (top, bottom, left, right) around the given [rect] to the mesh.
  /// The [border] parameter defines the style of each line (e.g., thickness, color).
  ///
  /// Note: Adjust [borderWidth] or the offset logic as needed, depending on how you
  /// want to position the lines around each rectangle.
  void add(Rect rect, Border? border) {
    MeshLine top = MeshLine(rect.topLeft - Offset(0, borderWidth), rect.topRight - Offset(0, borderWidth), border?.top);
    MeshLine bottom = MeshLine(rect.bottomLeft, rect.bottomRight, border?.bottom);
    MeshLine left = MeshLine(rect.topLeft, rect.bottomLeft, border?.left);
    MeshLine right = MeshLine(rect.topRight + Offset(borderWidth, 0), rect.bottomRight + Offset(borderWidth, 0), border?.right);

    // Top and bottom lines go to the horizontal list.
    horizontalLines.addAll(<MeshLine>[top, bottom]);

    // Left and right lines go to the vertical list.
    verticalLines.addAll(<MeshLine>[left, right]);
  }

  /// Merges all overlapping (or adjacent) lines within [horizontalLines] and [verticalLines].
  ///
  /// Call this after you have added all the rectangles (cells) to reduce
  /// the total number of lines by merging consecutive collinear segments
  /// that share the same style ([BorderSide]).
  void mergeOverlappedLines() {
    horizontalLines = _mergeLineSegments(horizontalLines, isHorizontal: true);
    verticalLines = _mergeLineSegments(verticalLines, isHorizontal: false);
  }

  /// Internal helper method that merges overlapping or adjacent line segments in a single list.
  ///
  /// [isHorizontal] indicates whether the list represents horizontal lines or vertical lines.
  List<MeshLine> _mergeLineSegments(
    List<MeshLine> lines, {
    required bool isHorizontal,
  }) {
    if (lines.isEmpty) {
      return lines;
    }

    // 1. Sort the lines based on a "common coordinate" (y for horizontal, x for vertical).
    //    Then sort by the start coordinate.
    lines.sort((MeshLine a, MeshLine b) {
      double aCommon = isHorizontal ? a.start.dy : a.start.dx;
      double bCommon = isHorizontal ? b.start.dy : b.start.dx;

      double aStart = isHorizontal ? a.start.dx : a.start.dy;
      double bStart = isHorizontal ? b.start.dx : b.start.dy;

      // First compare the "common coordinate".
      int compareCommon = aCommon.compareTo(bCommon);
      if (compareCommon != 0) {
        return compareCommon;
      }

      // If they are on the same line, compare the start coordinate.
      return aStart.compareTo(bStart);
    });

    List<MeshLine> merged = <MeshLine>[];
    MeshLine? current = lines.first;

    // 2. Traverse the sorted list and merge lines if possible.
    for (int i = 1; i < lines.length; i++) {
      MeshLine next = lines[i];

      if (_canBeMerged(current!, next, isHorizontal)) {
        // Merge the two lines into one extended segment.
        Offset newStart = _getMinStart(current, next, isHorizontal);
        Offset newEnd = _getMaxEnd(current, next, isHorizontal);

        current = MeshLine(newStart, newEnd, current.side);
      } else {
        // If they cannot be merged, add the current line to the result
        // and move on to the next one.
        merged.add(current);
        current = next;
      }
    }

    // Don't forget to add the last segment
    if (current != null) {
      merged.add(current);
    }

    return merged;
  }

  /// Checks whether two line segments [lineA] and [lineB] can be merged into a single segment.
  ///
  /// Two segments can be merged if:
  /// 1. They share the same style ([BorderSide]).
  /// 2. They are collinear (same y for horizontal or same x for vertical).
  /// 3. Their ranges overlap or touch.
  bool _canBeMerged(MeshLine lineA, MeshLine lineB, bool isHorizontal) {
    // Compare style first (border thickness, color, etc.).
    if (lineA.side != lineB.side) {
      return false;
    }

    if (isHorizontal) {
      // For horizontal lines, check the y-coordinate.
      if ((lineA.start.dy - lineB.start.dy).abs() > 0.0001) {
        return false;
      }

      // Check the x-ranges to see if they overlap or touch.
      double aMinX = _min(lineA.start.dx, lineA.end.dx);
      double aMaxX = _max(lineA.start.dx, lineA.end.dx);
      double bMinX = _min(lineB.start.dx, lineB.end.dx);
      double bMaxX = _max(lineB.start.dx, lineB.end.dx);

      return bMinX <= aMaxX + 0.0001 && aMinX <= bMaxX + 0.0001;
    } else {
      // For vertical lines, check the x-coordinate.
      if ((lineA.start.dx - lineB.start.dx).abs() > 0.0001) {
        return false;
      }

      // Check the y-ranges to see if they overlap or touch.
      double aMinY = _min(lineA.start.dy, lineA.end.dy);
      double aMaxY = _max(lineA.start.dy, lineA.end.dy);
      double bMinY = _min(lineB.start.dy, lineB.end.dy);
      double bMaxY = _max(lineB.start.dy, lineB.end.dy);

      return bMinY <= aMaxY + 0.0001 && aMinY <= bMaxY + 0.0001;
    }
  }

  /// Determines the minimum 'start' offset among [lineA] and [lineB]
  /// based on their orientation ([isHorizontal]).
  Offset _getMinStart(MeshLine lineA, MeshLine lineB, bool isHorizontal) {
    if (isHorizontal) {
      return (lineA.start.dx < lineB.start.dx) ? lineA.start : lineB.start;
    } else {
      return (lineA.start.dy < lineB.start.dy) ? lineA.start : lineB.start;
    }
  }

  /// Determines the maximum 'end' offset among [lineA] and [lineB]
  /// based on their orientation ([isHorizontal]).
  Offset _getMaxEnd(MeshLine lineA, MeshLine lineB, bool isHorizontal) {
    if (isHorizontal) {
      return (lineA.end.dx > lineB.end.dx) ? lineA.end : lineB.end;
    } else {
      return (lineA.end.dy > lineB.end.dy) ? lineA.end : lineB.end;
    }
  }

  /// A small helper to get the minimum of two doubles.
  double _min(double a, double b) => (a < b) ? a : b;

  /// A small helper to get the maximum of two doubles.
  double _max(double a, double b) => (a > b) ? a : b;
}

/// Represents a single line segment in the mesh, defined by [start], [end], and [side].
///
/// [side] can store information such as color, width, or style of the line.
class MeshLine with EquatableMixin {
  MeshLine(this.start, this.end, this._side);

  final Offset start;
  final Offset end;
  final BorderSide? _side;

  BorderSide get side => (_side == null || _side == BorderSide.none) ? MaterialSheetTheme.defaultBorderSide : _side;

  @override
  List<Object?> get props => <Object?>[start, end, side];
}
