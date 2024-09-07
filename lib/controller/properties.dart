import 'package:equatable/equatable.dart';

class ColumnProperties with EquatableMixin {
  final double width;

  ColumnProperties({
    required this.width,
  });

  ColumnProperties.defaults() : width = 100;

  @override
  List<Object?> get props => [width];
}

class RowProperties with EquatableMixin {
  final double height;

  RowProperties({
    required this.height,
  });

  RowProperties.defaults() : height = 22;

  @override
  List<Object?> get props => [height];
}

