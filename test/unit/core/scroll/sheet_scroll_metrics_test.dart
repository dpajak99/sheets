import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';

void main() {
  group('Tests of SheetScrollMetrics', () {
    group('Tests of SheetScrollMetrics.maxScrollExtent', () {
      test('Should [return correct maxScrollExtent] when [contentSize > viewportDimension]', () {
        // Arrange
        SheetScrollMetrics metrics = SheetScrollMetrics(
          axisDirection: SheetAxisDirection.vertical,
          contentSize: 1000,
          viewportDimension: 600,
        );

        // Act
        double maxScrollExtent = metrics.maxScrollExtent;

        // Assert
        expect(maxScrollExtent, 400.0);
      });

      test('Should [return zero] when [contentSize <= viewportDimension]', () {
        // Arrange
        SheetScrollMetrics metrics = SheetScrollMetrics(
          axisDirection: SheetAxisDirection.vertical,
          contentSize: 500,
          viewportDimension: 600,
        );

        // Act
        double maxScrollExtent = metrics.maxScrollExtent;

        // Assert
        expect(maxScrollExtent, 0.0);
      });
    });

    group('Tests of SheetScrollMetrics.minScrollExtent', () {
      test('Should [always return zero]', () {
        // Arrange
        SheetScrollMetrics metrics = SheetScrollMetrics.zero(SheetAxisDirection.horizontal);

        // Act
        double minScrollExtent = metrics.minScrollExtent;

        // Assert
        expect(minScrollExtent, 0.0);
      });
    });

    group('Tests of SheetScrollMetrics.copyWith()', () {
      test('Should [create a new instance] with [updated properties]', () {
        // Arrange
        SheetScrollMetrics metrics = SheetScrollMetrics(
          axisDirection: SheetAxisDirection.vertical,
          contentSize: 1000,
          viewportDimension: 600,
        );

        // Act
        SheetScrollMetrics newMetrics = metrics.copyWith(contentSize: 1200);

        // Assert
        expect(newMetrics.contentSize, 1200.0);
        expect(newMetrics.viewportDimension, 600.0);
        expect(newMetrics.axisDirection, SheetAxisDirection.vertical);
      });

      test('Should [maintain original properties] when [no parameters are provided]', () {
        // Arrange
        SheetScrollMetrics metrics = SheetScrollMetrics(
          axisDirection: SheetAxisDirection.horizontal,
          contentSize: 800,
          viewportDimension: 600,
        );

        // Act
        SheetScrollMetrics newMetrics = metrics.copyWith();

        // Assert
        expect(newMetrics.contentSize, metrics.contentSize);
        expect(newMetrics.viewportDimension, metrics.viewportDimension);
        expect(newMetrics.axisDirection, metrics.axisDirection);
      });
    });

    group('Tests of SheetScrollMetrics.zero()', () {
      test('Should [create instance] with [zero contentSize and viewportDimension]', () {
        // Arrange & Act
        SheetScrollMetrics metrics = SheetScrollMetrics.zero(SheetAxisDirection.vertical);

        // Assert
        expect(metrics.contentSize, 0.0);
        expect(metrics.viewportDimension, 0.0);
        expect(metrics.axisDirection, SheetAxisDirection.vertical);
      });
    });
  });
}
