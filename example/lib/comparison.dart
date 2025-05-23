import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/sheet.dart';
import 'package:sheets/widgets/goog/bottom_bar/goog_bottom_bar.dart';
import 'package:sheets/widgets/goog/toolbar/goog_formula_bar.dart';
import 'package:sheets/widgets/goog/toolbar/goog_toolbar.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';

void main() {
  runApp(const ComparisonExample());
}

class ComparisonExample extends StatefulWidget {
  const ComparisonExample({super.key});

  @override
  State<StatefulWidget> createState() => _ComparisonExampleState();
}

class _ComparisonExampleState extends State<ComparisonExample> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheets Comparison',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(icon: Text('sheets')),
                Tab(icon: Text('FlutterTable')),
                Tab(icon: Text('spreadsheet_table')),
              ],
            ),
            title: const Text('Sheets Comparison'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: TabBarView(
              children: <Widget>[
                const _SheetPage(),
                _FlutterTablePage(),
                _SpreadsheetTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetPage extends StatefulWidget {
  const _SheetPage();

  @override
  State<StatefulWidget> createState() => _SheetPageState();
}

class _FlutterTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: _buildTable(),
      ),
    );
  }

  Widget _buildTable() {
    return DataTable(
      columns: List<DataColumn>.generate(
        100,
        (int index) => DataColumn(label: Text('Column ${index + 1}')),
      ),
      rows: List<DataRow>.generate(
        100,
        (int rowIndex) => DataRow(
          cells: List<DataCell>.generate(
            100,
            (int cellIndex) => DataCell(Text('Cell ${rowIndex + 1}:${cellIndex + 1}')),
          ),
        ),
      ),
    );
  }
}

class _SpreadsheetTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpreadsheetTable(
      cellBuilder: (_, int row, int col) => Center(child: Text('Cell $row/$col')),
      legendBuilder: (_) => const Center(child: Text('Legend')),
      rowHeaderBuilder: (_, int index) => Center(child: Text('Row $index')),
      colHeaderBuilder: (_, int index) => Center(child: Text('Col $index')),
      rowsCount: 100,
      colCount: 100,
    );
  }
}

class _SheetPageState extends State<_SheetPage> {
  final Worksheet worksheet = Worksheet(
    data: WorksheetData.dev(),
  );

  @override
  Future<void> dispose() async {
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
              GoogToolbar(worksheet: worksheet),
              GoogFormulaBar(worksheet: worksheet),
              Expanded(
                child: Sheet(worksheet: worksheet),
              ),
              Container(height: 1, width: double.infinity, color: const Color(0xfff9fbfd)),
              Container(height: 1, width: double.infinity, color: const Color(0xffe1e3e1)),
              Container(height: 1, width: double.infinity, color: const Color(0xfff0f1f0)),
              const GoogBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}
