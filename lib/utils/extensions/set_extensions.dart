import 'dart:collection';

extension SetExtensions<T extends Object> on Set<T> {
  /// Groups the list elements by a key returned by the provided [keySelector] function.
  Map<K, List<T>> groupListsBy<K extends Comparable<K>>(K Function(T) keySelector) {
    Map<K, List<T>> groupedMap = <K, List<T>>{};

    for (T element in this) {
      K key = keySelector(element);
      groupedMap.putIfAbsent(key, () => <T>[]).add(element);
    }

    SplayTreeMap<K, List<T>> sortedMap = SplayTreeMap<K, List<T>>.from(groupedMap, (K a, K b) => a.compareTo(b));
    return Map<K, List<T>>.from(sortedMap);
  }
}
