import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';

class SheetMouseGestureDetector extends StatefulWidget {
  final MouseListener mouseListener;
  final Widget child;

  const SheetMouseGestureDetector({
    required this.mouseListener,
    required this.child,
    super.key,
  });

  static SheetMouseGestureDetectorState of(BuildContext context) {
    return context.findAncestorStateOfType<SheetMouseGestureDetectorState>()!;
  }

  @override
  State<StatefulWidget> createState() => SheetMouseGestureDetectorState();
}

class SheetMouseGestureDetectorState extends State<SheetMouseGestureDetector> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: widget.child),
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerHover: widget.mouseListener.notifyMouseHovered,
            onPointerDown: widget.mouseListener.notifyDragStarted,
            onPointerMove: widget.mouseListener.notifyDragUpdated,
            onPointerUp: widget.mouseListener.notifyDragEnd,
            child: ValueListenableBuilder<SystemMouseCursor>(
              valueListenable: widget.mouseListener.cursor,
              builder: (BuildContext context, SystemMouseCursor cursor, Widget? child) {
                return MouseRegion(
                  opaque: false,
                  hitTestBehavior: HitTestBehavior.translucent,
                  cursor: cursor,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
