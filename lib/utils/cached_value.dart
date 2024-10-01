class CachedValue<T> {
  T? _value;
  T Function() getter;

  CachedValue(this.getter);

  T get value {
    _value ??= getter();
    return _value as T;
  }
}
