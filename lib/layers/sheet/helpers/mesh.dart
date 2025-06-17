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

  final Map<double, List<StyledLine>> customVertical =
      <double, List<StyledLine>>{};
  final Map<double, List<StyledLine>> customHorizontal =
      <double, List<StyledLine>>{};

  void addVertical(double x, MeshLine line, BorderSide style) {
    customVertical
        .putIfAbsent(x, () => <StyledLine>[])
        .add(StyledLine(line, style));
  }

  void addHorizontal(double y, MeshLine line, BorderSide style) {
    customHorizontal
        .putIfAbsent(y, () => <StyledLine>[])
        .add(StyledLine(line, style));
  }

  Map<BorderSide, List<MeshLine>> get lines {
    Map<BorderSide, List<MeshLine>> result = <BorderSide, List<MeshLine>>{};
    for (MapEntry<double, List<StyledLine>> entry in customVertical.entries) {
      for (StyledLine styledLine in entry.value) {
        result
            .putIfAbsent(styledLine.style, () => <MeshLine>[])
            .add(styledLine.line);
      }
    }
    for (MapEntry<double, List<StyledLine>> entry in customHorizontal.entries) {
      for (StyledLine styledLine in entry.value) {
        result
            .putIfAbsent(styledLine.style, () => <MeshLine>[])
            .add(styledLine.line);
      }
    }
    return result;
  }
}

class StyledLine {
  StyledLine(this.line, this.style);

  final MeshLine line;
  final BorderSide style;
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
