extension IterableExtensions<E> on Iterable<E> {
  List<T> whereNotNull<T>() {
    return where((E element) => element != null).toList().cast();
  }

  List<T> withDivider<T>(T divider) {
    if(isEmpty) {
      return <T>[];
    }
    return expand((E element) sync* {
      yield element;
      yield divider;
    }).take(length * 2 - 1).toList().cast();
  }
}
