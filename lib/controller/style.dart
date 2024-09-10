import 'package:equatable/equatable.dart';

class ColumnStyle with EquatableMixin {
  final double width;

  ColumnStyle({
    required this.width,
  });

  ColumnStyle.defaults() : width = 100;

  ColumnStyle copyWith({
    double? width,
  }) {
    return ColumnStyle(
      width: width ?? this.width,
    );
  }

  @override
  List<Object?> get props => [width];
}

class RowStyle with EquatableMixin {
  final double height;

  RowStyle({
    required this.height,
  });

  RowStyle.defaults() : height = 22;

  RowStyle copyWith({
    double? height,
  }) {
    return RowStyle(
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => [height];
}

