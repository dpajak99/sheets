import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_scroll_physics.dart';
import 'package:sheets/utils/extensions/offset_extension.dart';

class MouseCursorListener extends StatelessWidget {
  final ValueNotifier<SystemMouseCursor> cursorListener;
  final ValueChanged<Offset> onMouseOffsetChanged;
  final VoidCallback onTap;
  final VoidCallback onDragStart;
  final VoidCallback onDragUpdate;
  final VoidCallback onDragEnd;
  final ValueChanged<Offset> onScroll;

  const MouseCursorListener({
    required this.cursorListener,
    required this.onMouseOffsetChanged,
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onScroll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cursorListener,
      builder: (BuildContext context, SystemMouseCursor cursor, _) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (PointerSignalEvent event) {
            if (event is PointerScrollEvent) {
              onScroll(event.scrollDelta);
            }
          },
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.translucent,
            onPanStart: (DragStartDetails dragStartDetails) {
              _notifyOffsetChanged(dragStartDetails.localPosition);
              onTap();
              onDragStart();
            },
            onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
              _notifyOffsetChanged(dragUpdateDetails.localPosition);
              onDragUpdate();
            },
            onPanEnd: (DragEndDetails dragEndDetails) {
              onDragEnd();
            },
            child: MouseRegion(
              opaque: false,
              hitTestBehavior: HitTestBehavior.translucent,
              cursor: cursor,
              onHover: (event) => _notifyOffsetChanged(event.localPosition),
            ),
          ),
        );
      },
    );
  }

  void _notifyOffsetChanged(Offset value) {
    onMouseOffsetChanged(value.limitMin(0, 0));
  }
}
