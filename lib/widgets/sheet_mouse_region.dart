import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/sheet.dart';

class SheetMouseRegion extends StatefulWidget {
  const SheetMouseRegion({
    required this.cursor,
    required this.child,
    this.onEnter,
    this.onExit,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    super.key,
  });

  final SystemMouseCursor cursor;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final PointerDownEventListener? onDragStart;
  final PointerMoveEventListener? onDragUpdate;
  final VoidCallback? onDragEnd;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _SheetMouseRegionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SystemMouseCursor>('cursor', cursor));
    properties.add(ObjectFlagProperty<PointerDownEventListener?>.has('onDragStart', onDragStart));
    properties.add(ObjectFlagProperty<PointerMoveEventListener?>.has('onDragUpdate', onDragUpdate));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onDragEnd', onDragEnd));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onEnter', onEnter));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onExit', onExit));
  }
}

class _SheetMouseRegionState extends State<SheetMouseRegion> {
  bool _silentHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        child: widget.child,
      ),
    );
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    _silentHovered = true;
    if (SheetCursor.instance.isPressed) {
      return;
    }
    SheetCursor.instance.set(widget.cursor);
    widget.onEnter?.call();
  }

  void _handleMouseExit(PointerExitEvent event) {
    _silentHovered = false;
    if (SheetCursor.instance.isPressed) {
      return;
    }
    SheetCursor.instance.reset();
    widget.onExit?.call();
  }

  void _handlePointerDown(PointerDownEvent event) {
    SheetCursor.instance.notifyKeyPressed(UniqueKey());
    SheetCursor.instance.set(widget.cursor);
    widget.onDragStart?.call(event);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    SheetCursor.instance.set(widget.cursor);
    widget.onDragUpdate?.call(event);
  }

  void _handlePointerUp(PointerUpEvent event) {
    SheetCursor.instance.notifyKeyReleased();
    if(_silentHovered) {
      SheetCursor.instance.reset();
    } else {
      widget.onExit?.call();
    }
    SheetCursor.instance.set(_silentHovered ? widget.cursor : SystemMouseCursors.basic);
    widget.onDragEnd?.call();
  }
}
