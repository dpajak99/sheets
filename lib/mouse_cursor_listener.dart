import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_scroll_physics.dart';

class MouseCursorListener extends StatelessWidget {
  final ValueNotifier<SystemMouseCursor> cursorListener;
  final ValueChanged<Offset> onMouseOffsetChanged;

  const MouseCursorListener({
    required this.cursorListener,
    required this.onMouseOffsetChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cursorListener,
      builder: (BuildContext context, SystemMouseCursor cursor, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (DragStartDetails dragStartDetails) {
            _notifyOffsetChanged(dragStartDetails.localPosition);
          },
          onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
            _notifyOffsetChanged(dragUpdateDetails.localPosition);
          },
          child: MouseRegion(
            opaque: false,
            cursor: cursor,
            onHover: (event) => _notifyOffsetChanged(event.localPosition),
          ),
        );
      },
    );
  }

  void _notifyOffsetChanged(Offset value) {
    onMouseOffsetChanged(value.limitMin(0, 0));
  }
}
