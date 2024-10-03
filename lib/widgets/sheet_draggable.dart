import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/sheet.dart';

class SheetDraggable extends StatefulWidget {
  final Size actionSize;
  final SystemMouseCursor cursor;
  final SystemMouseCursor? dragCursor;
  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragDeltaChanged;
  final ValueChanged<Offset> onDragEnd;
  final Positioned? Function(bool hovered, bool dragged)? builder;
  final Widget? child;
  final Offset? dragBarrier;

  const SheetDraggable({
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
  State<StatefulWidget> createState() => _SheetDraggableState();
}

class _SheetDraggableState extends State<SheetDraggable> {
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
            onEnter: (_) => _setHovered(),
            onHover: (_) => _setHovered(),
            onExit: (_) {
              if (_dragInProgress) return;
              _resetCursor();
            },
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
    _dragInProgress = true;
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

    _resetCursor();
  }

  void _setHovered() {
    if (_dragInProgress) return;
    if (Sheet.of(context).isNativeDragging()) return;
    if (Sheet.of(context).areMouseActionsEnabled() == false) return;

    Sheet.of(context).setCustomTapHovered(true);
    if (_hoverInProgress == false) {
      setState(() {
        _hoverInProgress = true;
        _dragInProgress = false;
      });
      Sheet.of(context).setCursor(widget.cursor);
    }
  }

  void _resetCursor() {
    setState(() {
      _hoverInProgress = false;
      _dragInProgress = false;
    });
    Sheet.of(context).enableMouseActions();
    Sheet.of(context).setCustomTapHovered(false);
    Sheet.of(context).resetCursor();
  }
}
