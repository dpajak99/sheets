import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_constants.dart';

double _kGapSize = 2.5;
double _kWeight = 3;
double _kLength = 16;

abstract class HeaderResizerPainter extends CustomPainter {
  Paint get resizerPaint => Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  Paint get dividerPaint => Paint()
    ..color = const Color(0xffc4c7c5)
    ..style = PaintingStyle.fill;
}

class ColumnHeaderResizerPainter extends HeaderResizerPainter {
  final ColumnConfig column;

  ColumnHeaderResizerPainter({
    required this.column,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    paintResizer(canvas, column);
    paintDivider(canvas, size, column);
  }

  void paintResizer(Canvas canvas, ColumnConfig column) {
    Rect columnRect = column.rect;
    double center = columnRect.right;
    double margin = columnRect.top + (columnRect.height - _kLength) / 2;

    Rect leftRect = Rect.fromLTWH(center - _kGapSize - _kWeight, margin, _kWeight, _kLength);
    Rect rightRect = Rect.fromLTWH(center + _kGapSize, margin, _kWeight, _kLength);

    canvas.drawRect(leftRect, resizerPaint);
    canvas.drawRect(rightRect, resizerPaint);
  }

  void paintDivider(Canvas canvas, Size size, ColumnConfig column) {
    Rect columnRect = column.rect;
    double center = columnRect.right;

    double outlineSize = _kGapSize;

    Offset start = Offset(center - outlineSize, 0);
    Offset end = Offset(center + outlineSize, size.height);

    canvas.drawRect(Rect.fromPoints(start, end), dividerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  bool isHovered(Offset offset) {
    Rect columnRect = column.rect;
    double center = columnRect.right;
    Rect rect = Rect.fromLTWH(center - _kGapSize - _kWeight, 0, _kWeight * 2 + _kGapSize, columnRect.height);
    return rect.contains(offset);
  }
}

class RowHeaderResizerPainter extends HeaderResizerPainter {
  final SheetController sheetController;

  RowHeaderResizerPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (RowConfig row in sheetController.visibilityController.visibleRows) {
      paintResizer(canvas, row);
      paintDivider(canvas, size, row);
    }
  }

  void paintResizer(Canvas canvas, RowConfig row) {
    Rect rowRect = row.rect;
    double center = rowRect.bottom;
    double margin = rowRect.left + (rowRect.width - _kLength) / 2;

    Rect topRect = Rect.fromLTWH(margin, center - _kGapSize - _kWeight, _kLength, _kWeight);
    Rect bottomRect = Rect.fromLTWH(margin, center + _kGapSize, _kLength, _kWeight);

    canvas.drawRect(topRect, resizerPaint);
    canvas.drawRect(bottomRect, resizerPaint);
  }

  void paintDivider(Canvas canvas, Size size, RowConfig row) {
    Rect rowRect = row.rect;
    double center = rowRect.bottom;

    double outlineSize = _kGapSize;

    Offset start = Offset(0, center - outlineSize);
    Offset end = Offset(size.width, center + outlineSize);

    canvas.drawRect(Rect.fromPoints(start, end), dividerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
