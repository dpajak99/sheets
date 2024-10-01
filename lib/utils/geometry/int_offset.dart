import 'package:equatable/equatable.dart';

class IntOffset with EquatableMixin {
  final int dx;
  final int dy;

  const IntOffset(this.dx, this.dy);

  static const IntOffset zero = IntOffset(0, 0);

  IntOffset operator +(IntOffset other) {
    return IntOffset(dx + other.dx, dy + other.dy);
  }

  @override
  List<Object?> get props => [dx, dy];
}