import 'package:flutter/material.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';

/// [ViewportOffsetTransformer] is responsible for transforming a global offset
/// (from the entire application) into a local offset relative to the visible grid
/// within the viewport.
///
/// This class also limits the local offset to ensure it stays within the
/// boundaries of the visible grid.
class ViewportOffsetTransformer {
  /// The rectangle representing the entire sheet area.
  final Rect sheetRect;

  /// The rectangle representing the visible area of the grid within the viewport.
  final Rect visibleGridRect;

  /// Creates a [ViewportOffsetTransformer] that converts global offsets to
  /// local ones, using the provided [sheetRect] and [visibleGridRect].
  ViewportOffsetTransformer(this.sheetRect, this.visibleGridRect);

  /// Transforms the given [globalOffset], which is relative to the entire sheet,
  /// into a local offset relative to the visible grid.
  ///
  /// The resulting local offset is limited to the bounds of the [visibleGridRect].
  Offset globalToLocal(Offset globalOffset) {
    Offset localOffset = globalOffset - Offset(sheetRect.left, sheetRect.top);
    return localOffset.limit(
      Offset(0, visibleGridRect.right),
      Offset(0, visibleGridRect.bottom),
    );
  }
}
