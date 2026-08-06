import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

// ─── Helpers & Color Palette ──────────────────────────────────────────────────

Color _typeColor(String? t) {
  switch (t) {
    case 'Audit':       return const Color(0xFF6C4CF1);
    case 'Maintenance': return const Color(0xFFF59E0B);
    case 'Training':    return const Color(0xFF10B981);
    case 'Inspection':  return const Color(0xFF3B82F6);
    case 'Holiday':     return const Color(0xFFF43F5E);
    default:            return const Color(0xFF6C4CF1);
  }
}

const _shortMonths = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const _fullMonths  = ['January','February','March','April','May','June','July',
                      'August','September','October','November','December'];
const _monthNums   = {'Jan':1,'Feb':2,'Mar':3,'Apr':4,'May':5,'Jun':6,
                      'Jul':7,'Aug':8,'Sep':9,'Oct':10,'Nov':11,'Dec':12};

String _dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';

String? _parseKey(String raw) {
  final p = raw.trim().split(' ');
  if (p.length != 3) return null;
  try {
    final day   = int.parse(p[0]);
    final month = _monthNums[p[1]] ?? 0;
    final year  = int.parse(p[2]);
    if (month == 0) return null;
    return '$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}';
  } catch (_) { return null; }
}

DateTime? _parseDateTime(String raw) {
  final p = raw.trim().split(' ');
  if (p.length != 3) return null;
  try {
    final day   = int.parse(p[0]);
    final month = _monthNums[p[1]] ?? 0;
    final year  = int.parse(p[2]);
    if (month == 0) return null;
    return DateTime(year, month, day);
  } catch (_) { return null; }
}

String _fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2,'0')} ${_shortMonths[d.month-1]} ${d.year}';

// ─── Minimal iOS-Style Transport Calendar Screen ──────────────────────────────

class TransportCalendarScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TransportCalendarScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<TransportCalendarScreen> createState() => _TransportCalendarScreenState();
}

class _TransportCalendarScreenState extends State<TransportCalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  late PageController _pageController;
  late int _initialPage;

  late Map<String, List<Map<String, dynamic>>> _eventsByKey;
  late List<Map<String, dynamic>> _allEvents;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
    _initialPage = 1200;
    _pageController = PageController(initialPage: _initialPage);
    _loadEvents();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    final raw = widget.data['events'] as List? ?? [];
    final now = DateTime.now();

    _allEvents = [
      ...raw.map((e) => Map<String, dynamic>.from(e as Map)),
      {
        'title': 'GPS Tracker System Update',
        'date': _fmtDate(now.add(const Duration(days: 1))),
        'time': '11:00 AM',
        'location': 'Transport Office',
        'type': 'Maintenance'
      },
      {
        'title': 'Monthly Route Review Meeting',
        'date': _fmtDate(now.add(const Duration(days: 3))),
        'time': '02:00 PM',
        'location': 'Conference Room B',
        'type': 'Audit'
      },
      {
        'title': 'BUS-01 Annual Fitness Check',
        'date': _fmtDate(now.add(const Duration(days: 7))),
        'time': '09:30 AM',
        'location': 'RTO Office, Delhi',
        'type': 'Inspection'
      },
      {
        'title': 'Driver Emergency Response Drill',
        'date': _fmtDate(now.add(const Duration(days: 10))),
        'time': '08:00 AM',
        'location': 'School Ground',
        'type': 'Training'
      },
    ];

    _eventsByKey = {};
    for (final e in _allEvents) {
      final k = _parseKey(e['date'] as String? ?? '');
      if (k != null) _eventsByKey.putIfAbsent(k, () => []).add(e);
    }
  }

  DateTime _monthForPage(int page) {
    final monthOffset = page - _initialPage;
    return DateTime(_focusedMonth.year, _focusedMonth.month + monthOffset);
  }

  /// Returns all events belonging to the currently focused month, sorted chronologically.
  List<Map<String, dynamic>> get _monthlyEvents {
    final List<Map<String, dynamic>> monthList = [];

    for (final e in _allEvents) {
      final dt = _parseDateTime(e['date'] as String? ?? '');
      if (dt != null && dt.year == _focusedMonth.year && dt.month == _focusedMonth.month) {
        monthList.add(e);
      }
    }

    monthList.sort((a, b) {
      final dtA = _parseDateTime(a['date'] as String? ?? '') ?? DateTime(2099);
      final dtB = _parseDateTime(b['date'] as String? ?? '') ?? DateTime(2099);
      return dtA.compareTo(dtB);
    });

    return monthList;
  }

  void _showEventDetailsBottomSheet(Map<String, dynamic> event) {
    final String title = event['title'] as String? ?? '';
    final String date = event['date'] as String? ?? '';
    final String time = event['time'] as String? ?? '';
    final String location = event['location'] as String? ?? '';
    final String type = event['type'] as String? ?? '';
    final Color color = _typeColor(type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0DDF0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header Banner with Type Badge & Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.16)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: -0.3,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Items List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0EDF8)),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(LucideIcons.calendar, 'Date', date),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.clock, 'Time', time),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.mapPin, 'Location', location),
                        const Divider(height: 1, color: Color(0xFFF0EDF8), indent: 14, endIndent: 14),
                        _buildDetailRow(LucideIcons.tag, 'Event Type', type),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Context Notes
                  const Text(
                    'Notes & Instructions',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF9FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF0EDF8)),
                    ),
                    child: Text(
                      'Ensure all relevant drivers, vehicles, and fleet personnel are prepared by $time on $date.',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF4A4A68),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dismiss Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Close Details',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF6C4CF1)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13.0, color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthlyEvts = _monthlyEvents;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: widget.onBack),
        title: const Text(
          'Calendar & Events',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
            fontSize: 18.5,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Minimal iOS-Style Monthly Calendar Card Grid ──
            _buildMonthlyCalendarCard(),
            const SizedBox(height: 22),

            // ── Monthly Events Section Heading ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Events (${_shortMonths[_focusedMonth.month - 1]} ${_focusedMonth.year})',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.3,
                  ),
                ),
                if (monthlyEvts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${monthlyEvts.length} Events',
                      style: const TextStyle(
                        color: Color(0xFF6C4CF1),
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Monthly Events Cards List ──
            if (monthlyEvts.isEmpty)
              _buildEmptyMonthCard()
            else
              ...monthlyEvts.map((e) => _buildEventCard(e)),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // ─── Monthly Calendar Grid Card ─────────────────────────────────────────────

  Widget _buildMonthlyCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Centered Month Header Title (No left/right chevron buttons)
          Center(
            child: Text(
              '${_fullMonths[_focusedMonth.month - 1]} ${_focusedMonth.year}',
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Weekday Headers (S M T W T F S)
          Row(
            children: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((l) =>
              Expanded(
                child: Center(
                  child: Text(
                    l,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFADABC8),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
          const SizedBox(height: 10),

          // Monthly Days Swipeable View with Week Dividers
          SizedBox(
            height: 275,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _focusedMonth = _monthForPage(page);
                });
              },
              itemBuilder: (context, page) {
                final monthDate = _monthForPage(page);
                return _buildMonthGrid(monthDate);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(DateTime monthDate) {
    final firstDay = DateTime(monthDate.year, monthDate.month, 1);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7; // Sunday = 0

    final cells = <int?>[];
    for (int i = 0; i < startOffset; i++) {
      cells.add(null);
    }
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(d);
    }
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final rows = <List<int?>>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(cells.sublist(i, i + 7));
    }

    final now = DateTime.now();

    return Column(
      children: rows.asMap().entries.map((entry) {
        final rowIndex = entry.key;
        final row = entry.value;
        final isLastRow = rowIndex == rows.length - 1;

        return Container(
          decoration: BoxDecoration(
            border: isLastRow
                ? null
                : const Border(
                    bottom: BorderSide(color: Color(0xFFF3EEFF), width: 1.0),
                  ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: row.map((day) {
              if (day == null) return const Expanded(child: SizedBox(height: 40));

              final date = DateTime(monthDate.year, monthDate.month, day);
              final key = _dayKey(date);
              final isSel = key == _dayKey(_selectedDate);
              final isToday = key == _dayKey(now);
              final hasEvent = _eventsByKey.containsKey(key);

              final Color dotColor = hasEvent
                  ? _typeColor(_eventsByKey[key]!.first['type'] as String?)
                  : Colors.transparent;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFF6C4CF1)
                                : isToday
                                    ? const Color(0xFFF3EEFF)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                            border: isToday && !isSel
                                ? Border.all(color: const Color(0xFF6C4CF1), width: 1.5)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: isSel || isToday ? FontWeight.bold : FontWeight.w500,
                              color: isSel
                                  ? Colors.white
                                  : isToday
                                      ? const Color(0xFF6C4CF1)
                                      : const Color(0xFF1E1E2D),
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        if (hasEvent)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSel ? Colors.white70 : dotColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // ─── Event Card (Monthly Events List) ───────────────────────────────────────

  Widget _buildEventCard(Map<String, dynamic> e) {
    final String title = e['title'] as String? ?? '';
    final String date = e['date'] as String? ?? '';
    final String time = e['time'] as String? ?? '';
    final String location = e['location'] as String? ?? '';
    final String type = e['type'] as String? ?? '';
    final Color color = _typeColor(type);

    final key = _parseKey(date);
    final isSelectedDateEvent = key != null && key == _dayKey(_selectedDate);

    return GestureDetector(
      onTap: () => _showEventDetailsBottomSheet(e),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelectedDateEvent ? const Color(0xFF6C4CF1) : const Color(0xFFF0EDF8),
            width: isSelectedDateEvent ? 1.5 : 1.0,
          ),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left color accent strip
            Container(
              width: 3.5,
              height: 48,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),

            // Content Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: -0.2,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(color: color, fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 12, color: Color(0xFF9E9AB8)),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 12.0, color: Color(0xFF4A4A68), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      const Icon(LucideIcons.clock, size: 12, color: Color(0xFF9E9AB8)),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
                      ),
                      if (location.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        const Icon(LucideIcons.mapPin, size: 12, color: Color(0xFF9E9AB8)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMonthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      child: const Center(
        child: Text(
          'No events scheduled this month.',
          style: TextStyle(
            fontSize: 13.0,
            color: Color(0xFF7A7A9D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
