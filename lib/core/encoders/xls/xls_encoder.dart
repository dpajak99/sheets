import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/data/worksheet.dart'; // Adjust the import path to your actual Worksheet model
import 'package:sheets/core/sheet_index.dart'; // Same note as above
import 'package:xml/xml.dart';

/// Base class for any node that can build itself into XML.
abstract class XlsxNode {
  /// Builds this node into the given [builder].
  void build(XmlBuilder builder);

  /// Returns the XML string (without pretty formatting).
  String toXmlString() {
    XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    build(builder);
    return builder.buildDocument().toXmlString();
  }
}

/// Creates an [ArchiveFile] from an [XlsxNode] by encoding its XML.
ArchiveFile xlsxFile(String path, XlsxNode node) {
  String xml = node.toXmlString();
  Uint8List bytes = utf8.encode(xml);
  return ArchiveFile(path, bytes.length, bytes);
}

// -----------------------------------------------------------------------------
// Content Types
// -----------------------------------------------------------------------------

/// Represents the `[Content_Types].xml` file.
class XlsxContentTypes extends XlsxNode {
  XlsxContentTypes({
    required this.defaults,
    required this.overrides,
  });

  final List<XlsxDefaultType> defaults;
  final List<XlsxOverrideType> overrides;

  @override
  void build(XmlBuilder builder) {
    builder.element('Types', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/package/2006/content-types');

      for (XlsxDefaultType def in defaults) {
        def.build(builder);
      }
      for (XlsxOverrideType ov in overrides) {
        ov.build(builder);
      }
    });
  }
}

/// Default content type node.
class XlsxDefaultType extends XlsxNode {
  XlsxDefaultType({
    required this.extension,
    required this.contentType,
  });

  final String extension;
  final String contentType;

  @override
  void build(XmlBuilder builder) {
    builder.element('Default', attributes: <String, String>{
      'Extension': extension,
      'ContentType': contentType,
    });
  }
}

/// Override content type node.
class XlsxOverrideType extends XlsxNode {
  XlsxOverrideType({
    required this.partName,
    required this.contentType,
  });

  final String partName;
  final String contentType;

  @override
  void build(XmlBuilder builder) {
    builder.element('Override', attributes: <String, String>{
      'PartName': partName,
      'ContentType': contentType,
    });
  }
}

// -----------------------------------------------------------------------------
// _rels/.rels
// -----------------------------------------------------------------------------

/// Represents the `_rels/.rels` file containing package-level relationships.
class XlsxRels extends XlsxNode {
  XlsxRels(this.relationships);

  final List<XlsxRelationship> relationships;

  @override
  void build(XmlBuilder builder) {
    builder.element('Relationships', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/package/2006/relationships');
      for (XlsxRelationship rel in relationships) {
        rel.build(builder);
      }
    });
  }
}

/// Describes a relationship entry.
class XlsxRelationship extends XlsxNode {
  XlsxRelationship({
    required this.id,
    required this.type,
    required this.target,
  });

  final String id;
  final String type;
  final String target;

  @override
  void build(XmlBuilder builder) {
    builder.element('Relationship', attributes: <String, String>{
      'Id': id,
      'Type': type,
      'Target': target,
    });
  }
}

// -----------------------------------------------------------------------------
// docProps/core.xml
// -----------------------------------------------------------------------------

/// Core properties such as creator, title, lastModifiedBy, etc.
class XlsxCoreProperties extends XlsxNode {
  XlsxCoreProperties({
    required this.title,
    required this.creator,
  });

  final String title;
  final String creator;

  @override
  void build(XmlBuilder builder) {
    builder.element('cp:coreProperties', nest: () {
      builder.namespace(
        'http://schemas.openxmlformats.org/package/2006/metadata/core-properties',
        'cp',
      );
      builder.namespace('http://purl.org/dc/elements/1.1/', 'dc');
      builder.namespace('http://purl.org/dc/terms/', 'dcterms');
      builder.namespace('http://purl.org/dc/dcmitype/', 'dcmitype');
      builder.namespace('http://www.w3.org/2001/XMLSchema-instance', 'xsi');

      builder.element('dc:title', nest: title);
      builder.element('dc:creator', nest: creator);
      builder.element('cp:lastModifiedBy', nest: creator);
      builder.element('dcterms:modified', nest: () {
        builder.attribute('xsi:type', 'dcterms:W3CDTF');
        builder.text(DateTime.now().toUtc().toIso8601String());
      });
    });
  }
}

// -----------------------------------------------------------------------------
// docProps/app.xml
// -----------------------------------------------------------------------------

/// Extended application properties, e.g., company, application name.
class XlsxAppProperties extends XlsxNode {
  @override
  void build(XmlBuilder builder) {
    builder.element('Properties', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/officeDocument/2006/extended-properties');
      builder.namespace('http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes', 'vt');

      builder.element('Application', nest: 'Dart XLSX');
      builder.element('DocSecurity', nest: '0');
      builder.element('ScaleCrop', nest: 'false');
      builder.element('Company', nest: 'MyCompany');
      builder.element('LinksUpToDate', nest: 'false');
      builder.element('SharedDoc', nest: 'false');
      builder.element('HyperlinksChanged', nest: 'false');
      builder.element('AppVersion', nest: '1.0');
    });
  }
}

// -----------------------------------------------------------------------------
// xl/_rels/workbook.xml.rels
// -----------------------------------------------------------------------------

/// Relationships for the workbook (pointing to styles, worksheets, etc.).
class XlsxWorkbookRels extends XlsxNode {
  XlsxWorkbookRels(this.relationships);

  final List<XlsxRelationship> relationships;

  @override
  void build(XmlBuilder builder) {
    builder.element('Relationships', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/package/2006/relationships');
      for ( XlsxRelationship rel in relationships) {
        rel.build(builder);
      }
    });
  }
}

// -----------------------------------------------------------------------------
// xl/workbook.xml
// -----------------------------------------------------------------------------

/// Represents the workbook file (xl/workbook.xml), containing references to sheets.
class XlsxWorkbook extends XlsxNode {
  XlsxWorkbook(this.sheets);

  final List<XlsxSheetRef> sheets;

  @override
  void build(XmlBuilder builder) {
    builder.element('workbook', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.namespace('http://schemas.openxmlformats.org/officeDocument/2006/relationships', 'r');

      builder.element('workbookPr');
      builder.element('sheets', nest: () {
        for ( XlsxSheetRef sheet in sheets) {
          sheet.build(builder);
        }
      });
    });
  }
}

/// A reference to a single sheet within the workbook.
class XlsxSheetRef extends XlsxNode {
  XlsxSheetRef({
    required this.name,
    required this.sheetId,
    required this.relationshipId,
  });

  final String name;
  final int sheetId;
  final String relationshipId;

  @override
  void build(XmlBuilder builder) {
    builder.element('sheet', attributes: <String, String>{
      'name': name,
      'sheetId': '$sheetId',
      'r:id': relationshipId,
    });
  }
}

// -----------------------------------------------------------------------------
// xl/worksheets/sheetN.xml
// -----------------------------------------------------------------------------

/// Represents a single worksheet document (e.g., xl/worksheets/sheet1.xml).
class XlsxWorksheetDoc extends XlsxNode {
  XlsxWorksheetDoc({
    required this.columns,
    required this.rows,
    this.mergedRanges = const <String>[],
  });

  final List<XlsxColumnDef> columns;
  final List<XlsxRow> rows;
  final List<String> mergedRanges;

  @override
  void build(XmlBuilder builder) {
    builder.element('worksheet', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.namespace('http://schemas.openxmlformats.org/officeDocument/2006/relationships', 'r');

      // <cols>
      builder.element('cols', nest: () {
        for (XlsxColumnDef col in columns) {
          col.build(builder);
        }
      });

      // <sheetData>
      builder.element('sheetData', nest: () {
        for (XlsxRow row in rows) {
          row.build(builder);
        }
      });

      // <mergeCells> if there are merged ranges
      if (mergedRanges.isNotEmpty) {
        builder.element('mergeCells', attributes: <String, String>{
          'count': '${mergedRanges.length}',
        }, nest: () {
          for (String range in mergedRanges) {
            builder.element('mergeCell', attributes: <String, String>{
              'ref': range,
            });
          }
        });
      }
    });
  }
}

/// Column definition (e.g., column width).
class XlsxColumnDef extends XlsxNode {
  XlsxColumnDef({
    required this.min,
    required this.max,
    required this.width,
    this.customWidth = false,
  });

  final int min;
  final int max;
  final double width;
  final bool customWidth;

  @override
  void build(XmlBuilder builder) {
    builder.element('col', attributes: <String, String>{
      'min': '$min',
      'max': '$max',
      'width': '$width',
      'customWidth': customWidth ? '1' : '0',
    });
  }
}

/// Row definition, holding multiple cells.
class XlsxRow extends XlsxNode {
  XlsxRow({
    required this.rowIndex,
    required this.cells,
    this.height = 20,
    this.customHeight = false,
  });

  final int rowIndex;
  final double height;
  final bool customHeight;
  final List<XlsxCell> cells;

  @override
  void build(XmlBuilder builder) {
    builder.element('row', nest: () {
      builder.attribute('r', '$rowIndex');
      builder.attribute('ht', '$height');
      if (customHeight) {
        builder.attribute('customHeight', '1');
      }
      for (XlsxCell cell in cells) {
        cell.build(builder);
      }
    });
  }
}

/// A single cell, referencing its position ([ref]) and storing a value.
class XlsxCell extends XlsxNode {
  XlsxCell({
    required this.ref,
    required this.value,
    this.styleIndex = 0,
  });

  final String ref;
  final int styleIndex;
  final XlsxCellValue value;

  @override
  void build(XmlBuilder builder) {
    // Using inlineStr for text content
    builder.element('c', nest: () {
      builder.attribute('r', ref);
      builder.attribute('s', '$styleIndex');
      builder.attribute('t', 'inlineStr');
      builder.element('is', nest: () {
        value.build(builder);
      });
    });
  }
}

// -----------------------------------------------------------------------------
// Cell values
// -----------------------------------------------------------------------------

/// Base class for a cell value, e.g. text or multiple runs.
abstract class XlsxCellValue extends XlsxNode {}

/// A simple text value.
class XlsxTextValue extends XlsxCellValue {
  XlsxTextValue(this.text);

  final String text;

  @override
  void build(XmlBuilder builder) {
    builder.element('t', nest: text);
  }
}

/// Rich text value with multiple runs.
class XlsxRichValue extends XlsxCellValue {
  XlsxRichValue(this.runs);

  final List<XlsxRun> runs;

  @override
  void build(XmlBuilder builder) {
    for (XlsxRun run in runs) {
      run.build(builder);
    }
  }
}

/// A single text run that can have bold/italic/underline/strike properties.
class XlsxRun extends XlsxNode {
  XlsxRun({
    required this.text,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strike = false,
  });

  final String text;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strike;

  @override
  void build(XmlBuilder builder) {
    builder.element('r', nest: () {
      builder.element('rPr', nest: () {
        if (bold) {
          builder.element('b');
        }
        if (italic) {
          builder.element('i');
        }
        if (underline) {
          builder.element('u');
        }
        if (strike) {
          builder.element('strike');
        }
      });
      builder.element('t', nest: () {
        builder.attribute('xml:space', 'preserve');
        builder.text(text);
      });
    });
  }
}

// -----------------------------------------------------------------------------
// xl/styles.xml
// -----------------------------------------------------------------------------

/// Represents the styleSheet (xl/styles.xml).
class XlsxStyles extends XlsxNode {
  XlsxStyles({
    required this.fonts,
    required this.fills,
    required this.xfs,
  });

  final List<XlsxFont> fonts;
  final List<XlsxFill> fills;
  final List<XlsxXf> xfs;

  @override
  void build(XmlBuilder builder) {
    builder.element('styleSheet', nest: () {
      builder.namespace('http://schemas.openxmlformats.org/spreadsheetml/2006/main');

      // <fonts>
      builder.element('fonts', attributes: <String, String>{'count': '${fonts.length}'}, nest: () {
        for (XlsxFont f in fonts) {
          f.build(builder);
        }
      });

      // <fills>
      builder.element('fills', attributes: <String, String>{'count': '${fills.length}'}, nest: () {
        for (XlsxFill fill in fills) {
          fill.build(builder);
        }
      });

      // Single default border
      builder.element('borders', attributes: <String, String>{'count': '1'}, nest: () {
        builder.element('border', nest: () {
          builder.element('left');
          builder.element('right');
          builder.element('top');
          builder.element('bottom');
          builder.element('diagonal');
        });
      });

      // <cellStyleXfs count="1"> -> default
      builder.element('cellStyleXfs', attributes: <String, String>{'count': '1'}, nest: () {
        builder.element('xf', attributes: <String, String>{
          'numFmtId': '0',
          'fontId': '0',
          'fillId': '0',
          'borderId': '0',
        });
      });

      // <cellXfs>
      builder.element('cellXfs', attributes: <String, String>{'count': '${xfs.length}'}, nest: () {
        for (XlsxXf xf in xfs) {
          xf.build(builder);
        }
      });

      // <cellStyles>
      builder.element('cellStyles', attributes: <String, String>{'count': '1'}, nest: () {
        builder.element('cellStyle', attributes: <String, String>{
          'name': 'Normal',
          'xfId': '0',
          'builtinId': '0',
        });
      });
    });
  }
}

/// Describes a font in the styleSheet.
class XlsxFont extends XlsxNode {
  XlsxFont({
    this.size = 11.0,
    this.fontName = 'Calibri',
    this.bold = false,
    this.italic = false,
  });

  final double size;
  final String fontName;
  final bool bold;
  final bool italic;

  @override
  void build(XmlBuilder builder) {
    builder.element('font', nest: () {
      builder.element('sz', attributes: <String, String>{'val': '${size.toStringAsFixed(0)}'});
      builder.element('color', attributes: <String, String>{'theme': '1'});
      builder.element('name', attributes: <String, String>{'val': fontName});
      if (bold) {
        builder.element('b');
      }
      if (italic) {
        builder.element('i');
      }
    });
  }
}

/// Describes a fill (e.g., background color) in the styleSheet.
class XlsxFill extends XlsxNode {
  XlsxFill({
    required this.patternType,
    this.fgColor,
    this.bgColor,
  });

  final String patternType; // "none", "solid", etc.
  final String? fgColor; // ARGB, e.g. "FFFF0000"
  final String? bgColor;

  @override
  void build(XmlBuilder builder) {
    builder.element('fill', nest: () {
      builder.element('patternFill', attributes: <String, String>{'patternType': patternType}, nest: () {
        if (fgColor != null) {
          builder.element('fgColor', attributes: <String, String>{'rgb': fgColor!});
        }
        if (bgColor != null) {
          builder.element('bgColor', attributes: <String, String>{'rgb': bgColor!});
        }
      });
    });
  }
}

/// Describes an `xf` entry that references font/fill/etc. indexes in the styleSheet.
class XlsxXf extends XlsxNode {
  XlsxXf({
    this.fontId = 0,
    this.fillId = 0,
    this.applyFill = false,
    this.applyFont = false,
    this.applyAlignment = false,
    this.horizontal,
    this.vertical,
    this.textRotation,
  });

  final int fontId;
  final int fillId;
  final bool applyFill;
  final bool applyFont;
  final bool applyAlignment;
  final String? horizontal;
  final String? vertical;
  final int? textRotation;

  @override
  void build(XmlBuilder builder) {
    builder.element('xf', nest: () {
      builder.attribute('numFmtId', '0');
      builder.attribute('fontId', '$fontId');
      builder.attribute('fillId', '$fillId');
      builder.attribute('borderId', '0');
      builder.attribute('xfId', '0');

      if (applyFill) {
        builder.attribute('applyFill', '1');
      }
      if (applyFont) {
        builder.attribute('applyFont', '1');
      }
      if (applyAlignment) {
        builder.attribute('applyAlignment', '1');
        builder.element('alignment', nest: () {
          if (horizontal != null) {
            builder.attribute('horizontal', horizontal!);
          }
          if (vertical != null) {
            builder.attribute('vertical', vertical!);
          }
          if (textRotation != null) {
            builder.attribute('textRotation', '$textRotation');
          }
        });
      }
    });
  }
}

// -----------------------------------------------------------------------------
// Main Encoding (Multiple Worksheets Support)
// -----------------------------------------------------------------------------

/// Encodes multiple [Worksheet] objects into an XLSX file.
/// [title] and [creator] are used in the document properties (docProps).
List<int> encodeWorkbookToXlsx({
  required List<Worksheet> worksheets,
  String title = 'Untitled',
  String creator = 'Unknown',
}) {
  Archive archive = Archive();

  // 1) [Content_Types].xml
  XlsxContentTypes contentTypes = _buildContentTypes(worksheets);
  archive.addFile(xlsxFile('[Content_Types].xml', contentTypes));

  // 2) _rels/.rels
  XlsxRels rels = XlsxRels(<XlsxRelationship>[
    XlsxRelationship(
      id: 'rId1',
      type: 'http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties',
      target: 'docProps/core.xml',
    ),
    XlsxRelationship(
      id: 'rId2',
      type: 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties',
      target: 'docProps/app.xml',
    ),
    XlsxRelationship(
      id: 'rId3',
      type: 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument',
      target: 'xl/workbook.xml',
    ),
  ]);
  archive.addFile(xlsxFile('_rels/.rels', rels));

  // 3) docProps/core.xml
  XlsxCoreProperties coreProps = XlsxCoreProperties(
    title: title,
    creator: creator,
  );
  archive.addFile(xlsxFile('docProps/core.xml', coreProps));

  // 4) docProps/app.xml
  XlsxAppProperties appProps = XlsxAppProperties();
  archive.addFile(xlsxFile('docProps/app.xml', appProps));

  // 5) xl/_rels/workbook.xml.rels
  XlsxWorkbookRels wbRels = _buildWorkbookRels(worksheets.length);
  archive.addFile(xlsxFile('xl/_rels/workbook.xml.rels', wbRels));

  // 6) xl/workbook.xml
  XlsxWorkbook workbook = _buildWorkbook(worksheets);
  archive.addFile(xlsxFile('xl/workbook.xml', workbook));

  // 7) Build a global style set from all worksheets
  //    (assuming you want a single styles.xml referencing all possible styles).
  XlsxStyles globalStyles = _buildGlobalStyles(worksheets);
  archive.addFile(xlsxFile('xl/styles.xml', globalStyles));

  // 8) Build each sheet file: sheet1.xml, sheet2.xml, ...
  for (int i = 0; i < worksheets.length; i++) {
    Worksheet ws = worksheets[i];

    // Convert the Worksheet to an XlsxWorksheetDoc
    XlsxWorksheetDoc sheetDoc = _buildWorksheetDoc(ws, globalStyles);

    // Add to the archive (e.g., "sheet1.xml", "sheet2.xml", etc.)
    String sheetPath = 'xl/worksheets/sheet${i + 1}.xml';
    archive.addFile(xlsxFile(sheetPath, sheetDoc));
  }

  // 9) Encode to ZIP (XLSX)
  List<int>? xlsxBytes = ZipEncoder().encode(archive);
  if (xlsxBytes == null) {
    throw Exception('Failed to encode XLSX');
  }
  return xlsxBytes;
}

// -----------------------------------------------------------------------------
// Helpers for building the XLSX structure
// -----------------------------------------------------------------------------

/// Builds [Content_Types].xml for multiple worksheets.
XlsxContentTypes _buildContentTypes(List<Worksheet> worksheets) {
  List<XlsxDefaultType> defaults = <XlsxDefaultType>[
    XlsxDefaultType(
      extension: 'rels',
      contentType: 'application/vnd.openxmlformats-package.relationships+xml',
    ),
    XlsxDefaultType(
      extension: 'xml',
      contentType: 'application/xml',
    ),
  ];

  // We'll have overrides for core, app, workbook, styles, and each sheet
  List<XlsxOverrideType> overrides = <XlsxOverrideType>[
    XlsxOverrideType(
      partName: '/_rels/.rels',
      contentType: 'application/vnd.openxmlformats-package.relationships+xml',
    ),
    XlsxOverrideType(
      partName: '/docProps/core.xml',
      contentType: 'application/vnd.openxmlformats-package.core-properties+xml',
    ),
    XlsxOverrideType(
      partName: '/docProps/app.xml',
      contentType: 'application/vnd.openxmlformats-officedocument.extended-properties+xml',
    ),
    XlsxOverrideType(
      partName: '/xl/workbook.xml',
      contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml',
    ),
    XlsxOverrideType(
      partName: '/xl/styles.xml',
      contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml',
    ),
  ];

  // Add overrides for each sheet (sheet1.xml, sheet2.xml, etc.)
  for (int i = 0; i < worksheets.length; i++) {
    overrides.add(
      XlsxOverrideType(
        partName: '/xl/worksheets/sheet${i + 1}.xml',
        contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml',
      ),
    );
  }

  return XlsxContentTypes(
    defaults: defaults,
    overrides: overrides,
  );
}

/// Builds the relationships for the workbook referencing each sheet and styles.
XlsxWorkbookRels _buildWorkbookRels(int sheetCount) {
  List<XlsxRelationship> relationships = <XlsxRelationship>[];

  // Each sheet => rId1, rId2, etc. The last rId is for the styles.
  // We'll assign rId for each sheet first.
  for (int i = 0; i < sheetCount; i++) {
    relationships.add(
      XlsxRelationship(
        id: 'rId${i + 1}',
        type: 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet',
        target: 'worksheets/sheet${i + 1}.xml',
      ),
    );
  }

  // Add the styles relationship at the end (rIdN+1)
  relationships.add(
    XlsxRelationship(
      id: 'rId${sheetCount + 1}',
      type: 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles',
      target: 'styles.xml',
    ),
  );

  return XlsxWorkbookRels(relationships);
}

/// Builds the workbook.xml referencing each sheet by name, ID, and relationship ID.
XlsxWorkbook _buildWorkbook(List<Worksheet> worksheets) {
  List<XlsxSheetRef> sheetRefs = <XlsxSheetRef>[];
  for (int i = 0; i < worksheets.length; i++) {
    Worksheet ws = worksheets[i];
    String name = ws.name ?? 'Sheet${i + 1}';
    int sheetId = i + 1;
    String relationshipId = 'rId${i + 1}';

    sheetRefs.add(
      XlsxSheetRef(
        name: name,
        sheetId: sheetId,
        relationshipId: relationshipId,
      ),
    );
  }
  return XlsxWorkbook(sheetRefs);
}

/// Builds a single [XlsxStyles] from **all** worksheets in the workbook.
XlsxStyles _buildGlobalStyles(List<Worksheet> worksheets) {
  // Collect unique style combos from all worksheets
  Map<_CellStyleKey, int> styleKeyToIndex = <_CellStyleKey, int>{};

  for (final Worksheet ws in worksheets) {
    for (final CellConfig config in ws.cellConfigs.values) {
      CellStyle style = config.style;
      // Adjust below to your own data structure
      const double fontSize = /* style.fontSize ?? */ 11;
      const bool bold = /* style.isBold ?? */ false;
      const bool italic = /* style.isItalic ?? */ false;
      Color bgColor = style.backgroundColor; // Possibly default to Colors.transparent

      _CellStyleKey key = _CellStyleKey(
        bgColor: bgColor,
        bold: bold,
        italic: italic,
        fontSize: fontSize,
      );
      styleKeyToIndex.putIfAbsent(key, () => styleKeyToIndex.length);
    }
  }

  // Prepare lists
  List<XlsxFont> fonts = <XlsxFont>[];
  List<XlsxFill> fills = <XlsxFill>[];
  List<XlsxXf> xfs = <XlsxXf>[];

  // 1) Default style at index=0
  fonts.add(XlsxFont(size: 11, fontName: 'Calibri'));
  fills.add(XlsxFill(patternType: 'none'));
  xfs.add(XlsxXf());

  // 2) Then for each unique style combo => new XlsxFont, XlsxFill, XlsxXf
  styleKeyToIndex.forEach((key, idx) {
    int fillId = idx + 1;
    int fontId = idx + 1;

    fills.add(
      XlsxFill(
        patternType: 'solid',
        fgColor: _argb(key.bgColor),
        bgColor: 'FFFFFFFF',
      ),
    );

    fonts.add(
      XlsxFont(
        size: key.fontSize,
        bold: key.bold,
        italic: key.italic,
      ),
    );

    xfs.add(
      XlsxXf(
        fontId: fontId,
        fillId: fillId,
        applyFont: true,
        applyFill: true,
      ),
    );
  });

  return XlsxStyles(
    fonts: fonts,
    fills: fills,
    xfs: xfs,
  );
}

/// Builds a single worksheet document (columns, rows, merges).
XlsxWorksheetDoc _buildWorksheetDoc(Worksheet ws, XlsxStyles styles) {
  // Reconstruct the same styleKey->index mapping used in _buildGlobalStyles
  Map<_CellStyleKey, int> styleKeyToXfIndex = <_CellStyleKey, int>{};

  // We know: index=0 => default
  // Then index i => i-th style key
  int combosCount = styles.fills.length - 1; // fill[0] is "none"
  for (int i = 1; i <= combosCount; i++) {
    XlsxFill fill = styles.fills[i];
    XlsxFont font = styles.fonts[i];

    Color bgColor = _parseColor(fill.fgColor ?? 'FFFFFFFF');
    bool bold = font.bold;
    bool italic = font.italic;
    double fontSize = font.size;

    _CellStyleKey key = _CellStyleKey(
      bgColor: bgColor,
      bold: bold,
      italic: italic,
      fontSize: fontSize,
    );
    styleKeyToXfIndex[key] = i;
  }

  // Build the columns
  List<XlsxColumnDef> columns = <XlsxColumnDef>[];
  for (int c = 0; c < ws.cols; c++) {
    ColumnConfig cfg = ws.columnConfigs[ColumnIndex(c)] ?? const ColumnConfig();
    // Fix the default width (Excel often defaults to ~8.43, but adjust to your preference)
    const double colWidth = /*cfg.width == 0 ? 8.43 : cfg.width*/ 8.43;
    bool isCustom = (colWidth - 8.43).abs() > 0.01;

    columns.add(
      XlsxColumnDef(
        min: c + 1,
        max: c + 1,
        width: colWidth,
        customWidth: isCustom,
      ),
    );
  }

  // Build rows & cells
  List<XlsxRow> rows = <XlsxRow>[];
  for (int r = 0; r < ws.rows; r++) {
    RowConfig rowCfg = ws.rowConfigs[RowIndex(r)] ?? const RowConfig();
    double rowHeight = rowCfg.height == 0 ? 20 : rowCfg.height;
    bool isCustomHeight = (rowHeight - 20).abs() > 0.01;

    List<XlsxCell> cellsInRow = <XlsxCell>[];
    for (int c = 0; c < ws.cols; c++) {
      CellIndex cellIndex = CellIndex.raw(r, c);
      CellConfig? cellConfig = ws.cellConfigs[cellIndex];
      if (cellConfig == null) {
        continue;
      }

      CellStyle style = cellConfig.style;
      const double fs = /* style.fontSize ?? */ 11;
      const bool b = /* style.isBold ?? */ false;
      const bool i = /* style.isItalic ?? */ false;
      Color color = style.backgroundColor;

      _CellStyleKey styleKey = _CellStyleKey(
        bgColor: color,
        bold: b,
        italic: i,
        fontSize: fs,
      );
      int styleIndex = styleKeyToXfIndex[styleKey] ?? 0;

      String textValue = cellConfig.value.toPlainText(); // adapt to your value type
      XlsxCell cellDto = XlsxCell(
        ref: cellIndex.reference,
        styleIndex: styleIndex,
        value: XlsxTextValue(textValue),
      );
      cellsInRow.add(cellDto);
    }

    XlsxRow rowDto = XlsxRow(
      rowIndex: r + 1,
      height: rowHeight,
      customHeight: isCustomHeight,
      cells: cellsInRow,
    );
    rows.add(rowDto);
  }

  // Build merges
  List<String> merges = <String>[];
  ws.cellConfigs.forEach((CellIndex idx, CellConfig cfg) {
    CellMergeStatus merge = cfg.mergeStatus;
    if (merge.isMerged && merge.start == idx) {
      merges.add(merge.reference);
    }
  });

  return XlsxWorksheetDoc(
    columns: columns,
    rows: rows,
    mergedRanges: merges,
  );
}

// -----------------------------------------------------------------------------
// Internal style key helper
// -----------------------------------------------------------------------------

/// Simple data class to combine background color + bold + italic + fontSize for cell-level styling.
class _CellStyleKey with EquatableMixin {
  _CellStyleKey({
    required this.bgColor,
    required this.bold,
    required this.italic,
    required this.fontSize,
  });

  final Color bgColor;
  final bool bold;
  final bool italic;
  final double fontSize;

  @override
  List<Object?> get props => <Object?>[bgColor, bold, italic, fontSize];
}

// -----------------------------------------------------------------------------
// Color helpers
// -----------------------------------------------------------------------------

/// Converts an ARGB string (e.g. "FFFF0000") to a Color.
Color _parseColor(String argb) {
  int value = int.parse(argb, radix: 16);
  return Color(value);
}

/// Converts a [Color] to an ARGB string (e.g. Color(0xFFFF0000) -> "FFFF0000").
String _argb(Color c) {
  return c.value.toRadixString(16).toUpperCase().padLeft(8, '0');
}
