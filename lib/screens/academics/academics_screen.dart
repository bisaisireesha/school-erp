import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math' as math;
import '../more/more_screen.dart';

import '../fees/fees_screen.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Academic Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildAcademicOverviewCard(),
              ),
              const SizedBox(height: 32),
              // Subject Performance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSubjectPerformance(),
              ),
              const SizedBox(height: 32),
              // Assignments
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildAssignmentsSection(),
              ),
              const SizedBox(height: 32),
              // Upcoming Exams
              _buildUpcomingExams(),
              const SizedBox(height: 32),
              // Syllabus Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSyllabusProgressSection(),
              ),
              const SizedBox(height: 24),
              // Learning Resources
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildLearningResourcesSection(),
              ),
              const SizedBox(height: 24),
              // Report Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildReportCardsSection(),
              ),
        const SizedBox(height: 120), // Bottom padding for navbar
      ],
    ),
    );
  }


  Widget _buildMiniCard({required IconData icon, required Color color, required String title, required String value, required String total, required String sub}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D), height: 1.1)),
                    Text(total, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, height: 1.3)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(sub, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Text stats
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Academic Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 12),
                    const Text('Overall Average', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7A7A9D))),
                    const Text('86%', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1), height: 1.1)),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Text('Grade: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        Text('A', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF22C55E))),
                        Text('   |   ', style: TextStyle(color: Colors.grey)),
                        Text('Rank: 12 / 45', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.86,
                        minHeight: 8,
                        backgroundColor: Color(0xFFF3EEFF),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("You're doing great! Keep it up! 🌟", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right side: Circular Illustration Placeholder
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF9F7FF)),
                    ),
                    const Icon(Icons.school_rounded, size: 54, color: Color(0xFF6C4CF1)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Bottom side: Two mini cards
          Row(
            children: [
              Expanded(
                child: _buildMiniCard(icon: Icons.assignment_turned_in_rounded, color: const Color(0xFF22C55E), title: 'Assignments', value: '18', total: ' / 20', sub: 'Completed'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(icon: Icons.track_changes_rounded, color: const Color(0xFF3B82F6), title: 'Attendance', value: '92', total: ' %', sub: 'Present'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Subject Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
              Text('View all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 24),
          _buildSubjectRow(icon: Icons.calculate_outlined, color: const Color(0xFF3B82F6), subject: 'Mathematics', percentage: 92, grade: 'A+'),
          const SizedBox(height: 20),
          _buildSubjectRow(icon: Icons.science_outlined, color: const Color(0xFF22C55E), subject: 'Science', percentage: 88, grade: 'A'),
          const SizedBox(height: 20),
          _buildSubjectRow(icon: Icons.menu_book_rounded, color: const Color(0xFFF97316), subject: 'English', percentage: 81, grade: 'B+'),
          const SizedBox(height: 20),
          _buildSubjectRow(icon: Icons.public_outlined, color: const Color(0xFF8B5CF6), subject: 'Social Studies', percentage: 90, grade: 'A+'),
          const SizedBox(height: 20),
          _buildSubjectRow(icon: Icons.computer_outlined, color: const Color(0xFFEC4899), subject: 'Computer', percentage: 95, grade: 'A+'),
        ],
      ),
    );
  }

  Widget _buildSubjectRow({required IconData icon, required Color color, required String subject, required int percentage, required String grade}) {
    return Row(
      children: [
        Container(
          width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(height: 6, decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(3))),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 32,
            child: Text('$percentage%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), textAlign: TextAlign.right),
          ),
          const SizedBox(width: 8),
          Text(grade, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
    );
  }

  Widget _buildSyllabusProgressSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Syllabus Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
              Text('View all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 24),
          FutureBuilder<String>(
            future: rootBundle.loadString('assets/mock/syllabus_progress.json'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
              final data = json.decode(snapshot.data!)['progress'] as List;
              return ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final item = data[index];
                  Color itemColor = Color(int.parse("0xFF${item['colorHex']}"));
                  IconData iconData;
                  switch (item['iconType']) {
                    case 'maths': iconData = Icons.import_contacts_rounded; break;
                    case 'science': iconData = Icons.science_outlined; break;
                    case 'english': iconData = Icons.menu_book_rounded; break;
                    case 'social_studies': iconData = Icons.language_rounded; break;
                    default: iconData = Icons.menu_book_rounded;
                  }
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: itemColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                        child: Icon(iconData, color: itemColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Text(item['subject'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      ),
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(height: 6, decoration: BoxDecoration(color: itemColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(3))),
                            FractionallySizedBox(
                              widthFactor: item['percentage'] / 100,
                              child: Container(height: 6, decoration: BoxDecoration(color: itemColor, borderRadius: BorderRadius.circular(3))),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 32,
                        child: Text('${item['percentage']}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)), textAlign: TextAlign.right),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Assignments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
            Text('View all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
          ],
        ),
        const SizedBox(height: 24),
        
        // Today
        _buildTimelineHeader(title: 'Today – 17 May', color: const Color(0xFFEF4444), hasTopLine: false),
        _buildTimelineItem(
          lineColor: const Color(0xFFEF4444),
          child: _buildAssignmentCard(
            title: 'Maths – Worksheet 12',
            subtitle: 'Due Today, 11:59 PM',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFEF4444),
            status: 'Pending',
            statusColor: const Color(0xFFEF4444),
          ),
        ),
        _buildTimelineItem(
          lineColor: const Color(0xFFEF4444),
          child: _buildAssignmentCard(
            title: 'Science – Lab Record',
            subtitle: 'Due Today, 11:59 PM',
            icon: Icons.science_outlined,
            iconColor: const Color(0xFF22C55E),
            status: 'Pending',
            statusColor: const Color(0xFFEF4444),
          ),
        ),
        
        // Tomorrow
        _buildTimelineHeader(title: 'Tomorrow – 18 May', color: const Color(0xFFF97316), topColor: const Color(0xFFEF4444)),
        _buildTimelineItem(
          lineColor: const Color(0xFFF97316),
          child: _buildAssignmentCard(
            title: 'English – Essay Writing',
            subtitle: 'Due Tomorrow, 11:59 PM',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFF97316),
            status: 'Pending',
            statusColor: const Color(0xFFF97316),
          ),
        ),
        _buildTimelineItem(
          lineColor: const Color(0xFFF97316),
          child: _buildAssignmentCard(
            title: 'Social Studies – Map Work',
            subtitle: 'Due Tomorrow, 11:59 PM',
            icon: Icons.public_outlined,
            iconColor: const Color(0xFF8B5CF6),
            status: 'Pending',
            statusColor: const Color(0xFFF97316),
          ),
        ),
        
        // This Week
        _buildTimelineHeader(title: 'This Week', color: const Color(0xFF3B82F6), topColor: const Color(0xFFF97316)),
        _buildTimelineItem(
          lineColor: const Color(0xFF3B82F6),
          child: _buildAssignmentCard(
            title: 'Computer – Presentation',
            subtitle: 'Due on 20 May, 11:59 PM',
            icon: Icons.desktop_windows_outlined,
            iconColor: const Color(0xFF3B82F6),
            status: 'Upcoming',
            statusColor: const Color(0xFF3B82F6),
          ),
        ),
        _buildTimelineItem(
          lineColor: const Color(0xFF3B82F6),
          child: _buildAssignmentCard(
            title: 'Hindi – Grammar Worksheet',
            subtitle: 'Due on 21 May, 11:59 PM',
            icon: Icons.desktop_windows_outlined,
            iconColor: const Color(0xFF3B82F6),
            status: 'Upcoming',
            statusColor: const Color(0xFF3B82F6),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineHeader({required String title, required Color color, bool hasTopLine = true, Color? topColor}) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasTopLine)
                Positioned(top: 0, bottom: 12, child: Container(width: 2, color: (topColor ?? color).withValues(alpha: 0.3))),
              Positioned(top: 12, bottom: 0, child: Container(width: 2, color: color.withValues(alpha: 0.3))),
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 3), color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  Widget _buildTimelineItem({required Color lineColor, required Widget child}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 16,
            child: Center(
              child: Container(width: 2, color: lineColor.withValues(alpha: 0.3)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Padding(padding: const EdgeInsets.only(top: 16.0, bottom: 8.0), child: child)),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingExams() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Upcoming Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
            ),
            
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: const Color(0xFF6C4CF1), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Upcoming', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF3EEFF))),
                      child: const Text('This Week', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF7A7A9D), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF3EEFF))),
                      child: const Text('This Month', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF7A7A9D), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // List
            FutureBuilder<String>(
              future: rootBundle.loadString('assets/mock/upcoming_exams.json'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(32.0), child: Center(child: CircularProgressIndicator()));
                final data = json.decode(snapshot.data!)['exams'] as List;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Divider(color: Color(0xFFF3EEFF), height: 32, thickness: 1.5),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    Color itemColor = Color(int.parse("0xFF${item['colorHex']}"));
                    return _buildExamListItem(
                      day: item['day'], month: item['month'], color: itemColor, 
                      subject: item['subject'], type: item['type'], daysLeft: item['daysLeft']
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 20),
            // View All Exams Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('View All Exams', style: TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.w800, fontSize: 15)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6C4CF1), size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamListItem({required String day, required String month, required Color color, required String subject, required String type, required String daysLeft}) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color, height: 1.1)),
              Text(month, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(subject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 2),
              Text(type, style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule_rounded, color: color, size: 14),
            const SizedBox(width: 4),
            Text(daysLeft, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ],
    );
  }


  Widget _buildLearningResourcesSection() {
    final List<Map<String, dynamic>> quickAccessData = [
      {'title': 'Recent', 'icon': Icons.access_time_rounded, 'color': const Color(0xFF3B82F6), 'bgColor': const Color(0xFFF4F8FF)},
      {'title': 'Bookmarks', 'icon': Icons.bookmark_border_rounded, 'color': const Color(0xFF3B82F6), 'bgColor': const Color(0xFFF4F8FF)},
      {'title': 'Downloads', 'icon': Icons.arrow_downward_rounded, 'color': const Color(0xFF22C55E), 'bgColor': const Color(0xFFF0FDF4)},
      {'title': 'Shared', 'icon': Icons.share_outlined, 'color': const Color(0xFF3B82F6), 'bgColor': const Color(0xFFF4F8FF)},
    ];

    final List<Map<String, dynamic>> resourceLibraryData = [
      {'title': 'PDF Notes', 'subtitle': '124 Files', 'icon': Icons.article_rounded, 'color': const Color(0xFFEF4444), 'bgColor': const Color(0xFFFFF1F2)},
      {'title': 'Video Lessons', 'subtitle': '86 Videos', 'icon': Icons.smart_display_rounded, 'color': const Color(0xFF22C55E), 'bgColor': const Color(0xFFF0FDF4)},
      {'title': 'Worksheets', 'subtitle': '120 Files', 'icon': Icons.description_rounded, 'color': const Color(0xFF8B5CF6), 'bgColor': const Color(0xFFF5F3FF)},
      {'title': 'Practice Tests', 'subtitle': '45 Tests', 'icon': Icons.assignment_rounded, 'color': const Color(0xFFF97316), 'bgColor': const Color(0xFFFFF7ED)},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Learning Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
              Text('View all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Quick Access', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: quickAccessData.map((data) => _buildQuickAccessItem(data)).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Resource Library', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.1,
            padding: EdgeInsets.zero,
            children: resourceLibraryData.map((data) => _buildResourceLibraryCard(data)).toList(),
          ),
          const SizedBox(height: 12),
          // Sample papers card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.article_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Sample Papers', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      SizedBox(height: 4),
                      Text('32 Papers', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF3B82F6), size: 24),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Explore all resources button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Explore all resources', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: Color(0xFF6C4CF1), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem(Map<String, dynamic> data) {
    return Flexible(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: data['bgColor'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(data['icon'], color: data['color'], size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            data['title'],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceLibraryCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data['bgColor'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data['icon'], color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['title'],
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  data['subtitle'],
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReportCardsSection() {
    final List<Map<String, dynamic>> reportCardsData = [
      {'title': 'Latest Report', 'subtitle': 'Term 1', 'score': '86%', 'grade': 'A', 'icon': Icons.description_outlined, 'color': const Color(0xFF6C4CF1)},
      {'title': 'Term 2', 'subtitle': null, 'score': '88%', 'grade': 'A', 'icon': Icons.event_note_outlined, 'color': const Color(0xFF3B82F6)},
      {'title': 'Half Yearly', 'subtitle': null, 'score': '87%', 'grade': 'A', 'icon': Icons.event_note_outlined, 'color': const Color(0xFF22C55E)},
      {'title': 'Annual', 'subtitle': null, 'score': '89%', 'grade': 'A+', 'icon': Icons.event_note_outlined, 'color': const Color(0xFFF97316)},
    ];

    final List<Map<String, dynamic>> reportActionsData = [
      {'title': 'All Reports', 'icon': Icons.inventory_2_outlined, 'color': const Color(0xFF6C4CF1)},
      {'title': 'Download', 'icon': Icons.download_rounded, 'color': const Color(0xFF3B82F6)},
      {'title': 'Compare', 'icon': Icons.trending_up_rounded, 'color': const Color(0xFF22C55E)},
      {'title': 'History', 'icon': Icons.access_time_rounded, 'color': const Color(0xFFF97316)},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Report Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              Row(
                children: const [
                  Text('View all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: Color(0xFF6C4CF1), size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.85,
            padding: EdgeInsets.zero,
            children: reportCardsData.map((data) => _buildReportCard(data)).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: reportActionsData.map((data) => _buildReportActionItem(data)).toList(),
          ),
          const SizedBox(height: 16),
          // View all report cards button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('View all report cards', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: Color(0xFF6C4CF1), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (data['color'] as Color).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data['icon'], color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['title'],
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (data['subtitle'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    data['subtitle'],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '${data['score']}  |  ${data['grade']}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: data['color']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportActionItem(Map<String, dynamic> data) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (data['color'] as Color).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data['icon'], color: data['color'], size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            data['title'],
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class StatRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - paint.strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Green (Excellent) - Top Left
    paint.color = const Color(0xFF22C55E);
    canvas.drawArc(rect, math.pi, math.pi / 2, false, paint);

    // Light Green (Good) - Top Right
    paint.color = const Color(0xFF4ADE80);
    canvas.drawArc(rect, -math.pi / 2, math.pi / 2, false, paint);

    // Red (Needs Improvement) - Bottom Right
    paint.color = const Color(0xFFEF4444);
    canvas.drawArc(rect, 0, math.pi / 2, false, paint);

    // Yellow (Average) - Bottom Left
    paint.color = const Color(0xFFFBBF24);
    canvas.drawArc(rect, math.pi / 2, math.pi / 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
