import 'package:equatable/equatable.dart';

class TextRotation with EquatableMixin {
  const TextRotation._(this._angle);

  TextRotation.custom(double angle) : _angle = angle % 90;

  static const TextRotation none = TextRotation._(0);
  static const TextRotation angleDown = TextRotation._(45);
  static const TextRotation angleUp = TextRotation._(-45);
  static const TextRotation down = TextRotation._(90);
  static const TextRotation up = TextRotation._(-90);
  static const TextRotation vertical = TextRotation._(10000);

  final double _angle;

  double get angle {
    if(_angle >= -90 && _angle <= 90) {
      return _angle;
    } else {
      return 0;
    }
  }

  @override
  List<Object?> get props => <Object?>[_angle];
}
