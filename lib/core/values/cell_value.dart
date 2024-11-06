import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class CellValueParser {
  static CellValue parse(MainSheetTextSpan span) {
    if (NumericCellValue.hasMatch(span.rawText)) {
      return NumericCellValue(span);
    } else if (DateCellValue.hasMatch(span.rawText)) {
      return DateCellValue(span);
    } else {
      return StringCellValue(span);
    }
  }
}

abstract class CellValue with EquatableMixin {
  const CellValue(this.span);

  final MainSheetTextSpan span;

  String get rawText => span.rawText;

  StringCellValue withText(String text) {
    return StringCellValue(span.withText(text));
  }
}

class StringCellValue extends CellValue {
  StringCellValue(super.span);

  StringCellValue.empty() : super(MainSheetTextSpan(text: ''));

  @override
  List<Object?> get props => <Object?>[span];
}

class DateCellValue extends CellValue {
  factory DateCellValue(MainSheetTextSpan span) {
    DateTime date = DateTime.parse(span.rawText);
    return DateCellValue._(date, span);
  }

  factory DateCellValue.auto(MainSheetTextSpan span) {
    DateTime date = DateTime.parse(span.rawText);
    MainSheetTextSpan updatedSpan = span.withText(DateFormat('yyyy-MM-dd').format(date));

    return DateCellValue._(date, updatedSpan);
  }

  const DateCellValue._(this.date, super.span);

  static bool hasMatch(String input) {
    return DateTime.tryParse(input) != null;
  }

  final DateTime date;

  @override
  String get rawText {
    if (date.hour == 0 && date.minute == 0 && date.second == 0) {
      return DateFormat('yyyy-MM-dd').format(date);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    }
  }

  @override
  List<Object?> get props => <Object?>[date, span];
}

class NumericCellValue extends CellValue {
  factory NumericCellValue(MainSheetTextSpan span) {
    double number = double.parse(span.rawText);
    return NumericCellValue._(number, span);
  }

  const NumericCellValue._(this.number, super.span);

  static bool hasMatch(String input) {
    return double.tryParse(input) != null;
  }

  final double number;

  @override
  String get rawText {
    double integerRemainder = number % 1;
    if (integerRemainder == 0) {
      return number.toInt().toString();
    } else {
      return number.toString();
    }
  }

  @override
  List<Object?> get props => <Object?>[number, span];
}
