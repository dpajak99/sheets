import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/sheet.dart';
import 'package:sheets/widgets/sections/sheet_footer.dart';
import 'package:sheets/widgets/sections/sheet_section_details_bar.dart';
import 'package:sheets/widgets/sections/sheet_section_toolbar.dart';

void main() {
  runApp(const MaterialSheetExample());
}

class MaterialSheetExample extends StatefulWidget {
  const MaterialSheetExample({super.key});

  @override
  State<StatefulWidget> createState() => _MaterialSheetExampleState();
}

class _MaterialSheetExampleState extends State<MaterialSheetExample> {
  final SheetController sheetController = SheetController(
    properties: SheetProperties(
      customColumnStyles: <ColumnIndex, ColumnStyle>{},
      customRowStyles: <RowIndex, RowStyle>{},
    ),
  );

  @override
  Future<void> dispose() async {
    await sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheets example',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SheetSectionToolbar(sheetController: sheetController),
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
