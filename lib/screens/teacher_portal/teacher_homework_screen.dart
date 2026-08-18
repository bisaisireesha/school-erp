import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';
import 'teacher_create_bottom_sheet.dart';
import 'teacher_homework_detail_screen.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final Function(Map<String, dynamic> newHomework)? onAddHomework;

  const TeacherHomeworkScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onAddHomework,
  });

  @override
  State<TeacherHomeworkScreen> createState() => _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState extends State<TeacherHomeworkScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All';

  late List<Map<String, dynamic>> _homeworkList;

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  void _loadHomework() {
    final raw = widget.data['homeworkList'] as List? ?? [];
    final list = raw.map((item) => Map<String, dynamic>.from(item)).toList();
    if (mounted) {
      setState(() {
        _homeworkList = list;
      });
    } else {
      _homeworkList = list;
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

  void _showCreateHomeworkModal() {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.homework,
      classList: _classes,
      subjectList: _subjects,
      onSubmit: (data) {
        final newHw = {
          'id': 'HW-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'title': data['title'] ?? 'Homework Task',
          'subject': data['subject'] ?? 'Mathematics',
          'className': data['className'] ?? 'Class 10-A',
          'dueDate': data['dueDate'] ?? '15 Aug 2026',
          'status': 'Active',
          'submittedCount': 0,
          'totalCount': 34,
          'description': data['description'] ?? '',
          'attachments': data['attachments'] ?? 'Worksheet.pdf',
        };

        if (mounted) {
          setState(() {
            _homeworkList.insert(0, newHw);
          });
        }

        if (widget.onAddHomework != null) {
          widget.onAddHomework!(newHw);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created and assigned "${newHw['title']}" to ${newHw['className']}!'),
            backgroundColor: const Color(0xFF6C4CF1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  void _openHomeworkDetail(Map<String, dynamic> hw) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeacherHomeworkDetailScreen(
          homework: hw,
          onUpdate: (updated) {
            if (mounted) {
              setState(() {
                final idx = _homeworkList.indexWhere((item) => item['id'] == updated['id']);
                if (idx != -1) {
                  _homeworkList[idx] = updated;
                }
              });
            }
          },
          onDelete: (id) {
            if (mounted) {
              setState(() {
                _homeworkList.removeWhere((item) => item['id'] == id);
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _homeworkList.where((hw) {
      if (_activeFilter == 'Active' && hw['status'] != 'Active') return false;
      if (_activeFilter == 'Evaluated' && hw['status'] != 'Evaluated') return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (hw['title'] ?? '').toString().toLowerCase().contains(q) ||
          (hw['subject'] ?? '').toString().toLowerCase().contains(q) ||
          (hw['className'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ──────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 4),
                  ],
                  const Expanded(
                    child: Text(
                      'Homework & Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showCreateHomeworkModal,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.plus, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0EEF8)),

            // ── Scrollable Body ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TeacherSearchBar(
                      controller: _searchController,
                      hintText: 'Search by title, subject, or class...',
                      onChanged: (val) {
                        if (mounted) setState(() => _searchQuery = val);
                      },
                      onClear: () {
                        if (mounted) setState(() => _searchQuery = '');
                      },
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips Bar
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildFilterChip('All Tasks (${_homeworkList.length})', 'All'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Active', 'Active'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Evaluated', 'Evaluated'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Homework List Cards
                    if (filtered.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF0EEF8)),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.bookX, size: 32, color: Color(0xFF94A3B8)),
                            SizedBox(height: 10),
                            Text(
                              'No homework tasks found',
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                          ],
                        ),
                      )
                    else
                      ...filtered.map((hw) => _buildHomeworkCard(hw)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _activeFilter == value;
    return GestureDetector(
      onTap: () {
        if (mounted) setState(() => _activeFilter = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF0EEF8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeworkCard(Map<String, dynamic> hw) {
    final bool isEvaluated = hw['status'] == 'Evaluated';
    final int submitted = (hw['submittedCount'] as num?)?.toInt() ?? 26;
    final int total = (hw['totalCount'] as num?)?.toInt() ?? 34;

    return GestureDetector(
      onTap: () => _openHomeworkDetail(hw),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0EEF8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x041E1E2D),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Subject + Class & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${hw['subject']} • ${hw['className']}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: isEvaluated ? const Color(0xFFF0FDF4) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    hw['status'] ?? 'Active',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: isEvaluated ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: Title
            Text(
              hw['title'] ?? '',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Row 3: Short Description
            Text(
              hw['description']?.isNotEmpty == true
                  ? hw['description']
                  : 'Complete assigned worksheet questions and submit solutions.',
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            const Divider(height: 1, color: Color(0xFFF4F3F8)),
            const SizedBox(height: 8),

            // Row 4: Due Date, Submissions Count & Arrow Indicator
            Row(
              children: [
                const Icon(LucideIcons.calendar, size: 13, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(
                  'Due: ${hw['dueDate'] ?? '15 Aug 2026'}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const Spacer(),
                Text(
                  '$submitted/$total Submitted',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6C4CF1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
