import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'subject_performance_screen.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math' as math;
import '../main_layout.dart';
import '../homework/homework_screen.dart';
import '../exams/exams_screen.dart';
import '../exams/report_card_screen.dart';
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
                  SubjectPerformanceScreen(
                    onBack: () => MainLayout.popSubScreen(context),
                    subjects: _subjects,
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
          decoration: const BoxDecoration(
            color: Color(0xFFF3F0FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF6C4CF1), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: Text(
            subject,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFF),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4CF1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 36,
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
        SizedBox(
          width: 24,
          child: Text(
            grade,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C4CF1),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

// ignore: unused_element
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
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('assets/mock/student_homework.json'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final Map<String, dynamic> data = json.decode(snapshot.data!);
        final List<dynamic> assignments = data['assignments'];

        final List<dynamic> today = assignments.where((hw) => hw['isToday'] == true).take(2).toList();
        final List<dynamic> upcoming = assignments.where((hw) => hw['isToday'] == false).take(2).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Homework and Assignments',
                  style: TextStyle(
                    fontSize: 18,
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

            if (today.isNotEmpty) ...[
              _buildTimelineHeader(
                title: 'Today',
                color: const Color(0xFFEF4444),
                hasTopLine: false,
              ),
              ...today.map((hw) {
                final status = hw['status'] as String;
                return _buildTimelineItem(
                  lineColor: const Color(0xFFEF4444),
                  child: _buildAssignmentCard(
                    item: hw,
                    subject: hw['subject'],
                    title: hw['desc']?.toString().replaceAll('\n', ' ') ?? '',
                    isToday: true,
                    status: status,
                    iconColor: status == 'Submitted' ? const Color(0xFF4CAF50) : const Color(0xFF6C4CF1),
                    iconBg: status == 'Submitted' ? const Color(0xFFF0FDF4) : const Color(0xFFF3F0FF),
                    onTap: () => MainLayout.pushSubScreen(
                      context,
                      HomeworkScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                        initialAssignmentToOpen: hw,
                      ),
                    ),
                  ),
                );
              }),
            ],
            
            if (upcoming.isNotEmpty) ...[
              _buildTimelineHeader(
                title: 'Upcoming',
                color: const Color(0xFF6C4CF1),
                topColor: today.isNotEmpty ? const Color(0xFFEF4444) : Colors.transparent,
              ),
              ...upcoming.map((hw) {
                final status = hw['status'] as String;
                return _buildTimelineItem(
                  lineColor: const Color(0xFF6C4CF1),
                  child: _buildAssignmentCard(
                    item: hw,
                    subject: hw['subject'],
                    title: hw['desc']?.toString().replaceAll('\n', ' ') ?? '',
                    isToday: false,
                    status: status,
                    iconColor: status == 'Submitted' ? const Color(0xFF4CAF50) : const Color(0xFF6C4CF1),
                    iconBg: status == 'Submitted' ? const Color(0xFFF0FDF4) : const Color(0xFFF3F0FF),
                    onTap: () => MainLayout.pushSubScreen(
                      context,
                      HomeworkScreen(
                        onBack: () => MainLayout.popSubScreen(context),
                        initialAssignmentToOpen: hw,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }

  
  Widget _buildTimelineHeader({
    required String title,
    required Color color,
    Color? topColor,
    bool hasTopLine = true,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Center(
            child: Column(
              children: [
                if (hasTopLine)
                  Container(
                    width: 2,
                    height: 12,
                    color: topColor?.withValues(alpha: 0.3) ?? color.withValues(alpha: 0.3),
                  )
                else
                  const SizedBox(height: 12),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 12,
                  color: color.withValues(alpha: 0.3),
                ),
              ],
            ),
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
    required Map<String, dynamic> item,
    required String subject,
    required String title,
    required bool isToday,
    required String status,
    required Color iconColor,
    required Color iconBg,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.bookOpen, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: status == 'Submitted'
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: status == 'Submitted'
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFFF9800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isToday ? const Color(0xFFFFF1F0) : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isToday ? 'Due Today' : 'Tomorrow',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isToday ? const Color(0xFFFF5630) : const Color(0xFF4A4A68),
                    ),
                  ),
                ),
              ],
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
                  itemCount: data.length > 3 ? 3 : data.length,
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
                          initialTabIndex: 0,
                          initialExamToOpen: item['type'],
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
                  SubjectPerformanceScreen(
                    onBack: () => MainLayout.popSubScreen(context),
                    subjects: _subjects,
                  ),
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
        'icon': LucideIcons.award,
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
        'icon': LucideIcons.award,
        'color': const Color(0xFF6C4CF1),
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
        'icon': LucideIcons.award,
        'color': const Color(0xFF6C4CF1),
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
        'icon': LucideIcons.award,
        'color': const Color(0xFF6C4CF1),
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
                    onTap: () => MainLayout.pushSubScreen(
                      context,
                      ReportCardScreen(
                        title: data['title'],
                        onBack: () => MainLayout.popSubScreen(context),
                      ),
                    ),
                  ),
                ).toList(),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              LucideIcons.calendar,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class PerformanceChartPainter extends CustomPainter {
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
