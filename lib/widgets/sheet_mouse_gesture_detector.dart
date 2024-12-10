import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sheets/sheet.dart';

class SheetMouseGestureDetector extends StatefulWidget {
  const SheetMouseGestureDetector({
    required this.child,
    super.key,
  });

  final Widget child;

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
    SheetCursor.instance.addListener(_onCursorChanged);
  }

  SystemMouseCursor _cursor = SystemMouseCursors.basic;

  void _onCursorChanged() {
    _cursor = SheetCursor.instance.value;
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
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return true;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    result.add(BoxHitTestEntry(this, position));
    return false;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }
}
