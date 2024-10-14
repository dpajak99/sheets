import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';

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
      sheetSelection: widget.sheetController.selectionController.visibleSelection,
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
      child: CustomPaint(painter: _selectionPainter),
    );
  }

  void _updateSelection() {
    _selectionPainter.sheetSelection = widget.sheetController.selectionController.visibleSelection;
  }

  void _updateViewport() {
    _selectionPainter.viewportDelegate = widget.sheetController.viewport;
  }
}

class _SelectionPainter extends ChangeNotifier implements CustomPainter {
  _SelectionPainter({
    required SheetSelection sheetSelection,
    required SheetViewport viewportDelegate,
  })  : _sheetSelection = sheetSelection,
        _viewportDelegate = viewportDelegate;

  late SheetSelection _sheetSelection;

  set sheetSelection(SheetSelection value) {
    _sheetSelection = value;
    notifyListeners();
  }

  late SheetViewport _viewportDelegate;

  set viewportDelegate(SheetViewport value) {
    _viewportDelegate = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth - borderWidth, columnHeadersHeight - borderWidth, size.width, size.height));

    SheetSelectionRenderer selectionRenderer = _sheetSelection.createRenderer(_viewportDelegate);

    SheetSelectionPaint selectionPaint = selectionRenderer.getPaint();
    selectionPaint.paint(_viewportDelegate, canvas, size);
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter oldDelegate) {
    return _sheetSelection != oldDelegate._sheetSelection || _viewportDelegate != oldDelegate._viewportDelegate;
  }

  @override
  bool? hitTest(Offset position) => false;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
