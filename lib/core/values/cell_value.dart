import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CellValueParser {
  static CellValue parse(String input) {
    if (input.isEmpty) {
      return const EmptyCellValue();
    } else if (double.tryParse(input) != null) {
      return NumericCellValue(double.parse(input));
    } else if (DateTime.tryParse(input) != null) {
      return DateCellValue(DateTime.parse(input));
    } else {
      return StringCellValue(input);
    }
  }
}

abstract class CellValue with EquatableMixin {
  const CellValue();

  String get asString;

  TextAlign get textAlign;
}

class StringCellValue extends CellValue {
  const StringCellValue(this.value);

  final String value;

  @override
  String get asString => value;

  @override
  TextAlign get textAlign => TextAlign.left;

  @override
  List<Object?> get props => <Object?>[value];
}

class DateCellValue extends CellValue {
  const DateCellValue(this.value);

  final DateTime value;

  @override
  String get asString {
    if(value.hour == 0 && value.minute == 0 && value.second == 0) {
      return DateFormat('yyyy-MM-dd').format(value);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(value);
    }
  }

  @override
  TextAlign get textAlign => TextAlign.right;

  @override
  List<Object?> get props => <Object?>[value];
}

class NumericCellValue extends CellValue {
  const NumericCellValue(this.value);

  final double value;

  int get asInt => value.toInt();

  double get asDouble => value;

  @override
  String get asString {
    double integerRemainder = value % 1;
    if (integerRemainder == 0) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }

  @override
  TextAlign get textAlign => TextAlign.right;

  @override
  List<Object?> get props => <Object?>[value];
}

class EmptyCellValue extends CellValue {
  const EmptyCellValue();

  @override
  String get asString => '';

  @override
  TextAlign get textAlign => TextAlign.left;

  @override
  List<Object?> get props => <Object?>[];
}
