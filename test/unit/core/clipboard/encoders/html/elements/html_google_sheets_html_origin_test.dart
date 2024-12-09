// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_table.dart';

void main() {
  group('HtmlGoogleSheetsHtmlOrigin', () {
    test('renders an HTML origin with a table', () {
      HtmlTable table = HtmlTable(
        rows: <HtmlTableRow>[
          HtmlTableRow(
            cells: <HtmlTableCell>[
              HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 1')]),
              HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 2')]),
            ],
          ),
          HtmlTableRow(
            cells: <HtmlTableCell>[
              HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 3')]),
              HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 4')]),
            ],
          ),
        ],
      );

      HtmlGoogleSheetsHtmlOrigin origin = HtmlGoogleSheetsHtmlOrigin(table: table);

      String result = origin.toHtml();

      expect(
        result,
        '<google-sheets-html-origin>'
            '<table>'
            '<tr><td>Cell 1</td><td>Cell 2</td></tr>'
            '<tr><td>Cell 3</td><td>Cell 4</td></tr>'
            '</table>'
            '</google-sheets-html-origin>',
      );
    });

    test('renders an empty HTML origin when table has no rows', () {
      HtmlTable table = HtmlTable(rows: <HtmlTableRow>[]);

      HtmlGoogleSheetsHtmlOrigin origin = HtmlGoogleSheetsHtmlOrigin(table: table);

      String result = origin.toHtml();

      expect(
        result,
        '<google-sheets-html-origin><table></table></google-sheets-html-origin>',
      );
    });

    test('includes props for equality comparison', () {
      HtmlTable table = HtmlTable(
        rows: <HtmlTableRow>[
          HtmlTableRow(
            cells: <HtmlTableCell>[
              HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 1')]),
            ],
          ),
        ],
      );

      HtmlGoogleSheetsHtmlOrigin origin1 = HtmlGoogleSheetsHtmlOrigin(table: table);
      HtmlGoogleSheetsHtmlOrigin origin2 = HtmlGoogleSheetsHtmlOrigin(table: table);

      expect(origin1 == origin2, isTrue);
    });
  });
}
