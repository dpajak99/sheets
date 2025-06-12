import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/widgets/sheet_mouse_region.dart';

/// Layer allowing users to pin rows and columns by dragging the top left corner
/// cross similarly to Google Sheets.
class SheetPinAreaLayer extends StatefulWidget {
  const SheetPinAreaLayer({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

  @override
  State<StatefulWidget> createState() => _SheetPinAreaLayerState();
}

class _SheetPinAreaLayerState extends State<SheetPinAreaLayer> {
  bool _isDraggingColumns = false;
  bool _isDraggingRows = false;
  double? _cursorLeft;
  double? _cursorTop;
  int _targetColumnCount = 0;
  int _targetRowCount = 0;

  WorksheetData get _data => widget.worksheet.data;

  // Colors used for the pin area guidelines.
  static const Color _headerGuideColor = Color(0xff1e40af); // dark blue
  static const Color _dynamicGuideColor = Color(0xff9fa8da); // light blue
  static const Color _pinnedGuideColor = Color(0xffc7c7c7); // grey

  Widget _buildGuideLine({
    required Axis axis,
    required double offset,
    required Color color,
  }) {
    if (axis == Axis.vertical) {
      return Positioned(
        top: 0,
        bottom: 0,
        left: offset,
        width: pinnedBorderWidth,
        child: Column(
          children: <Widget>[
            Container(height: columnHeadersHeight, color: _headerGuideColor),
            Expanded(child: Container(color: color)),
          ],
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      top: offset,
      height: pinnedBorderWidth,
      child: Row(
        children: <Widget>[
          Container(width: rowHeadersWidth, color: _headerGuideColor),
          Expanded(child: Container(color: color)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.worksheet.addListener(_handleWorksheetChanged);
  }

  @override
  void dispose() {
    widget.worksheet.removeListener(_handleWorksheetChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: SheetMouseRegion(
            cursor: SystemMouseCursors.click,
            onDragStart: (_) =>
                widget.worksheet.selection.update(SheetSelectionFactory.all()),
            child: Container(
              width: rowHeadersWidth,
              height: columnHeadersHeight,
              color: const Color(0xfff8f9fa),
            ),
          ),
        ),
        // Vertical drag handle for columns
        Positioned(
          top: 0,
          left: rowHeadersWidth + _data.pinnedColumnsWidth - pinnedBorderWidth,
          width: pinnedBorderWidth,
          height: columnHeadersHeight,
          child: SheetMouseRegion(
            cursor: _isDraggingColumns
                ? SystemMouseCursors.grabbing
                : SystemMouseCursors.grab,
            onDragStart: _handleColumnDragStart,
            onDragUpdate: _handleColumnDragUpdate,
            onDragEnd: _handleColumnDragEnd,
            child: const ColoredBox(
              color: Color(0xffb7b7b7),
            ),
          ),
        ),
        // Horizontal drag handle for rows
        Positioned(
          top: columnHeadersHeight + _data.pinnedRowsHeight - pinnedBorderWidth,
          left: 0,
          width: rowHeadersWidth,
          height: pinnedBorderWidth,
          child: SheetMouseRegion(
            cursor: _isDraggingRows
                ? SystemMouseCursors.grabbing
                : SystemMouseCursors.grab,
            onDragStart: _handleRowDragStart,
            onDragUpdate: _handleRowDragUpdate,
            onDragEnd: _handleRowDragEnd,
            child: const ColoredBox(
              color: Color(0xffb7b7b7),
            ),
          ),
        ),
        if (_isDraggingColumns) ...<Widget>[
          _buildPinnedColumnLine(),
          if (_cursorLeft != null) _buildDynamicColumnLine(),
        ],
        if (_isDraggingRows) ...<Widget>[
          _buildPinnedRowLine(),
          if (_cursorTop != null) _buildDynamicRowLine(),
        ],
      ],
    );
  }

  Widget _buildPinnedColumnLine() {
    double pinnedWidth = _isDraggingColumns
        ? _calculateColumnsWidth(_targetColumnCount)
        : _data.pinnedColumnsWidth;
    double x = rowHeadersWidth + pinnedWidth - pinnedBorderWidth;
    return _buildGuideLine(
      axis: Axis.vertical,
      offset: x,
      color: _pinnedGuideColor,
    );
  }

  Widget _buildDynamicColumnLine() {
    return _buildGuideLine(
      axis: Axis.vertical,
      offset: _cursorLeft! - pinnedBorderWidth,
      color: _dynamicGuideColor,
    );
  }

  Widget _buildPinnedRowLine() {
    double pinnedHeight =
        _isDraggingRows ? _calculateRowsHeight(_targetRowCount) : _data.pinnedRowsHeight;
    double y = columnHeadersHeight + pinnedHeight - pinnedBorderWidth;
    return _buildGuideLine(
      axis: Axis.horizontal,
      offset: y,
      color: _pinnedGuideColor,
    );
  }

  Widget _buildDynamicRowLine() {
    return _buildGuideLine(
      axis: Axis.horizontal,
      offset: _cursorTop! - pinnedBorderWidth,
      color: _dynamicGuideColor,
    );
  }

  void _handleColumnDragStart(PointerDownEvent event) {
    setState(() {
      _isDraggingColumns = true;
      _cursorLeft = rowHeadersWidth + _data.pinnedColumnsWidth;
      _targetColumnCount = _data.pinnedColumnCount;
    });
  }

  void _handleColumnDragUpdate(PointerMoveEvent event) {
    Offset local = widget.worksheet.viewport.globalOffsetToLocal(event.position);
    setState(() {
      _cursorLeft = local.dx.clamp(rowHeadersWidth.toDouble(), double.infinity);
      _targetColumnCount = _calculatePinnedColumns(local.dx);
    });
  }

  void _handleColumnDragEnd() {
    widget.worksheet.resolve(SetPinnedColumnsEvent(_targetColumnCount));
    setState(() {
      _isDraggingColumns = false;
      _cursorLeft = null;
    });
  }

  int _calculatePinnedColumns(double localX) {
    return _calculatePinnedCount(
      position: localX,
      headerOffset: rowHeadersWidth,
      itemCount: _data.columnCount,
      itemSize: (int i) => _data.columns.getWidth(ColumnIndex(i)),
    );
  }

  void _handleRowDragStart(PointerDownEvent event) {
    setState(() {
      _isDraggingRows = true;
      _cursorTop = columnHeadersHeight + _data.pinnedRowsHeight;
      _targetRowCount = _data.pinnedRowCount;
    });
  }

  void _handleRowDragUpdate(PointerMoveEvent event) {
    Offset local = widget.worksheet.viewport.globalOffsetToLocal(event.position);
    setState(() {
      _cursorTop = local.dy.clamp(columnHeadersHeight.toDouble(), double.infinity);
      _targetRowCount = _calculatePinnedRows(local.dy);
    });
  }

  void _handleRowDragEnd() {
    widget.worksheet.resolve(SetPinnedRowsEvent(_targetRowCount));
    setState(() {
      _isDraggingRows = false;
      _cursorTop = null;
    });
  }

  int _calculatePinnedRows(double localY) {
    return _calculatePinnedCount(
      position: localY,
      headerOffset: columnHeadersHeight,
      itemCount: _data.rowCount,
      itemSize: (int i) => _data.rows.getHeight(RowIndex(i)),
    );
  }

  double _calculateColumnsWidth(int count) {
    return _calculateSize(
      count: count,
      totalCount: _data.columnCount,
      itemSize: (int i) => _data.columns.getWidth(ColumnIndex(i)),
    );
  }

  double _calculateRowsHeight(int count) {
    return _calculateSize(
      count: count,
      totalCount: _data.rowCount,
      itemSize: (int i) => _data.rows.getHeight(RowIndex(i)),
    );
  }

  int _calculatePinnedCount({
    required double position,
    required double headerOffset,
    required int itemCount,
    required double Function(int index) itemSize,
  }) {
    double offset = position - headerOffset;
    if (offset <= 0) {
      return 0;
    }

    double length = 0;
    for (int i = 0; i < itemCount; i++) {
      length += itemSize(i) + borderWidth;
      if (offset < length) {
        return i + 1;
      }
    }
    return itemCount;
  }

  double _calculateSize({
    required int count,
    required int totalCount,
    required double Function(int index) itemSize,
  }) {
    double size = 0;
    int maxCount = count < totalCount ? count : totalCount;
    for (int i = 0; i < maxCount; i++) {
      size += itemSize(i) + borderWidth;
    }
    return size;
  }

  void _handleWorksheetChanged() {
    setState(() {});
  }
}
