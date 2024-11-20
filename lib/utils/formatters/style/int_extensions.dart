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