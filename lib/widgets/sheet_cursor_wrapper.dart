import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sheets/sheet.dart';

class SheetCursorWrapper extends StatelessWidget {
  const SheetCursorWrapper({
    required Widget child,
    super.key,
  }) : _child = child;

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: _child),
        const Positioned.fill(
          child: SizedBox.expand(
            child: _CustomCursorWrapper(),
          ),
        ),
      ],
    );
  }
}

class _CustomCursorWrapper extends SingleChildRenderObjectWidget {
  const _CustomCursorWrapper();

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CustomCursorWrapperRenderBox();
  }
}

class _CustomCursorWrapperRenderBox extends RenderBox implements MouseTrackerAnnotation {
  _CustomCursorWrapperRenderBox() {
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
