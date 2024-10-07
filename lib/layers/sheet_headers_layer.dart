import 'package:flutter/cupertino.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

class SheetHeadersLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetHeadersLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetHeadersLayerState();
}

class _SheetHeadersLayerState extends State<SheetHeadersLayer> {
  late final _ColumnHeadersPainter columnHeadersPainter;
  late final _RowHeadersPainter rowHeadersPainter;

  @override
  void initState() {
    super.initState();
    columnHeadersPainter = _ColumnHeadersPainter(
      visibleColumns: widget.sheetController.viewport.visibleColumns,
      selection: widget.sheetController.selectionController.visibleSelection,
    );
    rowHeadersPainter = _RowHeadersPainter(
      visibleRows: widget.sheetController.viewport.visibleRows,
      selection: widget.sheetController.selectionController.visibleSelection,
    );

    widget.sheetController.viewport.addListener(_updateVisibleColumns);
    widget.sheetController.viewport.addListener(_updateVisibleRows);
    widget.sheetController.selectionController.addListener(_updateSelection);
  }

  @override
  void dispose() {
    widget.sheetController.viewport.removeListener(_updateVisibleColumns);
    widget.sheetController.viewport.removeListener(_updateVisibleRows);
    widget.sheetController.selectionController.removeListener(_updateSelection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: CustomPaint(isComplex: true, painter: columnHeadersPainter),
        ),
        RepaintBoundary(
          child: CustomPaint(isComplex: true, painter: rowHeadersPainter),
        ),
      ],
    );
  }

  void _updateVisibleColumns() {
    columnHeadersPainter.visibleColumns = widget.sheetController.viewport.visibleColumns;
  }

  void _updateVisibleRows() {
    rowHeadersPainter.visibleRows = widget.sheetController.viewport.visibleRows;
  }

  void _updateSelection() {
    columnHeadersPainter.selection = widget.sheetController.selectionController.visibleSelection;
    rowHeadersPainter.selection = widget.sheetController.selectionController.visibleSelection;
  }
}

abstract class _HeadersPainter extends ChangeNotifier implements CustomPainter {
  void paintHeadersBackground(Canvas canvas, Rect rect, SelectionStatus selectionStatus) {
    Color backgroundColor = selectionStatus.selectValue(
      fullySelected: const Color(0xff2456cb),
      selected: const Color(0xffd6e2fb),
      notSelected: const Color(0xffffffff),
    );

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);
  }

  void paintHeadersBorder(Canvas canvas, Rect rect, {bool top = true}) {
    Paint borderPaint = Paint()
      ..color = const Color(0xffc4c7c5)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    if (top) {
      canvas.drawLine(rect.topLeft, rect.topRight, borderPaint);
    }
    canvas.drawLine(rect.topRight, rect.bottomRight, borderPaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, borderPaint);
    canvas.drawLine(rect.topLeft, rect.bottomLeft, borderPaint);
  }

  void paintHeadersLabel(Canvas canvas, Rect rect, String value, SelectionStatus selectionStatus) {
    TextStyle textStyle = selectionStatus.selectValue(
      fullySelected: defaultHeaderTextStyleSelectedAll,
      selected: defaultHeaderTextStyleSelected,
      notSelected: defaultHeaderTextStyle,
    );

    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(text: value, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: rect.width, maxWidth: rect.width);
    textPainter.paint(canvas, rect.center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

class _ColumnHeadersPainter extends _HeadersPainter {
  _ColumnHeadersPainter({
    required List<ColumnConfig> visibleColumns,
    required SheetSelection selection,
  })  : _visibleColumns = visibleColumns,
        _selection = selection;

  late List<ColumnConfig> _visibleColumns;

  set visibleColumns(List<ColumnConfig> value) {
    _visibleColumns = value;
    notifyListeners();
  }

  late SheetSelection _selection;

  set selection(SheetSelection value) {
    _selection = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ColumnConfig column in _visibleColumns) {
      SelectionStatus selectionStatus = _selection.isColumnSelected(column.columnIndex);

      paintHeadersBackground(canvas, column.rect, selectionStatus);
      paintHeadersBorder(canvas, column.rect, top: false);
      paintHeadersLabel(canvas, column.rect, column.value, selectionStatus);
    }
  }

  @override
  bool shouldRepaint(covariant _ColumnHeadersPainter oldDelegate) {
    return oldDelegate._visibleColumns != _visibleColumns || oldDelegate._selection != _selection;
  }
}

class _RowHeadersPainter extends _HeadersPainter {
  _RowHeadersPainter({
    required List<RowConfig> visibleRows,
    required SheetSelection selection,
  })  : _visibleRows = visibleRows,
        _selection = selection;

  late List<RowConfig> _visibleRows;

  set visibleRows(List<RowConfig> value) {
    _visibleRows = value;
    notifyListeners();
  }

  late SheetSelection _selection;

  set selection(SheetSelection value) {
    _selection = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (RowConfig row in _visibleRows) {
      SelectionStatus selectionStatus = _selection.isRowSelected(row.rowIndex);

      paintHeadersBackground(canvas, row.rect, selectionStatus);
      paintHeadersBorder(canvas, row.rect);
      paintHeadersLabel(canvas, row.rect, row.value, selectionStatus);
    }
  }

  @override
  bool shouldRepaint(covariant _RowHeadersPainter oldDelegate) {
    return oldDelegate._visibleRows != _visibleRows || oldDelegate._selection != _selection;
  }
}
