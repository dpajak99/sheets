// import 'package:sheets/core/values/pattern_matcher.dart';
//
// class ValueUtils {
//   static SegmentedStringCellValue? getSegmentedStringCellValue(String value) {
//     RegExp regex = RegExp(
//       r'^(?:(?<startNumber>\d+)\s+)?(?<text>.*?)(?<endNumber>\d+)?$',
//       unicode: true,
//     );
//
//     RegExpMatch? match = regex.firstMatch(value);
//     if (match != null) {
//       String? startNumber = match.namedGroup('startNumber');
//       String? endNumber = match.namedGroup('endNumber');
//       String? text = match.namedGroup('text');
//
//       String? valueToIncrement = startNumber ?? endNumber;
//       if (valueToIncrement != null && text != null) {
//         HorizontalDirection position = startNumber != null ? HorizontalDirection.left : HorizontalDirection.right;
//         return SegmentedStringCellValue(
//           PositionedValue<String, HorizontalDirection>(valueToIncrement, position),
//           position == HorizontalDirection.left ? ' $text' : text,
//         );
//       }
//     }
//
//     return null;
//   }
// }
