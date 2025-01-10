import 'package:sheets/core/data/worksheet.dart';

class Workbook {
  Workbook({
    required this.worksheets,
    this.title,
    this.author,
  });

  final String? title;
  final String? author;
  final List<Worksheet> worksheets;
}
