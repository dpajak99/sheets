import 'package:flutter/material.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/viewport/sheet_viewport_content.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/utils/directional_values.dart';

class SheetViewport extends ChangeNotifier {
  final SheetViewportContent visibleContent = SheetViewportContent();

  final SheetProperties _properties;

  final SheetScrollController _scrollController;

  late DirectionalValues<SheetScrollPosition> _scrollPosition;

  late SheetViewportRect viewportRect;

  SheetViewport(SheetProperties properties, SheetScrollController scrollController)
      : _scrollController = scrollController,
        _properties = properties {
    _scrollPosition = _scrollController.position;
    _scrollController.applyProperties(properties);

    viewportRect = SheetViewportRect(Rect.zero);

    visibleContent.applyProperties(_properties);
    visibleContent.addListener(notifyListeners);

    _properties.addListener(() => _updateSheetProperties(_properties));
    _scrollController.addListener(() => _updateScrollPosition(_scrollController));
  }

  @override
  void dispose() {
    visibleContent.removeListener(notifyListeners);
    _properties.removeListener(() => _updateSheetProperties(_properties));
    _scrollController.removeListener(() => _updateScrollPosition(_scrollController));

    super.dispose();
  }

  double get width => viewportRect.width;

  double get height => viewportRect.height;

  Rect get innerRectLocal {
    return viewportRect.innerRectLocal;
  }

  Rect get outerRectLocal {
    return viewportRect.local;
  }

  ColumnIndex get firstVisibleColumn {
    return visibleContent.columns.first.index;
  }

  RowIndex get firstVisibleRow {
    return visibleContent.rows.first.index;
  }

  Offset globalOffsetToLocal(Offset globalOffset) {
    return viewportRect.globalOffsetToLocal(globalOffset);
  }

  void setViewportRect(Rect rect) {
    if (viewportRect.isEquivalent(rect)) return;

    viewportRect = SheetViewportRect(rect);
    visibleContent.rebuild(viewportRect, _scrollPosition);

    _scrollController.setViewportSize(rect.size);
  }

  void ensureIndexFullyVisible(SheetIndex index) {
    Offset scrollOffset = _scrollController.offset;

    Rect sheetCoords = index.getSheetCoordinates(_properties);
    double sheetHeight = viewportRect.innerRectLocal.height;
    double sheetWidth = viewportRect.innerRectLocal.width;

    double topMargin = sheetCoords.top;
    double bottomMargin = sheetCoords.bottom;
    double leftMargin = sheetCoords.left;
    double rightMargin = sheetCoords.right;

    if (topMargin < scrollOffset.dy) {
      _scrollController.scrollToVertical(sheetCoords.top - 1);
    } else if (bottomMargin > scrollOffset.dy + sheetHeight) {
      _scrollController.scrollToVertical(sheetCoords.bottom - sheetHeight + 1);
    } else if (leftMargin < scrollOffset.dx) {
      _scrollController.scrollToHorizontal(sheetCoords.left - 1);
    } else if (rightMargin > scrollOffset.dx + sheetWidth) {
      _scrollController.scrollToHorizontal(sheetCoords.right - sheetWidth + 1);
    }
  }

  void _updateScrollPosition(SheetScrollController scrollController) {
    _scrollPosition = scrollController.position;
    visibleContent.rebuild(viewportRect, _scrollPosition);
  }

  void _updateSheetProperties(SheetProperties sheetProperties) {
    _scrollController.applyProperties(sheetProperties);

    visibleContent.applyProperties(sheetProperties);
    visibleContent.rebuild(viewportRect, _scrollPosition);
  }
}
