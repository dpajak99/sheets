extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> merge(Map<K, V> other) {
    return <K, V>{...this, ...other};
  }
}
