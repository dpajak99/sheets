import 'package:equatable/equatable.dart';

class ColumnStyle with EquatableMixin {
  final double width;

  ColumnStyle({
    required this.width,
  });

  ColumnStyle.defaults() : width = 100;

  @override
  List<Object?> get props => [width];
}

class RowStyle with EquatableMixin {
  final double height;

  RowStyle({
    required this.height,
  });

  RowStyle.defaults() : height = 22;

  @override
  List<Object?> get props => [height];
}

