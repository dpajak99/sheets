import 'package:flutter/material.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/sheet_viewport_delegate.dart';
import 'package:sheets/sheet_constants.dart';

class SheetSelectionLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetSelectionLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetSelectionLayerState();
}

class _SheetSelectionLayerState extends State<SheetSelectionLayer> {
  late _SelectionPainter _selectionPainter;

  @override
  void initState() {
    super.initState();
    _selectionPainter = _SelectionPainter(
      sheetSelection: widget.sheetController.selectionController.selection,
      viewportDelegate: widget.sheetController.viewport,
    );
    widget.sheetController.selectionController.addListener(_updateSelection);
    widget.sheetController.viewport.addListener(_updateViewport);
  }

  @override
  void dispose() {
    widget.sheetController.selectionController.removeListener(_updateSelection);
    widget.sheetController.viewport.removeListener(_updateViewport);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(isComplex: true, painter: _selectionPainter),
    );
  }

  void _updateSelection() {
    _selectionPainter.sheetSelection = widget.sheetController.selectionController.selection;
  }

  void _updateViewport() {
    _selectionPainter.viewportDelegate = widget.sheetController.viewport;
  }
}

class _SelectionPainter extends ChangeNotifier implements CustomPainter {
  _SelectionPainter({
    required SheetSelection sheetSelection,
    required SheetViewportDelegate viewportDelegate,
  })  : _sheetSelection = sheetSelection,
        _viewportDelegate = viewportDelegate;

  late SheetSelection _sheetSelection;

  set sheetSelection(SheetSelection value) {
    _sheetSelection = value;
    notifyListeners();
  }

  late SheetViewportDelegate _viewportDelegate;

  set viewportDelegate(SheetViewportDelegate value) {
    _viewportDelegate = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth - borderWidth, columnHeadersHeight - borderWidth, size.width, size.height));

    SheetSelectionPaint selectionPaint = _sheetSelection.paint;
    selectionPaint.paint(_viewportDelegate, canvas, size);
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter oldDelegate) {
    return _sheetSelection != oldDelegate._sheetSelection || _viewportDelegate != oldDelegate._viewportDelegate;
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
