import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/cell_value.dart';

class CellProperties with EquatableMixin {
  CellProperties(this.index, this.value);

  CellProperties.empty(this.index) : value = StringCellValue.empty();

  final CellIndex index;
  CellValue value;

  CellProperties copyWith({CellValue? value}) {
    return CellProperties(
      index,
      value ?? this.value,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, value];
}
