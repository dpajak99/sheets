import 'package:equatable/equatable.dart';

class IntOffset with EquatableMixin {
  final int dx;
  final int dy;

  const IntOffset(this.dx, this.dy);

  static const IntOffset zero = IntOffset(0, 0);

  @override
  List<Object?> get props => [dx, dy];
}