import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/edge_visibility.dart';

class SharedPaints {
  static void paintBorder({
    required Canvas canvas,
    required BorderRect rect,
    required Border border,
    required EdgeVisibility edgeVisibility,
    BorderSide? defaultBorderSide,
  }) {
    BorderSide topBorderSide = _buildBorderSide(border.top, defaultBorderSide);
    BorderSide rightBorderSide = _buildBorderSide(border.right, defaultBorderSide);
    BorderSide bottomBorderSide = _buildBorderSide(border.bottom, defaultBorderSide);
    BorderSide leftBorderSide = _buildBorderSide(border.left, defaultBorderSide);

    Paint topBorderPaint = Paint()
      ..color = topBorderSide.color
      ..strokeWidth = topBorderSide.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Paint rightBorderPaint = Paint()
      ..color = rightBorderSide.color
      ..strokeWidth = rightBorderSide.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Paint bottomBorderPaint = Paint()
      ..color = bottomBorderSide.color
      ..strokeWidth = bottomBorderSide.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Paint leftBorderPaint = Paint()
      ..color = leftBorderSide.color
      ..strokeWidth = leftBorderSide.width
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    Line topBorderLine = rect.getTopBorder(border);
    Line rightBorderLine = rect.getRightBorder(border);
    Line bottomBorderLine = rect.getBottomBorder(border);
    Line leftBorderLine = rect.getLeftBorder(border);

    if (topBorderSide.width > 0 && topBorderSide != BorderSide.none && edgeVisibility.top) {
      canvas.drawLine(topBorderLine.start, topBorderLine.end, topBorderPaint);
    }

    if (rightBorderSide.width > 0 && rightBorderSide != BorderSide.none && edgeVisibility.right) {
      canvas.drawLine(rightBorderLine.start, rightBorderLine.end, rightBorderPaint);
    }

    if (bottomBorderSide.width > 0 && bottomBorderSide != BorderSide.none) {
      canvas.drawLine(bottomBorderLine.start, bottomBorderLine.end, bottomBorderPaint);
    }

    if (leftBorderSide.width > 0 && leftBorderSide != BorderSide.none) {
      canvas.drawLine(leftBorderLine.start, leftBorderLine.end, leftBorderPaint);
    }
  }

  static BorderSide _buildBorderSide(BorderSide borderSide, BorderSide? defaultBorderSide) {
    if(borderSide == BorderSide.none) {
      return defaultBorderSide ?? BorderSide.none;
    }  else {
      return borderSide;
    }
  }
}
