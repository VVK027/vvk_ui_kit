import 'dart:async';

import 'package:flutter/material.dart';

/// Returns the next rebuild time for [UITimerBuilder].
typedef UITimerGenerator = DateTime? Function(DateTime now);

/// Rebuilds its child on a periodic or scheduled timer.
class UITimerBuilder extends StatefulWidget {
  const UITimerBuilder({
    super.key,
    required this.generator,
    required this.builder,
  });

  UITimerBuilder.periodic(
    Duration interval, {
    super.key,
    Duration? alignment,
    required this.builder,
  }) : generator = uiPeriodicTimer(
         interval,
         alignment: alignment ?? uiGetAlignmentUnit(interval),
       );

  UITimerBuilder.scheduled(
    Iterable<DateTime> schedule, {
    super.key,
    required this.builder,
  }) : generator = uiScheduledTimer(schedule);

  final UITimerGenerator generator;
  final WidgetBuilder builder;

  @override
  State<UITimerBuilder> createState() => _UITimerBuilderState();
}

class _UITimerBuilderState extends State<UITimerBuilder> {
  late Stream<DateTime> _stream;
  late Completer<void> _stopCompleter;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(UITimerBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cancel();
    _init();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  void _init() {
    _stopCompleter = Completer<void>();
    _stream = createUITimerStream(widget.generator, _stopCompleter.future);
  }

  void _cancel() {
    if (!_stopCompleter.isCompleted) {
      _stopCompleter.complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _stream,
      builder: (context, snapshot) => widget.builder(context),
    );
  }
}

UITimerGenerator uiPeriodicTimer(
  Duration interval, {
  Duration alignment = Duration.zero,
}) {
  assert(interval > Duration.zero);
  DateTime? next;
  return (DateTime now) {
    next = uiAlignDateTime((next ?? now).add(interval), alignment);
    if (now.compareTo(next!) < 0) {
      next = uiAlignDateTime(now.add(interval), alignment);
    }
    return next!;
  };
}

UITimerGenerator uiScheduledTimer(Iterable<DateTime> schedule) {
  final sorted = schedule.toList()..sort();
  return uiFromDateTimeIterable(sorted);
}

UITimerGenerator uiFromDateTimeIterable(Iterable<DateTime> iterable) {
  final iterator = iterable.iterator;
  return (DateTime now) => iterator.moveNext() ? iterator.current : null;
}

Stream<DateTime> createUITimerStream(
  UITimerGenerator generator,
  Future<void> stopSignal,
) async* {
  for (
    var now = DateTime.now(), next = generator(now);
    next != null;
    now = DateTime.now(), next = generator(now)
  ) {
    if (now.isAfter(next)) continue;
    final waitTime = next.difference(now);
    try {
      await stopSignal.timeout(waitTime);
      return;
    } on TimeoutException {
      yield next;
    }
  }
}

Duration uiGetAlignmentUnit(Duration interval) {
  return Duration(
    days: interval.inDays > 0 ? 1 : 0,
    hours: interval.inDays == 0 && interval.inHours > 0 ? 1 : 0,
    minutes: interval.inHours == 0 && interval.inMinutes > 0 ? 1 : 0,
    seconds: interval.inMinutes == 0 && interval.inSeconds > 0 ? 1 : 0,
    milliseconds: interval.inSeconds == 0 && interval.inMilliseconds > 0
        ? 1
        : 0,
    microseconds: interval.inMilliseconds == 0 && interval.inMicroseconds > 0
        ? 1
        : 0,
  );
}

DateTime uiAlignDateTime(
  DateTime dateTime,
  Duration alignment, [
  bool roundUp = false,
]) {
  assert(alignment >= Duration.zero);
  if (alignment == Duration.zero) return dateTime;

  final correction = Duration(
    hours: alignment.inDays > 0
        ? dateTime.hour
        : alignment.inHours > 0
        ? dateTime.hour % alignment.inHours
        : 0,
    minutes: alignment.inHours > 0
        ? dateTime.minute
        : alignment.inMinutes > 0
        ? dateTime.minute % alignment.inMinutes
        : 0,
    seconds: alignment.inMinutes > 0
        ? dateTime.second
        : alignment.inSeconds > 0
        ? dateTime.second % alignment.inSeconds
        : 0,
    milliseconds: alignment.inSeconds > 0
        ? dateTime.millisecond
        : alignment.inMilliseconds > 0
        ? dateTime.millisecond % alignment.inMilliseconds
        : 0,
    microseconds: alignment.inMilliseconds > 0 ? dateTime.microsecond : 0,
  );

  if (correction == Duration.zero) return dateTime;
  final corrected = dateTime.subtract(correction);
  return roundUp ? corrected.add(alignment) : corrected;
}
