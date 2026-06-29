/// Null-safe helpers for nullable and non-nullable [List] values.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Extensions for nullable [List] values.
extension ListExtension<T> on List<T>? {
  /// `true` when the list is `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// `true` when the list is non-null and not empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Alias for [isNotNullOrEmpty].
  bool get isNotNullAndNotEmpty => isNotNullOrEmpty;

  /// Returns this list, or an empty list when `null`.
  List<T> validate() => this ?? <T>[];

  /// First element, or `null` when empty/null.
  T? get firstOrNull => isNullOrEmpty ? null : this!.first;

  /// Last element, or `null` when empty/null.
  T? get lastOrNull => isNullOrEmpty ? null : this!.last;

  /// First element matching [test], or `null`.
  T? firstWhereOrNull(bool Function(T element) test) {
    if (isNullOrEmpty) return null;
    for (final element in this!) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Last element matching [test], or `null`.
  T? lastWhereOrNull(bool Function(T element) test) {
    if (isNullOrEmpty) return null;
    for (var i = this!.length - 1; i >= 0; i--) {
      final element = this![i];
      if (test(element)) return element;
    }
    return null;
  }

  /// Repeats the full list [times] times (e.g. `[1,2]` × 2 → `[1,2,1,2]`).
  List<T> repeat(int times) {
    if (isNullOrEmpty || times <= 0) return <T>[];
    final source = this!;
    return List<T>.generate(
      source.length * times,
      (index) => source[index % source.length],
    );
  }

  /// Copy without the first element.
  List<T> removeFirstElement() {
    if (isNullOrEmpty) return [];
    return List<T>.from(this!..removeAt(0));
  }

  /// Copy without the last element.
  List<T> removeLastElement() {
    if (isNullOrEmpty) return [];
    final copy = List<T>.from(this!);
    copy.removeLast();
    return copy;
  }

  /// Count of elements matching [predicate].
  int countWhere(bool Function(T element) predicate) {
    if (isNullOrEmpty) return 0;
    var count = 0;
    for (final element in this!) {
      if (predicate(element)) count++;
    }
    return count;
  }

  /// First [n] elements, or the full list when shorter.
  List<T> take(int n) {
    if (this == null || n <= 0) return [];
    return this!.take(n).toList();
  }

  /// Element at [index], or `null` when out of bounds.
  T? elementAtOrNull(int index) {
    if (isNullOrEmpty || index < 0 || index >= this!.length) return null;
    return this![index];
  }

  /// Alias for [elementAtOrNull].
  T? tryGet(int index) => elementAtOrNull(index);

  /// Elements matching [fun], or an empty list when null/empty.
  List<T> filterOrNewList(bool Function(T e) fun) {
    if (isNullOrEmpty) return [];
    final result = <T>[];
    for (final element in this!) {
      if (fun(element)) result.add(element);
    }
    return result;
  }

  /// Elements not matching [fun], or an empty list when null/empty.
  List<T> filterNot(bool Function(T element) fun) {
    if (isNullOrEmpty) return [];
    final result = <T>[];
    for (final element in this!) {
      if (!fun(element)) result.add(element);
    }
    return result;
  }

  /// Maps each element to a [Widget].
  List<Widget> toWidgetList(Widget Function(T value) mapFunc) =>
      isNullOrEmpty ? [] : this!.map(mapFunc).toList();

  /// Last valid index, or `null` when empty.
  int? get lastIndex => isNullOrEmpty ? null : this!.length - 1;

  /// Removes all occurrences of [item] in place.
  void removeAll(T item) {
    if (isNullOrEmpty) return;
    this!.removeWhere((element) => element == item);
  }

  /// Invokes [f] for each element with its index.
  void forEachIndexed(void Function(int index, T element) f) {
    if (isNullOrEmpty) return;
    for (var i = 0; i < this!.length; i++) {
      f(i, this![i]);
    }
  }

  /// Random element, or `null` when empty.
  T? random({int? seed}) {
    if (isNullOrEmpty) return null;
    return this![math.Random(seed).nextInt(this!.length)];
  }

  /// Inserts [separator] between elements.
  ///
  /// Use [start] / [end] to also place a separator at the beginning or end.
  List<T> separatorEvery(T separator, {bool start = false, bool end = false}) {
    if (isNullOrEmpty) return [];
    final items = this!;
    final result = <T>[];
    if (start) result.add(separator);
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      final isLast = i == items.length - 1;
      if (!isLast || end) result.add(separator);
    }
    return result;
  }

  /// Splits into sublists whenever [condition] is `true` (separator rows).
  List<List<T>> divideListByFunction(bool Function(T) condition) {
    if (isNullOrEmpty) return [];
    final nestedLists = <List<T>>[];
    var currentSublist = <T>[];

    for (final element in this!) {
      if (condition(element)) {
        if (currentSublist.isNotEmpty) {
          nestedLists.add(List<T>.from(currentSublist));
          currentSublist = [];
        }
      } else {
        currentSublist.add(element);
      }
    }

    if (currentSublist.isNotEmpty) {
      nestedLists.add(currentSublist);
    }
    return nestedLists;
  }

  /// Splits into fixed-size chunks of [rangeSize].
  List<List<T>>? divideListByRange(int rangeSize) {
    if (this == null) return null;
    if (rangeSize <= 0) {
      throw ArgumentError.value(rangeSize, 'rangeSize', 'must be > 0');
    }

    final nestedLists = <List<T>>[];
    for (var i = 0; i < this!.length; i += rangeSize) {
      final end = math.min(i + rangeSize, this!.length);
      nestedLists.add(this!.sublist(i, end));
    }
    return nestedLists;
  }
}

/// Helpers for lists that may contain nullable elements.
extension ListNullableElementExtension<T> on List<T?>? {
  /// Maps non-null elements, skipping `null` entries.
  List<R> mapNonNull<R>(R Function(T element) f) {
    if (this == null) return <R>[];
    final result = <R>[];
    for (final element in this!) {
      if (element != null) result.add(f(element));
    }
    return result;
  }
}

/// [lastWhereOrNull] for non-nullable lists.
extension ListLastWhereExtension<T> on List<T> {
  /// Last element satisfying [test], or `null`.
  T? lastWhereOrNull(bool Function(T element) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }
}

/// Aggregation helpers for nullable lists of numbers.
extension ListNumExtension on List<num>? {
  /// `true` when the list is `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// `true` when the list is non-null and not empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Sum of all elements, or `0` when null/empty.
  num get total {
    if (isNullOrEmpty) return 0;
    var sum = 0.0;
    for (final element in this!) {
      sum += element;
    }
    return sum;
  }
}
