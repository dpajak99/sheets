mixin NumericIndexMixin {
  int get value;

  bool operator <(NumericIndexMixin other) {
    return value < other.value;
  }

  bool operator <=(NumericIndexMixin other) {
    return value <= other.value;
  }

  bool operator >(NumericIndexMixin other) {
    return value > other.value;
  }

  bool operator >=(NumericIndexMixin other) {
    return value >= other.value;
  }

  int compareTo(NumericIndexMixin other) {
    return value.compareTo(other.value);
  }
}
