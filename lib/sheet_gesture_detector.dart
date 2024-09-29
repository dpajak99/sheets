import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/sheet.dart';

class SheetGestureDetector extends StatefulWidget {
  final Size actionSize;
  final SystemMouseCursor cursor;
  final SystemMouseCursor? dragCursor;
  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragDeltaChanged;
  final ValueChanged<Offset> onDragEnd;
  final Positioned? Function(bool hovered, bool dragged)? builder;
  final Widget? child;
  final Offset? dragBarrier;

  const SheetGestureDetector({
    required this.actionSize,
    required this.cursor,
    required this.onDragStart,
    required this.onDragDeltaChanged,
    required this.onDragEnd,
    SystemMouseCursor? dragCursor,
    this.builder,
    this.child,
    this.dragBarrier,
    super.key,
  }) : dragCursor = dragCursor ?? cursor;

  @override
  State<StatefulWidget> createState() => _SheetGestureDetectorState();
}

class _SheetGestureDetectorState extends State<SheetGestureDetector> {
  Offset _dragDelta = Offset.zero;
  bool _hoverInProgress = false;
  bool _dragInProgress = false;

  @override
  Widget build(BuildContext context) {
    Widget? child = widget.child ?? widget.builder!.call(_hoverInProgress, _dragInProgress);

    return Stack(
      children: [
        if (child != null) child,
        Positioned(
          width: widget.actionSize.width,
          height: widget.actionSize.height,
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            onEnter: (_) => _setHovered(true),
            onHover: (_) => _setHovered(true),
            onExit: (_) => _setHovered(false),
            child: Listener(
              onPointerDown: _onDragStart,
              onPointerMove: _onDragUpdate,
              onPointerUp: _onDragEnd,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }

  void _onDragStart(PointerDownEvent event) {
    Sheet.of(context).disableMouseActions();
    Sheet.of(context).setCursor(widget.cursor);
    _setDragged(true);
    widget.onDragStart(event.position);
  }

  void _onDragUpdate(PointerMoveEvent event) {
    if (widget.dragBarrier != null && (event.position.dy < widget.dragBarrier!.dy || event.position.dx < widget.dragBarrier!.dx)) {
      Sheet.of(context).resetCursor();
      return;
    } else {
      Sheet.of(context).setCursor(widget.cursor);
    }

    _dragDelta += event.delta;
    widget.onDragDeltaChanged(_dragDelta);
  }

  void _onDragEnd(PointerUpEvent details) {
    widget.onDragEnd(_dragDelta);

    _dragDelta = Offset.zero;
    widget.onDragDeltaChanged(_dragDelta);

    setState(() {
      _hoverInProgress = false;
      _dragInProgress = false;
    });

    Sheet.of(context).enableMouseActions();
    Sheet.of(context).resetCursor();
  }

  void _setHovered(bool value) {
    if (_dragInProgress) return;
    if (Sheet.of(context).isNativeDragging()) return;
    if (Sheet.of(context).areMouseActionsEnabled() == false) return;

    Sheet.of(context).setCustomTapHovered(value);

    if (_hoverInProgress != value) {
      setState(() {
        _hoverInProgress = value;
        _dragInProgress = false;
      });
      if (value == true) {
        Sheet.of(context).setCursor(widget.cursor);
      } else {
        Sheet.of(context).resetCursor();
      }
    }
  }

  void _setDragged(bool value) {
    if (_dragInProgress != value) {
      setState(() => _dragInProgress = value);
    }
  }
}
