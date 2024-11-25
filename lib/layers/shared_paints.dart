import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/edge_visibility.dart';

class SharedPaints {
  static void paintBorder({
    required Canvas canvas,
    required BorderRect rect,
    required Border border,
    required EdgeVisibility edgeVisibility,
  }) {
    Paint topBorderPaint = Paint()
      ..color = border.top.color
      ..strokeWidth = border.top.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Paint rightBorderPaint = Paint()
      ..color = border.right.color
      ..strokeWidth = border.right.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Paint bottomBorderPaint = Paint()
      ..color = border.bottom.color
      ..strokeWidth = border.bottom.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Paint leftBorderPaint = Paint()
      ..color = border.left.color
      ..strokeWidth = border.left.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Line topBorderLine = rect.getTopBorder(border);
    Line rightBorderLine = rect.getRightBorder(border);
    Line bottomBorderLine = rect.getBottomBorder(border);
    Line leftBorderLine = rect.getLeftBorder(border);

    if (border.top.width > 0 && border.top != BorderSide.none && edgeVisibility.top) {
      canvas.drawLine(topBorderLine.start, topBorderLine.end, topBorderPaint);
    }

    if (border.right.width > 0 && border.right != BorderSide.none && edgeVisibility.right) {
      canvas.drawLine(rightBorderLine.start, rightBorderLine.end, rightBorderPaint);
    }

    if (border.bottom.width > 0 && border.bottom != BorderSide.none) {
      canvas.drawLine(bottomBorderLine.start, bottomBorderLine.end, bottomBorderPaint);
    }

    if (border.left.width > 0 && border.left != BorderSide.none) {
      canvas.drawLine(leftBorderLine.start, leftBorderLine.end, leftBorderPaint);
    }
  }
}
