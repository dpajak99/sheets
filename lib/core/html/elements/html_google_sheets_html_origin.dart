import 'package:sheets/core/html/elements/html_element.dart';
import 'package:sheets/core/html/elements/html_table.dart';

class HtmlGoogleSheetsHtmlOrigin extends HtmlElement {
  HtmlGoogleSheetsHtmlOrigin({required this.table}) : super(tagName: 'google-sheets-html-origin');

  final HtmlTable table;

  @override
  String get content => table.toHtml();
}
