import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/layers/sheet/sheet_cells_layer_painter.dart';
import 'package:sheets/layers/sheet/sheet_headers_painter.dart';
import 'package:sheets/layers/sheet/sheet_selection_layer_painter.dart';
import 'package:sheets/utils/repeat_action_timer.dart';

class SheetLayer extends StatefulWidget {
  const SheetLayer({
    required this.sheetController,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onSecondaryPointerTap,
    required this.onDoubleTap,
    super.key,
  });

  final SheetController sheetController;
  final ValueChanged<ViewportItem> onDragStart;
  final ValueChanged<ViewportItem> onDragUpdate;
  final VoidCallback onDragEnd;
  final ValueChanged<ViewportItem> onSecondaryPointerTap;
  final ValueChanged<ViewportItem> onDoubleTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
    properties.add(ObjectFlagProperty<ValueChanged<ViewportItem>>.has('onDragStart', onDragStart));
    properties.add(ObjectFlagProperty<ValueChanged<ViewportItem>>.has('onDragUpdate', onDragUpdate));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onDragEnd', onDragEnd));
    properties.add(ObjectFlagProperty<ValueChanged<ViewportItem>>.has('onSecondaryPointerTap', onSecondaryPointerTap));
    properties.add(ObjectFlagProperty<ValueChanged<ViewportItem>>.has('onDoubleTap', onDoubleTap));
  }

  @override
  State<StatefulWidget> createState() => _SheetLayerState();
}

class _SheetLayerState extends State<SheetLayer> {
  late final SheetCellsLayerPainter _cellsPainter;
  late final SheetHorizontalHeadersPainter _columnHeadersPainter;
  late final SheetVerticalHeadersPainter _rowHeadersPainter;
  late final SheetSelectionLayerPainter _selectionPainter;
  late final RepeatActionTimer _repeatDragUpdateTimer;
  ViewportItem? _lastHoveredItem;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _cellsPainter = SheetCellsLayerPainter();
    _columnHeadersPainter = SheetHorizontalHeadersPainter();
    _rowHeadersPainter = SheetVerticalHeadersPainter();
    _selectionPainter = SheetSelectionLayerPainter();

    _repeatDragUpdateTimer = RepeatActionTimer(
      startDuration: const Duration(milliseconds: 200),
      nextHoldDuration: const Duration(milliseconds: 50),
    );

    widget.sheetController.addListener(_handleSheetControllerChanged);

    _rebuildCells();
    _rebuildHorizontalHeaders();
    _rebuildVerticalHeaders();
    _rebuildSelection();
  }

  @override
  void dispose() {
    super.dispose();
    widget.sheetController.removeListener(_handleSheetControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: RepaintBoundary(
            child: CustomPaint(painter: _cellsPainter),
          )),
          Positioned.fill(
              child: RepaintBoundary(
            child: CustomPaint(painter: _columnHeadersPainter),
          )),
          Positioned.fill(
              child: RepaintBoundary(
            child: CustomPaint(painter: _rowHeadersPainter),
          )),
          Positioned.fill(
              child: RepaintBoundary(
            child: CustomPaint(painter: _selectionPainter),
          )),
        ],
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    ViewportItem? viewportItem = _visibleContent.findAnyByOffset(event.localPosition);
    if (viewportItem == null) {
      return;
    }

    DateTime currentTime = DateTime.now();
    Duration? difference = _lastTapTime != null ? currentTime.difference(_lastTapTime!) : null;
    bool isDoubleTap = difference != null && difference < const Duration(milliseconds: 300);
    bool isSameItem = _lastHoveredItem == viewportItem;

    if (isDoubleTap && isSameItem) {
      widget.onDoubleTap(viewportItem);
      _lastTapTime = null;
      return;
    }

    _lastHoveredItem = viewportItem;
    _lastTapTime = DateTime.now();

    if (event.buttons == kPrimaryMouseButton) {
      widget.onDragStart(viewportItem);
    }
    if (event.buttons == kSecondaryMouseButton) {
      widget.onSecondaryPointerTap(viewportItem);
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    ViewportItem? viewportItem = _visibleContent.findAnyByOffset(event.localPosition);
    if (viewportItem == null || viewportItem == _lastHoveredItem) {
      return;
    }
    _lastHoveredItem = viewportItem;
    _lastTapTime = null;

    if (event.buttons == kPrimaryMouseButton) {
      _repeatDragUpdateTimer.reset();
      _repeatDragUpdateTimer.start(() => _handlePointerMove(event));
      widget.onDragUpdate(viewportItem);
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _repeatDragUpdateTimer.reset();
    widget.onDragEnd();
  }

  void _handleSheetControllerChanged() {
    SheetRebuildConfig rebuildConfig = widget.sheetController.value;
    if (rebuildConfig.rebuildCellsLayer) {
      _rebuildCells();
    }
    if (rebuildConfig.rebuildHorizontalHeaders) {
      _rebuildHorizontalHeaders();
    }
    if (rebuildConfig.rebuildVerticalHeaders) {
      _rebuildVerticalHeaders();
    }
    if (rebuildConfig.rebuildSelection) {
      _rebuildSelection();
    }
  }

  void _rebuildCells() {
    _cellsPainter.rebuild(
      visibleContent: _visibleContent,
    );
  }

  void _rebuildHorizontalHeaders() {
    _columnHeadersPainter.rebuild(
      visibleColumns: _visibleContent.columns,
      selection: _selection,
    );
  }

  void _rebuildVerticalHeaders() {
    _rowHeadersPainter.rebuild(
      visibleRows: _visibleContent.rows,
      selection: _selection,
    );
  }

  void _rebuildSelection() {
    _selectionPainter.rebuild(
      selection: _selection,
      viewport: _viewport,
    );
  }

  SheetViewportContentManager get _visibleContent => _viewport.visibleContent;

  SheetViewport get _viewport => widget.sheetController.viewport;

  SheetSelection get _selection => widget.sheetController.selection.value;
}
