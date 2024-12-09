// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_table.dart';

void main() {
  group('HtmlTable', () {
    test('renders a table with rows and cells', () {
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

      String result = table.toHtml();

      expect(
        result,
        '<table>'
            '<tr><td>Cell 1</td><td>Cell 2</td></tr>'
            '<tr><td>Cell 3</td><td>Cell 4</td></tr>'
            '</table>',
      );
    });

    test('renders an empty table', () {
      HtmlTable table = HtmlTable(rows: <HtmlTableRow>[]);

      String result = table.toHtml();

      expect(result, '<table></table>');
    });
  });

  group('HtmlTableRow', () {
    test('renders a row with cells', () {
      HtmlTableRow row = HtmlTableRow(
        cells: <HtmlTableCell>[
          HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 1')]),
          HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell 2')]),
        ],
      );

      String result = row.toHtml();

      expect(result, '<tr><td>Cell 1</td><td>Cell 2</td></tr>');
    });

    test('renders an empty row', () {
      HtmlTableRow row = HtmlTableRow.empty();

      String result = row.toHtml();

      expect(result, '<tr></tr>');
    });
  });

  group('HtmlTableCell', () {
    test('renders a cell with text', () {
      HtmlTableCell cell = HtmlTableCell(spans: <HtmlSpan>[HtmlSpan(text: 'Cell Content')]);

      String result = cell.toHtml();

      expect(result, '<td>Cell Content</td>');
    });

    test('renders a cell with multiple spans', () {
      HtmlTableCell cell = HtmlTableCell(
        spans: <HtmlSpan>[
          HtmlSpan(text: 'Span 1'),
          HtmlSpan(text: 'Span 2'),
        ],
      );

      String result = cell.toHtml();

      expect(result, '<td><span>Span 1</span><span>Span 2</span></td>');
    });

    test('renders a cell with colspan and rowspan', () {
      HtmlTableCell cell = HtmlTableCell(
        spans: <HtmlSpan>[HtmlSpan(text: 'Cell')],
        colSpan: 2,
        rowSpan: 3,
      );

      String result = cell.toHtml();

      expect(result, '<td colspan="2" rowspan="3">Cell</td>');
    });
  });

  group('HtmlTableStyle', () {
    test('creates an empty style', () {
      HtmlTableStyle style = HtmlTableStyle.empty();

      expect(style.properties, isEmpty);
    });

    test('creates a style from Dart properties', () {
      HtmlTableStyle style = HtmlTableStyle.fromDart(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        border: Border.all(),
        backgroundColor: const Color(0xFFFF0000),
      );

      Map<String, String> cssMap = style.propertiesMap;

      expect(cssMap['text-align'], 'center');
      expect(cssMap['vertical-align'], 'middle');
      expect(cssMap['border'], '1.0px solid #000000');
      expect(cssMap['background-color'], '#ff0000');
    });

    test('creates a style from CSS map', () {
      HtmlTableStyle style = HtmlTableStyle.fromCssMap(<String, String>{
        'text-align': 'right',
        'vertical-align': 'top',
        'border': '2px solid #00ff00',
        'background-color': '#0000ff',
      });

      Map<String, String> cssMap = style.propertiesMap;

      expect(cssMap['text-align'], 'right');
      expect(cssMap['vertical-align'], 'top');
      expect(cssMap['border'], '2.0px solid #00ff00');
      expect(cssMap['background-color'], '#0000ff');
    });
  });
}
