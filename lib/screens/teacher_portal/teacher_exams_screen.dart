import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';
import 'teacher_create_bottom_sheet.dart';
import 'teacher_schedule_publication_sheet.dart';
import 'teacher_exam_details_screen.dart';

class TeacherExamsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final Function(Map<String, dynamic> updatedExam)? onUpdateExam;

  const TeacherExamsScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onUpdateExam,
  });

  @override
  State<TeacherExamsScreen> createState() => _TeacherExamsScreenState();
}

class _TeacherExamsScreenState extends State<TeacherExamsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  late List<Map<String, dynamic>> _exams;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  void _loadExams() {
    final raw = widget.data['examsList'] as List? ?? [];
    final list = raw.map((item) => Map<String, dynamic>.from(item)).toList();
    if (mounted) {
      setState(() {
        _exams = list;
      });
    } else {
      _exams = list;
    }
  }

  List<String> get _classes {
    final classes = widget.data['classes'] as List? ?? [];
    return classes.map((c) => '${c['className']}-${c['section']}').toList();
  }

  List<String> get _subjects {
    final profile = widget.data['teacherProfile'] as Map<String, dynamic>? ?? {};
    final list = (profile['assignedSubjects'] as List?)?.map((e) => e.toString()).toList();
    if (list != null && list.isNotEmpty) return list;
    final classes = widget.data['classes'] as List? ?? [];
    return classes.map((c) => (c['subject'] ?? '').toString()).where((s) => s.isNotEmpty).toSet().toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openMarksEntry(Map<String, dynamic> exam) {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.marks,
      initialData: exam,
      classList: _classes,
      subjectList: _subjects,
      onSubmit: (resultData) {
        final status = resultData['status'] ?? 'Results Scheduled';
        setState(() {
          exam['status'] = status;
          exam['gradedCount'] = exam['totalStudents'] ?? 34;
          exam['marksUploaded'] = true;
          if (status == 'Results Scheduled') {
            exam['scheduledPublishDate'] = resultData['scheduledPublishDate'] ?? '20 Aug 2026';
            exam['scheduledPublishTime'] = resultData['scheduledPublishTime'] ?? '10:00 AM';
          } else if (status == 'Results Published') {
            exam['publishedDate'] = resultData['publishedDate'] ?? '20 Aug 2026, 10:00 AM';
          }
        });

        widget.onUpdateExam?.call(exam);

        if (status == 'Results Scheduled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(LucideIcons.calendarCheck, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Results publication scheduled for ${exam['scheduledPublishDate']}, ${exam['scheduledPublishTime']}!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF6C4CF1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Marks for "${exam['title']}" published to students & parents!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
    );
  }

  void _openScheduleSheet(Map<String, dynamic> exam) {
    TeacherSchedulePublicationSheet.show(
      context: context,
      exam: exam,
      onSchedule: (scheduleResult) {
        setState(() {
          exam['status'] = 'Results Scheduled';
          exam['scheduledPublishDate'] = scheduleResult['scheduledPublishDate'] ?? '20 Aug 2026';
          exam['scheduledPublishTime'] = scheduleResult['scheduledPublishTime'] ?? '10:00 AM';
          exam['gradedCount'] = exam['totalStudents'] ?? 34;
          exam['marksUploaded'] = true;
        });

        widget.onUpdateExam?.call(exam);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.calendarCheck, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Results publication scheduled for ${exam['scheduledPublishDate']}, ${exam['scheduledPublishTime']}!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF6C4CF1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      onPublishNow: () {
        _publishNow(exam);
      },
    );
  }

  void _publishNow(Map<String, dynamic> exam) {
    setState(() {
      exam['status'] = 'Results Published';
      exam['publishedDate'] = '20 Aug 2026, 10:00 AM';
      exam['gradedCount'] = exam['totalStudents'] ?? 34;
      exam['marksUploaded'] = true;
    });

    widget.onUpdateExam?.call(exam);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Marks for "${exam['title']}" published to students & parents!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _cancelSchedule(Map<String, dynamic> exam) {
    setState(() {
      exam['status'] = 'Marks Pending';
      exam['scheduledPublishDate'] = null;
      exam['scheduledPublishTime'] = null;
    });

    widget.onUpdateExam?.call(exam);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.xCircle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Publication schedule cancelled. Marks remain saved.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF475569),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _openExamDetails(Map<String, dynamic> exam) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeacherExamDetailsScreen(
          exam: exam,
          globalData: widget.data,
          onUpdate: (updated) {
            setState(() {
              final idx = _exams.indexWhere((e) => e['id'] == updated['id']);
              if (idx != -1) {
                _exams[idx] = updated;
              }
            });
            widget.onUpdateExam?.call(updated);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _exams.where((e) => e['status'] == 'Marks Pending').length;
    final scheduledCount = _exams.where((e) => e['status'] == 'Results Scheduled').length;
    final publishedCount = _exams.where((e) => e['status'] == 'Results Published' || e['status'] == 'Completed' || e['status'] == 'Published').length;

    final filtered = _exams.where((e) {
      final status = e['status'] ?? '';
      if (_selectedCategory == 'Upcoming' && status != 'Upcoming') return false;
      if (_selectedCategory == 'Marks Pending' && status != 'Marks Pending') return false;
      if (_selectedCategory == 'Results Scheduled' && status != 'Results Scheduled') return false;
      if (_selectedCategory == 'Completed' &&
          status != 'Completed' &&
          status != 'Published' &&
          status != 'Results Published' &&
          status != 'Results Scheduled') {
        return false;
      }
      if (_selectedCategory == 'Published' && status != 'Published' && status != 'Results Published' && status != 'Completed') return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (e['title'] ?? '').toString().toLowerCase().contains(q) ||
          (e['subject'] ?? '').toString().toLowerCase().contains(q) ||
          (e['className'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Exams & Gradebook',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Simple Compact Summary Row (Replaces 4 KPI Cards)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      icon: LucideIcons.award,
                      text: '${_exams.length} Exams',
                      color: const Color(0xFF6C4CF1),
                    ),
                    Container(width: 1, height: 16, color: const Color(0xFFEBE8FF)),
                    _buildSummaryItem(
                      icon: LucideIcons.clock,
                      text: '$pendingCount Marks Pending',
                      color: const Color(0xFFD97706),
                    ),
                    Container(width: 1, height: 16, color: const Color(0xFFEBE8FF)),
                    _buildSummaryItem(
                      icon: scheduledCount > 0 ? LucideIcons.calendarClock : LucideIcons.checkCircle2,
                      text: scheduledCount > 0
                          ? '$scheduledCount Scheduled'
                          : '$publishedCount Completed',
                      color: scheduledCount > 0
                          ? const Color(0xFF6C4CF1)
                          : const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search Bar
              TeacherSearchBar(
                controller: _searchController,
                hintText: 'Search exams by title, class, or subject...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
              const SizedBox(height: 12),

              // Horizontal Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All Exams', 'All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Upcoming', 'Upcoming'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Marks Pending', 'Marks Pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Scheduled', 'Results Scheduled'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed', 'Completed'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Exam Cards List
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.award, size: 36, color: Color(0xFFB0B0CC)),
                      SizedBox(height: 10),
                      Text(
                        'No exams found for this filter',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filtered.map((exam) => _buildExamCard(exam)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedCategory == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    final status = exam['status'] ?? 'Upcoming';
    final isPending = status == 'Marks Pending';
    final isScheduled = status == 'Results Scheduled';
    final isPublished = status == 'Results Published' || status == 'Completed' || status == 'Published';
    final gradedCount = exam['gradedCount'] ?? 0;
    final totalStudents = exam['totalStudents'] ?? 34;
    final scheduledDate = exam['scheduledPublishDate'] ?? '20 Aug 2026';
    final scheduledTime = exam['scheduledPublishTime'] ?? '10:00 AM';

    return GestureDetector(
      onTap: () => _openExamDetails(exam),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0EDF8)),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Subject + Class & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${exam['subject']} • ${exam['className']}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isPending
                        ? const Color(0xFFFEF3C7)
                        : isScheduled
                            ? const Color(0xFFF3F0FF)
                            : isPublished
                                ? const Color(0xFFECFDF5)
                                : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isScheduled
                        ? 'Results Scheduled'
                        : isPublished
                            ? 'Results Published'
                            : status,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: isPending
                          ? const Color(0xFFD97706)
                          : isScheduled
                              ? const Color(0xFF6C4CF1)
                              : isPublished
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Row 2: Exam Name
            Text(
              exam['title'] ?? '',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),

            // Row 3: Date & Time + Max Marks
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${exam['date']} • ${exam['time']}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Max: ${exam['totalMarks']}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF1E1E2D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Scheduled Result Info Notice (if scheduled)
            if (isScheduled) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEBE8FF)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendarClock, size: 14, color: Color(0xFF6C4CF1)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Publish on: $scheduledDate, $scheduledTime',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF0EDF8)),
            const SizedBox(height: 10),

            // Row 4: Grading Progress & Contextual Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$gradedCount/$totalStudents Graded',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                if (isPending)
                  ElevatedButton.icon(
                    onPressed: () => _openMarksEntry(exam),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(LucideIcons.edit3, size: 14, color: Colors.white),
                    label: const Text(
                      'Enter Marks',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (isScheduled)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () => _openScheduleSheet(exam),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6C4CF1),
                          side: const BorderSide(color: Color(0xFFEBE8FF)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      OutlinedButton(
                        onPressed: () => _cancelSchedule(exam),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64748B),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () => _publishNow(exam),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Publish Now',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                else if (isPublished)
                  OutlinedButton.icon(
                    onPressed: () => _openExamDetails(exam),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFFD1FAE5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(LucideIcons.fileText, size: 14, color: Color(0xFF10B981)),
                    label: const Text(
                      'View Results',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () => _openExamDetails(exam),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFEBE8FF)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFF64748B)),
                    label: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
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
}
