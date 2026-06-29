import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Selection mode for [UICalendar].
enum UICalendarMode { single, range }

/// Month grid calendar with single-date or range selection.
class UICalendar extends StatefulWidget {
  const UICalendar({
    super.key,
    this.selectedDate,
    this.selectedRange,
    this.onDateSelected,
    this.onRangeSelected,
    this.mode = UICalendarMode.single,
    this.firstDate,
    this.lastDate,
    this.initialMonth,
  });

  final DateTime? selectedDate;
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final UICalendarMode mode;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialMonth;

  @override
  State<UICalendar> createState() => _UICalendarState();
}

class _UICalendarState extends State<UICalendar> {
  late DateTime _visibleMonth;
  DateTime? _rangeStart;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(
      (widget.initialMonth ?? widget.selectedDate ?? DateTime.now()).year,
      (widget.initialMonth ?? widget.selectedDate ?? DateTime.now()).month,
    );
    _rangeStart = widget.selectedRange?.start;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    final range = widget.selectedRange;
    if (range == null) return false;
    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final end = DateTime(range.end.year, range.end.month, range.end.day);
    final current = DateTime(day.year, day.month, day.day);
    return !current.isBefore(start) && !current.isAfter(end);
  }

  bool _isDisabled(DateTime day) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null &&
        day.isBefore(DateTime(first.year, first.month, first.day))) {
      return true;
    }
    if (last != null &&
        day.isAfter(DateTime(last.year, last.month, last.day))) {
      return true;
    }
    return false;
  }

  void _selectDay(DateTime day) {
    if (_isDisabled(day)) return;

    if (widget.mode == UICalendarMode.single) {
      widget.onDateSelected?.call(day);
      return;
    }

    if (_rangeStart == null ||
        (widget.selectedRange != null &&
            widget.selectedRange!.start != widget.selectedRange!.end)) {
      setState(() => _rangeStart = day);
      widget.onRangeSelected?.call(DateTimeRange(start: day, end: day));
      return;
    }

    final start = _rangeStart!;
    final end = day.isBefore(start) ? start : day;
    final rangeStart = day.isBefore(start) ? day : start;
    widget.onRangeSelected?.call(DateTimeRange(start: rangeStart, end: end));
    setState(() => _rangeStart = null);
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  List<DateTime?> _buildMonthDays() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month);
    final daysInMonth = DateUtils.getDaysInMonth(
      _visibleMonth.year,
      _visibleMonth.month,
    );
    final leading = firstOfMonth.weekday % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(_visibleMonth.year, _visibleMonth.month, day),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final monthLabel = DateFormat.yMMMM().format(_visibleMonth);
    final days = _buildMonthDays();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => _changeMonth(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                monthLabel,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              onPressed: () => _changeMonth(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.outline,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 1.15,
          children: [
            for (final day in days)
              if (day == null)
                const SizedBox.shrink()
              else
                _DayCell(
                  day: day,
                  selected:
                      widget.selectedDate != null &&
                      _isSameDay(day, widget.selectedDate!),
                  inRange: _isInRange(day),
                  disabled: _isDisabled(day),
                  onTap: () => _selectDay(day),
                ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.inRange,
    required this.disabled,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool inRange;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected
        ? scheme.primary
        : inRange
        ? scheme.primary.withValues(alpha: 0.12)
        : Colors.transparent;
    final fg = selected
        ? scheme.onPrimary
        : disabled
        ? scheme.outline
        : scheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: fg,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
