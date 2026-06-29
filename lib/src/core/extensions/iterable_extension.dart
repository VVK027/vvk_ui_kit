import 'dart:collection';
import 'dart:math' as math;

/// Removes `null` entries from nullable iterables.
extension IterableNullFiltering<T> on Iterable<T?> {
  /// Non-null elements only.
  Iterable<T> filterNull() => whereType<T>();
}

/// Groups elements into a map keyed by a selector function.
extension IterableGrouping<T> on Iterable<T> {
  /// Groups elements by [keyFunction].
  ///
  /// Pass [sortingCriteria] to return a sorted [SplayTreeMap].
  Map<K, List<T>> groupBy<K>(
    K Function(T) keyFunction, {
    IterableGroupingCriteria<K>? sortingCriteria,
  }) {
    final map = sortingCriteria != null
        ? SplayTreeMap<K, List<T>>(sortingCriteria)
        : <K, List<T>>{};
    for (final element in this) {
      map.putIfAbsent(keyFunction(element), () => <T>[]).add(element);
    }
    return map;
  }
}

/// Sorting comparator for [IterableGrouping.groupBy].
typedef IterableGroupingCriteria<K> = int Function(K, K);

/// Numeric aggregation helpers for iterables of numbers.
extension IterableNum<N extends num> on Iterable<N> {
  /// Minimum value, or [ifEmpty] when the iterable is empty.
  N min({required N ifEmpty}) => isEmpty ? ifEmpty : reduce(math.min);

  /// Maximum value, or [ifEmpty] when the iterable is empty.
  N max({required N ifEmpty}) => isEmpty ? ifEmpty : reduce(math.max);

  /// Sum of all values, or [ifEmpty] when the iterable is empty.
  N sum({required N ifEmpty}) {
    if (isEmpty) return ifEmpty;
    var total = ifEmpty;
    for (final value in this) {
      total = (total + value) as N;
    }
    return total;
  }

  /// Sequential subtraction of all values, or [ifEmpty] when empty.
  N subtract({required N ifEmpty}) {
    if (isEmpty) return ifEmpty;
    final iterator = this.iterator;
    iterator.moveNext();
    var result = iterator.current;
    while (iterator.moveNext()) {
      result = (result - iterator.current) as N;
    }
    return result;
  }
}
