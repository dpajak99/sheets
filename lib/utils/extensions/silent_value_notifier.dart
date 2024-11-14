import 'package:flutter/foundation.dart';

class SilentValueNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  SilentValueNotifier(this._value) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  T _value;

  void setValue(T newValue, {bool notify = true}) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    if (notify) {
      notifyListeners();
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
