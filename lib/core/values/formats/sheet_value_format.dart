import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

abstract class SheetValueFormat with EquatableMixin {
  static SheetValueFormat auto(SheetRichText value) {
    try {
      List<SheetValueFormat> autoFormats = <SheetValueFormat>[
        SheetNumberFormat.decimalPattern(),
        SheetDateFormat('yyyy-MM-dd'),
        SheetDurationFormat.auto(),
      ];

      return autoFormats.firstWhere((SheetValueFormat format) => format.hasStrongMatch(value));
    } catch (e) {
      return SheetStringFormat();
    }
  }

  SheetRichText? formatVisible(SheetRichText richText);

  SheetRichText formatEditable(SheetRichText richText);

  SheetValueFormat decreaseDecimal();

  SheetValueFormat increaseDecimal();

  TextAlign get textAlign;

  bool hasStrongMatch(SheetRichText value) {
    SheetRichText? visibleText = formatVisible(value);
    return visibleText != null;
  }
}

typedef NumberFormatter = NumberFormat Function(String value);

class SheetNumberFormat extends SheetValueFormat {
  SheetNumberFormat({
    required this.numberFormat,
    bool? rounded,
  }) : rounded = rounded ?? false;

  factory SheetNumberFormat.custom([String? newPattern]) {
    String? locale;
    return SheetNumberFormat(
      numberFormat: NumberFormat(newPattern, locale),
    );
  }

  factory SheetNumberFormat.decimalPattern() {
    String? locale;
    return SheetNumberFormat(
      numberFormat: NumberFormat.decimalPattern(locale),
    );
  }

  factory SheetNumberFormat.decimalPatternDigits() {
    String? locale;
    int? decimalDigits;
    return SheetNumberFormat(
      numberFormat: NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimalDigits),
    );
  }

  factory SheetNumberFormat.percentPattern() {
    String? locale;
    return SheetNumberFormat(
      numberFormat: NumberFormat.percentPattern(locale),
    );
  }

  factory SheetNumberFormat.decimalPercentPattern() {
    String? locale;
    int? decimalDigits;
    return SheetNumberFormat(
      numberFormat: NumberFormat.decimalPercentPattern(locale: locale, decimalDigits: decimalDigits),
    );
  }

  factory SheetNumberFormat.scientificPattern() {
    String? locale;
    return SheetNumberFormat(
      numberFormat: NumberFormat.scientificPattern(locale),
    );
  }

  factory SheetNumberFormat.currency({bool? rounded}) {
    String? locale;
    String? name;
    String? symbol;
    int? decimalDigits;
    String? customPattern;

    return SheetNumberFormat(
      rounded: rounded,
      numberFormat: NumberFormat.currency(
        locale: locale,
        name: name,
        symbol: symbol,
        decimalDigits: decimalDigits,
        customPattern: customPattern,
      ),
    );
  }

  factory SheetNumberFormat.simpleCurrency() {
    String? locale;
    String? name;
    int? decimalDigits;

    return SheetNumberFormat(
      numberFormat: NumberFormat.simpleCurrency(
        locale: locale,
        name: name,
        decimalDigits: decimalDigits,
      ),
    );
  }

  factory SheetNumberFormat.compact() {
    String? locale;
    bool explicitSign = false;

    return SheetNumberFormat(
      numberFormat: NumberFormat.compact(
        locale: locale,
        explicitSign: explicitSign,
      ),
    );
  }

  factory SheetNumberFormat.compactLong() {
    String? locale;
    bool explicitSign = false;

    return SheetNumberFormat(
      numberFormat: NumberFormat.compactLong(
        locale: locale,
        explicitSign: explicitSign,
      ),
    );
  }

  factory SheetNumberFormat.compactSimpleCurrency() {
    String? locale;
    String? name;
    int? decimalDigits;

    return SheetNumberFormat(
      numberFormat: NumberFormat.compactSimpleCurrency(
        locale: locale,
        name: name,
        decimalDigits: decimalDigits,
      ),
    );
  }

  factory SheetNumberFormat.compactCurrency() {
    String? locale;
    String? name;
    String? symbol;
    int? decimalDigits;

    return SheetNumberFormat(
      numberFormat: NumberFormat.compactCurrency(
        locale: locale,
        name: name,
        symbol: symbol,
        decimalDigits: decimalDigits,
      ),
    );
  }

  final bool rounded;
  final NumberFormat numberFormat;

  @override
  SheetRichText? formatVisible(SheetRichText richText) {
    try {
      String text = richText.toPlainText();
      num number = numberFormat.parse(text);
      if (rounded) {
        number = number.round();
      }
      String formatted = numberFormat.format(number);
      return richText.withText(formatted);
    } catch (e) {
      return null;
    }
  }

  num toNumber(String text) {
    return numberFormat.parse(text);
  }

  @override
  SheetRichText formatEditable(SheetRichText richText) {
    return richText;
  }

  @override
  TextAlign get textAlign => TextAlign.right;

  @override
  SheetNumberFormat decreaseDecimal() {
    int minimumFractionDigits = (numberFormat.minimumFractionDigits) - 1;
    if (minimumFractionDigits < 0) {
      minimumFractionDigits = 0;
    }
    numberFormat.minimumFractionDigits = minimumFractionDigits;
    return this;
  }

  @override
  SheetNumberFormat increaseDecimal() {
    int minimumFractionDigits = (numberFormat.minimumFractionDigits) + 1;
    numberFormat.minimumFractionDigits = minimumFractionDigits;
    return this;
  }

  @override
  List<Object?> get props => <Object?>[numberFormat.toString()];
}

class SheetDateFormat extends SheetValueFormat {
  SheetDateFormat(String pattern) : dateFormat = DateFormat(pattern);

  final DateFormat dateFormat;

  @override
  SheetRichText? formatVisible(SheetRichText richText) {
    try {
      String text = richText.toPlainText();

      String formatted = dateFormat.format(DateTime.parse(text));
      return richText.withText(formatted);
    } catch (e) {
      return null;
    }
  }

  DateTime toDate(String text) {
    return dateFormat.parse(text);
  }

  @override
  SheetRichText formatEditable(SheetRichText richText) {
    return richText;
  }

  @override
  TextAlign get textAlign => TextAlign.right;

  @override
  SheetValueFormat decreaseDecimal() => this;

  @override
  SheetValueFormat increaseDecimal() => this;

  @override
  List<Object?> get props => <Object?>[dateFormat.toString()];
}

class SheetDurationFormat extends SheetValueFormat {
  SheetDurationFormat.auto() : _pattern = _patternAuto;

  SheetDurationFormat.withMilliseconds() : _pattern = _patternWithMilliseconds;

  SheetDurationFormat.withoutMilliseconds() : _pattern = _patternWithoutMilliseconds;

  static const String _patternAuto = 'auto';
  static const String _patternWithMilliseconds = 'HH:mm:ss.SSS';
  static const String _patternWithoutMilliseconds = 'HH:mm:ss';

  final String _pattern;

  @override
  bool hasStrongMatch(SheetRichText value) {
    SheetRichText? visibleText = formatVisible(value);
    bool containsColons = RegExp(r'\d+:\d+:\d+').hasMatch(value.toPlainText());
    return visibleText != null && containsColons;
  }

  @override
  SheetRichText? formatVisible(SheetRichText richText) {
    try {
      String text = richText.toPlainText();
      Duration duration = _parseDuration(text);

      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;
      int milliseconds = duration.inMilliseconds % 1000;

      String formattedDuration;
      if (_pattern == _patternAuto) {
        formattedDuration = milliseconds > 0 ? _patternWithMilliseconds : _patternWithoutMilliseconds;
      } else {
        formattedDuration = _pattern;
      }

      formattedDuration = formattedDuration
          .replaceAll('HH', hours.toString().padLeft(2, '0'))
          .replaceAll('mm', minutes.toString().padLeft(2, '0'))
          .replaceAll('ss', seconds.toString().padLeft(2, '0'))
          .replaceAll('SSS', milliseconds.toString().padLeft(3, '0'));

      return richText.withText(formattedDuration);
    } catch (e) {
      return null;
    }
  }

  @override
  SheetRichText formatEditable(SheetRichText richText) {
    try {
      String text = richText.toPlainText();
      Duration duration = _parseDuration(text);

      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;
      int milliseconds = duration.inMilliseconds % 1000;

      String formattedDuration = _patternWithMilliseconds;

      formattedDuration = formattedDuration
          .replaceAll('HH', hours.toString().padLeft(2, '0'))
          .replaceAll('mm', minutes.toString().padLeft(2, '0'))
          .replaceAll('ss', seconds.toString().padLeft(2, '0'))
          .replaceAll('SSS', milliseconds.toString().padLeft(3, '0'));

      return richText.withText(formattedDuration);
    } catch (e) {
      return richText;
    }
  }

  Duration toDuration(String text) {
    return _parseDuration(text);
  }

  Duration _parseDuration(String text) {
    if (double.tryParse(text) != null) {
      return _parseNumericDuration(text);
    } else {
      return _parseTextDuration(text);
    }
  }

  Duration _parseNumericDuration(String text) {
    double durationNumeric = double.parse(text);
    // Duration: 1 day * durationNumeric
    double microSeconds = const Duration(days: 1).inMicroseconds * durationNumeric;
    return Duration(microseconds: microSeconds.round());
  }

  Duration _parseTextDuration(String text) {
    RegExp regex = RegExp(r'^(?<hours>\d+):(?<minutes>\d{1,2}):(?<seconds>\d{1,2})(?:\.(?<milliseconds>\d{1,3}))?$');

    RegExpMatch? match = regex.firstMatch(text);

    if (match != null) {
      int hours = int.parse(match.namedGroup('hours') ?? '0');
      int minutes = int.parse(match.namedGroup('minutes') ?? '0');
      int seconds = int.parse(match.namedGroup('seconds') ?? '0');
      int milliseconds = int.parse(match.namedGroup('milliseconds') ?? '0');

      return Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
    } else {
      throw const FormatException('Invalid duration format');
    }
  }

  @override
  TextAlign get textAlign => TextAlign.right;

  @override
  SheetValueFormat decreaseDecimal() => this;

  @override
  SheetValueFormat increaseDecimal() => this;

  @override
  List<Object?> get props => <Object?>[];
}

class SheetStringFormat extends SheetValueFormat {
  @override
  SheetRichText formatVisible(SheetRichText richText) {
    return richText;
  }

  @override
  SheetRichText formatEditable(SheetRichText richText) {
    return richText;
  }

  @override
  TextAlign get textAlign => TextAlign.left;

  @override
  SheetValueFormat decreaseDecimal() => this;

  @override
  SheetValueFormat increaseDecimal() => this;

  @override
  List<Object?> get props => <Object?>[];
}
