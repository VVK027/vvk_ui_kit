import 'dart:math';

/// Utility extensions for [Set] values.
extension SetExtension<E> on Set<E> {
  /// Random element; throws [StateError] when empty.
  E random([int? seed]) {
    if (isEmpty)
      throw StateError('Cannot pick a random element from an empty set.');
    return elementAt(Random(seed).nextInt(length));
  }

  /// Random element, or `null` when empty.
  E? randomOrNull([int? seed]) {
    if (isEmpty) return null;
    return elementAt(Random(seed).nextInt(length));
  }

  /// Filtered copy as a new [Set].
  Set<E> whereSet(bool Function(E element) predicate) {
    return where(predicate).toSet();
  }

  /// Mapped copy as a new [Set].
  Set<T> mapSet<T>(T Function(E element) mapper) {
    return map(mapper).toSet();
  }

  /// `true` when every element satisfies [predicate].
  bool all(bool Function(E element) predicate) {
    for (final element in this) {
      if (!predicate(element)) return false;
    }
    return true;
  }

  /// `true` when no element satisfies [predicate].
  bool none(bool Function(E element) predicate) => !any(predicate);

  /// Copy with [element] added when non-null.
  Set<E> addIfNotNull(E? element) {
    if (element == null) return this;
    return {...this, element};
  }

  /// Copy with all non-null [elements] added.
  Set<E> addAllIfNotNull(Iterable<E?> elements) {
    return {...this, ...elements.whereType<E>()};
  }

  /// First element matching [predicate], or `null`.
  E? firstWhereOrNull(bool Function(E element) predicate) {
    for (final element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }

  /// Subset of elements from [start] up to optional [end] (list order).
  Set<E> slice(int start, [int? end]) {
    final list = toList();
    return Set.from(list.sublist(start, end ?? list.length));
  }

  /// `true` when this set contains any value from [other].
  bool containsAny(Iterable<E> other) => other.any(contains);

  /// Groups elements by [key] into sets.
  Map<K, Set<E>> groupBy<K>(K Function(E element) key) {
    final result = <K, Set<E>>{};
    for (final element in this) {
      (result[key(element)] ??= {}).add(element);
    }
    return result;
  }

  /// Keeps the first element for each distinct [key].
  Set<E> distinctBy<K>(K Function(E element) key) {
    final result = <E>{};
    final keys = <K>{};
    for (final element in this) {
      if (keys.add(key(element))) result.add(element);
    }
    return result;
  }

  /// Splits into chunks of at most [size] elements.
  Iterable<Set<E>> chunked(int size) sync* {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be > 0');
    }
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final chunk = <E>{iterator.current};
      while (chunk.length < size && iterator.moveNext()) {
        chunk.add(iterator.current);
      }
      yield chunk;
    }
  }

  /// Sorted copy using optional [compare].
  Set<E> sorted([int Function(E a, E b)? compare]) {
    final list = toList()..sort(compare);
    return Set.from(list);
  }

  /// Sorted copy by [key].
  Set<E> sortedBy<K extends Comparable<K>>(K Function(E element) key) {
    return sorted((a, b) => key(a).compareTo(key(b)));
  }

  /// Sorted copy by [key] in descending order.
  Set<E> sortedByDescending<K extends Comparable<K>>(
    K Function(E element) key,
  ) {
    return sorted((a, b) => key(b).compareTo(key(a)));
  }
}
