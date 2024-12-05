import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/scroll/sheet_scroll_physics.dart';

void main() {
  group('SheetScrollController Tests', () {
    test('Initializes with default scroll positions and metrics', () {
      // Arrange
      SheetScrollController controller = SheetScrollController();

      // Act
      Offset initialOffset = controller.offset;
      double horizontalViewport = controller.metrics.horizontal.viewportDimension;
      double verticalViewport = controller.metrics.vertical.viewportDimension;

      // Assert
      expect(initialOffset, Offset.zero);
      expect(horizontalViewport, 0.0);
      expect(verticalViewport, 0.0);
    });

    test('setViewportSize updates viewport dimensions correctly', () {
      // Arrange
      SheetScrollController controller = SheetScrollController();
      Size viewportSize = const Size(500, 300);

      // Act
      controller.setViewportSize(viewportSize);

      // Assert
      expect(controller.metrics.horizontal.viewportDimension, viewportSize.width - rowHeadersWidth);
      expect(controller.metrics.vertical.viewportDimension, viewportSize.height - columnHeadersHeight);
    });

    test('setContentSize updates content dimensions correctly', () {
      // Arrange
      SheetScrollController controller = SheetScrollController();
      Size contentSize = const Size(1000, 1000);

      // Act
      controller.setContentSize(contentSize);

      // Assert
      expect(controller.metrics.horizontal.contentSize, 1000);
      expect(controller.metrics.vertical.contentSize, 1000);
    });

    test('scrollBy updates the position by the specified delta', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()..setContentSize(const Size(1000, 1000));
      Offset initialOffset = Offset.zero;
      Offset scrollDelta = const Offset(100, 50);

      // Act
      controller.scrollBy(scrollDelta);
      Offset updatedOffset = controller.offset;

      // Assert
      expect(updatedOffset, initialOffset + scrollDelta);
    });

    test('scrollTo sets the position to the specified offset', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));
      Offset targetOffset = const Offset(200, 100);

      // Act
      controller.scrollTo(targetOffset);
      Offset updatedOffset = controller.offset;

      // Assert
      expect(updatedOffset, targetOffset);
    });

    test('scrollToVertical updates only the vertical offset', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));
      controller.scrollTo(const Offset(100, 100)); // Set initial offset
      double targetVerticalOffset = 150;

      // Act
      controller.scrollToVertical(targetVerticalOffset);

      // Assert
      expect(controller.offset.dy, targetVerticalOffset);
      expect(controller.offset.dx, 100); // Horizontal offset should remain unchanged
    });

    test('scrollToHorizontal updates only the horizontal offset', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));
      controller.scrollTo(const Offset(100, 100)); // Set initial offset
      double targetHorizontalOffset = 250;

      // Act
      controller.scrollToHorizontal(targetHorizontalOffset);

      // Assert
      expect(controller.offset.dx, targetHorizontalOffset);
      expect(controller.offset.dy, 100); // Vertical offset should remain unchanged
    });

    test('scrollBy applies physics transformations to the offset', () {
      // Arrange
      SmoothScrollPhysics customPhysics = SmoothScrollPhysics();
      SheetScrollController controller = SheetScrollController(physics: customPhysics)
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));
      Offset initialOffset = Offset.zero;
      Offset scrollDelta = const Offset(500, 300);

      // Act
      controller.scrollBy(scrollDelta);
      Offset updatedOffset = controller.offset;

      // Assert
      Offset expectedOffset = customPhysics.parseScrolledOffset(initialOffset, scrollDelta);
      expect(updatedOffset, expectedOffset);
    });

    test('scrollTo does not allow negative offsets', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));
      Offset targetOffset = const Offset(-100, -50);

      // Act
      controller.scrollTo(targetOffset);

      // Assert
      expect(controller.offset.dx, 0.0);
      expect(controller.offset.dy, 0.0);
    });

    test('scrollToVertical does not allow negative offset', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));

      // Act
      controller.scrollToVertical(-20);

      // Assert
      expect(controller.offset.dy, 0.0);
    });

    test('scrollToHorizontal does not allow negative offset', () {
      // Arrange
      SheetScrollController controller = SheetScrollController()
        ..setViewportSize(const Size(1000, 1000))
        ..setContentSize(const Size(1000, 1000));

      // Act
      controller.scrollToHorizontal(-20);

      // Assert
      expect(controller.offset.dx, 0.0);
    });
  });
}
