class PinnedHeaderGroups<T> {
  const PinnedHeaderGroups({required this.pinned, required this.normal});

  final List<T> pinned;
  final List<T> normal;
}

PinnedHeaderGroups<T> groupPinnedHeaders<T>(
  Iterable<T> headers,
  int pinnedCount,
  int Function(T) indexGetter,
) {
  final List<T> pinned = <T>[];
  final List<T> normal = <T>[];

  for (final T header in headers) {
    if (indexGetter(header) < pinnedCount) {
      pinned.add(header);
    } else {
      normal.add(header);
    }
  }

  return PinnedHeaderGroups<T>(pinned: pinned, normal: normal);
}
