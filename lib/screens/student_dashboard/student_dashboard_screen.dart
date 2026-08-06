import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey) onNavigate;

  const StudentDashboardScreen({
    super.key,
    required this.data,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final profile = data['studentProfile'] ?? {};
    final stats = data['quickStats'] ?? {};
    final subjects = data['subjects'] as List? ?? [];
    final homework = data['homework'] as List? ?? [];
    final timetable = data['timetable']?['periods'] as List? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Student Profile Welcome Card
          _buildWelcomeCard(profile),
          const SizedBox(height: 12),

          // Quick Stats Grid (Compact 8pt grid)
          _buildQuickStats(stats),
          const SizedBox(height: 12),

          // Today's Timetable Preview
          _buildTimetablePreview(timetable),
          const SizedBox(height: 12),

          // Pending Assignments Card
          _buildAssignmentsCard(homework),
          const SizedBox(height: 12),

          // Enrolled Subjects Overview
          _buildSubjectsOverview(subjects),
          const SizedBox(height: 90), // Bottom padding for floating nav bar
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(Map<String, dynamic> profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C4CF1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(LucideIcons.user, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${profile['name']?.split(' ')[0] ?? 'Student'}! 👋',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${profile['gradeClass'] ?? 'Class 10-A'} • Roll No: ${profile['rollNo'] ?? 24}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${profile['schoolName'] ?? 'Sunrise International Academy'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Attendance',
            '${stats['attendance']}%',
            LucideIcons.userCheck,
            const Color(0xFF10B981),
            () => onNavigate('attendance'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatItem(
            'Pending HW',
            '${stats['pendingAssignments']}',
            LucideIcons.fileText,
            const Color(0xFFF59E0B),
            () => onNavigate('homework'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatItem(
            'Next Exam',
            'In ${stats['nextExamDays']} Days',
            LucideIcons.calendarCheck,
            const Color(0xFF3B82F6),
            () => onNavigate('exams'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF7A7A9D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetablePreview(List timetable) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Schedule',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                onPressed: () => onNavigate('timetable'),
                child: const Text('View All', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (timetable.isEmpty)
            const Text('No classes scheduled today', style: TextStyle(color: Color(0xFF7A7A9D), fontSize: 12))
          else
            Column(
              children: timetable.take(3).map((item) {
                final isActive = item['active'] == true;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFF3EEFF) : const Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive ? const Color(0xFF6C4CF1) : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFE2E2F0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.clock,
                          size: 14,
                          color: isActive ? Colors.white : const Color(0xFF4A4A68),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['subject'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                              ),
                            ),
                            Text(
                              '${item['time']} • ${item['room']}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D)),
                            ),
                          ],
                        ),
                      ),
                      if (isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C4CF1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'LIVE NOW',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsCard(List homework) {
    final pending = homework.where((h) => h['status'] == 'Pending').toList();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Deadlines',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                onPressed: () => onNavigate('homework'),
                child: const Text('Homework Hub', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (pending.isEmpty)
            const Text('All homework completed! Great job! 🎉', style: TextStyle(color: Color(0xFF10B981), fontSize: 12))
          else
            Column(
              children: pending.take(2).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.fileText, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            Text(
                              '${item['subject']} • Due: ${item['dueDate']}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: const Size(50, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () => onNavigate('homework'),
                        child: const Text('Submit', style: TextStyle(fontSize: 11, color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectsOverview(List subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Subjects & Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
              onPressed: () => onNavigate('subjects'),
              child: const Text('All Subjects', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final sub = subjects[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(LucideIcons.bookOpen, color: Color(0xFF6C4CF1), size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sub['name'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Syllabus: ${sub['progress']}%',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF7A7A9D)),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (sub['progress'] ?? 0) / 100,
                            backgroundColor: const Color(0xFFE2E2F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                            minHeight: 5,
                          ),
                        ),
                      ],
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
}
