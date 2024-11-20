extension DoubleExtensions on double {
  double safeClamp(num min, num max) {
    if (this < min) {
      return min.toDouble();
    } else if (this > max) {
      return max.toDouble();
    } else {
      return this;
    }
  }
}