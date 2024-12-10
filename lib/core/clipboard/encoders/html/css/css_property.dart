import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CssValue<T> with EquatableMixin {
  T toDart();

  @override
  List<Object?> get props => <Object?>[toDart()];
}

@optionalTypeArgs
abstract class CssProperty<V, T extends CssValue<V>> with EquatableMixin {
  CssProperty(this.value);

  final T value;

  Map<String, String> toCssMap();

  V toDart() => value.toDart();

  @override
  List<Object?> get props => <Object?>[value];
}
