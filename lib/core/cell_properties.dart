import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class IndexedCellProperties with EquatableMixin {
  const IndexedCellProperties({
    required this.index,
    required this.properties,
  });

  final CellIndex index;
  final CellProperties properties;

  IndexedCellProperties copyWith({CellIndex? index, CellProperties? properties}) {
    return IndexedCellProperties(
      index: index ?? this.index,
      properties: properties ?? this.properties,
    );
  }

  CellIndex get startIndex {
    CellMergeStatus mergeStatus = properties.mergeStatus;
    if (mergeStatus is MergedCell) {
      return mergeStatus.start;
    }
    return index;
  }

  CellIndex get endIndex {
    CellMergeStatus mergeStatus = properties.mergeStatus;
    if (mergeStatus is MergedCell) {
      return mergeStatus.end;
    }
    return index;
  }

  @override
  List<Object?> get props => <Object?>[index, properties];
}

class CellProperties with EquatableMixin {
  CellProperties({
    CellStyle? style,
    SheetRichText? value,
    CellMergeStatus? mergeStatus,
  }) {
    this.style = style ?? CellStyle();
    this.value = value ?? SheetRichText();
    this.mergeStatus = mergeStatus ?? NoCellMerge();
  }

  late final CellStyle style;
  late final SheetRichText value;
  late final CellMergeStatus mergeStatus;

  CellProperties copyWith({SheetRichText? value, CellStyle? style, CellMergeStatus? mergeStatus}) {
    return CellProperties(
      style: style ?? this.style,
      value: value ?? this.value,
      mergeStatus: mergeStatus ?? this.mergeStatus,
    );
  }

  SheetRichText get visibleRichText {
    return visibleValueFormat.formatVisible(value) ?? value;
  }

  SheetRichText get editableRichText {
    return visibleValueFormat.formatEditable(value);
  }

  SheetValueFormat get visibleValueFormat {
    return style.valueFormat ?? SheetValueFormat.auto(value);
  }

  TextAlign get visibleTextAlign {
    return style.horizontalAlign ?? visibleValueFormat.textAlign;
  }

  @override
  List<Object?> get props => <Object?>[style, mergeStatus, value];
}

abstract class CellMergeStatus with EquatableMixin {
  CellMergeStatus move({required int dx, required int dy});

  int get width => 0;

  int get height => 0;

  List<CellIndex> get mergedCells => <CellIndex>[];

  bool contains(CellIndex index) {
    return false;
  }
}

class NoCellMerge extends CellMergeStatus {
  @override
  NoCellMerge move({required int dx, required int dy}) {
    return this;
  }

  @override
  List<Object?> get props => <Object>[];
}

class MergedCell extends CellMergeStatus {
  MergedCell({
    required this.start,
    required this.end,
  });

  final CellIndex start;
  final CellIndex end;

  MergedCellIndex get index => MergedCellIndex(start: start, end: end);

  @override
  int get width {
    return end.column.value - start.column.value;
  }

  String get id => '${width + 1}x${height + 1}';

  @override
  int get height => end.row.value - start.row.value;

  bool isMainCell(CellIndex index) {
    return index == start;
  }

  @override
  bool contains(CellIndex index) {
    if (index is MergedCellIndex) {
      return index.selectedCells.any(contains);
    }
    return index.row.value >= start.row.value &&
        index.row.value <= end.row.value &&
        index.column.value >= start.column.value &&
        index.column.value <= end.column.value;
  }

  @override
  List<CellIndex> get mergedCells {
    List<CellIndex> mergedCells = <CellIndex>[];
    for (int i = start.row.value; i <= end.row.value; i++) {
      for (int j = start.column.value; j <= end.column.value; j++) {
        mergedCells.add(CellIndex(row: RowIndex(i), column: ColumnIndex(j)));
      }
    }
    return mergedCells;
  }

  @override
  MergedCell move({required int dx, required int dy}) {
    return MergedCell(
      start: start.move(dx: dx, dy: dy),
      end: end.move(dx: dx, dy: dy),
    );
  }

  MergedCell moveVertical({required int dy, bool reverse = false}) {
    int updatedDy = reverse ? dy - height : dy;
    return MergedCell(
      start: start.move(dx: 0, dy: updatedDy),
      end: end.move(dx: 0, dy: updatedDy),
    );
  }

  MergedCell moveHorizontal({required int dx, bool reverse = false}) {
    int updatedDx = reverse ? dx - width : dx;
    return MergedCell(
      start: start.move(dx: updatedDx, dy: 0),
      end: end.move(dx: updatedDx, dy: 0),
    );
  }

  @override
  List<Object?> get props => <Object?>[start, end];
}
