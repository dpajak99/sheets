import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/text_rotation.dart';

void main() {
  group('Tests of CellStyleFormatActions', () {
    group('Tests of SetHorizontalAlignAction', () {
      test('Should [set horizontal alignment] on CellStyle', () {
        // Arrange
        CellStyle initialStyle = CellStyle(horizontalAlign: TextAlign.start);
        SetHorizontalAlignIntent intent = SetHorizontalAlignIntent(TextAlign.center);
        SetHorizontalAlignAction action = intent.createAction(cellStyle: initialStyle);

        // Act
        CellStyle updatedStyle = action.format(initialStyle);

        // Assert
        CellStyle expectedStyle = CellStyle(horizontalAlign: TextAlign.center);
        expect(updatedStyle, expectedStyle);
      });
    });

    group('Tests of SetVerticalAlignAction', () {
      test('Should [set vertical alignment] on CellStyle', () {
        // Arrange
        CellStyle initialStyle = CellStyle(verticalAlign: TextAlignVertical.top);
        SetVerticalAlignIntent intent = SetVerticalAlignIntent(TextAlignVertical.center);
        SetVerticalAlignAction action = intent.createAction(cellStyle: initialStyle);

        // Act
        CellStyle updatedStyle = action.format(initialStyle);

        // Assert
        CellStyle expectedStyle =  CellStyle(verticalAlign: TextAlignVertical.center);
        expect(updatedStyle, expectedStyle);
      });
    });

    group('Tests of SetBackgroundColorAction', () {
      test('Should [set background color] on CellStyle', () {
        // Arrange
        CellStyle initialStyle = CellStyle(backgroundColor: Colors.transparent);
        SetBackgroundColorIntent intent = SetBackgroundColorIntent(color: Colors.red);
        SetBackgroundColorAction action = intent.createAction(cellStyle: initialStyle);

        // Act
        CellStyle updatedStyle = action.format(initialStyle);

        // Assert
        CellStyle expectedStyle = CellStyle(backgroundColor: Colors.red);
        expect(updatedStyle, expectedStyle);
      });
    });

    group('Tests of SetValueFormatAction', () {
      test('Should [set value format] on CellStyle', () {
        // Arrange
        CellStyle initialStyle = CellStyle();
        SheetValueFormat testFormat = SheetNumberFormat.decimalPattern();
        SetValueFormatIntent intent = SetValueFormatIntent(format: (_) => testFormat);
        SetValueFormatAction action = intent.createAction(cellStyle: initialStyle);

        // Act
        CellStyle updatedStyle = action.format(initialStyle);

        // Assert
        CellStyle expectedStyle = CellStyle(valueFormat: SheetNumberFormat.decimalPattern());
        expect(updatedStyle, expectedStyle);
      });

      test('Should [nullify value format] when intent provides null format', () {
        // Arrange
        CellStyle initialStyle = CellStyle(valueFormat: SheetNumberFormat.decimalPattern());
        SetValueFormatIntent intent = SetValueFormatIntent(format: (_) => null);
        SetValueFormatAction action = intent.createAction(cellStyle: initialStyle);

        // Act
        CellStyle updatedStyle = action.format(initialStyle);

        // Assert
        CellStyle expectedStyle = CellStyle();
        expect(updatedStyle, expectedStyle);
      });
    });

    group('Tests of SetRotationAction', () {
      test('Should [set text rotation] on CellStyle', () {
        // Arrange
        CellStyle initialStyle = CellStyle();
        SetRotationIntent intent = SetRotationIntent(TextRotation.angleUp);
        SetRotationAction action = intent.createAction(cellStyle: initialStyle);

        // Act
        CellStyle updatedStyle = action.format(initialStyle);

        // Assert
        CellStyle expectedStyle =  CellStyle(rotation: TextRotation.angleUp);
        expect(updatedStyle, expectedStyle);
      });
    });
  });
}
