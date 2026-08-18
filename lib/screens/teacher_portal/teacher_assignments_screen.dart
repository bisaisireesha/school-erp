import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';
import 'teacher_create_bottom_sheet.dart';

class TeacherAssignmentsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final Function(Map<String, dynamic> newAssignment)? onAddAssignment;

  const TeacherAssignmentsScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onAddAssignment,
  });

  @override
  State<TeacherAssignmentsScreen> createState() => _TeacherAssignmentsScreenState();
}

class _TeacherAssignmentsScreenState extends State<TeacherAssignmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All';

  late List<Map<String, dynamic>> _assignmentsList;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() {
    final raw = widget.data['assignmentsList'] as List? ?? [];
    final list = raw.map((item) => Map<String, dynamic>.from(item)).toList();
    if (mounted) {
      setState(() {
        _assignmentsList = list;
      });
    } else {
      _assignmentsList = list;
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

  void _showCreateAssignmentModal() {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.assignment,
      classList: _classes,
      subjectList: _subjects,
      onSubmit: (data) {
        final newAsg = {
          'id': 'ASG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'title': data['title'] ?? 'Assignment Project',
          'subject': data['subject'] ?? 'Mathematics',
          'className': data['className'] ?? 'Class 10-A',
          'dueDate': data['dueDate'] ?? '20 Aug 2026',
          'totalMarks': data['totalMarks'] ?? 50,
          'submissionCount': '0 / 34 Submitted',
          'status': 'Open',
          'description': data['description'] ?? '',
        };

        setState(() {
          _assignmentsList.insert(0, newAsg);
        });

        if (widget.onAddAssignment != null) {
          widget.onAddAssignment!(newAsg);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created Assignment "${newAsg['title']}" for ${newAsg['className']}!'),
            backgroundColor: const Color(0xFF6C4CF1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  void _showAssignmentDetails(Map<String, dynamic> asg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          asg['title'] ?? '',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          asg['status'] ?? 'Open',
                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${asg['subject']} • ${asg['className']} • Max Marks: ${asg['totalMarks'] ?? 50}',
                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFF0EDF8)),
                  const SizedBox(height: 14),
                  const Text(
                    'Assignment Brief',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    asg['description'] ?? 'Detailed rubric and research instructions.',
                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Grading & Evaluation Status',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asg['submissionCount'] ?? '18 / 34 Submitted',
                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Close', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _assignmentsList.where((asg) {
      if (_activeFilter == 'Open' && asg['status'] != 'Open') return false;
      if (_activeFilter == 'Grading' && !asg['status'].toString().contains('Grading')) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (asg['title'] ?? '').toString().toLowerCase().contains(q) ||
          (asg['subject'] ?? '').toString().toLowerCase().contains(q) ||
          (asg['className'] ?? '').toString().toLowerCase().contains(q);
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
              // Top Bar Row
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Assignments & Projects',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showCreateAssignmentModal,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              TeacherSearchBar(
                controller: _searchController,
                hintText: 'Search assignment by title, subject, class...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
              const SizedBox(height: 12),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All (${_assignmentsList.length})', 'All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Open', 'Open'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Grading in Progress', 'Grading'),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Assignment Cards
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.fileX2, size: 36, color: Color(0xFF64748B)),
                      SizedBox(height: 10),
                      Text(
                        'No assignments found',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                    ],
                  ),
                )
              else
                ...filtered.map((asg) => _buildAssignmentCard(asg)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
          ),
          boxShadow: isSelected ? AppShadows.soft : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> asg) {
    final isGrading = asg['status'].toString().contains('Grading');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${asg['subject']} • ${asg['className']}',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isGrading ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  asg['status'] ?? 'Open',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: isGrading ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            asg['title'] ?? '',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            asg['description'] ?? '',
            style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Color(0xFF475569), height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0EDF8)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${asg['dueDate']}',
                      style: const TextStyle(fontSize: 13.0, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '• ${asg['submissionCount']}',
                        style: const TextStyle(fontSize: 13.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showAssignmentDetails(asg),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Text('Details', style: TextStyle(color: Color(0xFF6C4CF1), fontSize: 13.0, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6C4CF1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
