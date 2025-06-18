import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Mesh {
  Mesh({
    required this.verticalPoints,
    required this.horizontalPoints,
    this.maxVertical = 0,
    this.maxHorizontal = 0,
  });

  final List<double> verticalPoints;
  final List<double> horizontalPoints;
  final double maxVertical;
  final double maxHorizontal;

  final Map<double, Set<StyledLine>> customVertical =
      <double, Set<StyledLine>>{};
  final Map<double, Set<StyledLine>> customHorizontal =
      <double, Set<StyledLine>>{};

  bool hasVertical(double x, MeshLine line) {
    return customVertical[x]?.any((StyledLine s) => s.line == line) ?? false;
  }

  bool hasHorizontal(double y, MeshLine line) {
    return customHorizontal[y]?.any((StyledLine s) => s.line == line) ?? false;
  }

  void addVertical(double x, MeshLine line, BorderSide style) {
    customVertical
        .putIfAbsent(x, () => <StyledLine>{})
        .add(StyledLine(line, style));
  }

  void addHorizontal(double y, MeshLine line, BorderSide style) {
    customHorizontal
        .putIfAbsent(y, () => <StyledLine>{})
        .add(StyledLine(line, style));
  }

  Map<BorderSide, List<MeshLine>> get lines {
    final Map<BorderSide, Set<MeshLine>> result =
        <BorderSide, Set<MeshLine>>{};
    for (final MapEntry<double, Set<StyledLine>> entry in customVertical.entries) {
      for (final StyledLine styledLine in entry.value) {
        result
            .putIfAbsent(styledLine.style, () => <MeshLine>{})
            .add(styledLine.line);
      }
    }
    for (final MapEntry<double, Set<StyledLine>> entry in
        customHorizontal.entries) {
      for (final StyledLine styledLine in entry.value) {
        result
            .putIfAbsent(styledLine.style, () => <MeshLine>{})
            .add(styledLine.line);
      }
    }
    return result.map((BorderSide key, Set<MeshLine> value) =>
        MapEntry<BorderSide, List<MeshLine>>(key, value.toList()));
  }
}

class StyledLine with EquatableMixin {
  StyledLine(this.line, this.style);

  final MeshLine line;
  final BorderSide style;

  @override
  List<Object?> get props => <Object?>[line, style];
}

class MeshLine with EquatableMixin {
  MeshLine(this.start, this.end);

  final Offset start;
  final Offset end;

  @override
  List<Object?> get props => <Object?>[start, end];

  @override
  String toString() => 'Line{start: $start, end: $end}';
}
