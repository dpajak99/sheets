import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/utils/repeat_action_timer.dart';

class SheetMouseGestureDetector extends StatefulWidget {
  const SheetMouseGestureDetector({
    required this.mouseListener,
    required this.child,
    super.key,
  });

  final MouseListener mouseListener;
  final Widget child;

  static SheetMouseGestureDetectorState of(BuildContext context) {
    return context.findAncestorStateOfType<SheetMouseGestureDetectorState>()!;
  }

  @override
  State<StatefulWidget> createState() => SheetMouseGestureDetectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MouseListener>('mouseListener', mouseListener));
  }
}

class SheetMouseGestureDetectorState extends State<SheetMouseGestureDetector> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: widget.child),
        const Positioned.fill(
          child: SizedBox.expand(
            child: RemoteMouseWidget(),
          ),
        ),
      ],
    );
  }
}

class RemoteMouseWidget extends SingleChildRenderObjectWidget {
  const RemoteMouseWidget({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RemoteMouseRenderBox();
  }
}

class RemoteMouseRenderBox extends RenderBox implements MouseTrackerAnnotation {
  RemoteMouseRenderBox() {
    SheetCursor.instance.cursor.addListener(_onCursorChanged);
  }

  SystemMouseCursor _cursor = SystemMouseCursors.basic;
  late final RepeatActionTimer _repeatDragUpdateTimer;


  void _onCursorChanged() {
    _cursor = SheetCursor.instance.cursor.value;
    markNeedsPaint();
  }

  @override
  PointerEnterEventListener? get onEnter => null;

  @override
  PointerExitEventListener? get onExit => null;

  @override
  MouseCursor get cursor => _cursor;

  @override
  bool get validForMouseTracker => attached;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
    if (event is PointerDownEvent) {
      _handlePointerDown(event);
    } else if (event is PointerUpEvent) {
      _handlePointerUp(event);
    } else if (event is PointerMoveEvent) {
      _handlePointerMove(event);
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    _handlePointerHover(position);
    return true;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  void _handlePointerHover(Offset offset) {
    SheetCursor.instance.handleCursorMove(offset);
  }

  void _handlePointerDown(PointerDownEvent event) {
    SheetCursor.instance.handlePress(event.position);
  }

  void _handlePointerUp(PointerUpEvent event) {
    SheetCursor.instance.handleRelease();
  }

  void _handlePointerMove(PointerMoveEvent event) {
    SheetCursor.instance.handlePressMove(event.position);
  }
}
