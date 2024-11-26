import 'package:flutter/material.dart';

class DirectionalValues<A extends Object> extends ChangeNotifier {
  DirectionalValues(this._vertical, this._horizontal) {
    if (_vertical is Listenable) {
      (_vertical as Listenable).addListener(notifyListeners);
      (_horizontal as Listenable).addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    if (_vertical is Listenable) {
      (_vertical as Listenable).removeListener(notifyListeners);
      (_horizontal as Listenable).removeListener(notifyListeners);
    }
    super.dispose();
  }

  A _vertical;

  A get vertical => _vertical;

  set vertical(A vertical) {
    if (_vertical == vertical) {
      return;
    }
    _vertical = vertical;
    notifyListeners();
  }

  A _horizontal;

  A get horizontal {
    return _horizontal;
  }

  set horizontal(A horizontal) {
    if (_horizontal == horizontal) {
      return;
    }
    _horizontal = horizontal;

    notifyListeners();
  }

  void update({required A horizontal, required A vertical}) {
    if (_horizontal == horizontal && _vertical == vertical) {
      return;
    }
    _horizontal = horizontal;
    _vertical = vertical;
    notifyListeners();
  }
}
