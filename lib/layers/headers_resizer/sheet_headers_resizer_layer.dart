import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_mouse_region.dart';

class HeadersResizerLayer extends StatefulWidget {
  const HeadersResizerLayer({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

  @override
  State<StatefulWidget> createState() => _HeadersResizerLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}

class _HeadersResizerLayerState extends State<HeadersResizerLayer> {
  late final ValueNotifier<List<ViewportRow>> _visibleRowsNotifier;
  late final ValueNotifier<List<ViewportColumn>> _visibleColumnsNotifier;

  @override
  void initState() {
    super.initState();
    List<ViewportRow> visibleRows = _visibleContent.rows;
    List<ViewportColumn> visibleColumns = _visibleContent.columns;

    _visibleRowsNotifier = ValueNotifier<List<ViewportRow>>(visibleRows);
    _visibleColumnsNotifier = ValueNotifier<List<ViewportColumn>>(visibleColumns);

    widget.worksheet.addListener(_handleSheetControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: ValueListenableBuilder<List<ViewportColumn>>(
            valueListenable: _visibleColumnsNotifier,
            builder: (BuildContext context, List<ViewportColumn> visibleColumns, _) {
              return Stack(
                fit: StackFit.expand,
                children: visibleColumns.map((ViewportColumn column) {
                  return _VerticalHeaderResizer(
                    height: widget.worksheet.viewport.height,
                    column: column,
                    onResize: (double delta) => widget.worksheet.resolve(ResizeColumnEvent(column.index, delta)),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Positioned.fill(
          child: ValueListenableBuilder<List<ViewportRow>>(
            valueListenable: _visibleRowsNotifier,
            builder: (BuildContext context, List<ViewportRow> visibleRows, _) {
              return Stack(
                fit: StackFit.expand,
                children: visibleRows.map((ViewportRow row) {
                  return _HorizontalHeaderResizer(
                    width: widget.worksheet.viewport.width,
                    row: row,
                    onResize: (double delta) => widget.worksheet.resolve(ResizeRowEvent(row.index, delta)),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildConfig rebuildConfig = widget.worksheet.value;
    if (rebuildConfig.rebuildHorizontalHeaders || rebuildConfig.rebuildVerticalHeaders) {
      _visibleRowsNotifier.value = _visibleContent.rows;
      _visibleColumnsNotifier.value = _visibleContent.columns;
    }
  }

  SheetViewportContentManager get _visibleContent => widget.worksheet.viewport.visibleContent;
}

class _VerticalHeaderResizer extends StatelessWidget {
  const _VerticalHeaderResizer({
    required double height,
    required ViewportColumn column,
    required void Function(double) onResize,
  })  : _onResize = onResize,
        _column = column,
        _height = height;

  final double _height;
  final ViewportColumn _column;
  final ValueChanged<double> _onResize;

  @override
  Widget build(BuildContext context) {
    Rect columnRect = _column.rect;
    double startX = columnRect.right + 1;

    return _ResizerPositionedGestureDetector.vertical(
      left: startX,
      cursor: SystemMouseCursors.resizeColumn,
      baseSize: columnRect.width,
      minSize: minColumnWidth,
      onResize: _onResize,
      childBuilder: (bool hovered, bool dragged) {
        return _HeaderResizer(
          hovered: hovered,
          dragged: dragged,
          direction: _ResizerDirection.vertical,
          collapsedSize: columnRect.height,
          expandedSize: _height,
        );
      },
    );
  }
}

class _HorizontalHeaderResizer extends StatelessWidget {
  const _HorizontalHeaderResizer({
    required double width,
    required ViewportRow row,
    required void Function(double) onResize,
  })  : _onResize = onResize,
        _row = row,
        _width = width;

  final double _width;
  final ViewportRow _row;
  final ValueChanged<double> _onResize;

  @override
  Widget build(BuildContext context) {
    Rect rowRect = _row.rect;
    double startY = rowRect.bottom;

    return _ResizerPositionedGestureDetector.horizontal(
      top: startY,
      cursor: SystemMouseCursors.resizeRow,
      baseSize: rowRect.height,
      minSize: minRowHeight,
      onResize: _onResize,
      childBuilder: (bool hovered, bool dragged) {
        return _HeaderResizer(
          hovered: hovered,
          dragged: dragged,
          direction: _ResizerDirection.horizontal,
          collapsedSize: rowRect.width,
          expandedSize: _width,
        );
      },
    );
  }
}

class _ResizerPositionedGestureDetector extends StatefulWidget {
  const _ResizerPositionedGestureDetector.horizontal({
    required double this.top,
    required this.cursor,
    required this.baseSize,
    required this.minSize,
    required this.onResize,
    required this.childBuilder,
  }) : left = null;

  const _ResizerPositionedGestureDetector.vertical({
    required double this.left,
    required this.cursor,
    required this.baseSize,
    required this.minSize,
    required this.onResize,
    required this.childBuilder,
  }) : top = null;

  final double? left;
  final double? top;
  final SystemMouseCursor cursor;
  final double baseSize;
  final double minSize;
  final ValueChanged<double> onResize;
  final Widget Function(bool hovered, bool dragged) childBuilder;

  @override
  State<StatefulWidget> createState() => _ResizerPositionedGestureDetectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('left', left));
    properties.add(DoubleProperty('top', top));
    properties.add(DiagnosticsProperty<SystemMouseCursor>('cursor', cursor));
    properties.add(DoubleProperty('baseSize', baseSize));
    properties.add(DoubleProperty('minSize', minSize));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has('onResize', onResize));
    properties.add(ObjectFlagProperty<Widget Function(bool hovered, bool dragged)>.has('childBuilder', childBuilder));
  }
}

class _ResizerPositionedGestureDetectorState extends State<_ResizerPositionedGestureDetector> {
  bool _hovered = false;
  bool _dragged = false;
  double _resizeValue = 0;

  @override
  Widget build(BuildContext context) {
    double visibleResizeValue = _resizeValue;
    double newSize = widget.baseSize + visibleResizeValue;
    if (newSize < widget.minSize) {
      visibleResizeValue = widget.minSize - widget.baseSize;
    }

    double left = _isVertical ? widget.left! - (_HeaderResizer.crossAxisSize / 2) + visibleResizeValue : 0;
    double top = _isHorizontal ? widget.top! - (_HeaderResizer.crossAxisSize / 2) + visibleResizeValue : 0;
    double? width = _isVertical ? _HeaderResizer.crossAxisSize : null;
    double? height = _isHorizontal ? _HeaderResizer.crossAxisSize : null;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: SheetMouseRegion(
        onEnter: () {
          setState(() => _hovered = true);
        },
        onExit: () {
          setState(() => _hovered = false);
        },
        onDragStart: (PointerDownEvent event) {
          setState(() => _dragged = true);
        },
        onDragUpdate: (PointerMoveEvent event) {
          double delta = _offsetConverter(event.delta);
          _resizeValue += delta;
          setState(() {});
        },
        onDragEnd: () {
          double newSize = widget.baseSize + _resizeValue;
          newSize = newSize > minColumnWidth ? newSize : minColumnWidth;
          widget.onResize(newSize);
          setState(() {
            _dragged = false;
            _resizeValue = 0;
          });
        },
        cursor: widget.cursor,
        child: widget.childBuilder(_hovered, _dragged),
      ),
    );
  }

  double _offsetConverter(Offset offset) {
    if (_isHorizontal) {
      return offset.dy;
    } else {
      return offset.dx;
    }
  }

  bool get _isHorizontal => widget.top != null;

  bool get _isVertical => widget.left != null;
}

enum _ResizerDirection { horizontal, vertical }

class _HeaderResizer extends StatelessWidget {
  const _HeaderResizer({
    required _ResizerDirection direction,
    required double collapsedSize,
    required double expandedSize,
    bool hovered = true,
    bool dragged = true,
  })  : _dragged = dragged,
        _hovered = hovered,
        _collapsedSize = collapsedSize,
        _expandedSize = expandedSize,
        _direction = direction;

  static double get crossAxisSize => _HeaderResizerPainter.resizerWeight * 2 + _HeaderResizerPainter.resizerGapSize;

  final _ResizerDirection _direction;
  final double _collapsedSize;
  final double _expandedSize;
  final bool _hovered;
  final bool _dragged;

  @override
  Widget build(BuildContext context) {
    double resizerLength = _dragged ? _expandedSize : _collapsedSize;

    return CustomPaint(
      size: Size(
        _direction == _ResizerDirection.horizontal ? resizerLength : _HeaderResizerPainter.resizerWeight,
        _direction == _ResizerDirection.vertical ? resizerLength : _HeaderResizerPainter.resizerWeight,
      ),
      painter: _HeaderResizerPainter(
        direction: _direction,
        collapsedSize: _collapsedSize,
        hovered: _hovered,
        dragged: _dragged,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('crossAxisSize', crossAxisSize));
  }
}

class _HeaderResizerPainter extends CustomPainter {
  _HeaderResizerPainter({
    required this.direction,
    required this.collapsedSize,
    this.hovered = true,
    this.dragged = true,
  });

  static const double resizerGapSize = 5;
  static const double resizerWeight = 3;
  static const double resizerLength = 16;

  final _ResizerDirection direction;
  final double collapsedSize;
  final bool hovered;
  final bool dragged;

  @override
  void paint(Canvas canvas, Size size) {
    if (!hovered) {
      return;
    }
    Paint resizerPaint = Paint()
      ..color = Colors.black
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    Paint dividerPaint = Paint()
      ..color = const Color(0xffc4c7c5)
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    double padding = (collapsedSize - resizerLength) / 2.0;
    double startOffset = padding;

    Rect startRect;
    Rect middleRect;
    Rect endRect;

    if (direction == _ResizerDirection.horizontal) {
      startRect = Rect.fromLTWH(startOffset, 0, resizerLength, resizerWeight);
      middleRect = Rect.fromLTWH(0, resizerWeight, size.width, resizerGapSize);
      endRect = Rect.fromLTWH(startOffset, resizerWeight + resizerGapSize, resizerLength, resizerWeight);
    } else {
      startRect = Rect.fromLTWH(0, startOffset, resizerWeight, resizerLength);
      middleRect = Rect.fromLTWH(resizerWeight, 0, resizerGapSize, size.height);
      endRect = Rect.fromLTWH(resizerWeight + resizerGapSize, startOffset, resizerWeight, resizerLength);
    }

    canvas.drawRect(startRect, resizerPaint);
    canvas.drawRect(endRect, resizerPaint);

    if (dragged) {
      canvas.drawRect(middleRect, dividerPaint);
    }
  }

  @override
  bool shouldRepaint(_HeaderResizerPainter oldDelegate) {
    return oldDelegate.hovered != hovered ||
        oldDelegate.dragged != dragged ||
        oldDelegate.direction != direction ||
        oldDelegate.collapsedSize != collapsedSize;
  }
}
