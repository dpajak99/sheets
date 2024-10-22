extension IterableExtensions<E> on Iterable<E> {
  List<T> whereNotNull<T>() {
    return where((E element) => element != null).toList().cast();
  }
}