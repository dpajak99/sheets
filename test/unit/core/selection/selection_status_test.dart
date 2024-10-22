import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_status.dart';

void main() {
  group('Tests of SelectionStatus.statusFalse', () {
    test('Should [return SelectionStatus] with FALSE values', () {
      // Act
      SelectionStatus actualStatus = SelectionStatus.statusFalse;

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, expectedStatus);
    });
  });

  group('Tests of SelectionStatus.statusTrue', () {
    test('Should [return SelectionStatus] with TRUE values', () {
      // Act
      SelectionStatus actualStatus = SelectionStatus.statusTrue;

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, expectedStatus);
    });
  });

  group('Tests of SelectionStatus.selectValue', () {
    test('Should [return "fullySelected"] if status is FULLY SELECTED', () {
      // Act
      String actualValue = SelectionStatus(true, true)
          .selectValue(notSelected: 'notSelected', selected: 'selected', fullySelected: 'fullySelected');

      // Assert
      expect(actualValue, 'fullySelected');
    });

    test('Should [return "selected"] if status is SELECTED', () {
      // Act
      String actualValue = SelectionStatus(true, false)
          .selectValue(notSelected: 'notSelected', selected: 'selected', fullySelected: 'fullySelected');

      // Assert
      expect(actualValue, 'selected');
    });

    test('Should [return "notSelected"] if status is NOT SELECTED', () {
      // Act
      String actualValue = SelectionStatus(false, false)
          .selectValue(notSelected: 'notSelected', selected: 'selected', fullySelected: 'fullySelected');

      // Assert
      expect(actualValue, 'notSelected');
    });
  });

  group('Tests of SelectionStatus.isSelected', () {
    test('Should [return TRUE] if status is SELECTED', () {
      // Act
      bool actualValue = SelectionStatus(true, false).isSelected;

      // Assert
      expect(actualValue, true);
    });

    test('Should [return FALSE] if status is NOT SELECTED', () {
      // Act
      bool actualValue = SelectionStatus(false, false).isSelected;

      // Assert
      expect(actualValue, false);
    });
  });

  group('Tests of SelectionStatus.isFullySelected', () {
    test('Should [return TRUE] if status is FULLY SELECTED', () {
      // Act
      bool actualValue = SelectionStatus(true, true).isFullySelected;

      // Assert
      expect(actualValue, true);
    });

    test('Should [return FALSE] if status is SELECTED', () {
      // Act
      bool actualValue = SelectionStatus(true, false).isFullySelected;

      // Assert
      expect(actualValue, false);
    });

    test('Should [return FALSE] if status is NOT SELECTED', () {
      // Act
      bool actualValue = SelectionStatus(false, false).isFullySelected;

      // Assert
      expect(actualValue, false);
    });
  });
}
