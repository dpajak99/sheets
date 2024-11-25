import 'package:flutter/material.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/directional_values.dart';

class SheetViewport extends ChangeNotifier {
  SheetViewport(SheetDataManager dataManager, SheetScrollController scrollController)
      : _scrollController = scrollController,
        _dataManager = dataManager,
        visibleContent = SheetViewportContentManager(dataManager) {

    _scrollPosition = _scrollController.position;
    _scrollController.applyProperties(dataManager);

    viewportRect = SheetViewportRect(Rect.zero);

    visibleContent.addListener(notifyListeners);

    _dataManager.addListener(() => _updateSheetProperties(_dataManager));
    _scrollController.addListener(() => _updateScrollPosition(_scrollController));
  }

  final SheetViewportContentManager visibleContent;
  final SheetDataManager _dataManager;
  final SheetScrollController _scrollController;
  late DirectionalValues<SheetScrollPosition> _scrollPosition;
  late SheetViewportRect viewportRect;

  @override
  void dispose() {
    visibleContent.removeListener(notifyListeners);
    _dataManager.removeListener(() => _updateSheetProperties(_dataManager));
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
    if (viewportRect.isEquivalent(rect)) {
      return;
    }

    viewportRect = SheetViewportRect(rect);
    visibleContent.rebuild(viewportRect, _scrollPosition);

    _scrollController.setViewportSize(rect.size);
  }

  ViewportItem? ensureIndexFullyVisible(SheetIndex index) {
    Offset scrollOffset = _scrollController.offset;

    Rect cellSheetCoords = index.getSheetCoordinates(_dataManager);

    double sheetWidth = viewportRect.innerRectLocal.width;
    double sheetHeight = viewportRect.innerRectLocal.height;

    double topMargin = cellSheetCoords.top;
    double bottomMargin = cellSheetCoords.bottom;
    double leftMargin = cellSheetCoords.left;
    double rightMargin = cellSheetCoords.right;

    if (topMargin < scrollOffset.dy) {
      double shift = cellSheetCoords.top;
      _scrollController.scrollToVertical(shift);
    } else if (bottomMargin > scrollOffset.dy + sheetHeight) {
      double shift = cellSheetCoords.bottom - sheetHeight;
      _scrollController.scrollToVertical(shift);
    } else if (leftMargin < scrollOffset.dx) {
      double shift = cellSheetCoords.left;
      _scrollController.scrollToHorizontal(shift);
    } else if (rightMargin > scrollOffset.dx + sheetWidth) {
      double shift = cellSheetCoords.right - sheetWidth;
      _scrollController.scrollToHorizontal(shift);
    }

    return visibleContent.findCell(index.toCellIndex());
  }

  void _updateScrollPosition(SheetScrollController scrollController) {
    _scrollPosition = scrollController.position;
    visibleContent.rebuild(viewportRect, _scrollPosition);
  }

  void _updateSheetProperties(SheetDataManager sheetProperties) {
    _scrollController.applyProperties(sheetProperties);
    visibleContent.rebuild(viewportRect, _scrollPosition);
  }
}
