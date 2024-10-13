import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/listeners/mouse_listener.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';

class SheetGestureDetector extends StatefulWidget {
  final SheetController sheetController;

  const SheetGestureDetector({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetGestureDetectorState();
}

class _SheetGestureDetectorState extends State<SheetGestureDetector> {
  final GlobalKey _key = GlobalKey();
  Rect _listenableAreaRect = Rect.zero;
  Rect _visibleCellsBounds = Rect.zero;

  bool _pressActive = false;
  bool _scrollBlocked = false;
  Offset _globalPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.sheetController.viewport.addListener(_notifyVisibleCellBoundsChanged);
    _notifyVisibleCellBoundsChanged();
  }

  @override
  void didUpdateWidget(covariant SheetGestureDetector oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox? renderBox = _key.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      Offset position = renderBox.localToGlobal(Offset.zero);
      _listenableAreaRect = Rect.fromLTRB(position.dx, position.dy, renderBox.size.width, renderBox.size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      key: _key,
      valueListenable: mouseListener.cursor,
      builder: (BuildContext context, SystemMouseCursor cursor, _) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _handlePointerDown,
          onPointerHover: _handlePointerHover,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              mouseListener.scroll(event.scrollDelta);
            }
          },
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            cursor: cursor,
          ),
        );
      },
    );
  }

  void _notifyVisibleCellBoundsChanged() {
    _visibleCellsBounds = widget.sheetController.viewport.localBounds;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (mouseListener.customTapHovered) return;
    _pressActive = true;
    _globalPosition = event.position;

    _notifyOffsetChanged();
    _onPanStart();
  }

  void _handlePointerHover(PointerHoverEvent event) {
    _globalPosition = event.position;
    _notifyOffsetChanged();
  }

  void _handlePointerMove(PointerMoveEvent event) {
    _globalPosition = event.position;
    _notifyOffsetChanged();

    if (_pressActive) {
      _onPanUpdate();
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _globalPosition = event.position;
    _notifyOffsetChanged();
    _pressActive = false;
    _onPanEnd();
  }

  SheetItemConfig? notifiedItem;

  void _onPanStart() {
    SheetItemConfig? hoveredItem = mouseListener.hoveredItem.value;
    if (hoveredItem != null) {
      notifiedItem = hoveredItem;
      mouseListener.dragStart(hoveredItem);
    }
  }

  void _onPanUpdate() {
    SheetItemConfig? hoveredItem = mouseListener.hoveredItem.value;
    if (notifiedItem == hoveredItem) return;
    mouseListener.dragUpdate();
    notifiedItem = hoveredItem;

    _scrollOutsideBounds();
  }

  void _onPanEnd() {
    mouseListener.dragEnd();
  }

  void _notifyOffsetChanged() {
    Offset mousePosition = localPosition.limitMin(0, 0);
    SheetItemConfig? sheetItemConfig = widget.sheetController.viewport.findByOffset(mousePosition);
    if (sheetItemConfig != null) {
      mouseListener.updateHover(mousePosition, sheetItemConfig);
    }
  }

  void _scrollOutsideBounds() {
    if(_pressActive == false || _scrollBlocked) return;

    double areaTop = min(_visibleCellsBounds.top, _listenableAreaRect.top);
    double areaLeft = max(_visibleCellsBounds.left, _listenableAreaRect.left);
    double areaRight = min(_visibleCellsBounds.right, _listenableAreaRect.right);
    double areaBottom = min(_visibleCellsBounds.bottom, _listenableAreaRect.bottom);

    Offset localPosition = _globalPosition - Offset(_listenableAreaRect.left, _listenableAreaRect.top);
    double actualY = localPosition.dy;
    double actualX = localPosition.dx;

    int minTimeToNext = 10;
    double scrollDelta = 0;
    if (actualX < areaLeft) {
      minTimeToNext = 50;
      scrollDelta = actualX - areaLeft;
      mouseListener.scroll(Offset(-defaultColumnWidth, 0));
    } else if (actualX > areaRight) {
      minTimeToNext = 50;
      scrollDelta = actualX - areaRight;
      mouseListener.scroll(Offset(defaultColumnWidth, 0));
    } else if (actualY < areaTop) {
      minTimeToNext = 10;
      scrollDelta = actualY - areaTop;
      mouseListener.scroll(Offset(0, -defaultRowHeight));
    } else if (actualY > areaBottom) {
      minTimeToNext = 10;
      scrollDelta = actualY - areaBottom;
      mouseListener.scroll(Offset(0, defaultRowHeight));
    }
    _scrollBlocked = true;
    Future<void>.delayed(Duration(milliseconds: max(minTimeToNext, 200 - scrollDelta.abs().toInt())), () {
      _scrollBlocked = false;
      _notifyOffsetChanged();
      _scrollOutsideBounds();
      _onPanUpdate();
    });
  }

  Offset get localPosition {
    Offset localPosition = _globalPosition - Offset(_listenableAreaRect.left, _listenableAreaRect.top);
    localPosition = localPosition.limit(
      Offset(_visibleCellsBounds.left, _visibleCellsBounds.right),
      Offset(_visibleCellsBounds.top, _visibleCellsBounds.bottom),
    );
    return localPosition;
  }

  SheetMouseListener get mouseListener => widget.sheetController.mouse;
}
