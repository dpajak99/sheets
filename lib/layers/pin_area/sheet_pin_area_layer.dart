import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_event.dart';
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
  bool _draggingColumns = false;
  bool _draggingRows = false;
  double? _cursorX;
  double? _cursorY;
  int _targetColumnCount = 0;
  int _targetRowCount = 0;

  WorksheetData get _data => widget.worksheet.data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: rowHeadersWidth + borderWidth,
            height: columnHeadersHeight + borderWidth,
            decoration: const BoxDecoration(
              color: Color(0xfff8f9fa),
              border: Border(
                right: BorderSide(color: Color(0xffc7c7c7), width: pinnedBorderWidth),
                bottom: BorderSide(color: Color(0xffc7c7c7), width: pinnedBorderWidth),
              ),
            ),
          ),
        ),
        // Vertical drag handle for columns
        Positioned(
          top: 0,
          left: rowHeadersWidth + borderWidth - pinnedBorderWidth,
          width: pinnedBorderWidth,
          height: columnHeadersHeight + pinnedBorderWidth,
          child: SheetMouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            onDragStart: _handleColumnDragStart,
            onDragUpdate: _handleColumnDragUpdate,
            onDragEnd: _handleColumnDragEnd,
            child: const SizedBox.expand(),
          ),
        ),
        // Horizontal drag handle for rows
        Positioned(
          top: columnHeadersHeight + borderWidth - pinnedBorderWidth,
          left: 0,
          width: rowHeadersWidth + pinnedBorderWidth,
          height: pinnedBorderWidth,
          child: SheetMouseRegion(
            cursor: SystemMouseCursors.resizeRow,
            onDragStart: _handleRowDragStart,
            onDragUpdate: _handleRowDragUpdate,
            onDragEnd: _handleRowDragEnd,
            child: const SizedBox.expand(),
          ),
        ),
        if (_draggingColumns) ...<Widget>[
          _buildPinnedColumnLine(),
          if (_cursorX != null) _buildDynamicColumnLine(),
        ],
        if (_draggingRows) ...<Widget>[
          _buildPinnedRowLine(),
          if (_cursorY != null) _buildDynamicRowLine(),
        ],
      ],
    );
  }

  Widget _buildPinnedColumnLine() {
    double x = rowHeadersWidth + borderWidth + _data.pinnedColumnsWidth;
    return Positioned(
      top: columnHeadersHeight,
      bottom: 0,
      left: x,
      width: pinnedBorderWidth,
      child: Container(color: const Color(0xffc7c7c7)),
    );
  }

  Widget _buildDynamicColumnLine() {
    return Positioned(
      top: columnHeadersHeight,
      bottom: 0,
      left: _cursorX,
      width: pinnedBorderWidth,
      child: Container(color: const Color(0xff9fa8da)),
    );
  }

  Widget _buildPinnedRowLine() {
    double y = columnHeadersHeight + borderWidth + _data.pinnedRowsHeight;
    return Positioned(
      left: rowHeadersWidth,
      right: 0,
      top: y,
      height: pinnedBorderWidth,
      child: Container(color: const Color(0xffc7c7c7)),
    );
  }

  Widget _buildDynamicRowLine() {
    return Positioned(
      left: rowHeadersWidth,
      right: 0,
      top: _cursorY,
      height: pinnedBorderWidth,
      child: Container(color: const Color(0xff9fa8da)),
    );
  }

  void _handleColumnDragStart(PointerDownEvent event) {
    setState(() {
      _draggingColumns = true;
      _cursorX = rowHeadersWidth + pinnedBorderWidth + _data.pinnedColumnsWidth;
      _targetColumnCount = _data.pinnedColumnCount;
    });
  }

  void _handleColumnDragUpdate(PointerMoveEvent event) {
    Offset local = widget.worksheet.viewport.globalOffsetToLocal(event.position);
    setState(() {
      _cursorX =
          local.dx.clamp((rowHeadersWidth + pinnedBorderWidth).toDouble(), double.infinity);
      _targetColumnCount = _calculatePinnedColumns(local.dx);
    });
  }

  void _handleColumnDragEnd() {
    widget.worksheet.resolve(SetPinnedColumnsEvent(_targetColumnCount));
    setState(() {
      _draggingColumns = false;
      _cursorX = null;
    });
  }

  int _calculatePinnedColumns(double localX) {
    double x = (localX - rowHeadersWidth - pinnedBorderWidth).clamp(0.0, double.infinity);
    double width = 0;
    int count = 0;
    for (int i = 0; i < _data.columnCount; i++) {
      width += _data.columns.getWidth(ColumnIndex(i)) + borderWidth;
      if (x < width) {
        count = i + 1;
        break;
      }
    }
    return count;
  }

  void _handleRowDragStart(PointerDownEvent event) {
    setState(() {
      _draggingRows = true;
      _cursorY = columnHeadersHeight + pinnedBorderWidth + _data.pinnedRowsHeight;
      _targetRowCount = _data.pinnedRowCount;
    });
  }

  void _handleRowDragUpdate(PointerMoveEvent event) {
    Offset local = widget.worksheet.viewport.globalOffsetToLocal(event.position);
    setState(() {
      _cursorY =
          local.dy.clamp((columnHeadersHeight + pinnedBorderWidth).toDouble(), double.infinity);
      _targetRowCount = _calculatePinnedRows(local.dy);
    });
  }

  void _handleRowDragEnd() {
    widget.worksheet.resolve(SetPinnedRowsEvent(_targetRowCount));
    setState(() {
      _draggingRows = false;
      _cursorY = null;
    });
  }

  int _calculatePinnedRows(double localY) {
    double y = (localY - columnHeadersHeight - pinnedBorderWidth).clamp(0.0, double.infinity);
    double height = 0;
    int count = 0;
    for (int i = 0; i < _data.rowCount; i++) {
      height += _data.rows.getHeight(RowIndex(i)) + borderWidth;
      if (y < height) {
        count = i + 1;
        break;
      }
    }
    return count;
  }
}
