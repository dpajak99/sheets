import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/sheet.dart';
import 'package:sheets/widgets/material/toolbar/sheet_toolbar.dart';
import 'package:sheets/widgets/sections/sheet_footer.dart';
import 'package:sheets/widgets/sections/sheet_section_details_bar.dart';

void main() async {
  Intl.defaultLocale = 'pl_PL';
  await initializeDateFormatting('pl_PL');

  runApp(const MaterialSheetExample());
}

class MaterialSheetExample extends StatefulWidget {
  const MaterialSheetExample({super.key});

  @override
  State<StatefulWidget> createState() => _MaterialSheetExampleState();
}

class _MaterialSheetExampleState extends State<MaterialSheetExample> {
  final SheetController sheetController = SheetController(
    data: SheetData.dev(),
  );

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheets example',
      locale: const Locale('pl_PL'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SheetToolbar(sheetController: sheetController),
              SheetSectionDetailsBar(sheetController: sheetController),
              Expanded(
                child: Sheet(sheetController: sheetController),
              ),
              Container(height: 1, width: double.infinity, color: const Color(0xfff9fbfd)),
              Container(height: 1, width: double.infinity, color: const Color(0xffe1e3e1)),
              Container(height: 1, width: double.infinity, color: const Color(0xfff0f1f0)),
              const SheetFooter(),
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
