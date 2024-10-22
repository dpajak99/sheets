import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';

class SheetDraggable extends StatefulWidget {
  const SheetDraggable({
    required this.draggableAreaRect,
    required this.mouseListener,
    required this.handler,
    required this.child,
    super.key,
  });

  final Rect draggableAreaRect;
  final MouseListener mouseListener;
  final DraggableGestureHandler handler;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _SheetDraggableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Rect>('draggableAreaRect', draggableAreaRect));
    properties.add(DiagnosticsProperty<MouseListener>('mouseListener', mouseListener));
    properties.add(DiagnosticsProperty<DraggableGestureHandler>('handler', handler));
  }
}

class _SheetDraggableState extends State<SheetDraggable> {
  late final DraggableGestureRecognizer recognizer;

  @override
  void initState() {
    super.initState();
    recognizer = DraggableGestureRecognizer(widget.handler);
    recognizer.setDraggableArea(widget.draggableAreaRect);

    widget.mouseListener.insertRecognizer(recognizer);
  }

  @override
  void didUpdateWidget(covariant SheetDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draggableAreaRect != widget.draggableAreaRect) {
      recognizer.setDraggableArea(widget.draggableAreaRect);
    }
  }

  @override
  Future<void> dispose() async {
    await widget.mouseListener.removeRecognizer(recognizer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DraggableGestureRecognizer>('recognizer', recognizer));
  }
}
