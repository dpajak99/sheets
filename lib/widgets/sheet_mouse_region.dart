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
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;
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
    properties.add(ObjectFlagProperty<PointerEnterEventListener?>.has('onEnter', onEnter));
    properties.add(ObjectFlagProperty<PointerExitEventListener?>.has('onExit', onExit));
    properties.add(ObjectFlagProperty<PointerDownEventListener?>.has('onDragStart', onDragStart));
    properties.add(ObjectFlagProperty<PointerMoveEventListener?>.has('onDragUpdate', onDragUpdate));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onDragEnd', onDragEnd));
  }
}

class _SheetMouseRegionState extends State<SheetMouseRegion> {
  bool _silentHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) {
        _silentHovered = true;
        if (SheetCursor.instance.isPressed) {
          return;
        }
        SheetCursor.instance.value = widget.cursor;
        widget.onEnter?.call(event);
      },
      onExit: (PointerExitEvent event) {
        _silentHovered = false;
        if (SheetCursor.instance.isPressed) {
          return;
        }
        SheetCursor.instance.value = SystemMouseCursors.basic;
        widget.onExit?.call(event);
      },
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (PointerDownEvent event) {
          SheetCursor.instance.isPressed = true;
          SheetCursor.instance.value = widget.cursor;
          widget.onDragStart?.call(event);
        },
        onPointerMove: (PointerMoveEvent event) {
          SheetCursor.instance.value = widget.cursor;
          widget.onDragUpdate?.call(event);
        },
        onPointerUp: (PointerUpEvent event) {
          SheetCursor.instance.isPressed = false;
          SheetCursor.instance.value = _silentHovered ? widget.cursor : SystemMouseCursors.basic;
          widget.onDragEnd?.call();
        },
        child: widget.child,
      ),
    );
  }
}
