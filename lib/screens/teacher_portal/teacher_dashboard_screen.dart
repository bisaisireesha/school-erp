import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey, {Map<String, dynamic>? arguments}) onNavigate;
  final Function(String actionKey) onQuickAction;

  const TeacherDashboardScreen({
    super.key,
    required this.data,
    required this.onNavigate,
    required this.onQuickAction,
  });

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDay = 'Mon';

  final List<Map<String, String>> _weekDays = [
    {'day': 'Sun', 'date': '09'},
    {'day': 'Mon', 'date': '10'},
    {'day': 'Tue', 'date': '11'},
    {'day': 'Wed', 'date': '12'},
    {'day': 'Thu', 'date': '13'},
    {'day': 'Fri', 'date': '14'},
    {'day': 'Sat', 'date': '15'},
  ];

  Set<String> get _assignedSubjects {
    final profile = widget.data['teacherProfile'] as Map<String, dynamic>? ?? {};
    final list = (profile['assignedSubjects'] as List?)?.map((e) => e.toString()).toSet();
    if (list != null && list.isNotEmpty) return list;
    final classes = widget.data['classes'] as List? ?? [];
    return classes.map((c) => (c['subject'] ?? '').toString()).where((s) => s.isNotEmpty).toSet();
  }

  Set<String> get _assignedClasses {
    final classes = widget.data['classes'] as List? ?? [];
    final set = <String>{};
    for (var c in classes) {
      final name = c['className']?.toString() ?? '';
      final sec = c['section']?.toString() ?? '';
      if (name.isNotEmpty) {
        set.add(name);
        if (sec.isNotEmpty) {
          set.add('$name-$sec');
        }
      }
    }
    return set;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _shiftDay(int delta) {
    final currentIndex = _weekDays.indexWhere((d) => d['day'] == _selectedDay);
    if (currentIndex != -1) {
      final newIndex = (currentIndex + delta).clamp(0, _weekDays.length - 1);
      setState(() {
        _selectedDay = _weekDays[newIndex]['day']!;
      });
    }
  }

  bool _isAssignedSubjectOrClass(String? subject, String? className) {
    if (subject != null && subject.isNotEmpty) {
      final matchesSubject = _assignedSubjects.any((s) => subject.toLowerCase().contains(s.toLowerCase()) || s.toLowerCase().contains(subject.toLowerCase()));
      if (matchesSubject) return true;
    }
    if (className != null && className.isNotEmpty) {
      final matchesClass = _assignedClasses.any((c) => className.toLowerCase().contains(c.toLowerCase()) || c.toLowerCase().contains(className.toLowerCase()));
      if (matchesClass) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.data['quickStats'] as Map<String, dynamic>? ?? {};
    final rawClasses = (widget.data['classes'] as List? ?? []);
    final rawNeedAttention = (widget.data['needAttention'] as List? ?? []);
    final rawExams = (widget.data['examsList'] as List? ?? []);
    final calendarEvents = (widget.data['calendarEvents'] as List? ?? []);
    final timetableData = (widget.data['timetable'] as Map<String, dynamic>? ?? {});

    // Filter strictly to teacher's assigned subjects and classes
    final classesList = rawClasses.where((cls) {
      final subj = cls['subject']?.toString();
      final cName = '${cls['className']}-${cls['section']}';
      return _isAssignedSubjectOrClass(subj, cName);
    }).toList();

    final examsList = rawExams.where((ex) {
      final subj = ex['subject']?.toString();
      final cName = ex['className']?.toString();
      return _isAssignedSubjectOrClass(subj, cName);
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Greeting & Search (No "Term 1")
          _buildHeaderSearchSection(),
          const SizedBox(height: 20),

          // 2. Core Metrics (Clean 2x2 Grid)
          _buildMetricsGrid(stats),
          const SizedBox(height: 24),

          // 3. Quick Actions
          _buildQuickActionsSection(),
          const SizedBox(height: 24),

          // 4. Today's Schedule (Simplified Date Selector & Clean Hierarchy, No "Today" pill)
          _buildTodaysScheduleSection(timetableData),
          const SizedBox(height: 24),

          // 5. Need Attention (Actionable Alerts)
          if (rawNeedAttention.isNotEmpty) ...[
            _buildNeedAttentionSection(rawNeedAttention),
            const SizedBox(height: 24),
          ],

          // 6. Upcoming Exams (Teacher-assigned subjects only)
          if (examsList.isNotEmpty) ...[
            _buildUpcomingExamsSection(examsList),
            const SizedBox(height: 24),
          ],

          // 7. My Classes Overview (No progress bars, Teacher-assigned classes only)
          if (classesList.isNotEmpty) ...[
            _buildMyClassesOverviewSection(classesList),
            const SizedBox(height: 24),
          ],

          // 8. Upcoming Events
          if (calendarEvents.isNotEmpty) ...[
            _buildUpcomingEventsSection(calendarEvents),
          ],
        ],
      ),
    );
  }

  // ─── 1. Header Greeting & Search (No "Term 1") ─────────────────────────────
  Widget _buildHeaderSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, Sarah 👋',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.4,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            Text(
              'Senior Faculty • STEM Department',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 12),
        TeacherSearchBar(
          controller: _searchController,
          hintText: 'Search schedule, classes, exams...',
          onChanged: (val) => setState(() => _searchQuery = val),
          onClear: () => setState(() => _searchQuery = ''),
        ),
      ],
    );
  }

  // ─── 2. Core Metrics (Clean, Spacious 2x2 Grid) ────────────────────────────
  Widget _buildMetricsGrid(Map<String, dynamic> stats) {
    final classesToday = stats['classesToday'] ?? 5;
    final pendingAttendance = stats['pendingAttendance'] ?? 1;
    final assignmentsToReview = stats['assignmentsToReview'] ?? 18;
    final scheduleProgress = stats['scheduleProgress'] ?? '3 / 5';

    final metrics = [
      {
        'title': 'Classes Today',
        'value': '$classesToday',
        'subtitle': '3 Completed',
        'icon': LucideIcons.graduationCap,
        'accentColor': const Color(0xFF3B82F6),
        'navKey': 'classes',
      },
      {
        'title': 'Attendance',
        'value': '$pendingAttendance',
        'subtitle': 'Class Pending',
        'icon': LucideIcons.calendarX2,
        'accentColor': const Color(0xFFEF4444),
        'navKey': 'attendance',
      },
      {
        'title': 'Assignments',
        'value': '$assignmentsToReview',
        'subtitle': 'To Review',
        'icon': LucideIcons.fileCheck2,
        'accentColor': const Color(0xFFF59E0B),
        'navKey': 'assignments',
      },
      {
        'title': "Today's Schedule",
        'value': scheduleProgress.toString(),
        'subtitle': 'Periods Done',
        'icon': LucideIcons.clockCheck,
        'accentColor': const Color(0xFF10B981),
        'navKey': 'timetable',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final item = metrics[index];
        final Color accentColor = item['accentColor'] as Color;

        return InkWell(
          onTap: () => widget.onNavigate(item['navKey'] as String),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.5),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'] as IconData, color: accentColor, size: 16),
                    ),
                    Text(
                      item['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['value'] as String,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── 3. Quick Actions ──────────────────────────────────────────────────────
  Widget _buildQuickActionsSection() {
    final actions = [
      {
        'title': 'Attendance',
        'icon': LucideIcons.calendarCheck,
        'color': const Color(0xFF6C4CF1),
        'actionKey': 'take_attendance',
      },
      {
        'title': 'Homework',
        'icon': LucideIcons.bookPlus,
        'color': const Color(0xFF3B82F6),
        'actionKey': 'create_homework',
      },
      {
        'title': 'Assignment',
        'icon': LucideIcons.filePlus2,
        'color': const Color(0xFF10B981),
        'actionKey': 'create_assignment',
      },
      {
        'title': 'Timetable',
        'icon': LucideIcons.calendarDays,
        'color': const Color(0xFFF59E0B),
        'actionKey': 'view_timetable',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: actions.map((act) {
            final Color color = act['color'] as Color;

            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onQuickAction(act['actionKey'] as String),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(act['icon'] as IconData, color: color, size: 18),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        act['title'] as String,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── 4. Today's Schedule (Simplified & Clean, No "Today" pill) ─────────────
  Widget _buildTodaysScheduleSection(Map<String, dynamic> timetableData) {
    final List rawPeriods = (timetableData[_selectedDay] as List? ?? widget.data['todaysSchedule'] as List? ?? []);

    // Filter to teacher's assigned subjects/classes + search query
    final filteredPeriods = rawPeriods.where((item) {
      final subject = (item['subject'] ?? '').toString();
      final className = (item['className'] ?? item['class'] ?? '').toString();
      if (!_isAssignedSubjectOrClass(subject, className)) return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final room = (item['room'] ?? '').toString().toLowerCase();
      final time = (item['time'] ?? '').toString().toLowerCase();
      return subject.toLowerCase().contains(q) || className.toLowerCase().contains(q) || room.contains(q) || time.contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row (No "Today" badge)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onNavigate('timetable'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Minimal Horizontal Date Selector: ‹ / Sun 09 / Mon 10 ... / ›
        _buildMinimalDateSelector(),
        const SizedBox(height: 10),

        // Compact Schedule Cards (Subject → Class → Time & Location)
        if (filteredPeriods.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                const Icon(LucideIcons.calendarOff, size: 26, color: Color(0xFF94A3B8)),
                const SizedBox(height: 6),
                Text(
                  'No classes scheduled for $_selectedDay',
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
              ],
            ),
          )
        else
          ...filteredPeriods.map((item) => _buildScheduleCard(item)),
      ],
    );
  }

  // Simplified Minimal Horizontal Date Selector
  Widget _buildMinimalDateSelector() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _shiftDay(-1),
          icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6C4CF1), size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 32),
          splashRadius: 16,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.map((d) {
              final isSel = d['day'] == _selectedDay;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = d['day']!),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF6C4CF1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        d['day']!,
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d['date']!,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                          color: isSel ? Colors.white : const Color(0xFF1E1E2D),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        IconButton(
          onPressed: () => _shiftDay(1),
          icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6C4CF1), size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 32),
          splashRadius: 16,
        ),
      ],
    );
  }

  // Compact Schedule Card with clear hierarchy: Subject → Class → Time & Location
  Widget _buildScheduleCard(Map<String, dynamic> item) {
    final String subject = item['subject'] ?? 'Subject';
    final String time = item['time'] ?? '08:30 AM';
    final String className = item['className'] ?? item['class'] ?? 'Class 10';
    final String room = item['room'] ?? 'Room 204';
    final int period = item['period'] ?? 1;

    return InkWell(
      onTap: () => widget.onNavigate('timetable'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0EDF8)),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            // Period Number Badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  'P$period',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Subject, Class, Time & Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          subject,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: Color(0xFF1E1E2D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          className,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 12.5, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 12.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                      ),
                      if (room.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(fontSize: 11.0, color: Color(0xFF94A3B8))),
                        const SizedBox(width: 6),
                        const Icon(LucideIcons.mapPin, size: 12.5, color: Color(0xFF64748B)),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            room,
                            style: const TextStyle(fontSize: 12.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFCDCBE0), size: 18),
          ],
        ),
      ),
    );
  }

  // ─── 5. Need Attention (Actionable Alerts) ──────────────────────────────────
  Widget _buildNeedAttentionSection(List needAttention) {
    final filtered = needAttention.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = (item['title'] ?? '').toString().toLowerCase();
      final desc = (item['desc'] ?? '').toString().toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.alertTriangle, size: 17, color: Color(0xFFEF4444)),
            const SizedBox(width: 6),
            const Text(
              'Need Attention',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${needAttention.length} Urgent',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...filtered.map((item) {
          final isHigh = item['severity'] == 'High';
          final targetScreen = item['targetScreen'] ?? 'attendance';

          return InkWell(
            onTap: () => widget.onNavigate(targetScreen),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: isHigh ? const Color(0xFFFFF9F9) : const Color(0xFFFFFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isHigh ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7),
                ),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isHigh ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      isHigh ? Icons.error_outline_rounded : Icons.info_outline_rounded,
                      color: isHigh ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: isHigh ? const Color(0xFF991B1B) : const Color(0xFF92400E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['desc'] ?? '',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: isHigh ? const Color(0xFF7F1D1D) : const Color(0xFF78350F),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: isHigh ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Action',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── 6. Upcoming Exams (Teacher-assigned subjects only) ────────────────────
  Widget _buildUpcomingExamsSection(List examsList) {
    final filtered = examsList.where((exam) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = (exam['title'] ?? '').toString().toLowerCase();
      final subject = (exam['subject'] ?? '').toString().toLowerCase();
      final className = (exam['className'] ?? '').toString().toLowerCase();
      return title.contains(q) || subject.contains(q) || className.contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Upcoming Exams',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${examsList.length}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => widget.onNavigate('exams'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...filtered.take(3).map((exam) {
          final isPending = exam['status'] == 'Marks Pending';
          final isCompleted = exam['status'] == 'Completed' || exam['status'] == 'Published';
          final String status = exam['status'] ?? 'Upcoming';

          Color statusColor = const Color(0xFF3B82F6);
          Color statusBg = const Color(0xFFEFF6FF);
          if (isPending) {
            statusColor = const Color(0xFFEF4444);
            statusBg = const Color(0xFFFEF2F2);
          } else if (isCompleted) {
            statusColor = const Color(0xFF10B981);
            statusBg = const Color(0xFFECFDF5);
          }

          return InkWell(
            onTap: () => widget.onNavigate('exams'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0EDF8)),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isPending ? const Color(0xFFFEF2F2) : const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      LucideIcons.award,
                      color: isPending ? const Color(0xFFEF4444) : const Color(0xFF6C4CF1),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                exam['subject'] ?? 'Subject',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
                                  color: Color(0xFF1E1E2D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F0FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                exam['className'] ?? 'Class',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C4CF1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          exam['title'] ?? '',
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${exam['date']}${exam['time'] != null ? ' • ${exam['time']}' : ''}',
                          style: const TextStyle(fontSize: 12.0, color: Color(0xFF475569)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── 7. My Classes (No progress bar, Teacher-assigned classes only) ─────────
  Widget _buildMyClassesOverviewSection(List classesList) {
    final filtered = classesList.where((cls) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final subject = (cls['subject'] ?? '').toString().toLowerCase();
      final className = (cls['className'] ?? '').toString().toLowerCase();
      final room = (cls['room'] ?? '').toString().toLowerCase();
      return subject.contains(q) || className.contains(q) || room.contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'My Classes',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${classesList.length} Batches',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => widget.onNavigate('classes'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...filtered.take(3).map((cls) {
          final int studentCount = cls['studentCount'] ?? 34;
          final String className = '${cls['className']}-${cls['section']}';
          final String subject = cls['subject'] ?? 'Subject';
          final String room = cls['room'] ?? 'Room 204';
          final bool isPending = cls['isAttendancePending'] == true;

          return InkWell(
            onTap: () => widget.onNavigate('class_details', arguments: cls),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0EDF8)),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(LucideIcons.bookOpen, color: Color(0xFF6C4CF1), size: 17),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$className • $subject',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: Color(0xFF1E1E2D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$studentCount Students${room.isNotEmpty ? ' • $room' : ''}',
                          style: const TextStyle(fontSize: 12.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPending ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      isPending ? 'Pending' : 'Marked',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isPending ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── 8. Upcoming Events ────────────────────────────────────────────────────
  Widget _buildUpcomingEventsSection(List events) {
    final filtered = events.where((ev) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = (ev['title'] ?? '').toString().toLowerCase();
      final category = (ev['category'] ?? '').toString().toLowerCase();
      final location = (ev['location'] ?? '').toString().toLowerCase();
      return title.contains(q) || category.contains(q) || location.contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${events.length}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => widget.onNavigate('calendar'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...filtered.take(3).map((ev) {
          final String title = ev['title'] ?? 'Event';
          final String date = ev['date'] ?? '15 Aug';
          final String time = ev['time'] ?? '';
          final String category = ev['category'] ?? 'Academic';
          final String location = ev['location'] ?? '';

          IconData iconData = LucideIcons.calendarDays;
          Color iconColor = const Color(0xFF6C4CF1);

          if (category == 'Meetings') {
            iconData = LucideIcons.users;
            iconColor = const Color(0xFF3B82F6);
          } else if (category == 'Holidays') {
            iconData = LucideIcons.flag;
            iconColor = const Color(0xFFEF4444);
          } else if (category == 'Exams') {
            iconData = LucideIcons.award;
            iconColor = const Color(0xFFF59E0B);
          }

          return InkWell(
            onTap: () => widget.onNavigate('calendar'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0EDF8)),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(iconData, size: 17, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Color(0xFF1E1E2D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$date${time.isNotEmpty && time != 'Full Day' ? ' • $time' : ''}${location.isNotEmpty && location != '-' ? ' • $location' : ''}',
                          style: const TextStyle(fontSize: 12.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F8FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFEBE8FF)),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
