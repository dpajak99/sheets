class DirectionalValues<T extends Object> {
  DirectionalValues({
    required T vertical,
    required T horizontal,
  }) : _vertical = vertical,
        _horizontal = horizontal;

  final T _vertical;
  final T _horizontal;

  T get vertical => _vertical;

  T get horizontal => _horizontal;
}
