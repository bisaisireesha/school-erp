import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

// ─── Subject accent colours (left-border only; text stays dark) ───────────────
const Map<String, Color> _subjectAccent = {
  'mathematics': Color(0xFF6C4CF1), // indigo
  'physics':     Color(0xFF3B82F6), // blue
  'science':     Color(0xFF10B981), // green
  'english':     Color(0xFFF59E0B), // amber
  'social':      Color(0xFFEC4899), // pink
  'hindi':       Color(0xFFEF4444), // red
};

Color _accent(String subject) {
  final key = subject.toLowerCase();
  for (final k in _subjectAccent.keys) {
    if (key.contains(k)) return _subjectAccent[k]!;
  }
  return const Color(0xFF64748B);
}

// ─── Full weekly timetable (extends JSON data with more subjects) ─────────────
const Map<String, List<Map<String, String>>> _timetable = {
  'Mon': [
    {'time': '8:30 – 9:15',  'subject': 'Mathematics',    'class': 'Class 10-A', 'room': 'Room 204'},
    {'time': '9:15 – 10:00', 'subject': 'Science',        'class': 'Class 9-B',  'room': 'Lab 1'},
    {'time': '10:00 – 10:45','subject': 'English',        'class': 'Class 10-B', 'room': 'Room 110'},
    {'time': '10:45 – 11:00','subject': '',               'class': '',           'room': ''},  // Recess
    {'time': '11:00 – 11:45','subject': 'Physics',        'class': 'Class 10-B', 'room': 'Physics Lab 2'},
    {'time': '11:45 – 12:30','subject': 'Free Period',    'class': '',           'room': ''},
    {'time': '12:30 – 1:15', 'subject': 'Hindi',          'class': 'Class 9-C',  'room': 'Room 108'},
    {'time': '1:15 – 2:00',  'subject': 'Social Studies', 'class': 'Class 10-A', 'room': 'Room 205'},
  ],
  'Tue': [
    {'time': '8:30 – 9:15',  'subject': 'English',        'class': 'Class 10-A', 'room': 'Room 110'},
    {'time': '9:15 – 10:00', 'subject': 'Mathematics',    'class': 'Class 10-A', 'room': 'Room 204'},
    {'time': '10:00 – 10:45','subject': 'Physics Lab',    'class': 'Class 10-B', 'room': 'Physics Lab 2'},
    {'time': '10:45 – 11:00','subject': '',               'class': '',           'room': ''},  // Recess
    {'time': '11:00 – 11:45','subject': 'Free Period',    'class': '',           'room': ''},
    {'time': '11:45 – 12:30','subject': 'Science',        'class': 'Class 9-B',  'room': 'Lab 1'},
    {'time': '12:30 – 1:15', 'subject': 'Free Period',    'class': '',           'room': ''},
    {'time': '1:15 – 2:00',  'subject': 'Mathematics',    'class': 'Class 9-C',  'room': 'Room 108'},
  ],
  'Wed': [
    {'time': '8:30 – 9:15',  'subject': 'Social Studies', 'class': 'Class 9-C',  'room': 'Room 205'},
    {'time': '9:15 – 10:00', 'subject': 'Mathematics',    'class': 'Class 9-C',  'room': 'Room 108'},
    {'time': '10:00 – 10:45','subject': 'Mathematics',    'class': 'Class 10-A', 'room': 'Room 204'},
    {'time': '10:45 – 11:00','subject': '',               'class': '',           'room': ''},  // Recess
    {'time': '11:00 – 11:45','subject': 'Hindi',          'class': 'Class 10-B', 'room': 'Room 112'},
    {'time': '11:45 – 12:30','subject': 'Free Period',    'class': '',           'room': ''},
    {'time': '1:15 – 2:00',  'subject': 'Physics',        'class': 'Class 10-B', 'room': 'Physics Lab 2'},
  ],
  'Thu': [
    {'time': '8:30 – 9:15',  'subject': 'Mathematics',    'class': 'Class 10-A', 'room': 'Room 204'},
    {'time': '9:15 – 10:00', 'subject': 'Physics',        'class': 'Class 10-B', 'room': 'Physics Lab 2'},
    {'time': '10:00 – 10:45','subject': 'Free Period',    'class': '',           'room': ''},
    {'time': '10:45 – 11:00','subject': '',               'class': '',           'room': ''},  // Recess
    {'time': '11:00 – 11:45','subject': 'Mathematics',    'class': 'Class 9-C',  'room': 'Room 108'},  // Ongoing
    {'time': '11:45 – 12:30','subject': 'English',        'class': 'Class 10-A', 'room': 'Room 110'},
    {'time': '12:30 – 1:15', 'subject': 'Free Period',    'class': '',           'room': ''},
    {'time': '1:15 – 2:00',  'subject': 'Mathematics Lab','class': 'Class 10-A', 'room': 'Math Lab 1'},
  ],
  'Fri': [
    {'time': '8:30 – 9:15',  'subject': 'Mathematics Quiz','class': 'Class 9-C', 'room': 'Room 108'},
    {'time': '9:15 – 10:00', 'subject': 'Physics',         'class': 'Class 10-B','room': 'Physics Lab 2'},
    {'time': '10:00 – 10:45','subject': 'Hindi',           'class': 'Class 9-C', 'room': 'Room 112'},
    {'time': '10:45 – 11:00','subject': '',                'class': '',          'room': ''},
    {'time': '11:00 – 11:45','subject': 'Mathematics',     'class': 'Class 10-A','room': 'Room 204'},
    {'time': '11:45 – 12:30','subject': 'Free Period',     'class': '',          'room': ''},
    {'time': '1:15 – 2:00',  'subject': 'Social Studies',  'class': 'Class 10-A','room': 'Room 205'},
  ],
  'Sat': [
    {'time': '9:00 – 10:00', 'subject': 'Mathematics Consultation', 'class': 'Class 10-A', 'room': 'Room 204'},
    {'time': '10:15 – 11:30','subject': 'Physics Olympiad Prep',    'class': 'Class 10-B', 'room': 'Physics Lab 2'},
    {'time': '11:30 – 12:00','subject': 'Free Period',              'class': '',           'room': ''},
  ],
};

// ─── Which slot index is "current" on today (Thursday) ───────────────────────
// Slots 0-1 are done, slot 4 is ongoing (11:00-11:45).
const int _currentSlotThu = 4;

// ─────────────────────────────────────────────────────────────────────────────
class TeacherTimetableScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final Function(String screenKey, {Map<String, dynamic>? arguments})? onNavigate;

  const TeacherTimetableScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onNavigate,
  });

  @override
  State<TeacherTimetableScreen> createState() => _TeacherTimetableScreenState();
}

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen> {
  static const String _todayKey = 'Thu';
  late String _selectedDay;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _selectedDay = _todayKey;
  }

  bool _isRecess(Map<String, String> row) =>
      row['subject']?.isEmpty ?? true;

  bool _isFree(Map<String, String> row) =>
      (row['subject'] ?? '').toLowerCase() == 'free period';

  // Status for today's slots
  String _slotStatus(int idx) {
    if (_selectedDay != _todayKey) return 'normal';
    if (idx < _currentSlotThu) return 'done';
    if (idx == _currentSlotThu) return 'current';
    return 'upcoming';
  }

  void _openClass(Map<String, String> row) {
    widget.onNavigate?.call('class_details', arguments: {
      'className': row['class']?.split('-').first.trim() ?? '',
      'section': (row['class']?.contains('-') ?? false)
          ? row['class']!.split('-').last.trim()
          : 'A',
      'subject': row['subject'] ?? '',
      'room': row['room'] ?? '',
      'isAttendancePending': true,
    });
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final slots = _timetable[_selectedDay] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title bar ────────────────────────────────────────────────
            _buildTitleBar(),
            // ── Day pills ─────────────────────────────────────────────────
            _buildDaySelector(),
            // ── List ─────────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                itemCount: slots.length,
                itemBuilder: (ctx, i) {
                  final row = slots[i];
                  if (_isRecess(row)) return _recessDivider(row['time']!);
                  if (_isFree(row))   return _freeRow(row['time']!, i);
                  return _classRow(row, i, _slotStatus(i));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TITLE BAR ─────────────────────────────────────────────────────────────
  Widget _buildTitleBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          if (widget.onBack != null) ...[
            AppBackButton(onPressed: widget.onBack!),
            const SizedBox(width: 4),
          ],
          const Text(
            'My Timetable',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.4,
            ),
          ),
          const Spacer(),
          if (_selectedDay == _todayKey)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDDD6FF)),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
        ],
      ),
    );
  }


  // ─── DAY SELECTOR ──────────────────────────────────────────────────────────
  Widget _buildDaySelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: _days.map((d) {
          final isSelected = d == _selectedDay;
          final isToday    = d == _todayKey;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDay = d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C4CF1)
                      : const Color(0xFFF4F3F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? const Color(0xFF6C4CF1)
                                : const Color(0xFF475569),
                      ),
                    ),
                    if (isToday && !isSelected) ...[
                      const SizedBox(height: 3),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C4CF1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── CLASS ROW ─────────────────────────────────────────────────────────────
  Widget _classRow(Map<String, String> row, int idx, String status) {
    final subject   = row['subject'] ?? '';
    final cls       = row['class'] ?? '';
    final room      = row['room'] ?? '';
    final time      = row['time'] ?? '';
    final accent    = _accent(subject);
    final isCurrent = status == 'current';
    final isDone    = status == 'done';

    return GestureDetector(
      onTap: () => _openClass(row),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFFF0EDFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent
                ? const Color(0xFF6C4CF1).withValues(alpha: 0.35)
                : const Color(0xFFEEEDF5),
            width: 1,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: isDone
                      ? accent.withValues(alpha: 0.35)
                      : accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Time block
                      SizedBox(
                        width: 76,
                        child: Text(
                          time.replaceAll(' – ', '\n'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCurrent
                                ? const Color(0xFF6C4CF1)
                                : isDone
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF475569),
                            height: 1.5,
                          ),
                        ),
                      ),

                      // Vertical separator
                      Container(
                        width: 1,
                        height: 38,
                        color: isCurrent
                            ? const Color(0xFF6C4CF1).withValues(alpha: 0.2)
                            : const Color(0xFFEEEDF5),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),

                      // Class details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    subject,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isDone
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF1E1E2D),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6C4CF1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Now',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  cls,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDone
                                        ? const Color(0xFF94A3B8)
                                        : isCurrent
                                            ? const Color(0xFF6C4CF1)
                                            : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCBD5E1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  LucideIcons.mapPin,
                                  size: 11,
                                  color: isDone
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    room,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDone
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── FREE PERIOD ROW ───────────────────────────────────────────────────────
  Widget _freeRow(String time, int idx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEDF5)),
      ),
      child: Row(
        children: [
          // Left accent (neutral)
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: 76,
              child: Text(
                time.replaceAll(' – ', '\n'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFB0BAC9),
                  height: 1.5,
                ),
              ),
            ),
          ),
          Container(width: 1, height: 24, color: const Color(0xFFEEEDF5)),
          const SizedBox(width: 12),
          const Icon(LucideIcons.coffee, size: 14, color: Color(0xFFCBD5E1)),
          const SizedBox(width: 7),
          const Text(
            'Free Period',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ─── RECESS DIVIDER ────────────────────────────────────────────────────────
  Widget _recessDivider(String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFB0BAC9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: const Color(0xFFEEEDF5))),
          const SizedBox(width: 8),
          const Text(
            'Recess',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB0BAC9),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: const Color(0xFFEEEDF5))),
        ],
      ),
    );
  }
}
