import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/values/formats/number_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  List<String> patterns = [
    '0.00%',
    '0',
    '0.00',
    '#,##0.00',
    '\$#,##0_);(\$#,##0)',
    '0.00E+00',
  ];

  String value = '12345.6789';
  SheetRichText richText = SheetRichText.single(
    text: value,
    style: defaultTextStyle,
  );

  for (String pattern in patterns) {
    ValueFormat formatter = CustomNumberFormat(pattern);
    SheetRichText formattedValue = formatter.format(richText);
    print('Pattern: $pattern => ${formattedValue.getPlainText()}');
  }
}
