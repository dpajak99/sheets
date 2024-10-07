import 'package:equatable/equatable.dart';

class SelectionStatus with EquatableMixin {
  final bool _isSelected;
  final bool _isFullySelected;

  SelectionStatus(this._isSelected, this._isFullySelected);

  static SelectionStatus statusFalse = SelectionStatus(false, false);

  static SelectionStatus statusTrue = SelectionStatus(true, false);

  T selectValue<T>({required T notSelected, required T selected, required T fullySelected}) {
    if (_isSelected && _isFullySelected) {
      return fullySelected;
    } else if (_isSelected) {
      return selected;
    } else {
      return notSelected;
    }
  }

  bool get isSelected => _isSelected;

  bool get isFullySelected => _isFullySelected;

  @override
  List<Object?> get props => [_isSelected, _isFullySelected];
}
