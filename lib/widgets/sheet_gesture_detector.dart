import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/listeners/mouse_listener.dart';
import 'package:sheets/utils/extensions/offset_extension.dart';

class SheetGestureDetector extends StatefulWidget {
  final SheetMouseListener mouseListener;
  final ValueChanged<Offset> onMouseOffsetChanged;

  const SheetGestureDetector({
    required this.mouseListener,
    required this.onMouseOffsetChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetGestureDetectorState();
}

class _SheetGestureDetectorState extends State<SheetGestureDetector> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.mouseListener.cursor,
      builder: (BuildContext context, SystemMouseCursor cursor, _) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (PointerSignalEvent event) {
            if (event is PointerScrollEvent) {
              widget.mouseListener.scroll(event.scrollDelta);
            }
          },
          onPointerDown: _onDragStart,
          onPointerMove: _onDragUpdate,
          onPointerUp: _onDragEnd,
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            cursor: cursor,
            onHover: (event) => _notifyOffsetChanged(event.localPosition),
          ),
        );
      },
    );
  }

  SheetItemConfig? _dragStartItem;
  bool _dragStarted = false;

  Timer? tapTimer;

  void _onDragStart(PointerDownEvent event) {
    _notifyOffsetChanged(event.localPosition);

    if(tapTimer != null) return;

    Offset tapPosition = event.localPosition;
    SheetItemConfig? hoveredItem = widget.mouseListener.hoveredItem.value;
    if( hoveredItem == null) return;

    _dragStartItem = hoveredItem;
    // widget.mouseListener.tap();
    // widget.mouseListener.dragStart(_dragStartItem!);
    tapTimer = Timer(const Duration(milliseconds: 100), () {
      Offset? currentPosition = widget.mouseListener.mousePosition.value;
      // print('tapPosition: $tapPosition');
      // print('currentPosition: $currentPosition');
      double verticalDistance = (tapPosition.dy - currentPosition.dy).abs();
      double horizontalDistance = (tapPosition.dx - currentPosition.dx).abs();

      // print('verticalDistance: $verticalDistance | horizontalDistance: $horizontalDistance');

      if(verticalDistance < 10 || horizontalDistance < 10) {
        print('TAP');
        // widget.mouseListener.tap();
      } else {
        print('DRAG');
        widget.mouseListener.dragStart(hoveredItem);
      }

      tapTimer?.cancel();
      tapTimer = null;
    });
  }

  void _onDragUpdate(PointerMoveEvent event) {
    if(_dragStartItem == null) return;

    _notifyOffsetChanged(event.localPosition);
    widget.mouseListener.dragUpdate();
  }

  void _onDragEnd(PointerUpEvent event) {
    _notifyOffsetChanged(event.localPosition);
    _dragStarted = false;
    _dragStartItem = null;
    widget.mouseListener.dragEnd();
  }

  void _notifyOffsetChanged(Offset value) {
    widget.onMouseOffsetChanged(value.limitMin(0, 0));
  }
}
