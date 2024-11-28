import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/direction.dart';

class RepeatValuePattern extends ValuePattern<SheetRichText, String> {
  RepeatValuePattern() : super(steps: <String>[], lastValue: SheetRichText());

  @override
  SheetRichText calculateNewValue(int index, CellProperties templateProperties, SheetRichText lastValue, void step) {
    // Returns the last value unchanged
    return templateProperties.value;
  }

  @override
  SheetRichText formatValue(SheetRichText previousRichText, SheetRichText value) {
    return value;
  }

  @override
  void updateState(SheetRichText newValue) {
    // No state to update
  }
}
