import 'package:sheets/core/data/worksheet.dart';

class Workbook {
  Workbook({
    required this.worksheets,
    this.name,
  });

  final String? name;
  final List<Worksheet> worksheets;
}
