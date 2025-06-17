import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/layers/sheet/helpers/mesh.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class MeshPainter {
  const MeshPainter();

  void paint(Canvas canvas, Iterable<ViewportCell> cells, Rect clipRect) {
    if (cells.isEmpty) return;
    final Mesh mesh = _buildMesh(cells);
    canvas.save();
    canvas.clipRect(clipRect);
    _drawMesh(canvas, mesh);
    canvas.restore();
  }

  Mesh _buildMesh(Iterable<ViewportCell> cells) {
    final Set<double> vertical = <double>{};
    final Set<double> horizontal = <double>{};

    for (final ViewportCell cell in cells) {
      vertical
        ..add(cell.rect.left)
        ..add(cell.rect.right);
      horizontal
        ..add(cell.rect.top)
        ..add(cell.rect.bottom);
    }

    final List<double> vPoints = vertical.toList()..sort();
    final List<double> hPoints = horizontal.toList()..sort();

    final Mesh mesh = Mesh(
      verticalPoints: vPoints,
      horizontalPoints: hPoints,
      maxHorizontal: vPoints.isNotEmpty ? vPoints.last : 0,
      maxVertical: hPoints.isNotEmpty ? hPoints.last : 0,
    );

    final BorderSide defaultBorder = MaterialSheetTheme.defaultBorderSide;

    for (final ViewportCell cell in cells) {
      _addDefaultLines(mesh, cell.rect, defaultBorder);
    }
    for (final ViewportCell cell in cells) {
      _addCustomLines(
        mesh,
        cell.rect,
        cell.properties.style.border,
        defaultBorder,
      );
    }

    return mesh;
  }

  void _addDefaultLines(Mesh mesh, Rect rect, BorderSide style) {
    final MeshLine top = MeshLine(rect.topLeft, rect.topRight);
    final MeshLine right = MeshLine(rect.topRight, rect.bottomRight);
    final MeshLine bottom = MeshLine(rect.bottomLeft, rect.bottomRight);
    final MeshLine left = MeshLine(rect.topLeft, rect.bottomLeft);

    mesh.addHorizontal(rect.top, top, style);
    mesh.addHorizontal(rect.bottom, bottom, style);
    mesh.addVertical(rect.right, right, style);
    mesh.addVertical(rect.left, left, style);
  }

  void _addCustomLines(
    Mesh mesh,
    Rect rect,
    Border? border,
    BorderSide defaultStyle,
  ) {
    final MeshLine top = MeshLine(rect.topLeft, rect.topRight);
    final MeshLine right = MeshLine(rect.topRight, rect.bottomRight);
    final MeshLine bottom = MeshLine(rect.bottomLeft, rect.bottomRight);
    final MeshLine left = MeshLine(rect.topLeft, rect.bottomLeft);

    final BorderSide topSide = border?.top ?? defaultStyle;
    final BorderSide rightSide = border?.right ?? defaultStyle;
    final BorderSide bottomSide = border?.bottom ?? defaultStyle;
    final BorderSide leftSide = border?.left ?? defaultStyle;

    if (topSide != defaultStyle) {
      mesh.addHorizontal(rect.top, top, topSide);
    }
    if (rightSide != defaultStyle) {
      mesh.addVertical(rect.right, right, rightSide);
    }
    if (bottomSide != defaultStyle) {
      mesh.addHorizontal(rect.bottom, bottom, bottomSide);
    }
    if (leftSide != defaultStyle) {
      mesh.addVertical(rect.left, left, leftSide);
    }
  }

  void _drawMesh(Canvas canvas, Mesh mesh) {
    final Map<BorderSide, List<MeshLine>> linesByStyle = mesh.lines;

    for (final MapEntry<BorderSide, List<MeshLine>> entry
        in linesByStyle.entries) {
      final BorderSide side = entry.key;
      final List<MeshLine> lines = entry.value;
      final Paint paint = Paint()
        ..color = side.color
        ..strokeWidth = side.width
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square;

      canvas.drawPoints(
        PointMode.lines,
        lines
            .expand((MeshLine line) => <Offset>[line.start, line.end])
            .toList(),
        paint,
      );
    }
  }
}
