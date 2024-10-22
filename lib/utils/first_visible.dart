import 'package:sheets/core/sheet_index.dart';

class FirstVisible<T extends SheetIndex> {
  final T index;
  final double hiddenSize;

  FirstVisible(this.index, this.hiddenSize);
}
