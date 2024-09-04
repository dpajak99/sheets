import 'package:flutter/material.dart';
import 'package:sheets/sheet_controller.dart';

double borderWidth = 0.6;

int columnHeadersCount = 1;
int rowHeadersCount = 1;

class SheetPainterNotifier extends ChangeNotifier {
  void repaint() {
    notifyListeners();
  }
}

class SheetPainter extends CustomPainter {
  final SheetController sheetController;

  SheetPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    SheetVisibilityConfig visibilityConfig = sheetController.getVisibilityConfig(size);

    HeadersPainter headersPainter = HeadersPainter(
      canvas: canvas,
      visibilityConfig: visibilityConfig,
    );

    BaseLayoutPainter baseLayoutPainter = BaseLayoutPainter(
      canvas: canvas,
      visibleCells: visibilityConfig.visibleCells,
    );

    SelectionPainter selectionPainter = SelectionPainter(
      canvas: canvas,
      sheetController: sheetController,
      visibilityConfig: visibilityConfig,
    );

    baseLayoutPainter.paint();
    selectionPainter.paint();
    headersPainter.paint();
  }

  @override
  bool shouldRepaint(covariant SheetPainter oldDelegate) {
    return true;
  }
}

class HeadersPainter {
  final Canvas canvas;
  final SheetVisibilityConfig visibilityConfig;

  HeadersPainter({
    required this.canvas,
    required this.visibilityConfig,
  });

  void paint() {
    ColumnHeadersPainter columnHeadersPainter = ColumnHeadersPainter(
      canvas: canvas,
      visibleColumns: visibilityConfig.visibleColumns,
    );
    RowHeadersPainter rowHeadersPainter = RowHeadersPainter(
      canvas: canvas,
      visibleRows: visibilityConfig.visibleRows,
    );

    columnHeadersPainter.paint();
    rowHeadersPainter.paint();
  }
}

class ColumnHeadersPainter {
  final Canvas canvas;
  final List<ProgramColumnConfig> visibleColumns;

  ColumnHeadersPainter({
    required this.canvas,
    required this.visibleColumns,
  });

  void paint() {
    for (ProgramColumnConfig column in visibleColumns) {
      if (column.selected) {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffd6e2fb)
          ..style = PaintingStyle.fill;

        canvas.drawRect(column.rect, backgroundPaint);
      } else {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffffffff)
          ..style = PaintingStyle.fill;

        canvas.drawRect(column.rect, backgroundPaint);
      }

      Paint borderPaint = Paint()
        ..color = const Color(0xffc5c7c5)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(column.rect, borderPaint);

      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${column.columnKey.value}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: column.selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: cellWidth - 10, maxWidth: cellWidth - 10);
      textPainter.paint(canvas, column.rect.topLeft + const Offset(5, 5));
    }
  }
}

class RowHeadersPainter {
  final Canvas canvas;
  final List<ProgramRowConfig> visibleRows;

  RowHeadersPainter({
    required this.canvas,
    required this.visibleRows,
  });

  void paint() {
    for (ProgramRowConfig row in visibleRows) {
      if (row.selected) {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffd6e2fb)
          ..style = PaintingStyle.fill;

        canvas.drawRect(row.rect, backgroundPaint);
      } else {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffffffff)
          ..style = PaintingStyle.fill;

        canvas.drawRect(row.rect, backgroundPaint);
      }

      Paint borderPaint = Paint()
        ..color = const Color(0xffc5c7c5)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(row.rect, borderPaint);

      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${row.rowKey.value}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: row.selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: rowHeadersWidth - 10, maxWidth: rowHeadersWidth - 10);
      textPainter.paint(canvas, row.rect.topLeft + const Offset(5, 5));
    }
  }
}

class SelectionPainter {
  final Canvas canvas;
  final SheetController sheetController;
  final SheetVisibilityConfig visibilityConfig;

  SelectionPainter({
    required this.canvas,
    required this.sheetController,
    required this.visibilityConfig,
  });

  void paint() {
    SheetSelection selection = sheetController.selection;
    if (selection.isEmpty) {
      return;
    }

    List<ProgramCellConfig> selectedCells = visibilityConfig.getSelectedCells(selection);

    Paint mainCellPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth * 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(selectedCells.first.rect, mainCellPaint);

    if (selection.length > 1) {
      Paint backgroundPaint = Paint()
        ..color = const Color(0x203572e3)
        ..color = const Color(0x203572e3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromPoints(selectedCells.first.rect.topLeft, selectedCells.last.rect.bottomRight), backgroundPaint);
    }

    if (selection.isCompleted) {
      Paint selectionPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromPoints(selectedCells.first.rect.topLeft, selectedCells.last.rect.bottomRight), selectionPaint);
    }

    if (selection.isCompleted) {
      Paint selectionDotBorderPaint = Paint()
        ..color = const Color(0xffffffff)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(selectedCells.last.rect.bottomRight, 5, selectionDotBorderPaint);

      Paint selectionDotPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(selectedCells.last.rect.bottomRight, 4, selectionDotPaint);
    }
  }
}

class BaseLayoutPainter {
  final Canvas canvas;
  final List<ProgramCellConfig> visibleCells;

  BaseLayoutPainter({
    required this.canvas,
    required this.visibleCells,
  });

  void paint() {
    for (ProgramCellConfig cell in visibleCells) {
      Paint backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(cell.rect, backgroundPaint);

      Paint borderPaint = Paint()
        ..color = const Color(0xffe1e1e1)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(cell.rect, borderPaint);

      // Fill cell with text
      // TextPainter textPainter = TextPainter(
      //   text: const TextSpan(
      //     // text: '${cell.programRowConfig.rowKey.value}-${cell.programColumnConfig.columnKey.value}',
      //     text: '',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 12,
      //     ),
      //   ),
      //   textDirection: TextDirection.ltr,
      // );
      //
      // textPainter.layout();
      // textPainter.paint(canvas, cell.rect.topLeft + const Offset(5, 5));
    }
  }
}