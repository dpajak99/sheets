import 'package:equatable/equatable.dart';
import 'package:sheets/utils/numeric_index_mixin.dart';

class Range<A extends NumericIndexMixin> with EquatableMixin {
  final A start;
  final A end;

  Range._(this.start, this.end);

  Range.equal(A value)
      : start = value,
        end = value;

  factory Range(A value1, A value2) {
    if (value1 < value2) {
      return Range._(value1, value2);
    } else {
      return Range._(value2, value1);
    }
  }

  bool contains(A value) {
    return value >= start && value <= end;
  }

  bool containsRange(Range<A> range) {
    return range.start >= start && range.end <= end;
  }

  @override
  List<Object?> get props => [start, end];
}