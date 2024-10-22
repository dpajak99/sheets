import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';

void main() {
  SheetProperties properties = SheetProperties(
    rowCount: 3,
    columnCount: 3,
    customColumnStyles: <ColumnIndex, ColumnStyle>{
      ColumnIndex(0): ColumnStyle(width: 20),
      ColumnIndex(1): ColumnStyle(width: 30),
      ColumnIndex(2): ColumnStyle(width: 25),
    },
    customRowStyles: <RowIndex, RowStyle>{
      RowIndex(0): RowStyle(height: 50),
      RowIndex(1): RowStyle(height: 60),
      RowIndex(2): RowStyle(height: 55),
    },
  );

  group('Tests of SheetScrollController', () {
    group('Tests of SheetScrollController.applyProperties()', () {
      test('Should [update metrics] when [properties are applied]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();

        // Expected content sizes
        double expectedContentWidth = 20.0 + 30.0 + 25.0; // 75.0
        double expectedContentHeight = 50.0 + 60.0 + 55.0; // 165.0

        // Act
        scrollController.applyProperties(properties);

        // Assert
        expect(scrollController.metrics.vertical.contentSize, expectedContentHeight);
        expect(scrollController.metrics.horizontal.contentSize, expectedContentWidth);
      });
    });

    group('Tests of SheetScrollController.scrollBy()', () {
      test('Should [update position offsets] when [scrolling by delta]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController()..applyProperties(properties);
        Offset delta = const Offset(20, 20);

        // Act
        scrollController.scrollBy(delta);

        // Assert
        expect(scrollController.position.horizontal.offset, delta.dx);
        expect(scrollController.position.vertical.offset, delta.dy);
      });
    });

    group('Tests of SheetScrollController.scrollTo()', () {
      test('Should [set position offsets] when [scrolling to specific offset]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        Offset offset = const Offset(150, 250);

        // Act
        scrollController.scrollTo(offset);

        // Assert
        expect(scrollController.position.horizontal.offset, offset.dx);
        expect(scrollController.position.vertical.offset, offset.dy);
      });
    });

    group('Tests of SheetScrollController.scrollToVertical()', () {
      test('Should [set vertical offset] when [scrolling to specific vertical position]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        double verticalOffset = 300;

        // Act
        scrollController.scrollToVertical(verticalOffset);

        // Assert
        expect(scrollController.position.vertical.offset, verticalOffset);
      });

      test('Should [clamp vertical offset to 0] when [negative offset is provided]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        double verticalOffset = -50;

        // Act
        scrollController.scrollToVertical(verticalOffset);

        // Assert
        expect(scrollController.position.vertical.offset, 0.0);
      });
    });

    group('Tests of SheetScrollController.scrollToHorizontal()', () {
      test('Should [set horizontal offset] when [scrolling to specific horizontal position]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        double horizontalOffset = 400;

        // Act
        scrollController.scrollToHorizontal(horizontalOffset);

        // Assert
        expect(scrollController.position.horizontal.offset, horizontalOffset);
      });

      test('Should [clamp horizontal offset to 0] when [negative offset is provided]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        double horizontalOffset = -100;

        // Act
        scrollController.scrollToHorizontal(horizontalOffset);

        // Assert
        expect(scrollController.position.horizontal.offset, 0.0);
      });
    });

    group('Tests of SheetScrollController.setViewportSize()', () {
      test('Should [update viewport dimensions] when [size is set]', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        Size size = const Size(800, 600);

        // Act
        scrollController.setViewportSize(size);

        // Assert
        expect(
          scrollController.metrics.horizontal.viewportDimension,
          size.width - rowHeadersWidth,
        );
        expect(
          scrollController.metrics.vertical.viewportDimension,
          size.height - columnHeadersHeight,
        );
      });
    });

    group('Tests of SheetScrollController.offset', () {
      test('Should [return current offsets] of positions', () {
        // Arrange
        SheetScrollController scrollController = SheetScrollController();
        Offset expectedOffset = const Offset(150, 250);

        scrollController.scrollTo(expectedOffset);

        // Act
        Offset actualOffset = scrollController.offset;

        // Assert
        expect(actualOffset, expectedOffset);
      });
    });
  });
}
