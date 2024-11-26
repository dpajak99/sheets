class Int {
  static const int max = 9007199254740992;
}

extension IntExtensions on int {
  int safeClamp(num min, num max) {
    if (this < min) {
      return min.toInt();
    } else if (this > max) {
      return max.toInt();
    } else {
      return this;
    }
  }
}
