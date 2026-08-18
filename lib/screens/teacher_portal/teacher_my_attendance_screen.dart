import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import '../../widgets/teacher_attachment_picker.dart';

// ─── Attendance data — August 2026 ───────────────────────────────────────────
// P=Present  A=Absent  L=Leave  H=Holiday  W=Weekend
const Map<int, String> _aug = {
  1:  'P', 2:  'W', 3:  'W',
  4:  'P', 5:  'P', 6:  'P', 7:  'P', 8:  'P', 9:  'W', 10: 'W',
  11: 'P', 12: 'P', 13: 'P', 14: 'P', 15: 'H',
  16: 'W', 17: 'W',
  18: 'P', 19: 'P', 20: 'P', 21: 'L', 22: 'A',
  23: 'W', 24: 'W',
  25: 'P', 26: 'P', 27: 'P', 28: 'P', 29: 'P',
  30: 'W', 31: 'W',
};
// Aug 1 2026 = Saturday → Sunday-first grid offset = 6
const int _aug2026Offset = 6;
const int _todayDay = 13;

// ─── Status colour tokens ─────────────────────────────────────────────────────
const _statusBg = {
  'P': Color(0xFFF0FDF4),
  'A': Color(0xFFFEF2F2),
  'L': Color(0xFFFFFBEB),
  'H': Color(0xFFEFF6FF),
};
const _statusFg = {
  'P': Color(0xFF16A34A),
  'A': Color(0xFFDC2626),
  'L': Color(0xFFD97706),
  'H': Color(0xFF2563EB),
};
const _statusLabel = {
  'P': 'Present',
  'A': 'Absent',
  'L': 'Leave',
  'H': 'Holiday',
};

// ─── Leave model ─────────────────────────────────────────────────────────────
class _Leave {
  final String type, from, to, status, reason;
  const _Leave(this.type, this.from, this.to, this.status, this.reason);
}

// ─── Screen ──────────────────────────────────────────────────────────────────
class TeacherMyAttendanceScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherMyAttendanceScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherMyAttendanceScreen> createState() =>
      _TeacherMyAttendanceScreenState();
}

class _TeacherMyAttendanceScreenState
    extends State<TeacherMyAttendanceScreen> {
  int _month = 8;
  int _year  = 2026;
  int? _tapped;
  bool _showAll = false;

  final List<_Leave> _leaves = [
    const _Leave('Medical Leave',   '21 Aug 2026', '21 Aug 2026', 'Approved', 'Doctor appointment'),
    const _Leave('Personal Leave',  '22 Aug 2026', '22 Aug 2026', 'Pending',  'Family function'),
    const _Leave('Casual Leave',    '05 Jul 2026', '05 Jul 2026', 'Approved', 'Personal work'),
    const _Leave('Emergency Leave', '15 Jun 2026', '16 Jun 2026', 'Approved', 'Family emergency'),
  ];

  // summary counts
  int _count(String s) =>
      _aug.values.where((v) => v == s).length;

  // ─── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  _kpiGrid(),
                  const SizedBox(height: 16),
                  _calendarCard(),
                  const SizedBox(height: 16),
                  _leaveSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────────────
  Widget _header() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          if (widget.onBack != null) ...[
            AppBackButton(onPressed: widget.onBack!),
            const SizedBox(width: 4),
          ],
          const Expanded(
            child: Text(
              'My Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.3,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _openRequestLeave,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(LucideIcons.plus, size: 14, color: Colors.white),
            label: const Text(
              'Request Leave',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2×2 KPI GRID ──────────────────────────────────────────────────────────
  Widget _kpiGrid() {
    final items = [
      ('Present',  _count('P'), 'P'),
      ('Absent',   _count('A'), 'A'),
      ('Leave',    _count('L'), 'L'),
      ('Holidays', _count('H'), 'H'),
    ];

    return Row(
      children: [
        _kpiColumn(items[0], items[2]),
        const SizedBox(width: 10),
        _kpiColumn(items[1], items[3]),
      ],
    );
  }

  Widget _kpiColumn(
      (String, int, String) top, (String, int, String) bottom) {
    return Expanded(
      child: Column(
        children: [
          _kpiCard(top),
          const SizedBox(height: 10),
          _kpiCard(bottom),
        ],
      ),
    );
  }

  Widget _kpiCard((String, int, String) item) {
    final (label, value, key) = item;
    final fg = _statusFg[key] ?? const Color(0xFF64748B);
    final bg = _statusBg[key] ?? const Color(0xFFF8F9FA);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EEF8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x061E1E2D),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coloured dot accent
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),
          ),
          // Count in status tint pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CALENDAR CARD ─────────────────────────────────────────────────────────
  Widget _calendarCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EEF8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x061E1E2D),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _calendarHeader(),
          const SizedBox(height: 12),
          _weekdayRow(),
          const SizedBox(height: 6),
          _calendarGrid(),
          const SizedBox(height: 12),
          _legend(),
          if (_tapped != null) ...[
            const SizedBox(height: 10),
            _dayChip(),
          ],
        ],
      ),
    );
  }

  Widget _calendarHeader() {
    return Row(
      children: [
        Text(
          '${_monthName(_month)} $_year',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const Spacer(),
        _navBtn(Icons.chevron_left_rounded, _prevMonth),
        const SizedBox(width: 6),
        _navBtn(Icons.chevron_right_rounded, _nextMonth),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback fn) => GestureDetector(
        onTap: fn,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F7FC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF0EEF8)),
          ),
          child: Icon(icon, size: 17, color: const Color(0xFF64748B)),
        ),
      );

  Widget _weekdayRow() {
    return Row(
      children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _calendarGrid() {
    final dim    = DateUtils.getDaysInMonth(_year, _month);
    final offset = (_month == 8 && _year == 2026) ? _aug2026Offset : 0;
    final rows   = ((offset + dim) / 7).ceil();
    final isAug  = _month == 8 && _year == 2026;

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: List.generate(7, (col) {
              final idx = row * 7 + col;
              final day = idx - offset + 1;
              if (day < 1 || day > dim) {
                return const Expanded(child: SizedBox(height: 36));
              }

              final status    = isAug ? _aug[day] : null;
              final isToday   = isAug && day == _todayDay;
              final isTapped  = _tapped == day;
              final isWeekend = status == 'W' || status == null;

              Color bgColor   = Colors.transparent;
              Color textColor = const Color(0xFFCBD5E1);
              FontWeight fw   = FontWeight.w400;

              if (isTapped) {
                bgColor   = const Color(0xFF6C4CF1);
                textColor = Colors.white;
                fw        = FontWeight.w700;
              } else if (!isWeekend) {
                bgColor   = _statusBg[status] ?? Colors.transparent;
                textColor = _statusFg[status] ?? const Color(0xFF1E1E2D);
                fw        = FontWeight.w600;
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (isWeekend) return;
                    setState(() => _tapped = _tapped == day ? null : day);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 36,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isTapped
                          ? Border.all(
                              color: const Color(0xFF6C4CF1),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: fw,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  // ─── LEGEND ────────────────────────────────────────────────────────────────
  Widget _legend() {
    const items = [
      ('Present', 'P'),
      ('Absent',  'A'),
      ('Leave',   'L'),
      ('Holiday', 'H'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((e) {
        final (label, key) = e;
        final fg = _statusFg[key]!;
        final bg = _statusBg[key]!;
        return Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                  border: Border.all(color: fg.withValues(alpha: 0.5)),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── DAY CHIP ──────────────────────────────────────────────────────────────
  Widget _dayChip() {
    final status = _aug[_tapped];
    final label  = _statusLabel[status] ?? 'Unknown';
    final fg     = _statusFg[status] ?? const Color(0xFF64748B);
    final bg     = _statusBg[status] ?? const Color(0xFFF8F9FA);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '${_monthName(_month)} $_tapped',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _tapped = null),
            child: Icon(Icons.close_rounded, size: 15, color: fg),
          ),
        ],
      ),
    );
  }

  // ─── LEAVE SECTION ─────────────────────────────────────────────────────────
  Widget _leaveSection() {
    final visible = _showAll ? _leaves : _leaves.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Leave Requests',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const Spacer(),
            if (_leaves.length > 3)
              GestureDetector(
                onTap: () => setState(() => _showAll = !_showAll),
                child: Text(
                  _showAll ? 'Show less' : 'View all',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C4CF1),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        if (_leaves.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No leave requests',
                style: TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF0EEF8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x061E1E2D),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: visible.asMap().entries.map((e) {
                final isLast = e.key == visible.length - 1;
                return Column(
                  children: [
                    _leaveRow(e.value),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        indent: 14,
                        endIndent: 14,
                        color: Color(0xFFF8F7FC),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _leaveRow(_Leave req) {
    Color statusFg;
    Color statusBg;
    switch (req.status) {
      case 'Approved':
        statusFg = const Color(0xFF16A34A);
        statusBg = const Color(0xFFF0FDF4);
      case 'Pending':
        statusFg = const Color(0xFFD97706);
        statusBg = const Color(0xFFFFFBEB);
      default:
        statusFg = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEF2F2);
    }

    final dateStr = req.from == req.to ? req.from : '${req.from} – ${req.to}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req.type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              req.status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: statusFg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── REQUEST LEAVE ─────────────────────────────────────────────────────────
  void _openRequestLeave() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _RequestLeaveScreen(
        onSubmit: (req) => setState(() => _leaves.insert(0, req)),
      ),
    ));
  }

  // ─── HELPERS ───────────────────────────────────────────────────────────────
  void _prevMonth() => setState(() {
        _tapped = null;
        _month == 1 ? (_month = 12, _year--) : _month--;
      });
  void _nextMonth() => setState(() {
        _tapped = null;
        _month == 12 ? (_month = 1, _year++) : _month++;
      });

  String _monthName(int m) => const [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ][m];
}

// ─────────────────────────────────────────────────────────────────────────────
// Request Leave Screen
// ─────────────────────────────────────────────────────────────────────────────
class _RequestLeaveScreen extends StatefulWidget {
  final void Function(_Leave) onSubmit;
  const _RequestLeaveScreen({required this.onSubmit});

  @override
  State<_RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<_RequestLeaveScreen> {
  final _types = [
    'Casual Leave',
    'Medical Leave',
    'Personal Leave',
    'Emergency Leave',
    'Maternity / Paternity Leave',
  ];

  String    _type = 'Casual Leave';
  DateTime? _from;
  DateTime? _to;
  final     _reasonCtrl = TextEditingController();
  List<AttachedFile> _attachments = [];
  bool      _loading    = false;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  bool get _valid =>
      _from != null && _to != null && _reasonCtrl.text.trim().isNotEmpty;

  Future<void> _pick({required bool isFrom}) async {
    final now = DateTime.now();
    final d   = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_from ?? now) : (_to ?? _from ?? now),
      firstDate:   DateTime(2026, 1),
      lastDate:    DateTime(2027, 12),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary:   Color(0xFF6C4CF1),
            onSurface: Color(0xFF1E1E2D),
          ),
        ),
        child: child!,
      ),
    );
    if (d == null) return;
    setState(() {
      if (isFrom) {
        _from = d;
        if (_to != null && _to!.isBefore(d)) _to = d;
      } else {
        _to = d;
      }
    });
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select date';
    const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
               'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${m[d.month]} ${d.year}';
  }

  void _submit() async {
    if (!_valid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onSubmit(_Leave(
      _type,
      _fmt(_from),
      _fmt(_to),
      'Pending',
      _reasonCtrl.text.trim(),
    ));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  AppBackButton(
                      onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(width: 4),
                  const Text(
                    'Request Leave',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).viewInsets.bottom + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Leave Type'),
                    const SizedBox(height: 6),
                    _dropdownField(),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('From'),
                              const SizedBox(height: 6),
                              _dateField(_fmt(_from),
                                  () => _pick(isFrom: true)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('To'),
                              const SizedBox(height: 6),
                              _dateField(_fmt(_to),
                                  () => _pick(isFrom: false)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _fieldLabel('Reason'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _reasonCtrl,
                      maxLines: 4,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E1E2D),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Brief reason for leave…',
                        hintStyle: const TextStyle(
                            color: Color(0xFFB0BAC9), fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFFAFAFC),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE8E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE8E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF6C4CF1), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Supporting Document Attachment Picker
                    TeacherAttachmentPicker(
                      label: 'Supporting Documents (Optional)',
                      hintText: 'Medical certificate, prescription, or note (PDF, JPG)',
                      initialFiles: _attachments,
                      onChanged: (files) => setState(() => _attachments = files),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _valid && !_loading ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          disabledBackgroundColor: const Color(0xFFE8E8F0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Submit Request',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: _valid
                                      ? Colors.white
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
      );

  Widget _dropdownField() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8F0)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _type,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF64748B), size: 20),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E2D),
            ),
            items: _types
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _type = v ?? _type),
          ),
        ),
      );

  Widget _dateField(String label, VoidCallback onTap) {
    final picked = !label.startsWith('Select');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: picked
                      ? const Color(0xFF1E1E2D)
                      : const Color(0xFFB0BAC9),
                ),
              ),
            ),
            const Icon(LucideIcons.calendar, size: 15,
                color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
