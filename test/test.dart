// // <span style="font-size:10pt;font-family:Arial;font-style:normal;" data-sheets-root="1">
// //   <span style="font-size:10pt;font-family:Arial;font-style:normal;">a</span>
// //   <span style="font-size:10pt;font-family:Arial;font-weight:bold;font-style:normal;">sd</span>
// //   <span style="font-size:10pt;font-family:Arial;font-style:normal;color:#ff0000;">fa</span>
// //   <span style="font-size:10pt;font-family:Arial;font-style:normal;">sf</span>
// //   <span style="font-size:14pt;font-family:Arial;font-style:normal;">as</span>
// // </span>
//
// import 'package:sheets/core/values/sheet_text_span.dart';
// import 'package:sheets/utils/html_span_parser.dart';
//
// void main() {
//   HtmlSpanParser htmlSpanParser = HtmlSpanParser();
//
//   String htmlString =
//       '<style type="text/css"><!--td {border: 1px solid #cccccc;}br {mso-data-placement:same-cell;}--></style><span style="font-size:10pt;font-family:Arial;font-style:normal;" data-sheets-root="1"><span style="font-size:10pt;font-family:Arial;font-style:normal;">a</span><span style="font-size:10pt;font-family:Arial;font-weight:bold;font-style:normal;">sd</span><span style="font-size:10pt;font-family:Arial;font-style:normal;color:#ff0000;">fa</span><span style="font-size:10pt;font-family:Arial;font-style:normal;">sf</span><span style="font-size:14pt;font-family:Arial;font-style:normal;">as</span></span>';
//
//   SheetTextSpan customSpan = htmlSpanParser.parse(htmlString);
//
//   print(customSpan);
// }
