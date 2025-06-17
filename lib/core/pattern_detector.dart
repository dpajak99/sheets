import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/patterns/linear_date_pattern.dart';
import 'package:sheets/core/values/patterns/linear_duration_pattern.dart';
import 'package:sheets/core/values/patterns/linear_numeric_pattern.dart';
import 'package:sheets/core/values/patterns/linear_string_pattern.dart';
import 'package:sheets/core/values/patterns/repeat_value_pattern.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';

class PatternDetector {
  final List<ValuePatternMatcher> matchers = <ValuePatternMatcher>[
    LinearNumericPatternMatcher(),
    LinearDatePatternMatcher(),
    LinearDurationPatternMatcher(),
    LinearStringPatternMatcher(),
  ];

  ValuePattern<dynamic, dynamic> detectPattern(
    List<IndexedCellProperties> patternCells,
  ) {
    for (ValuePatternMatcher matcher in matchers) {
      ValuePattern<dynamic, dynamic>? pattern = matcher.detect(patternCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatValuePattern();
  }
}
