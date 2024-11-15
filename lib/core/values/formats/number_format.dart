import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

abstract class ValueFormat with EquatableMixin {
  SheetRichText format(SheetRichText richText);
}

class CustomNumberFormat extends ValueFormat {
  CustomNumberFormat(this.pattern);

  final String pattern;

  @override
  SheetRichText format(SheetRichText richText) {
    String text = richText.getPlainText();
    
    double? value = double.tryParse(text.replaceAll(',', ''));
    if (value == null) {
      return richText;
    }

    NumberFormat numberFormat = _parsePattern(pattern);
    String formatted = numberFormat.format(value);
    return richText.withText(formatted);
  }

  NumberFormat _parsePattern(String pattern) {
    // Handle percentage patterns
    if (pattern.contains('%')) {
      int decimalPlaces = _countDecimalPlaces(pattern);
      return NumberFormat.decimalPercentPattern(
        decimalDigits: decimalPlaces,
      );
    }

    // Handle exponential patterns
    if (pattern.contains('E') || pattern.contains('e')) {
      int decimalPlaces = _countDecimalPlaces(pattern);
      return NumberFormat.scientificPattern()
        ..maximumFractionDigits = decimalPlaces;
    }

    // Handle currency patterns
    if (pattern.contains('\$')) {
      int decimalPlaces = _countDecimalPlaces(pattern);
      return NumberFormat.currency(
        symbol: '\$',
        decimalDigits: decimalPlaces,
      );
    }

    // // Handle fraction patterns (simplified)
    // if (pattern.contains('/')) {
    //   return _fractionFormat();
    // }

    // Handle general number patterns
    int decimalPlaces = _countDecimalPlaces(pattern);
    String intlPattern = pattern.replaceAll('#', '')
        .replaceAll(',', '')
        .replaceAll('_', '')
        .replaceAll(';', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('[Red]', '')
        .replaceAll('\$', '')
        .replaceAll('@', '');

    return NumberFormat(intlPattern)
      ..maximumFractionDigits = decimalPlaces;
  }

  int _countDecimalPlaces(String pattern) {
    RegExp regex = RegExp(r'0\.([0]+)');
    Match? match = regex.firstMatch(pattern);
    if (match != null) {
      return match.group(1)!.length;
    }
    return 0;
  }

  String _fractionFormat(double value) {
    int wholeNumber = value.truncate();
    double fraction = value - wholeNumber;
    int denominator = 1;
    while ((fraction * denominator) % 1 > 0.0001) {
      denominator *= 10;
    }
    int numerator = (fraction * denominator).round();
    return '$wholeNumber $numerator/$denominator';
  }

  @override
  List<Object?> get props => <Object?>[pattern];
}
