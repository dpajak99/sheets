import 'package:flutter/material.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';

class SheetViewport {
  SheetViewport(Worksheet worksheet)
      : visibleContent = SheetViewportContentManager(worksheet) {
    rect = SheetViewportRect(Rect.zero);
  }

  final SheetViewportContentManager visibleContent;
  late SheetViewportRect rect;

  void rebuild(Offset scrollOffset) {
    visibleContent.rebuild(rect, scrollOffset);
  }

  double get width => rect.width;

  double get height => rect.height;

  Rect get innerRectLocal {
    return rect.innerLocal;
  }

  Rect get outerRectLocal {
    return rect.local;
  }

  ColumnIndex get firstVisibleColumn {
    return visibleContent.columns.first.index;
  }

  RowIndex get firstVisibleRow {
    return visibleContent.rows.first.index;
  }

  Offset globalOffsetToLocal(Offset globalOffset) {
    return rect.globalOffsetToLocal(globalOffset);
  }

  void setViewportRect(Rect rect) {
    if (this.rect.isEquivalent(rect)) {
      return;
    }

    this.rect = SheetViewportRect(rect);
  }
}
