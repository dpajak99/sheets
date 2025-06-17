import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class BackgroundColorPainter {
  BackgroundColorPainter(
      {required this.color, required Iterable<BorderRect> shapes})
      : _corners = <Offset>[],
        _colors = <Color>[],
        _indices = <int>[] {
    shapes.forEach(_fillRect);
  }

  static const int _cornersCount = 4;

  final Color color;
  final List<Offset> _corners;
  final List<Color> _colors;
  final List<int> _indices;

  void layout(Canvas canvas) {
    canvas.drawVertices(
      Vertices(VertexMode.triangles, _corners,
          colors: _colors, indices: _indices),
      BlendMode.srcOver,
      Paint(),
    );
  }

  void _fillRect(BorderRect rect) {
    int offset = _corners.length ~/ _cornersCount;
    List<Offset> cornerPoints = rect.asOffsets;
    _corners.addAll(cornerPoints);
    _colors.addAll(List<Color>.filled(cornerPoints.length, color));
    _indices.addAll(<int>[0, 1, 2, 1, 2, 3]
        .map((int index) => index + offset * _cornersCount));
  }
}
