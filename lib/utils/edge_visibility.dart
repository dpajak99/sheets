import 'package:equatable/equatable.dart';

class EdgeVisibility with EquatableMixin {
  EdgeVisibility({
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.left = true,
  });

  const EdgeVisibility.allVisible()
      : top = true,
        right = true,
        bottom = true,
        left = true;

  final bool top;
  final bool right;
  final bool bottom;
  final bool left;

  @override
  List<Object?> get props => <Object?>[top, right, bottom, left];
}
