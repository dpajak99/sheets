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

T min<T extends NumericIndexMixin>(T a, T b) {
  return a.value < b.value ? a : b;
}

T max<T extends NumericIndexMixin>(T a, T b) {
  return a.value > b.value ? a : b;
}
