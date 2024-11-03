import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';

class CellProperties with EquatableMixin {
  CellProperties(this.index, this.value);

  CellProperties.empty(this.index) : value = const EmptyCellValue();

  final CellIndex index;
  CellValue value;

  CellProperties copyWith({CellValue? value}) {
    return CellProperties(
      index,
      value ?? this.value,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, value];
}

class CellValueParser {
  static CellValue parse(String input) {
    if (input.isEmpty) {
      return const EmptyCellValue();
    } else if (double.tryParse(input) != null) {
      return NumericCellValue(double.parse(input));
    } else if (DateTime.tryParse(input) != null) {
      return DateCellValue(DateTime.parse(input));
    } else if (_tryParseDuration(input) != null) {
      return DurationCellValue(_tryParseDuration(input)!);
    } else {
      return StringCellValue(input);
    }
  }

  static Duration? _tryParseDuration(String input) {
    List<String> parts = input.split(':');
    bool allNumeric = parts.every((String part) => int.tryParse(part) != null);
    if( !allNumeric ) {
      return null;
    }
    if (parts.length == 3) {
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      int seconds = int.tryParse(parts[2]) ?? 0;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else if (parts.length == 2) {
      int minutes = int.tryParse(parts[0]) ?? 0;
      int seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    } else if (parts.length == 1) {
      int seconds = int.tryParse(parts[0]) ?? 0;
      return Duration(seconds: seconds);
    } else {
      return null;
    }
  }
}

abstract class CellValue extends Equatable {
  const CellValue();

  String get asString;
}

class DurationCellValue extends CellValue {
  const DurationCellValue(this.value);

  final Duration value;

  Duration get asDuration => value;

  @override
  String get asString => value.toString();

  @override
  List<Object?> get props => <Object?>[value];
}

class StringCellValue extends CellValue {
  const StringCellValue(this.value);

  final String value;

  @override
  String get asString => value;

  @override
  List<Object?> get props => <Object?>[value];
}

class DateCellValue extends CellValue {
  const DateCellValue(this.value);

  final DateTime value;

  DateTime get asDate => value;

  @override
  String get asString => value.toIso8601String();

  @override
  List<Object?> get props => <Object?>[value];
}

class NumericCellValue extends CellValue {
  const NumericCellValue(this.value);

  final double value;

  int get asInt => value.toInt();

  double get asDouble => value;

  @override
  String get asString => value.toString();

  @override
  List<Object?> get props => <Object?>[value];
}

class EmptyCellValue extends CellValue {
  const EmptyCellValue();

  @override
  String get asString => '';

  @override
  List<Object?> get props => <Object?>[];
}