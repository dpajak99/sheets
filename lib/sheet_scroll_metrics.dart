import 'package:equatable/equatable.dart';

enum SheetAxisDirection { vertical, horizontal }

class SheetScrollMetrics with EquatableMixin {
  SheetScrollMetrics({
    required SheetAxisDirection axisDirection,
    required double contentSize,
    required double viewportDimension,
  })  : _axisDirection = axisDirection,
        _contentSize = contentSize,
        _viewportDimension = viewportDimension;

  SheetScrollMetrics.zero(SheetAxisDirection axisDirection)
      : this(
          axisDirection: axisDirection,
          contentSize: 0,
          viewportDimension: 0,
        );

  SheetScrollMetrics copyWith({
    double? contentSize,
    double? viewportDimension,
  }) {
    return SheetScrollMetrics(
      axisDirection: _axisDirection,
      contentSize: contentSize ?? _contentSize,
      viewportDimension: viewportDimension ?? _viewportDimension,
    );
  }

  SheetAxisDirection get axisDirection => _axisDirection;
  final SheetAxisDirection _axisDirection;

  double get maxScrollExtent => _contentSize - _viewportDimension;

  double get minScrollExtent => 0;

  double get contentSize => _contentSize;
  final double _contentSize;

  double get viewportDimension => _viewportDimension;
  final double _viewportDimension;

  @override
  List<Object?> get props => [_axisDirection, _viewportDimension, _contentSize];
}
