extension IterableExtensions<E> on Iterable<E> {
  List<E> whereNotNull() {
    return where((E element) => element != null).toList();
  }
}