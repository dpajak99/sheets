extension IterableExtensions<E> on Iterable<E> {
  List<E> whereNotNull() {
    return where((element) => element != null).toList();
  }
}