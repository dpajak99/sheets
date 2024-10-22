class CachedValue<T> {
  CachedValue(this.getter);

  T? _value;
  T Function() getter;

  T get value {
    _value ??= getter();
    return _value as T;
  }
}
