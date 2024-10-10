import 'dart:collection';

extension SetExtensions<T extends Object> on Set<T> {
  /// Groups the list elements by a key returned by the provided [keySelector] function.
  Map<K, List<T>> groupListsBy<K extends Comparable>(K Function(T) keySelector) {
    Map<K, List<T>> groupedMap = {};

    for (var element in this) {
      final key = keySelector(element);
      groupedMap.putIfAbsent(key, () => []).add(element);
    }

    SplayTreeMap sortedMap = SplayTreeMap<K, List<T>>.from(groupedMap, (K a, K b) => a.compareTo(b));
    return Map.from(sortedMap);
  }
}
