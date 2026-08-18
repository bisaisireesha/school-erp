import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_create_bottom_sheet.dart';
import 'teacher_schedule_publication_sheet.dart';

class TeacherExamDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> exam;
  final Map<String, dynamic>? globalData;
  final Function(Map<String, dynamic> updatedExam)? onUpdate;

  const TeacherExamDetailsScreen({
    super.key,
    required this.exam,
    this.globalData,
    this.onUpdate,
  });

  @override
  State<TeacherExamDetailsScreen> createState() => _TeacherExamDetailsScreenState();
}

class _TeacherExamDetailsScreenState extends State<TeacherExamDetailsScreen> {
  late Map<String, dynamic> _exam;
  late List<Map<String, dynamic>> _studentMarks;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _exam = Map<String, dynamic>.from(widget.exam);
    _initStudentMarks();
  }

  void _initStudentMarks() {
    final total = (_exam['totalStudents'] as num?)?.toInt() ?? 34;
    final isAlreadyGraded = _exam['status'] == 'Completed' ||
        _exam['status'] == 'Published' ||
        _exam['status'] == 'Results Published' ||
        _exam['status'] == 'Results Scheduled';
    final graded = (_exam['gradedCount'] as num?)?.toInt() ?? (isAlreadyGraded ? total : 0);
    final maxMarks = (_exam['totalMarks'] as num?)?.toInt() ?? 80;

    // Check if students exist in global data
    final globalStudents = (widget.globalData?['students'] as List?) ?? [];
    final matchingStudents = globalStudents.where((s) {
      final cName = _exam['className']?.toString() ?? '';
      return s['className'] == cName || cName.isEmpty;
    }).toList();

    final defaultNames = [
      'Aarav Sharma', 'Ananya Roy', 'Dev Patel', 'Diya Sengupta',
      'Ethan Vance', 'Ishaan Verma', 'Kavya Menon', 'Liam Connor',
      'Meera Joshi', 'Noah Williams', 'Aditya Rao', 'Bhavna Kapoor',
      'Chetan Saxena', 'Fatima Zahra', 'Gaurav Nair', 'Harshita Sen',
      'Jayant Misra', 'Kritika Anand', 'Lucas Taylor', 'Mason Anderson',
      'Olivia Smith', 'Sophia Martinez', 'James White', 'Mia Clark',
      'Charlotte Lewis', 'Alexander Walker', 'Amelia Allen', 'Henry Young',
      'Harper King', 'Elijah Wright', 'Evelyn Scott', 'Oliver Green',
      'Abigail Adams', 'Daniel Baker'
    ];

    _studentMarks = List.generate(total, (i) {
      final rollStr = (i + 1).toString().padLeft(2, '0');
      String name;
      if (i < matchingStudents.length) {
        name = matchingStudents[i]['name'] ?? 'Student $rollStr';
      } else if (i < defaultNames.length) {
        name = defaultNames[i];
      } else {
        name = 'Student $rollStr';
      }

      final bool isGraded = i < graded;
      int? score;
      String grade = 'Pending';

      if (isGraded) {
        final factor = ((i * 7 + 13) % 25) / 100.0;
        final pct = 0.70 + factor;
        score = (maxMarks * pct).round();
        if (score > maxMarks) score = maxMarks;

        final pctScore = (score / maxMarks) * 100;
        if (pctScore >= 90) {
          grade = 'A+';
        } else if (pctScore >= 80) {
          grade = 'A';
        } else if (pctScore >= 70) {
          grade = 'B+';
        } else if (pctScore >= 60) {
          grade = 'B';
        } else {
          grade = 'C';
        }
      }

      return {
        'rollNo': rollStr,
        'name': name,
        'score': score,
        'maxMarks': maxMarks,
        'grade': grade,
        'isGraded': isGraded,
      };
    });
  }

  List<String> get _classes {
    final classes = widget.globalData?['classes'] as List? ?? [];
    return classes.map((c) => '${c['className']}-${c['section']}').toList();
  }

  List<String> get _subjects {
    final profile = widget.globalData?['teacherProfile'] as Map<String, dynamic>? ?? {};
    final list = (profile['assignedSubjects'] as List?)?.map((e) => e.toString()).toList();
    if (list != null && list.isNotEmpty) return list;
    final classes = widget.globalData?['classes'] as List? ?? [];
    return classes.map((c) => (c['subject'] ?? '').toString()).where((s) => s.isNotEmpty).toSet().toList();
  }

  void _openMarksEntryModal() {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.marks,
      initialData: _exam,
      classList: _classes,
      subjectList: _subjects,
      onSubmit: (resultData) {
        final status = resultData['status'] ?? 'Results Scheduled';
        setState(() {
          _exam['status'] = status;
          _exam['gradedCount'] = _exam['totalStudents'] ?? 34;
          _exam['marksUploaded'] = true;

          if (status == 'Results Scheduled') {
            _exam['scheduledPublishDate'] = resultData['scheduledPublishDate'] ?? '20 Aug 2026';
            _exam['scheduledPublishTime'] = resultData['scheduledPublishTime'] ?? '10:00 AM';
          } else if (status == 'Results Published') {
            _exam['publishedDate'] = resultData['publishedDate'] ?? '20 Aug 2026, 10:00 AM';
          }

          final maxMarks = (_exam['totalMarks'] as num?)?.toInt() ?? 80;
          for (var item in _studentMarks) {
            item['isGraded'] = true;
            if (item['score'] == null) {
              item['score'] = (maxMarks * 0.85).round();
              item['grade'] = 'A';
            }
          }
        });

        widget.onUpdate?.call(_exam);

        if (status == 'Results Scheduled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(LucideIcons.calendarCheck, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Results publication scheduled for ${_exam['scheduledPublishDate']}, ${_exam['scheduledPublishTime']}!',
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
                      'Marks for "${_exam['title']}" published to students & parents!',
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

  void _openScheduleSheet() {
    TeacherSchedulePublicationSheet.show(
      context: context,
      exam: _exam,
      onSchedule: (scheduleResult) {
        setState(() {
          _exam['status'] = 'Results Scheduled';
          _exam['scheduledPublishDate'] = scheduleResult['scheduledPublishDate'] ?? '20 Aug 2026';
          _exam['scheduledPublishTime'] = scheduleResult['scheduledPublishTime'] ?? '10:00 AM';
          _exam['gradedCount'] = _exam['totalStudents'] ?? 34;
          _exam['marksUploaded'] = true;
        });

        widget.onUpdate?.call(_exam);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.calendarCheck, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Results publication scheduled for ${_exam['scheduledPublishDate']}, ${_exam['scheduledPublishTime']}!',
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
      onPublishNow: _publishNow,
    );
  }

  void _publishNow() {
    setState(() {
      _exam['status'] = 'Results Published';
      _exam['publishedDate'] = '20 Aug 2026, 10:00 AM';
      _exam['gradedCount'] = _exam['totalStudents'] ?? 34;
      _exam['marksUploaded'] = true;

      final maxMarks = (_exam['totalMarks'] as num?)?.toInt() ?? 80;
      for (var item in _studentMarks) {
        item['isGraded'] = true;
        if (item['score'] == null) {
          item['score'] = (maxMarks * 0.85).round();
          item['grade'] = 'A';
        }
      }
    });

    widget.onUpdate?.call(_exam);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Marks for "${_exam['title']}" published to students & parents!',
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

  void _cancelSchedule() {
    setState(() {
      _exam['status'] = 'Marks Pending';
      _exam['scheduledPublishDate'] = null;
      _exam['scheduledPublishTime'] = null;
    });

    widget.onUpdate?.call(_exam);

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

  @override
  Widget build(BuildContext context) {
    final status = _exam['status'] ?? 'Upcoming';
    final isPending = status == 'Marks Pending';
    final isScheduled = status == 'Results Scheduled';
    final isPublished = status == 'Results Published' || status == 'Completed' || status == 'Published';
    final int totalStudents = (_exam['totalStudents'] as num?)?.toInt() ?? 34;
    final int gradedCount = (_exam['gradedCount'] as num?)?.toInt() ?? 0;
    final maxMarks = _exam['totalMarks'] ?? 80;
    final scheduledDate = _exam['scheduledPublishDate'] ?? '20 Aug 2026';
    final scheduledTime = _exam['scheduledPublishTime'] ?? '10:00 AM';
    final publishedDate = _exam['publishedDate'] ?? '20 Aug 2026, 10:00 AM';
    final instructions = _exam['instructions'] ?? 'Bring standard geometry kits and scientific calculators. Part A consists of 20 multiple choice questions; Part B contains 5 descriptive problem sets.';

    final filteredStudents = _studentMarks.where((s) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return s['name'].toString().toLowerCase().contains(q) ||
          s['rollNo'].toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AppBackButton(onPressed: () => Navigator.of(context).pop()),
        ),
        title: const Text(
          'Exam Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPending
                  ? const Color(0xFFFEF3C7)
                  : isScheduled
                      ? const Color(0xFFF3F0FF)
                      : isPublished
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isScheduled
                  ? 'Results Scheduled'
                  : isPublished
                      ? 'Results Published'
                      : status,
              style: TextStyle(
                fontSize: 12,
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Exam Header Info Container (Minimal, Clean)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject + Class Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: Text(
                        '${_exam['subject']} • ${_exam['className']}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Exam Title
                    Text(
                      _exam['title'] ?? 'Exam Assessment',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Key Meta Grid: Date/Time & Max Marks
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(LucideIcons.calendarClock, size: 15, color: Color(0xFF64748B)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${_exam['date']} (${_exam['time']})',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF475569),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(LucideIcons.award, size: 15, color: Color(0xFF64748B)),
                            const SizedBox(width: 5),
                            Text(
                              'Max: $maxMarks Marks',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (instructions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFEBE8FF)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.info, size: 14, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              instructions,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF475569),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Publication Status & Actions Banner
              if (isScheduled)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0D8FD)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.calendarClock, size: 18, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Results Scheduled',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ),
                          Text(
                            '$gradedCount/$totalStudents Graded',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Publish on: $scheduledDate • Time: $scheduledTime',
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _openScheduleSheet,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF6C4CF1),
                                side: const BorderSide(color: Color(0xFF6C4CF1)),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Edit Schedule', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancelSchedule,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF64748B),
                                side: const BorderSide(color: Color(0xFFCBD5E1)),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Cancel Schedule', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _publishNow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C4CF1),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Publish Now', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else if (isPublished)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.checkCircle2, size: 18, color: Color(0xFF10B981)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Results Published',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Published on: $publishedDate',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.users, size: 13, color: Color(0xFF10B981)),
                            SizedBox(width: 4),
                            Text(
                              'Live to Parents',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Grading Status',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$gradedCount / $totalStudents Graded',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _openMarksEntryModal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          LucideIcons.edit3,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Enter Marks',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // 3. Simple Student Marks Summary Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Student Marks Summary',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$totalStudents Students',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Student Search Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEBE8FF)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, size: 16, color: Color(0xFF7A7A9D)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(fontSize: 13.0, color: Color(0xFF1E1E2D)),
                        decoration: const InputDecoration(
                          hintText: 'Search student by name or roll number...',
                          hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _searchQuery = ''),
                        child: const Icon(LucideIcons.x, size: 15, color: Color(0xFF7A7A9D)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Student Marks Roster List
              if (filteredStudents.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: const Text(
                    'No students found matching search',
                    style: TextStyle(fontSize: 13.0, color: Color(0xFF64748B)),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final stu = filteredStudents[index];
                    final bool isGraded = stu['isGraded'] == true;
                    final int? score = stu['score'] as int?;
                    final String grade = stu['grade'] as String;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                      ),
                      child: Row(
                        children: [
                          // Roll Number Badge
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              stu['rollNo'],
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Student Name
                          Expanded(
                            child: Text(
                              stu['name'],
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E1E2D),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Score / Pending
                          if (isGraded && score != null) ...[
                            Text(
                              '$score / $maxMarks',
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                grade,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
