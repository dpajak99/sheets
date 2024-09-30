import 'package:flutter/material.dart';
import 'package:sheets/models/sheet_item_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_draggable.dart';

double _kGapSize = 5;
double _kWeight = 3;
double _kLength = 16;

class HeadersResizerLayer extends StatelessWidget {
  final SheetController sheetController;

  const HeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _VerticalHeadersResizerLayer(sheetController: sheetController),
        _HorizontalHeadersResizerLayer(sheetController: sheetController),
      ],
    );
  }
}

class _VerticalHeadersResizerLayer extends StatelessWidget {
  final SheetController sheetController;

  const _VerticalHeadersResizerLayer({required this.sheetController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: sheetController.viewport.visibleColumns.map((ColumnConfig column) {
        return _VerticalHeaderResizer(
          column: column,
          onResize: (Offset delta) => sheetController.resizeColumnBy(column, delta.dx),
        );
      }).toList(),
    );
  }
}

class _VerticalHeaderResizer extends StatefulWidget {
  final ColumnConfig column;
  final ValueChanged<Offset> onResize;

  const _VerticalHeaderResizer({
    required this.column,
    required this.onResize,
  });

  @override
  State<StatefulWidget> createState() => _VerticalHeaderResizerState();
}

class _VerticalHeaderResizerState extends State<_VerticalHeaderResizer> {
  double dragDelta = 0;

  @override
  Widget build(BuildContext context) {
    Rect columnRect = widget.column.rect;
    double marginTop = columnRect.top + (columnRect.height - _kLength) / 2;
    double dividerWidth = _kGapSize + _kWeight * 2;

    return Positioned(
      top: widget.column.rect.top,
      left: widget.column.rect.right - (_kGapSize / 2) - _kWeight + dragDelta,
      bottom: 0,
      width: dividerWidth,
      child: SheetDraggable(
        dragBarrier: Offset(widget.column.rect.left + 20, 0),
        onDragStart: (_) {},
        onDragDeltaChanged: _handleDragDeltaChanged,
        onDragEnd: widget.onResize,
        cursor: SystemMouseCursors.resizeColumn,
        actionSize: Size(dividerWidth, columnRect.height),
        builder: (bool hovered, bool dragged) {
          if (hovered == false) return null;

          return Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: _kWeight, height: _kLength, margin: EdgeInsets.only(top: marginTop), color: Colors.black),
                if (dragged) ...<Widget>[
                  Container(width: _kGapSize, height: double.infinity, color: const Color(0xffc4c7c5)),
                ] else ...<Widget>[
                  SizedBox(width: _kGapSize),
                ],
                Container(width: _kWeight, height: _kLength, margin: EdgeInsets.only(top: marginTop), color: Colors.black),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleDragDeltaChanged(Offset value) {
    setState(() => dragDelta = value.dx);
  }
}

class _HorizontalHeadersResizerLayer extends StatelessWidget {
  final SheetController sheetController;

  const _HorizontalHeadersResizerLayer({required this.sheetController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: sheetController.viewport.visibleRows.map((RowConfig row) {
        return _HorizontalHeaderResizer(
          row: row,
          onResize: (Offset delta) => sheetController.resizeRowBy(row, delta.dy),
        );
      }).toList(),
    );
  }
}

class _HorizontalHeaderResizer extends StatefulWidget {
  final RowConfig row;
  final ValueChanged<Offset> onResize;

  const _HorizontalHeaderResizer({
    required this.row,
    required this.onResize,
  });

  @override
  State<StatefulWidget> createState() => _HorizontalHeaderResizerState();
}

class _HorizontalHeaderResizerState extends State<_HorizontalHeaderResizer> {
  double dragDelta = 0;

  @override
  Widget build(BuildContext context) {
    Rect rowRect = widget.row.rect;
    double marginLeft = rowRect.left + (rowRect.width - _kLength) / 2;
    double dividerHeight = _kGapSize + _kWeight * 2;

    return Positioned(
      top: widget.row.rect.bottom - (_kGapSize / 2) - _kWeight + dragDelta,
      left: 0,
      right: 0,
      height: dividerHeight,
      child: SheetDraggable(
        dragBarrier: Offset(0, widget.row.rect.top + 20),
        onDragStart: (_) {},
        onDragDeltaChanged: _handleDragDeltaChanged,
        onDragEnd: widget.onResize,
        cursor: SystemMouseCursors.resizeRow,
        actionSize: Size(rowRect.width, dividerHeight),
        builder: (bool hovered, bool dragged) {
          if (hovered == false) return null;

          return Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: _kLength, height: _kWeight, margin: EdgeInsets.only(left: marginLeft), color: Colors.black),
                if (dragged) ...<Widget>[
                  Container(height: _kGapSize, width: double.infinity, color: const Color(0xffc4c7c5)),
                ] else ...<Widget>[
                  SizedBox(height: _kGapSize),
                ],
                Container(width: _kLength, height: _kWeight, margin: EdgeInsets.only(left: marginLeft), color: Colors.black),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleDragDeltaChanged(Offset value) {
    setState(() => dragDelta = value.dy);
  }
}
