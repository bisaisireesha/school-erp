import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TeacherHomeworkDetailScreen extends StatefulWidget {
  final Map<String, dynamic> homework;
  final VoidCallback? onBack;
  final Function(Map<String, dynamic> updatedHomework)? onUpdate;
  final Function(String id)? onDelete;

  const TeacherHomeworkDetailScreen({
    super.key,
    required this.homework,
    this.onBack,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<TeacherHomeworkDetailScreen> createState() =>
      _TeacherHomeworkDetailScreenState();
}

class _TeacherHomeworkDetailScreenState
    extends State<TeacherHomeworkDetailScreen> {
  late Map<String, dynamic> _hw;

  // Mock student roster for submissions
  late List<Map<String, dynamic>> _roster;

  @override
  void initState() {
    super.initState();
    _hw = Map<String, dynamic>.from(widget.homework);
    _initRoster();
  }

  void _initRoster() {
    final int submittedCount = (_hw['submittedCount'] as num?)?.toInt() ?? 26;
    final int totalCount = (_hw['totalCount'] as num?)?.toInt() ?? 34;

    final sampleNames = [
      'Ethan Harris', 'Olivia Smith', 'Liam Johnson', 'Emma Davis',
      'Noah Wilson', 'Ava Brown', 'Sophia Martinez', 'Lucas Taylor',
      'Mason Anderson', 'Isabella Thomas', 'James White', 'Mia Clark',
      'Benjamin Hall', 'Charlotte Lewis', 'Alexander Walker', 'Amelia Allen',
      'Henry Young', 'Harper King', 'Elijah Wright', 'Evelyn Scott',
      'Oliver Green', 'Abigail Adams', 'Daniel Baker', 'Emily Nelson',
      'Michael Carter', 'Ella Mitchell', 'Logan Perez', 'Avery Roberts',
      'Jackson Turner', 'Scarlett Phillips', 'Sebastian Campbell', 'Grace Parker',
      'Jack Evans', 'Chloe Edwards'
    ];

    _roster = List.generate(totalCount, (i) {
      final isSubmitted = i < submittedCount;
      final rollStr = (i + 1).toString().padLeft(2, '0');
      final name = i < sampleNames.length ? sampleNames[i] : 'Student $rollStr';

      return {
        'rollNo': rollStr,
        'name': name,
        'status': isSubmitted ? 'Turned In' : 'Pending',
        'time': isSubmitted ? '12 Aug, ${(i % 12) + 1}:30 PM' : 'Not submitted',
        'file': isSubmitted ? 'HW_${name.replaceAll(' ', '_')}.pdf' : null,
        'marks': isSubmitted ? '${(40 + (i % 10))}/50' : null,
      };
    });
  }

  void _handleDownloadAttachment(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E1E2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Saved $fileName to Downloads',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete Homework Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E1E2D))),
        content: Text('Are you sure you want to delete "${_hw['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              widget.onDelete?.call(_hw['id'] ?? '');
              Navigator.pop(context); // return to list
            },
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleEdit() {
    final titleCtrl = TextEditingController(text: _hw['title']);
    final descCtrl = TextEditingController(text: _hw['description']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Edit Homework Task',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 14),
            const Text('Task Title', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            const SizedBox(height: 6),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Instructions', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            const SizedBox(height: 6),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    _hw['title'] = titleCtrl.text.trim();
                    _hw['description'] = descCtrl.text.trim();
                  });
                  widget.onUpdate?.call(_hw);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Homework updated successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmissionsRoster() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SubmissionsRosterSheet(roster: _roster, taskTitle: _hw['title'] ?? 'Homework'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int submitted = (_hw['submittedCount'] as num?)?.toInt() ?? 26;
    final int total = (_hw['totalCount'] as num?)?.toInt() ?? 34;
    final int pending = total - submitted;
    final bool isEvaluated = _hw['status'] == 'Evaluated';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  AppBackButton(onPressed: widget.onBack ?? () => Navigator.pop(context)),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Task Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleEdit,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F7FC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.edit2, size: 16, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _handleDelete,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFEE2E2)),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Main Task Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
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
                          // Badges Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_hw['subject']} • ${_hw['className']}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C4CF1),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isEvaluated ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _hw['status'] ?? 'Active',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: isEvaluated ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            _hw['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Dates Info Row
                          Row(
                            children: [
                              const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF6C4CF1)),
                              const SizedBox(width: 5),
                              Text(
                                'Due on ${_hw['dueDate'] ?? '15 Aug 2026'}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                              ),
                              const SizedBox(width: 12),
                              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFCBD5E1), shape: BoxShape.circle)),
                              const SizedBox(width: 12),
                              const Text(
                                'Assigned: 10 Aug 2026',
                                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: Color(0xFFF0EEF8)),
                          const SizedBox(height: 14),

                          // Description / Instructions
                          const Text(
                            'Instructions',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _hw['description']?.isNotEmpty == true
                                ? _hw['description']
                                : 'Complete all questions in the attached practice sheet. Show detailed working for Section B problems.',
                            style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), height: 1.45),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Attachments Section
                    const Text(
                      'Attached Resources',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EEF8)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(LucideIcons.fileText, color: Color(0xFFEF4444), size: 19),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _hw['attachments'] ?? 'Trigonometry_Worksheet_Ch4.pdf',
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'PDF Document • 2.4 MB',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _handleDownloadAttachment(_hw['attachments'] ?? 'Trigonometry_Worksheet_Ch4.pdf'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F0FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.download, size: 13, color: Color(0xFF6C4CF1)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Download',
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Submissions Summary Section
                    const Text(
                      'Submission Status',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
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
                        children: [
                          Row(
                            children: [
                              // 26 Submitted Chip
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$submitted',
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF16A34A)),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Submitted',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF15803D)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // 8 Pending Chip
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFBEB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$pending',
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFD97706)),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Pending',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB45309)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Linear Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total > 0 ? (submitted / total) : 0,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // View Submissions Button
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: _showSubmissionsRoster,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C4CF1),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(LucideIcons.users, size: 16, color: Colors.white),
                              label: const Text(
                                'View Submissions Roster',
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Submissions Roster Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _SubmissionsRosterSheet extends StatefulWidget {
  final List<Map<String, dynamic>> roster;
  final String taskTitle;

  const _SubmissionsRosterSheet({required this.roster, required this.taskTitle});

  @override
  State<_SubmissionsRosterSheet> createState() => _SubmissionsRosterSheetState();
}

class _SubmissionsRosterSheetState extends State<_SubmissionsRosterSheet> {
  String _filter = 'All';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.roster.where((s) {
      if (_filter == 'Submitted' && s['status'] != 'Turned In') return false;
      if (_filter == 'Pending' && s['status'] != 'Pending') return false;
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return (s['name'] ?? '').toString().toLowerCase().contains(q) ||
          (s['rollNo'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student Submissions',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                      ),
                      Text(
                        widget.taskTitle,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Filter Tabs & Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: ['All', 'Submitted', 'Pending'].map((f) {
                      final isSel = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF6C4CF1) : const Color(0xFFF8F7FC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Search in roster
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7FC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF0EEF8)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _search = val),
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E1E2D)),
                decoration: const InputDecoration(
                  hintText: 'Search student name or roll...',
                  hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
          ),

          // Student List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, index) => const Divider(height: 1, color: Color(0xFFF8F7FC)),
              itemBuilder: (ctx, i) {
                final s = filtered[i];
                final isTurnedIn = s['status'] == 'Turned In';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isTurnedIn ? const Color(0xFFF0FDF4) : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            s['rollNo'] ?? '01',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isTurnedIn ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s['name'] ?? '',
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s['time'] ?? '',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: isTurnedIn ? const Color(0xFFF0FDF4) : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          s['status'] ?? 'Pending',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isTurnedIn ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
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
      ),
    );
  }
}
