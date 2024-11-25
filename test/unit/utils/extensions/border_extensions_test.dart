import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/border_extensions.dart';

void main() {
  group('Tests of BorderExtensions', () {
    group('Tests of Border.copyWith()', () {
      test('Should [return new Border] with updated top border', () {
        // Arrange
        Border originalBorder = const Border(
          top: BorderSide(color: Colors.red),
          right: BorderSide(color: Colors.green),
          bottom: BorderSide(color: Colors.blue),
          left: BorderSide(color: Colors.yellow),
        );

        BorderSide newTop = const BorderSide();

        // Act
        Border updatedBorder = originalBorder.copyWith(top: newTop);

        // Assert
        expect(updatedBorder.top, newTop);
        expect(updatedBorder.right, originalBorder.right);
        expect(updatedBorder.bottom, originalBorder.bottom);
        expect(updatedBorder.left, originalBorder.left);
      });

      test('Should [return new Border] with updated right border', () {
        // Arrange
        Border originalBorder = const Border(
          top: BorderSide(color: Colors.red),
          right: BorderSide(color: Colors.green),
          bottom: BorderSide(color: Colors.blue),
          left: BorderSide(color: Colors.yellow),
        );

        BorderSide newRight = const BorderSide();

        // Act
        Border updatedBorder = originalBorder.copyWith(right: newRight);

        // Assert
        expect(updatedBorder.right, newRight);
        expect(updatedBorder.top, originalBorder.top);
        expect(updatedBorder.bottom, originalBorder.bottom);
        expect(updatedBorder.left, originalBorder.left);
      });

      test('Should [return new Border] with updated bottom border', () {
        // Arrange
        Border originalBorder = const Border(
          top: BorderSide(color: Colors.red),
          right: BorderSide(color: Colors.green),
          bottom: BorderSide(color: Colors.blue),
          left: BorderSide(color: Colors.yellow),
        );

        BorderSide newBottom = const BorderSide();

        // Act
        Border updatedBorder = originalBorder.copyWith(bottom: newBottom);

        // Assert
        expect(updatedBorder.bottom, newBottom);
        expect(updatedBorder.top, originalBorder.top);
        expect(updatedBorder.right, originalBorder.right);
        expect(updatedBorder.left, originalBorder.left);
      });

      test('Should [return new Border] with updated left border', () {
        // Arrange
        Border originalBorder = const Border(
          top: BorderSide(color: Colors.red),
          right: BorderSide(color: Colors.green),
          bottom: BorderSide(color: Colors.blue),
          left: BorderSide(color: Colors.yellow),
        );

        BorderSide newLeft = const BorderSide();

        // Act
        Border updatedBorder = originalBorder.copyWith(left: newLeft);

        // Assert
        expect(updatedBorder.left, newLeft);
        expect(updatedBorder.top, originalBorder.top);
        expect(updatedBorder.right, originalBorder.right);
        expect(updatedBorder.bottom, originalBorder.bottom);
      });

      test('Should [return same Border] when [no parameters are provided]', () {
        // Arrange
        Border originalBorder = const Border(
          top: BorderSide(color: Colors.red),
          right: BorderSide(color: Colors.green),
          bottom: BorderSide(color: Colors.blue),
          left: BorderSide(color: Colors.yellow),
        );

        // Act
        Border updatedBorder = originalBorder.copyWith();

        // Assert
        expect(updatedBorder, originalBorder);
      });
    });
  });
}
