import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_scroll_events.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/widgets/sheet_mouse_region.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class SheetScrollable extends StatefulWidget {
  const SheetScrollable({
    required this.child,
    required this.sheetController,
    super.key,
  });

  final Widget child;
  final SheetController sheetController;

  @override
  State<SheetScrollable> createState() => _SheetScrollableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetScrollableState extends State<SheetScrollable> {
  final SheetScrollbarPainter verticalScrollbarPainter = SheetScrollbarPainter(axisDirection: SheetAxisDirection.vertical);
  final SheetScrollbarPainter horizontalScrollbarPainter = SheetScrollbarPainter(axisDirection: SheetAxisDirection.horizontal);

  @override
  void initState() {
    super.initState();
    widget.sheetController.addListener(_rebuild);
    _rebuild();
  }

  @override
  void dispose() {
    widget.sheetController.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrollbarWeight = scrollbarWidth - borderWidth * 2;

    return _ScrollbarLayout(
      scrollbarWeight: scrollbarWeight,
      verticalScrollbar: Column(
        children: <Widget>[
          Container(height: columnHeadersHeight),
          Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          Expanded(
            child: SheetScrollbar(
              painter: verticalScrollbarPainter,
              deltaModifier: (Offset offset) => offset.dy,
              onScroll: (double offset) {
                widget.sheetController.resolve(ScrollByEvent(Offset(0, offset)));
              },
            ),
          ),
          Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          _ScrollbarButton(
            size: scrollbarWeight,
            icon: Icons.arrow_drop_up,
            onPressed: () {
              widget.sheetController.resolve(ScrollByEvent(const Offset(0, -20)));
            },
          ),
          Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          _ScrollbarButton(
            size: scrollbarWeight,
            icon: Icons.arrow_drop_down,
            onPressed: () {
              widget.sheetController.resolve(ScrollByEvent(const Offset(0, 20)));
            },
          ),
        ],
      ),
      horizontalScrollbar: Row(
        children: <Widget>[
          Container(width: rowHeadersWidth),
          VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          Expanded(
            child: SheetScrollbar(
              painter: horizontalScrollbarPainter,
              deltaModifier: (Offset offset) => offset.dx,
              onScroll: (double offset) {
                widget.sheetController.resolve(ScrollByEvent(Offset(offset, 0)));
              },
            ),
          ),
          VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          _ScrollbarButton(
            size: scrollbarWeight,
            icon: Icons.arrow_left,
            onPressed: () {
              widget.sheetController.resolve(ScrollByEvent(const Offset(-20, 0)));
            },
          ),
          VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          _ScrollbarButton(
            size: scrollbarWeight,
            icon: Icons.arrow_right,
            onPressed: () {
              widget.sheetController.resolve(ScrollByEvent(const Offset(20, 0)));
            },
          ),
          VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
          SizedBox(width: scrollbarWeight, height: scrollbarWeight),
        ],
      ),
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent) {
            widget.sheetController.resolve(ScrollByEvent(event.scrollDelta));
          }
        },
        child: widget.child,
      ),
    );
  }

  void _rebuild() {
    _updateVerticalPosition();
    _updateHorizontalPosition();
    _updateMetrics();
  }

  void _updateVerticalPosition() {
    verticalScrollbarPainter.scrollPosition = widget.sheetController.scroll.position.vertical;
  }

  void _updateHorizontalPosition() {
    horizontalScrollbarPainter.scrollPosition = widget.sheetController.scroll.position.horizontal;
  }

  void _updateMetrics() {
    verticalScrollbarPainter.scrollMetrics = widget.sheetController.scroll.metrics.vertical;
    horizontalScrollbarPainter.scrollMetrics = widget.sheetController.scroll.metrics.horizontal;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetScrollbarPainter>('verticalScrollbarPainter', verticalScrollbarPainter));
    properties.add(DiagnosticsProperty<SheetScrollbarPainter>('horizontalScrollbarPainter', horizontalScrollbarPainter));
  }
}

class SheetScrollbar extends StatefulWidget {
  const SheetScrollbar({
    required this.painter,
    required this.onScroll,
    required this.deltaModifier,
    super.key,
  });

  final SheetScrollbarPainter painter;
  final ValueChanged<double> onScroll;
  final double Function(Offset offset) deltaModifier;

  @override
  State<StatefulWidget> createState() => _SheetScrollbarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetScrollbarPainter>('painter', painter));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has('onScroll', onScroll));
    properties.add(ObjectFlagProperty<double Function(Offset offset)>.has('deltaModifier', deltaModifier));
  }
}

class _SheetScrollbarState extends State<SheetScrollbar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SheetMouseRegion(
        key: UniqueKey(),
        cursor: SystemMouseCursors.basic,
        onEnter: _onHover,
        onExit: _onExit,
        onDragUpdate: _onScroll,
        child: CustomPaint(painter: widget.painter),
      ),
    );
  }

  void _onScroll(PointerMoveEvent event) {
    double delta = widget.deltaModifier(event.delta);
    double updatedDelta = widget.painter.parseDeltaToRealScroll(delta);
    widget.onScroll(updatedDelta);
  }

  void _onHover() {
    widget.painter.hovered = true;
  }

  void _onExit() {
    widget.painter.hovered = false;
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
                    left: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
                    right: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
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
            border: Border(top: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1))),
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

class SheetScrollbarPainter extends ChangeNotifier implements CustomPainter {
  SheetScrollbarPainter({
    required SheetAxisDirection axisDirection,
  })  : _axisDirection = axisDirection,
        _metrics = SheetScrollMetrics.zero(axisDirection),
        _position = SheetScrollPosition();
  final SheetAxisDirection _axisDirection;

  late SheetScrollMetrics _metrics;

  set scrollMetrics(SheetScrollMetrics scrollMetrics) {
    if (_metrics == scrollMetrics) {
      return;
    }
    _metrics = scrollMetrics;
    notifyListeners();
  }

  late SheetScrollPosition _position;

  set scrollPosition(SheetScrollPosition scrollPosition) {
    if (_position == scrollPosition) {
      return;
    }
    _position = scrollPosition;
    notifyListeners();
  }

  bool _hovered = false;

  set hovered(bool hovered) {
    if (_hovered == hovered) {
      return;
    }
    _hovered = hovered;
    notifyListeners();
  }

  double _scrollToThumbRatio = 0;

  @override
  bool? hitTest(Offset position) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    _paintScrollbar(canvas, size);
  }

  void _paintScrollbar(Canvas canvas, Size size) {
    double thumbMargin = _hovered ? 0 : 2;
    double thumbMinSize = 48;

    Size trackSize = size;

    Size thumbSize;
    Offset thumbOffset;

    switch (_axisDirection) {
      case SheetAxisDirection.vertical:
        double trackHeight = trackSize.height;
        double availableTrackHeight = trackHeight - (2 * thumbMargin);

        double ratio = _viewportDimension / _contentSize;
        double offsetRatio = _scrollOffset / (_contentSize - _viewportDimension);

        double thumbHeight = max(availableTrackHeight * ratio, thumbMinSize);
        double thumbPosition = offsetRatio * (availableTrackHeight - thumbHeight) + thumbMargin;

        thumbSize = Size(trackSize.width - (thumbMargin * 2), thumbHeight);
        thumbOffset = Offset(thumbMargin, thumbPosition);

        double maxScrollPosition = _contentSize - _viewportDimension;
        double maxThumbOffset = trackHeight - thumbHeight;
        _scrollToThumbRatio = maxScrollPosition / maxThumbOffset;
      case SheetAxisDirection.horizontal:
        double trackWidth = trackSize.width;
        double availableTrackWidth = trackWidth - (2 * thumbMargin);

        double ratio = _viewportDimension / _contentSize;
        double offsetRatio = _scrollOffset / (_contentSize - _viewportDimension);

        double thumbWidth = max(availableTrackWidth * ratio, thumbMinSize);
        double thumbPosition = offsetRatio * (availableTrackWidth - thumbWidth) + thumbMargin;

        thumbSize = Size(thumbWidth, trackSize.height - (thumbMargin * 2));
        thumbOffset = Offset(thumbPosition, thumbMargin);

        double maxScrollPosition = _contentSize - _viewportDimension;
        double maxThumbOffset = trackWidth - thumbWidth;
        _scrollToThumbRatio = maxScrollPosition / maxThumbOffset;
    }

    _paintTrack(canvas, trackSize);
    _paintThumb(canvas, thumbSize, thumbOffset);
  }

  double get _viewportDimension => _metrics.viewportDimension;

  double get _contentSize => _metrics.contentSize;

  double get _scrollOffset => _position.offset;

  double parseDeltaToRealScroll(double delta) {
    return delta * _scrollToThumbRatio;
  }

  void _paintTrack(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintThumb(Canvas canvas, Size size, Offset offset) {
    Paint paint = Paint()
      ..color = _hovered ? const Color(0xffbdc1c6) : const Color(0xffdadce0)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(offset & size, const Radius.circular(16)), paint);
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant SheetScrollbarPainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRepaint(covariant SheetScrollbarPainter oldDelegate) {
    return oldDelegate._metrics != _metrics || oldDelegate._position != _position;
  }
}

class _ScrollbarButton extends StatelessWidget {
  const _ScrollbarButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: onPressed,
      cursor: SystemMouseCursors.basic,
      builder: (Set<WidgetState> states) {
        return Container(
          width: size,
          height: size,
          color: getBackgroundColor(states),
          child: Center(
            child: Icon(icon, size: 12, color: getIconColor(states)),
          ),
        );
      },
    );
  }

  Color getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xff919191);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffc1c1c1);
    } else {
      return const Color(0xfff8f8f8);
    }
  }

  Color getIconColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.white;
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xff767676);
    } else {
      return const Color(0xff989898);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DoubleProperty('size', size));
  }
}
