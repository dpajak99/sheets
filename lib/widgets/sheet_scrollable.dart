import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_scroll_events.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/widgets/scrollbar/sheet_scrollbar.dart';
import 'package:sheets/widgets/scrollbar/sheet_scrollbar_painter.dart';

class SheetScrollable extends StatefulWidget {
  const SheetScrollable({
    required this.child,
    required this.worksheet,
    super.key,
  });

  final Widget child;
  final Worksheet worksheet;

  @override
  State<SheetScrollable> createState() => _SheetScrollableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}

class _SheetScrollableState extends State<SheetScrollable> {
  final SheetScrollbarPainter verticalScrollbarPainter =
      SheetScrollbarPainter(axisDirection: SheetAxisDirection.vertical);
  final SheetScrollbarPainter horizontalScrollbarPainter =
      SheetScrollbarPainter(axisDirection: SheetAxisDirection.horizontal);

  @override
  void initState() {
    super.initState();
    widget.worksheet.addListener(_rebuild);
    _rebuild();
  }

  @override
  void dispose() {
    widget.worksheet.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scrollbarWeight = scrollbarWidth - borderWidth * 2;

    return _ScrollbarLayout(
      scrollbarWeight: scrollbarWeight,
      verticalScrollbar: _buildVerticalScrollbar(scrollbarWeight),
      horizontalScrollbar: _buildHorizontalScrollbar(scrollbarWeight),
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent) {
            widget.worksheet.resolve(ScrollByEvent(event.scrollDelta));
          }
        },
        child: widget.child,
      ),
    );
  }

  Widget _buildVerticalScrollbar(double scrollbarWeight) {
    return Column(
      children: <Widget>[
        Container(height: columnHeadersHeight),
        Divider(
            height: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        Expanded(
          child: SheetScrollbar(
            painter: verticalScrollbarPainter,
            deltaModifier: (Offset offset) => offset.dy,
            onScroll: (double offset) {
              widget.worksheet.resolve(ScrollByEvent(Offset(0, offset)));
            },
          ),
        ),
        Divider(
            height: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        ScrollbarButton(
          size: scrollbarWeight,
          icon: Icons.arrow_drop_up,
          onPressed: () {
            widget.worksheet.resolve(ScrollByEvent(const Offset(0, -20)));
          },
        ),
        Divider(
            height: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        ScrollbarButton(
          size: scrollbarWeight,
          icon: Icons.arrow_drop_down,
          onPressed: () {
            widget.worksheet.resolve(ScrollByEvent(const Offset(0, 20)));
          },
        ),
      ],
    );
  }

  Widget _buildHorizontalScrollbar(double scrollbarWeight) {
    return Row(
      children: <Widget>[
        Container(width: rowHeadersWidth),
        VerticalDivider(
            width: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        Expanded(
          child: SheetScrollbar(
            painter: horizontalScrollbarPainter,
            deltaModifier: (Offset offset) => offset.dx,
            onScroll: (double offset) {
              widget.worksheet.resolve(ScrollByEvent(Offset(offset, 0)));
            },
          ),
        ),
        VerticalDivider(
            width: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        ScrollbarButton(
          size: scrollbarWeight,
          icon: Icons.arrow_left,
          onPressed: () {
            widget.worksheet.resolve(ScrollByEvent(const Offset(-20, 0)));
          },
        ),
        VerticalDivider(
            width: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        ScrollbarButton(
          size: scrollbarWeight,
          icon: Icons.arrow_right,
          onPressed: () {
            widget.worksheet.resolve(ScrollByEvent(const Offset(20, 0)));
          },
        ),
        VerticalDivider(
            width: borderWidth,
            thickness: borderWidth,
            color: Color(0xffd9d9d9)),
        SizedBox(width: scrollbarWeight, height: scrollbarWeight),
      ],
    );
  }

  void _rebuild() {
    _updateVerticalPosition();
    _updateHorizontalPosition();
    _updateMetrics();
  }

  void _updateVerticalPosition() {
    verticalScrollbarPainter.scrollPosition =
        widget.worksheet.scroll.position.vertical;
  }

  void _updateHorizontalPosition() {
    horizontalScrollbarPainter.scrollPosition =
        widget.worksheet.scroll.position.horizontal;
  }

  void _updateMetrics() {
    verticalScrollbarPainter.scrollMetrics =
        widget.worksheet.scroll.metrics.vertical;
    horizontalScrollbarPainter.scrollMetrics =
        widget.worksheet.scroll.metrics.horizontal;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetScrollbarPainter>(
        'verticalScrollbarPainter', verticalScrollbarPainter));
    properties.add(DiagnosticsProperty<SheetScrollbarPainter>(
        'horizontalScrollbarPainter', horizontalScrollbarPainter));
  }
}

class _ScrollbarLayout extends StatelessWidget {
  const _ScrollbarLayout({
    required this.verticalScrollbar,
    required this.horizontalScrollbar,
    required this.child,
    required this.scrollbarWeight,
  });

  final Widget verticalScrollbar;
  final Widget horizontalScrollbar;
  final Widget child;
  final double scrollbarWeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(child: child),
              Container(
                width: scrollbarWeight,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xfff8f8f8),
                  border: Border(
                    left: BorderSide(
                        width: borderWidth, color: const Color(0xffe1e3e1)),
                    right: BorderSide(
                        width: borderWidth, color: const Color(0xffe1e3e1)),
                  ),
                ),
                child: verticalScrollbar,
              ),
            ],
          ),
        ),
        Container(
          height: scrollbarWeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xfff8f8f8),
            border: Border(
                top: BorderSide(
                    width: borderWidth, color: const Color(0xffe1e3e1))),
          ),
          child: horizontalScrollbar,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('scrollbarWeight', scrollbarWeight));
  }
}
