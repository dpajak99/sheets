// import 'package:sheets/core/cell_properties.dart';
// import 'package:sheets/core/values/cell_value.dart';
// import 'package:sheets/core/values/pattern.dart';
// import 'package:sheets/core/values/pattern_matcher.dart';
// import 'package:sheets/core/values/sheet_text_span.dart';
//
// class DateSequencePatternMatcher implements PatternMatcher {
//   @override
//   ValuePattern? detect(List<CellProperties> baseCells) {
//     bool allDates = baseCells.every((CellProperties cell) => cell.value is DateCellValue);
//     if (!allDates) {
//       return null;
//     }
//
//     List<DateCellValue> cellValues = baseCells.map((CellProperties cell) => cell.value as DateCellValue).toList();
//     List<DateTime> rawCellValues = cellValues.map((DateCellValue cellValue) => cellValue.date).toList();
//     List<Duration> steps = _calculateSteps(rawCellValues);
//     if (steps.isEmpty) {
//       return null;
//     }
//
//     DateTime lastDate = rawCellValues.last;
//     return DateSequencePattern(steps, lastDate);
//   }
//
//   List<Duration> _calculateSteps(List<DateTime> values) {
//     List<Duration> steps = <Duration>[];
//
//     for (int i = 0; i < values.length - 1; i++) {
//       DateTime currentDate = values[i];
//       DateTime nextDate = values[i + 1];
//       steps.add(nextDate.difference(currentDate));
//     }
//
//     while (steps.isNotEmpty && steps.first == Duration.zero) {
//       steps.removeAt(0);
//     }
//
//     if (steps.isEmpty) {
//       return <Duration>[const Duration(days: 1)];
//     } else {
//       return steps;
//     }
//   }
// }
//
// class DateSequencePattern implements ValuePattern {
//   DateSequencePattern(this.steps, this.lastDate);
//
//   final List<Duration> steps;
//   final DateTime lastDate;
//
//   @override
//   void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
//     DateTime lastDate = this.lastDate;
//
//     for (int i = 0; i < fillCells.length; i++) {
//       Duration step = steps[i % steps.length];
//       DateTime newDateTimeValue = lastDate.add(step);
//       lastDate = newDateTimeValue;
//
//       SheetRichText templateSpan = baseCells[i % baseCells.length].value.span;
//       SheetRichText newSpan = templateSpan.withText(newDateTimeValue.toString());
//       fillCells[i].value = DateCellValue.auto(newSpan);
//     }
//   }
// }
