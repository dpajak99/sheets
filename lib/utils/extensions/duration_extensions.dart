extension DurationExtensions on Duration {
  Duration difference(Duration other) {
    return Duration(microseconds: inMicroseconds - other.inMicroseconds);
  }

  Duration add(Duration other) {
    return Duration(microseconds: inMicroseconds + other.inMicroseconds);
  }
}
