import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';

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
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerHover: widget.mouseListener.notifyMouseHovered,
            onPointerDown: widget.mouseListener.notifyDragStarted,
            onPointerMove: widget.mouseListener.notifyDragUpdated,
            onPointerUp: widget.mouseListener.notifyDragEnd,
            child: const SizedBox.expand(child: RemoteMouseWidget()),
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
    SheetCursor.instance.addListener(_onCursorChanged);
  }

  void _onCursorChanged() {
    markNeedsPaint();
  }

  @override
  PointerEnterEventListener? get onEnter => _handlePointerEnter;

  @override
  PointerExitEventListener? get onExit => _handlePointerExit;

  @override
  MouseCursor get cursor => SheetCursor.instance.value;

  @override
  bool get validForMouseTracker => attached;

  void _handlePointerEnter(PointerEnterEvent event) {}

  void _handlePointerExit(PointerExitEvent event) {}

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return true;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }
}
