import 'package:sheets/core/sheet_index.dart';

class FirstVisible<T extends SheetIndex> {
  FirstVisible(this.index, this.hiddenSize);

  final T index;
  final double hiddenSize;
}
