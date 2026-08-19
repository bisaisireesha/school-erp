import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math' as math;
import '../main_layout.dart';
import '../homework/homework_screen.dart';
import '../exams/exams_screen.dart';
import '../resources/resources_screen.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> {
  String _selectedExamFilter = 'Upcoming';

  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAcademicsData();
  }

  Future<void> _loadAcademicsData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/parent_academics.json',
      );
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _subjects = List<Map<String, dynamic>>.from(data['subjects']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr));
  }

  IconData _getIcon(String iconStr) {
    switch (iconStr) {
      case 'calculate_outlined':
        return Icons.calculate_outlined;
      case 'science_outlined':
        return Icons.science_outlined;
      case 'menu_book_rounded':
        return Icons.menu_book_rounded;
      case 'public_outlined':
        return Icons.public_outlined;
      case 'computer_outlined':
        return Icons.computer_outlined;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: MainLayout.globalSearchQuery,
      builder: (context, searchQuery, child) {
        final query = searchQuery.toLowerCase();

        if (query.isNotEmpty) {
          // Show filtered subjects
          final filteredSubjects = _subjects
              .where(
                (s) => s['subject'].toString().toLowerCase().contains(query),
              )
              .toList();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildScreenHeader('Academic Overview'),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Subject Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (filteredSubjects.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'No subjects found',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFF3EEFF),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: filteredSubjects
                            .map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: _buildSubjectRow(
                                  icon: _getIcon(s['icon']),
                                  color: _getColor(s['color']),
                                  subject: s['subject'],
                                  percentage: s['percentage'],
                                  grade: s['grade'],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 120),
              ],
            ),
          );
        }

        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C4CF1)),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildScreenHeader('Academic Overview'),
              ),
              const SizedBox(height: 12),
              // Academic Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildAcademicOverviewCard(),
              ),
              const SizedBox(height: 32),
              // Subject Performance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSubjectPerformance(context),
              ),
              const SizedBox(height: 32),
              // Assignments
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildAssignmentsSection(context),
              ),
              const SizedBox(height: 32),
              // Upcoming Exams
              _buildUpcomingExams(context),
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
                child: _buildLearningResourcesSection(context),
              ),
              const SizedBox(height: 24),
              // Report Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildReportCardsSection(context),
              ),
              const SizedBox(height: 120), // Bottom padding for navbar
            ],
          ),
        );
      },
    );
  }

  Widget _buildScreenHeader(String title) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            MainLayout.switchTab(0);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1E1E2D),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String total,
    required String sub,
  }) {
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
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                        height: 1.1,
                      ),
                    ),
                    Text(
                      total,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
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
                    const Text(
                      'Academic Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Overall Average',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A7A9D),
                      ),
                    ),
                    const Text(
                      '86%',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF6C4CF1),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Text(
                          'Grade: ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        Text(
                          'A',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                        Text('   |   ', style: TextStyle(color: Colors.grey)),
                        Text(
                          'Rank: 12 / 45',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.86,
                        minHeight: 8,
                        backgroundColor: Color(0xFFF3EEFF),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You're doing great! Keep it up! 🌟",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A7A9D),
                      ),
                    ),
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF9F7FF),
                      ),
                    ),
                    const Icon(
                      Icons.school_rounded,
                      size: 54,
                      color: Color(0xFF6C4CF1),
                    ),
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
                child: _buildMiniCard(
                  icon: Icons.assignment_turned_in_rounded,
                  color: const Color(0xFF22C55E),
                  title: 'Assignments',
                  value: '18',
                  total: ' / 20',
                  sub: 'Completed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(
                  icon: Icons.track_changes_rounded,
                  color: const Color(0xFF3B82F6),
                  title: 'Attendance',
                  value: '92',
                  total: ' %',
                  sub: 'Present',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformance(BuildContext context) {
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
            children: [
              const Text(
                'Subject Performance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(
                  context,
                  ExamsScreen(onBack: () => MainLayout.popSubScreen(context)),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ..._subjects.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildSubjectRow(
                icon: _getIcon(s['icon']),
                color: _getColor(s['color']),
                subject: s['subject'],
                percentage: s['percentage'],
                grade: s['grade'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow({
    required IconData icon,
    required Color color,
    required String subject,
    required int percentage,
    required String grade,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Text(
            subject,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 32,
          child: Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          grade,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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
              Text(
                'Syllabus Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FutureBuilder<String>(
            future: rootBundle.loadString('assets/mock/syllabus_progress.json'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final data = json.decode(snapshot.data!)['progress'] as List;
              return ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final item = data[index];
                  Color itemColor = Color(int.parse("0xFF${item['colorHex']}"));
                  IconData iconData;
                  switch (item['iconType']) {
                    case 'maths':
                      iconData = Icons.import_contacts_rounded;
                      break;
                    case 'science':
                      iconData = Icons.science_outlined;
                      break;
                    case 'english':
                      iconData = Icons.menu_book_rounded;
                      break;
                    case 'social_studies':
                      iconData = Icons.language_rounded;
                      break;
                    default:
                      iconData = Icons.menu_book_rounded;
                  }
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: itemColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(iconData, color: itemColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Text(
                          item['subject'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: itemColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: item['percentage'] / 100,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: itemColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${item['percentage']}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                          textAlign: TextAlign.right,
                        ),
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

  Widget _buildAssignmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Assignments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E2D),
              ),
            ),
            GestureDetector(
              onTap: () => MainLayout.pushSubScreen(
                context,
                HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
              ),
              child: const Text(
                'View all',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Today
        _buildTimelineHeader(
          title: 'Today – 17 May',
          color: const Color(0xFFEF4444),
          hasTopLine: false,
        ),
        _buildTimelineItem(
          lineColor: const Color(0xFFEF4444),
          child: _buildAssignmentCard(
            title: 'Maths – Worksheet 12',
            subtitle: 'Due Today, 11:59 PM',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFEF4444),
            status: 'Pending',
            statusColor: const Color(0xFFEF4444),
            onTap: () => MainLayout.pushSubScreen(
              context,
              HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
            ),
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
            onTap: () => MainLayout.pushSubScreen(
              context,
              HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
            ),
          ),
        ),

        // Tomorrow
        _buildTimelineHeader(
          title: 'Tomorrow – 18 May',
          color: const Color(0xFFF97316),
          topColor: const Color(0xFFEF4444),
        ),
        _buildTimelineItem(
          lineColor: const Color(0xFFF97316),
          child: _buildAssignmentCard(
            title: 'English – Essay Writing',
            subtitle: 'Due Tomorrow, 11:59 PM',
            icon: Icons.description_outlined,
            iconColor: const Color(0xFFF97316),
            status: 'Pending',
            statusColor: const Color(0xFFF97316),
            onTap: () => MainLayout.pushSubScreen(
              context,
              HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
            ),
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
            onTap: () => MainLayout.pushSubScreen(
              context,
              HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
            ),
          ),
        ),

        // This Week
        _buildTimelineHeader(
          title: 'This Week',
          color: const Color(0xFF3B82F6),
          topColor: const Color(0xFFF97316),
        ),
        _buildTimelineItem(
          lineColor: const Color(0xFF3B82F6),
          child: _buildAssignmentCard(
            title: 'Computer – Presentation',
            subtitle: 'Due on 20 May, 11:59 PM',
            icon: Icons.desktop_windows_outlined,
            iconColor: const Color(0xFF3B82F6),
            status: 'Upcoming',
            statusColor: const Color(0xFF3B82F6),
            onTap: () => MainLayout.pushSubScreen(
              context,
              HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
            ),
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
            onTap: () => MainLayout.pushSubScreen(
              context,
              HomeworkScreen(onBack: () => MainLayout.popSubScreen(context)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineHeader({
    required String title,
    required Color color,
    bool hasTopLine = true,
    Color? topColor,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasTopLine)
                Positioned(
                  top: 0,
                  bottom: 12,
                  child: Container(
                    width: 2,
                    color: (topColor ?? color).withValues(alpha: 0.3),
                  ),
                ),
              Positioned(
                top: 12,
                bottom: 0,
                child: Container(width: 2, color: color.withValues(alpha: 0.3)),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 3),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
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
              child: Container(
                width: 2,
                color: lineColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: child,
            ),
          ),
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingExams(BuildContext context) {
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
              child: const Text(
                'Upcoming Exams',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildExamFilterTab('Upcoming'),
                  const SizedBox(width: 8),
                  _buildExamFilterTab('This Week'),
                  const SizedBox(width: 8),
                  _buildExamFilterTab('This Month'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List
            FutureBuilder<String>(
              future: rootBundle.loadString('assets/mock/upcoming_exams.json'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final allData = json.decode(snapshot.data!)['exams'] as List;

                final data = allData.where((item) {
                  if (_selectedExamFilter == 'Upcoming') return true;
                  final daysLeftStr = item['daysLeft'].toString();
                  final daysMatch = RegExp(r'\d+').firstMatch(daysLeftStr);
                  if (daysMatch != null) {
                    final days = int.parse(daysMatch.group(0)!);
                    if (_selectedExamFilter == 'This Week') return days <= 7;
                    if (_selectedExamFilter == 'This Month') return days <= 30;
                  }
                  return true;
                }).toList();

                if (data.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No exams found.',
                        style: TextStyle(
                          color: Color(0xFF7A7A9D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFF3EEFF),
                    height: 32,
                    thickness: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    Color itemColor = Color(
                      int.parse("0xFF${item['colorHex']}"),
                    );
                    return _buildExamListItem(
                      day: item['day'],
                      month: item['month'],
                      color: itemColor,
                      subject: item['subject'],
                      type: item['type'],
                      daysLeft: item['daysLeft'],
                      onTap: () => MainLayout.pushSubScreen(
                        context,
                        ExamsScreen(
                          onBack: () => MainLayout.popSubScreen(context),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),
            // View All Exams Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () => MainLayout.pushSubScreen(
                  context,
                  ExamsScreen(onBack: () => MainLayout.popSubScreen(context)),
                ),
                behavior: HitTestBehavior.opaque,
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
                      Text(
                        'View All Exams',
                        style: TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF6C4CF1),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamFilterTab(String label) {
    final isSelected = _selectedExamFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedExamFilter = label),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(color: const Color(0xFFF3EEFF)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7A7A9D),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamListItem({
    required String day,
    required String month,
    required Color color,
    required String subject,
    required String type,
    required String daysLeft,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1.1,
                  ),
                ),
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7A9D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                daysLeft,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearningResourcesSection(BuildContext context) {
    final List<Map<String, dynamic>> resourceLibraryData = [
      {
        'title': 'PDF Notes',
        'subtitle': '124 Files',
        'icon': Icons.article_rounded,
        'color': const Color(0xFFEF4444),
        'bgColor': const Color(0xFFFFF1F2),
      },
      {
        'title': 'Video Lessons',
        'subtitle': '86 Videos',
        'icon': Icons.smart_display_rounded,
        'color': const Color(0xFF22C55E),
        'bgColor': const Color(0xFFF0FDF4),
      },
      {
        'title': 'Worksheets',
        'subtitle': '120 Files',
        'icon': Icons.description_rounded,
        'color': const Color(0xFF8B5CF6),
        'bgColor': const Color(0xFFF5F3FF),
      },
      {
        'title': 'Practice Tests',
        'subtitle': '45 Tests',
        'icon': Icons.assignment_rounded,
        'color': const Color(0xFFF97316),
        'bgColor': const Color(0xFFFFF7ED),
      },
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
              const Text(
                'Learning Resources',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(
                  context,
                  ResourcesScreen(
                    onBack: () => MainLayout.popSubScreen(context),
                  ),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...resourceLibraryData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return Column(
              children: [
                _buildSimpleResourceItem(
                  title: data['title'],
                  subtitle: data['subtitle'],
                  icon: data['icon'],
                  color: data['color'],
                  bgColor: data['bgColor'],
                ),
                if (index != resourceLibraryData.length - 1)
                  const Divider(
                    height: 32,
                    thickness: 1,
                    color: Color(0xFFF3EEFF),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSimpleResourceItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: () => MainLayout.pushSubScreen(
        context,
        ResourcesScreen(onBack: () => MainLayout.popSubScreen(context)),
      ),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xFF4A4A68),
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCardsSection(BuildContext context) {
    final List<Map<String, dynamic>> reportCardsData = [
      {
        'title': 'Latest Report',
        'subtitle': 'Term 1 · 2025–26',
        'score': '86%',
        'grade': 'A',
        'icon': Icons.star_rounded,
        'color': const Color(0xFF6C4CF1),
        'subjects': [
          {'name': 'Mathematics', 'marks': 92, 'max': 100, 'grade': 'A+'},
          {'name': 'Science', 'marks': 88, 'max': 100, 'grade': 'A'},
          {'name': 'English', 'marks': 81, 'max': 100, 'grade': 'B+'},
          {'name': 'Social Studies', 'marks': 78, 'max': 100, 'grade': 'B'},
          {'name': 'Computer', 'marks': 95, 'max': 100, 'grade': 'A+'},
        ],
      },
      {
        'title': 'Term 2',
        'subtitle': '2024–25',
        'score': '88%',
        'grade': 'A',
        'icon': Icons.bookmark_rounded,
        'color': const Color(0xFF3B82F6),
        'subjects': [
          {'name': 'Mathematics', 'marks': 90, 'max': 100, 'grade': 'A+'},
          {'name': 'Science', 'marks': 85, 'max': 100, 'grade': 'A'},
          {'name': 'English', 'marks': 86, 'max': 100, 'grade': 'A'},
          {'name': 'Social Studies', 'marks': 80, 'max': 100, 'grade': 'B+'},
          {'name': 'Computer', 'marks': 98, 'max': 100, 'grade': 'A+'},
        ],
      },
      {
        'title': 'Half Yearly',
        'subtitle': '2024–25',
        'score': '87%',
        'grade': 'A',
        'icon': Icons.donut_large_rounded,
        'color': const Color(0xFF22C55E),
        'subjects': [
          {'name': 'Mathematics', 'marks': 89, 'max': 100, 'grade': 'A'},
          {'name': 'Science', 'marks': 91, 'max': 100, 'grade': 'A+'},
          {'name': 'English', 'marks': 84, 'max': 100, 'grade': 'A'},
          {'name': 'Social Studies', 'marks': 77, 'max': 100, 'grade': 'B'},
          {'name': 'Computer', 'marks': 93, 'max': 100, 'grade': 'A+'},
        ],
      },
      {
        'title': 'Annual',
        'subtitle': '2023–24',
        'score': '89%',
        'grade': 'A+',
        'icon': Icons.emoji_events_rounded,
        'color': const Color(0xFFF97316),
        'subjects': [
          {'name': 'Mathematics', 'marks': 94, 'max': 100, 'grade': 'A+'},
          {'name': 'Science', 'marks': 90, 'max': 100, 'grade': 'A+'},
          {'name': 'English', 'marks': 83, 'max': 100, 'grade': 'A'},
          {'name': 'Social Studies', 'marks': 85, 'max': 100, 'grade': 'A'},
          {'name': 'Computer', 'marks': 96, 'max': 100, 'grade': 'A+'},
        ],
      },
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
              const Text(
                'Report Cards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              GestureDetector(
                onTap: () => MainLayout.pushSubScreen(
                  context,
                  ExamsScreen(
                    onBack: () => MainLayout.popSubScreen(context),
                    initialTabIndex: 1,
                  ),
                ),
                child: Row(
                  children: const [
                    Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF6C4CF1),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2x2 grid of report cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            padding: EdgeInsets.zero,
            children: reportCardsData
                .map(
                  (data) => _buildReportCard(
                    data,
                    onTap: () => _showReportCardSheet(context, data),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> data, {VoidCallback? onTap}) {
    final color = data['color'] as Color;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.18), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(data['icon'], color: Colors.white, size: 18),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['grade'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data['score'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportCardSheet(BuildContext context, Map<String, dynamic> data) {
    final color = data['color'] as Color;
    final subjects = data['subjects'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header banner
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.75)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            data['icon'],
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data['score'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Grade ${data['grade']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Subject breakdown
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      'Subject-wise Performance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                  ),

                  ...subjects.map((s) {
                    final pct = (s['marks'] as int) / (s['max'] as int);
                    final subColor = pct >= 0.9
                        ? const Color(0xFF22C55E)
                        : pct >= 0.8
                        ? const Color(0xFF6C4CF1)
                        : pct >= 0.7
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFFF59E0B);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFF3EEFF),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${s['marks']}/${s['max']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: subColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: subColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    s['grade'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: subColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: subColor.withValues(
                                  alpha: 0.1,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  subColor,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // View Full Results button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          MainLayout.pushSubScreen(
                            context,
                            ExamsScreen(
                              onBack: () => MainLayout.popSubScreen(context),
                              initialTabIndex: 1,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'View Full Results',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
