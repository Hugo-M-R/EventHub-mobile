import 'package:flutter/material.dart';

import '../theme/eventhub_colors.dart';

const _eventBlue = Color(0xFF1976D2);
const _eventBlueLight = Color(0xFFE3F2FD);

/// Calendário mensal com destaque em azul para dias que possuem eventos.
class EventCalendar extends StatefulWidget {
  const EventCalendar({
    super.key,
    required this.eventDates,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onClearSelection,
  });

  final Set<DateTime> eventDates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onClearSelection;

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  static const _weekdays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  static const _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = _initialFocusedMonth();
  }

  @override
  void didUpdateWidget(EventCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null &&
        (widget.selectedDate!.year != _focusedMonth.year ||
            widget.selectedDate!.month != _focusedMonth.month)) {
      _focusedMonth = DateTime(
        widget.selectedDate!.year,
        widget.selectedDate!.month,
      );
    }
  }

  DateTime _initialFocusedMonth() {
    final selected = widget.selectedDate;
    if (selected != null) {
      return DateTime(selected.year, selected.month);
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasEvent(DateTime day) {
    return widget.eventDates.any((d) => _isSameDay(d, day));
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  List<DateTime?> _buildMonthGrid() {
    final firstOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final leadingEmpty = firstOfMonth.weekday % 7;

    final cells = <DateTime?>[];
    for (var i = 0; i < leadingEmpty; i++) {
      cells.add(null);
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(DateTime(_focusedMonth.year, _focusedMonth.month, day));
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildMonthGrid();
    final hasSelection = widget.selectedDate != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: EventHubColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EventHubColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: EventHubColors.textPrimary,
                onPressed: () => _changeMonth(-1),
              ),
              Expanded(
                child: Text(
                  '${_months[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: EventHubColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: EventHubColors.textPrimary,
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: _weekdays
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: EventHubColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: cells.length,
            itemBuilder: (context, index) {
              final day = cells[index];
              if (day == null) return const SizedBox.shrink();
              return _DayCell(
                date: day,
                isToday: _isSameDay(day, _today),
                hasEvent: _hasEvent(day),
                isSelected: widget.selectedDate != null &&
                    _isSameDay(day, widget.selectedDate!),
                onTap: () => widget.onDateSelected(day),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: _eventBlue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Dias com eventos',
                style: TextStyle(
                  fontSize: 12,
                  color: EventHubColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (hasSelection)
                TextButton.icon(
                  onPressed: widget.onClearSelection,
                  icon: const Icon(Icons.filter_alt_off, size: 18),
                  label: const Text('Limpar filtro'),
                  style: TextButton.styleFrom(
                    foregroundColor: EventHubColors.orangeButton,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isToday,
    required this.hasEvent,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool hasEvent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color background = Colors.transparent;
    Color textColor = EventHubColors.textPrimary;
    Border? border;

    if (isSelected) {
      background = EventHubColors.orangeButton;
      textColor = Colors.white;
    } else if (hasEvent) {
      background = _eventBlueLight;
      textColor = _eventBlue;
    }

    if (isToday && !isSelected) {
      border = Border.all(color: EventHubColors.orangeButton, width: 1.5);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
            border: border,
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: hasEvent || isSelected ? FontWeight.w600 : FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
