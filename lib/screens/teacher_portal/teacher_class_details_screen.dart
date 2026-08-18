import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';

class TeacherClassDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> classData;
  final Map<String, dynamic> globalData;
  final VoidCallback onBack;
  final Function(String screenKey, {Map<String, dynamic>? arguments}) onNavigate;

  const TeacherClassDetailsScreen({
    super.key,
    required this.classData,
    required this.globalData,
    required this.onBack,
    required this.onNavigate,
  });

  @override
  State<TeacherClassDetailsScreen> createState() => _TeacherClassDetailsScreenState();
}

class _TeacherClassDetailsScreenState extends State<TeacherClassDetailsScreen> {
  final TextEditingController _studentSearchController = TextEditingController();
  String _studentQuery = '';
  int _activeTab = 0; // 0 = Overview & Actions, 1 = Students Roster, 2 = Homework & Tasks

  @override
  void dispose() {
    _studentSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cls = widget.classData;
    final String targetClassName = '${cls['className']}-${cls['section']}';
    final allStudents = (widget.globalData['students'] as List? ?? []);
    final allHomework = (widget.globalData['homeworkList'] as List? ?? []);

    final classStudents = allStudents.where((s) {
      final sClass = (s['className'] ?? s['classId'] ?? '').toString();
      if (sClass.isNotEmpty &&
          !sClass.toLowerCase().contains(targetClassName.toLowerCase()) &&
          !targetClassName.toLowerCase().contains(sClass.toLowerCase())) {
        return false;
      }
      if (_studentQuery.isEmpty) return true;
      final q = _studentQuery.toLowerCase();
      return (s['name'] ?? '').toString().toLowerCase().contains(q) ||
          (s['rollNo'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    final homeworkList = allHomework.where((hw) {
      final hwClass = (hw['className'] ?? '').toString();
      return hwClass.isEmpty ||
          hwClass.toLowerCase().contains(targetClassName.toLowerCase()) ||
          targetClassName.toLowerCase().contains(hwClass.toLowerCase());
    }).toList();

    final String subject = cls['subject'] ?? 'Mathematics';
    final String className = cls['className'] ?? 'Class 10';
    final String section = cls['section'] != null ? 'Section ${cls['section']}' : '';
    final String room = cls['room'] ?? 'Room 204';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Clean Header (Back → Class Name & Subject)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  AppBackButton(onPressed: widget.onBack),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$className ${section.isNotEmpty ? "• $section" : ""}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$subject • $room',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Simple Tab Navigation (Overview & Actions | Students | Homework)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, 'Overview & Actions'),
                  _buildTabButton(1, 'Students (${classStudents.length})'),
                  _buildTabButton(2, 'Homework (${homeworkList.length})'),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // 3. Tab Content (Simple sections, no clutter, no progress bars)
            Expanded(
              child: _activeTab == 0
                  ? _buildOverviewTab(cls, classStudents.length, homeworkList.length)
                  : _activeTab == 1
                      ? _buildStudentsTab(classStudents)
                      : _buildHomeworkTab(homeworkList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C4CF1).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // ─── TAB 0: OVERVIEW & ACTIONS (Clean, Logical Sections) ───────────────────
  Widget _buildOverviewTab(Map<String, dynamic> cls, int studentCount, int homeworkCount) {
    final String subject = cls['subject'] ?? 'Mathematics';
    final String className = cls['className'] ?? 'Class 10';
    final String section = cls['section'] != null ? 'Section ${cls['section']}' : '';
    final String room = cls['room'] ?? 'Room 204';
    final bool isPending = cls['isAttendancePending'] == true;
    final int count = cls['studentCount'] ?? studentCount;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Class Information Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$className ${section.isNotEmpty ? "($section)" : ""}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPending ? 'Attendance Pending' : 'Attendance Marked',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: isPending ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 14),

                // Info Rows (Subject, Room, Enrolled Students, Teacher)
                _buildInfoRow(LucideIcons.bookOpen, 'Subject', subject),
                const SizedBox(height: 10),
                _buildInfoRow(LucideIcons.mapPin, 'Classroom', room),
                const SizedBox(height: 10),
                _buildInfoRow(LucideIcons.users, 'Enrolled Students', '$count Students'),
                const SizedBox(height: 10),
                _buildInfoRow(LucideIcons.userCheck, 'Allotted Teacher', 'Sarah Williams (Faculty)'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Quick Actions
          const Text(
            'Class Actions',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          // Action Grid: Take Attendance, View Students, Homework, Assignments, Study Material
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildActionCard(
                icon: LucideIcons.calendarCheck,
                title: 'Take Attendance',
                subtitle: isPending ? 'Pending today' : 'Completed',
                color: const Color(0xFF10B981),
                bg: const Color(0xFFECFDF5),
                onTap: () => widget.onNavigate('attendance'),
              ),
              _buildActionCard(
                icon: LucideIcons.users,
                title: 'View Students',
                subtitle: '$count roster entries',
                color: const Color(0xFF6C4CF1),
                bg: const Color(0xFFF3F0FF),
                onTap: () => setState(() => _activeTab = 1),
              ),
              _buildActionCard(
                icon: LucideIcons.bookOpen,
                title: 'Homework',
                subtitle: '$homeworkCount active tasks',
                color: const Color(0xFF8B5CF6),
                bg: const Color(0xFFF5F3FF),
                onTap: () => widget.onNavigate('homework'),
              ),
              _buildActionCard(
                icon: LucideIcons.fileCheck2,
                title: 'Assignments',
                subtitle: 'Projects & rubrics',
                color: const Color(0xFFF59E0B),
                bg: const Color(0xFFFFFBEB),
                onTap: () => widget.onNavigate('assignments'),
              ),
              _buildActionCard(
                icon: LucideIcons.folderClosed,
                title: 'Resources',
                subtitle: 'Files & notes',
                color: const Color(0xFF06B6D4),
                bg: const Color(0xFFECFEFF),
                onTap: () => widget.onNavigate('resources'),
              ),
              _buildActionCard(
                icon: LucideIcons.calendarDays,
                title: 'Class Timetable',
                subtitle: 'Weekly periods',
                color: const Color(0xFF3B82F6),
                bg: const Color(0xFFEFF6FF),
                onTap: () => widget.onNavigate('timetable'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0EDF8)),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_rounded, size: 14, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB 1: STUDENTS ROSTER (Simple Search & Clean Roster Cards) ───────────
  Widget _buildStudentsTab(List students) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: TeacherSearchBar(
            controller: _studentSearchController,
            hintText: 'Search student by name or roll number...',
            onChanged: (val) => setState(() => _studentQuery = val),
            onClear: () => setState(() => _studentQuery = ''),
          ),
        ),
        Expanded(
          child: students.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.users, size: 36, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 8),
                        const Text(
                          'No students match the search query',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try searching by full name or roll no.',
                          style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                  physics: const BouncingScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final stu = students[index];
                    final String attendance = stu['attendance'] ?? 'Present';
                    final bool isPresent = attendance == 'Present';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                stu['rollNo'] ?? '01',
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stu['name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Roll No: ${stu['rollNo']} • Attendance: ${stu['attendanceRate'] ?? "95%"}',
                                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPresent ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              attendance,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: isPresent ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─── TAB 2: HOMEWORK & TASKS (Clean, No Progress Bars) ──────────────────────
  Widget _buildHomeworkTab(List homework) {
    if (homework.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.bookOpenCheck, size: 36, color: Color(0xFF94A3B8)),
              const SizedBox(height: 8),
              const Text(
                'No homework tasks for this class',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create a new homework task from the Homework module.',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      physics: const BouncingScrollPhysics(),
      itemCount: homework.length,
      itemBuilder: (context, index) {
        final hw = homework[index];
        final isEvaluated = hw['status'] == 'Evaluated';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0EDF8)),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      hw['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: isEvaluated ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      hw['status'] ?? 'Active',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: isEvaluated ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ],
              ),
              if ((hw['description'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  hw['description'] ?? '',
                  style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Color(0xFF475569), height: 1.35),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF0EDF8)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text('Due: ${hw['dueDate']}', style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                  const SizedBox(width: 10),
                  Text('• ${hw['submittedCount']}/${hw['totalCount']} Turned In', style: const TextStyle(fontSize: 13.0, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
