import 'package:equatable/equatable.dart';
import 'package:sheets/sheet_constants.dart';

class ColumnStyle with EquatableMixin {
  final double width;

  ColumnStyle({
    required this.width,
  });

  ColumnStyle.defaults() : width = defaultColumnWidth;

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

  RowStyle.defaults() : height = defaultRowHeight;

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

