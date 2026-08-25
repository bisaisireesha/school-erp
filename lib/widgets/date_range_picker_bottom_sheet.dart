import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class DateRangePickerBottomSheet extends StatefulWidget {
  final DateTimeRange? initialRange;
  final Function(DateTimeRange, String) onRangeSelected;

  const DateRangePickerBottomSheet({
    super.key,
    this.initialRange,
    required this.onRangeSelected,
  });

  @override
  State<DateRangePickerBottomSheet> createState() => _DateRangePickerBottomSheetState();
}

class _DateRangePickerBottomSheetState extends State<DateRangePickerBottomSheet> {
  late DateTime _calendarMonth;
  DateTime? _startDate;
  DateTime? _endDate;


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _calendarMonth = DateTime(now.year, now.month);
    
    if (widget.initialRange != null) {
      _startDate = widget.initialRange!.start;
      _endDate = widget.initialRange!.end;
      _calendarMonth = DateTime(_startDate!.year, _startDate!.month);
    } else {
      _applyQuickOption('This Month');
    }
  }

  void _applyQuickOption(String option) {
    final now = DateTime.now();
    setState(() {
      if (option == 'This Month') {
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
        _calendarMonth = DateTime(now.year, now.month);
      } else if (option == 'Last Month') {
        _startDate = DateTime(now.year, now.month - 1, 1);
        _endDate = DateTime(now.year, now.month, 0);
        _calendarMonth = DateTime(now.year, now.month - 1);
      } else if (option == '3 Months') {
        _startDate = DateTime(now.year, now.month - 2, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
        _calendarMonth = DateTime(now.year, now.month);
      } else if (option == '6 Months') {
        _startDate = DateTime(now.year, now.month - 5, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
        _calendarMonth = DateTime(now.year, now.month);
      } else if (option == 'This Year') {
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year, 12, 31);
        _calendarMonth = DateTime(now.year, now.month);
      }
    });
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        _startDate = date;
        _endDate = null;
      } else {
        _endDate = date;
      }
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            const Text(
              'Select Date Range',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 16),
            // Inputs
            Row(
              children: [
                Expanded(child: _buildDateInput(_startDate)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(LucideIcons.arrowRight, size: 16, color: Color(0xFF7A7A9D)),
                ),
                Expanded(child: _buildDateInput(_endDate)),
              ],
            ),
            const SizedBox(height: 24),
            // Month selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _changeMonth(-1),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(LucideIcons.chevronLeft, size: 20, color: Color(0xFF4A4A68)),
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_calendarMonth),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                GestureDetector(
                  onTap: () => _changeMonth(1),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF4A4A68)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Days header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map<Widget>((d) => SizedBox(width: 32, child: Center(child: Text(d, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D)))))).toList(),
            ),
            const SizedBox(height: 12),
            // Grid
            _buildCalendarGrid(),
            const SizedBox(height: 24),
            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_startDate != null && _endDate != null) {
                    widget.onRangeSelected(DateTimeRange(start: _startDate!, end: _endDate!), 'Custom Range');
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4EFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Apply Selection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput(DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF3EEFF)), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date != null ? DateFormat('MMM d, yyyy').format(date) : 'Select', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: date != null ? const Color(0xFF1E1E2D) : const Color(0xFF7A7A9D))),
          const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF1E1E2D)),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final int daysInMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1, 0).day;
    final int firstWeekday = DateTime(_calendarMonth.year, _calendarMonth.month, 1).weekday % 7; // Sun = 0
    final int prevDaysInMonth = DateTime(_calendarMonth.year, _calendarMonth.month, 0).day;

    List<Widget> dayWidgets = [];
    
    // Prev month days
    for (int i = firstWeekday - 1; i >= 0; i--) {
      dayWidgets.add(_buildDayCell(null, prevDaysInMonth - i, isFaded: true));
    }
    
    // Current month days
    for (int i = 1; i <= daysInMonth; i++) {
      dayWidgets.add(_buildDayCell(DateTime(_calendarMonth.year, _calendarMonth.month, i), i));
    }
    
    // Next month days
    int remaining = 42 - dayWidgets.length;
    for (int i = 1; i <= remaining; i++) {
      dayWidgets.add(_buildDayCell(null, i, isFaded: true));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      childAspectRatio: 1,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime? date, int dayText, {bool isFaded = false}) {
    if (date == null) {
      return Center(child: Text(dayText.toString(), style: const TextStyle(fontSize: 13, color: Color(0xFFD3D3E0), fontWeight: FontWeight.w500)));
    }

    bool isStart = _startDate != null && _isSameDay(date, _startDate!);
    bool isEnd = _endDate != null && _isSameDay(date, _endDate!);
    bool isBetween = false;
    
    if (_startDate != null && _endDate != null) {
      isBetween = date.isAfter(_startDate!) && date.isBefore(_endDate!);
    }

    bool isSelected = isStart || isEnd;
    
    BoxDecoration decoration = const BoxDecoration();
    
    if (isSelected) {
      decoration = BoxDecoration(
        color: const Color(0xFF6B4EFF),
        shape: BoxShape.circle,
      );
    } else if (isBetween) {
      decoration = BoxDecoration(
        color: const Color(0xFFF3EEFF),
        shape: BoxShape.rectangle,
      );
    }

    Widget cell = Container(
      decoration: decoration,
      child: Center(
        child: Text(
          dayText.toString(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : (isBetween ? const Color(0xFF6B4EFF) : const Color(0xFF1E1E2D)),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () => _onDaySelected(date),
      child: cell,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
