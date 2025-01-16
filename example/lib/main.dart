import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sheets/core/data/workbook.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/sheet.dart';
import 'package:sheets/widgets/goog/bottom_bar/goog_bottom_bar.dart';
import 'package:sheets/widgets/goog/header/goog_header.dart';
import 'package:sheets/widgets/goog/toolbar/goog_formula_bar.dart';
import 'package:sheets/widgets/goog/toolbar/goog_toolbar.dart';

void main() async {
  await LocaleSettings.setLocale(AppLocale.en);
  // await LocaleSettings.setLocale(AppLocale.plPl);
  runApp(TranslationProvider(child: const MaterialSheetExample()));
}

class MaterialSheetExample extends StatefulWidget {
  const MaterialSheetExample({super.key});

  @override
  State<StatefulWidget> createState() => _MaterialSheetExampleState();
}

class _MaterialSheetExampleState extends State<MaterialSheetExample> {
  final SheetController sheetController = SheetController(
    workbook: Workbook(
      worksheets: <Worksheet>[
        Worksheet(
          name: 'Test1',
          rows: 100,
          cols: 100,
          columnConfigs: <ColumnIndex, ColumnConfig>{
            ColumnIndex(0): const ColumnConfig(pinned: true),
            ColumnIndex(1): const ColumnConfig(pinned: true),
          },
          rowConfigs: <RowIndex, RowConfig>{
            RowIndex(0): const RowConfig(pinned: true),
            RowIndex(1): const RowConfig(pinned: true),
          },
        ),
        Worksheet(name: 'Test2', rows: 10, cols: 10),
        Worksheet(name: 'Test3', rows: 25, cols: 25),
      ],
    ),
  );

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheets example',
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const GoogHeader(),
              GoogToolbar(sheetController: sheetController),
              GoogFormulaBar(sheetController: sheetController),
              Expanded(
                child: Sheet(sheetController: sheetController),
              ),
              Container(height: 1, width: double.infinity, color: const Color(0xfff9fbfd)),
              Container(height: 1, width: double.infinity, color: const Color(0xffe1e3e1)),
              Container(height: 1, width: double.infinity, color: const Color(0xfff0f1f0)),
              GoogBottomBar(controller: sheetController),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}
