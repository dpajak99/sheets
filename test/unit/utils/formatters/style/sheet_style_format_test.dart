import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/border_edges.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';

void main() {
  group('Tests of SetBorderAction', () {
    test('Should apply all borders to selected cells', () {
      // Arrange
      SetBorderIntent intent = SetBorderIntent(
        edges: BorderEdges.all,
        selectedCells: <CellIndex>[
          CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
        ],
        borderSide: const BorderSide(),
      );
      SetBorderAction action = intent.createAction();
      SheetData data = SheetData(rowCount: 10, columnCount: 10);

      // Act
      action.format(data);

      // Assert
      for (CellIndex cell in intent.selectedCells) {
        Border? border = data.getCellProperties(cell).style.border;
        expect(border?.top.color, Colors.black);
        expect(border?.bottom.color, Colors.black);
        expect(border?.left.color, Colors.black);
        expect(border?.right.color, Colors.black);
      }
    });

    test('Should clear borders from selected cells', () {
      // Arrange
      SetBorderIntent intent = SetBorderIntent(
        edges: BorderEdges.clear,
        selectedCells: <CellIndex>[
          CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        ],
        borderSide: const BorderSide(),
      );
      SetBorderAction action = intent.createAction();
      SheetData data = SheetData(rowCount: 10, columnCount: 10);

      // Pre-set borders for cells
      BorderSide borderSide = const BorderSide();
      Border border = Border.all(color: borderSide.color, width: borderSide.width);
      for (CellIndex cell in intent.selectedCells) {
        data.setCellStyle(cell, data.getCellProperties(cell).style.copyWith(border: border));
      }

      // Act
      action.format(data);

      // Assert
      for (CellIndex cell in intent.selectedCells) {
        Border? border = data.getCellProperties(cell).style.border;
        expect(border?.top, BorderSide.none);
        expect(border?.bottom, BorderSide.none);
        expect(border?.left, BorderSide.none);
        expect(border?.right, BorderSide.none);
      }
    });

    test('Should apply horizontal borders to top and bottom rows', () {
      // Arrange
      SetBorderIntent intent = SetBorderIntent(
        edges: BorderEdges.horizontal,
        selectedCells: <CellIndex>[
          CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
        ],
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      );
      SetBorderAction action = intent.createAction();
      SheetData data = SheetData(rowCount: 10, columnCount: 10);

      // Act
      action.format(data);

      // Assert
      expect(
        data.getCellProperties(CellIndex(row: RowIndex(0), column: ColumnIndex(0))).style.border?.top.color,
        Colors.blue,
      );
      expect(
        data.getCellProperties(CellIndex(row: RowIndex(1), column: ColumnIndex(0))).style.border?.bottom.color,
        Colors.blue,
      );
    });

    test('Should apply vertical borders to leftmost and rightmost columns', () {
      // Arrange
      SetBorderIntent intent = SetBorderIntent(
        edges: BorderEdges.vertical,
        selectedCells: <CellIndex>[
          CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
        ],
        borderSide: const BorderSide(color: Colors.green, width: 2),
      );
      SetBorderAction action = intent.createAction();
      SheetData data = SheetData(rowCount: 10, columnCount: 10);

      // Act
      action.format(data);

      // Assert
      expect(
        data.getCellProperties(CellIndex(row: RowIndex(0), column: ColumnIndex(0))).style.border?.left.color,
        Colors.green,
      );
      expect(
        data.getCellProperties(CellIndex(row: RowIndex(0), column: ColumnIndex(1))).style.border?.right.color,
        Colors.green,
      );
    });

    test('Should apply inner borders to selected cells', () {
      // Arrange
      SetBorderIntent intent = SetBorderIntent(
        edges: BorderEdges.inner,
        selectedCells: <CellIndex>[
          CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
          CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
          CellIndex(row: RowIndex(1), column: ColumnIndex(1)),
        ],
        borderSide: const BorderSide(color: Colors.red, width: 2),
      );
      SetBorderAction action = intent.createAction();
      SheetData data = SheetData(rowCount: 10, columnCount: 10);

      // Act
      action.format(data);

      // Assert
      expect(
        data.getCellProperties(CellIndex(row: RowIndex(0), column: ColumnIndex(0))).style.border?.bottom.color,
        Colors.red,
      );
      expect(
        data.getCellProperties(CellIndex(row: RowIndex(0), column: ColumnIndex(1))).style.border?.left.color,
        Colors.red,
      );
    });
  });
}
