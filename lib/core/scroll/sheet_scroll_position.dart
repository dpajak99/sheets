import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SheetScrollPosition extends ChangeNotifier with EquatableMixin {
  SheetScrollPosition();

  SheetScrollPosition.zero();

  double _offset = 0;

  double get offset => _offset;

  set offset(double offset) {
    if (_offset == offset) {
      return;
    }
    _offset = offset;
    notifyListeners();
  }

  @override
  List<Object?> get props => <Object?>[_offset];
}
