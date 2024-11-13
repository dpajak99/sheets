// import 'package:equatable/equatable.dart';
// import 'package:sheets/core/cell_properties.dart';
// import 'package:sheets/core/values/pattern.dart';
//
// abstract class PatternMatcher {
//   ValuePattern? detect(List<CellProperties> baseCells);
// }
//
// class SegmentedStringCellValue with EquatableMixin {
//   SegmentedStringCellValue(this.integer, this.text);
//
//   final PositionedValue<String, HorizontalDirection> integer;
//   final String text;
//
//   @override
//   List<Object?> get props => <Object?>[integer, text];
// }
//
// enum HorizontalDirection { left, right }
//
// class PositionedValue<T, P> with EquatableMixin {
//   PositionedValue(this.value, this.position);
//
//   final T value;
//   final P position;
//
//   @override
//   List<Object?> get props => <Object?>[value, position];
// }
