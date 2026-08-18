import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';

class _ClassAttendanceState {
  int updateCount; // 0, 1, 2
  String? lastUpdatedTime;
  bool isEditing;

  _ClassAttendanceState({
    this.updateCount = 0,
    this.lastUpdatedTime,
  }) : isEditing = false;
}

class TeacherAttendanceScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final Function(String classId, List<Map<String, dynamic>> attendanceRecords)? onSubmitAttendance;

  const TeacherAttendanceScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onSubmitAttendance,
  });

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedClass = 'Class 10-A';
  DateTime _selectedDate = DateTime.now();

  late List<Map<String, dynamic>> _students;

  // Track edit count & submission state per class (Max 2 updates per day)
  final Map<String, _ClassAttendanceState> _classUpdateStates = {
    'Class 10-A': _ClassAttendanceState(updateCount: 0),
    'Class 10-B': _ClassAttendanceState(updateCount: 1, lastUpdatedTime: '10:30 AM'),
    'Class 9-C': _ClassAttendanceState(updateCount: 0),
  };

  List<String> get _classList {
    final classes = widget.data['classes'] as List? ?? [];
    final list = classes.map((c) => '${c['className']}-${c['section']}').toList();
    return list.isNotEmpty ? list : ['Class 10-A', 'Class 10-B', 'Class 9-C'];
  }

  _ClassAttendanceState get _currentClassState {
    return _classUpdateStates.putIfAbsent(_selectedClass, () => _ClassAttendanceState());
  }

  @override
  void initState() {
    super.initState();
    final list = _classList;
    if (list.isNotEmpty) {
      _selectedClass = list.first;
    }
    _loadStudents();
  }

  void _loadStudents() {
    final rawStudents = widget.data['students'] as List? ?? [];
    final list = rawStudents.map((s) {
      final map = Map<String, dynamic>.from(s);
      final att = map['attendance'];
      if (att == null || (att != 'Absent' && att != 'Late' && att != 'Leave')) {
        map['attendance'] = 'Present';
      } else if (att == 'Leave') {
        map['attendance'] = 'Late';
      }
      return map;
    }).toList();

    if (mounted) {
      setState(() {
        _students = list;
      });
    } else {
      _students = list;
    }
  }

  List<Map<String, dynamic>> get _currentClassStudents {
    return _students.where((s) {
      final sClass = (s['className'] ?? '').toString();
      if (sClass.isEmpty) return true;
      return sClass.toLowerCase().contains(_selectedClass.toLowerCase()) ||
          _selectedClass.toLowerCase().contains(sClass.toLowerCase());
    }).toList();
  }

  bool get _isAllPresent {
    final classStudents = _currentClassStudents;
    if (classStudents.isEmpty) return false;
    return classStudents.every((s) => s['attendance'] == 'Present');
  }

  void _setAttendanceStatus(int studentIndex, String status) {
    // If class has reached max 2 edits and is not editing, ignore
    if (_currentClassState.updateCount >= 2) return;
    if (_currentClassState.updateCount == 1 && !_currentClassState.isEditing) return;

    setState(() {
      _students[studentIndex]['attendance'] = status;
    });
  }

  void _markAll(String status) {
    if (_currentClassState.updateCount >= 2) return;
    if (_currentClassState.updateCount == 1 && !_currentClassState.isEditing) return;

    setState(() {
      for (var s in _students) {
        final sClass = (s['className'] ?? '').toString();
        if (sClass.isEmpty ||
            sClass.toLowerCase().contains(_selectedClass.toLowerCase()) ||
            _selectedClass.toLowerCase().contains(sClass.toLowerCase())) {
          s['attendance'] = status;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All $_selectedClass students marked as $status'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  int get _presentCount => _currentClassStudents.where((s) => s['attendance'] == 'Present').length;
  int get _absentCount => _currentClassStudents.where((s) => s['attendance'] == 'Absent').length;
  int get _lateCount => _currentClassStudents.where((s) => s['attendance'] == 'Late' || s['attendance'] == 'Leave').length;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _changeDate(int dayDelta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: dayDelta));
    });
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today, ${date.day} ${months[date.month - 1]}';
    }
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _currentTimeString() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _handleAttendanceSubmit() {
    final state = _currentClassState;
    if (state.updateCount >= 2) return;

    final updatedTime = _currentTimeString();
    setState(() {
      state.updateCount += 1;
      state.lastUpdatedTime = updatedTime;
      state.isEditing = false;
    });

    if (widget.onSubmitAttendance != null) {
      widget.onSubmitAttendance!(_selectedClass, _students);
    }

    final remaining = 2 - state.updateCount;
    final message = remaining > 0
        ? 'Attendance updated at $updatedTime ($remaining edit remaining today)'
        : 'Attendance finalized at $updatedTime (Editing locked for today)';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
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

  void _startEditing() {
    setState(() {
      _currentClassState.isEditing = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classStudents = _currentClassStudents;
    final filteredStudents = classStudents.where((s) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (s['name'] ?? '').toString().toLowerCase().contains(q) ||
          (s['rollNo'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    final state = _currentClassState;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Standard Left-Aligned Title with Back button if available)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 6.0),
              child: Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 4),
                  ],
                  const Text(
                    'Class Attendance',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Assigned Class Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: _classList.map((cls) {
                  final isSelected = cls == _selectedClass;
                  final clsState = _classUpdateStates[cls];
                  final bool hasSubmitted = (clsState?.updateCount ?? 0) > 0;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedClass = cls),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
                        ),
                        boxShadow: isSelected ? AppShadows.soft : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cls,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 13.0,
                            ),
                          ),
                          if (hasSubmitted) ...[
                            const SizedBox(width: 5),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : const Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 6.0),

            // 3. Attendance Status Banner (State 1 & 2: Updated time, edits remaining)
            _buildUpdateStatusBanner(state),

            // 4. Date Switcher, Live Counts, and Mark All Present Action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // Date Switcher
                    GestureDetector(
                      onTap: _pickDate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _changeDate(-1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.chevron_left_rounded, size: 18, color: Color(0xFF64748B)),
                            ),
                          ),
                          const Icon(LucideIcons.calendar, size: 13.5, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 4.0),
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _changeDate(1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14.0),

                    // Compact Live Counts
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSummaryText('P', '$_presentCount', const Color(0xFF10B981)),
                        const SizedBox(width: 8.0),
                        _buildSummaryText('A', '$_absentCount', const Color(0xFFEF4444)),
                        const SizedBox(width: 8.0),
                        _buildSummaryText('L', '$_lateCount', const Color(0xFFF59E0B)),
                      ],
                    ),
                    const SizedBox(width: 14.0),

                    // Mark All Present Action (With Reactive Highlight State)
                    _buildMarkAllPresentButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // 5. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TeacherSearchBar(
                controller: _searchController,
                hintText: 'Search student by name or roll number...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
            ),
            const SizedBox(height: 8.0),

            // 6. Student List
            Expanded(
              child: filteredStudents.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.userX, size: 36, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 8.0),
                            const Text(
                              'No students found',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'No students match "$_searchQuery"',
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 130.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredStudents.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0EDF8),
                      ),
                      itemBuilder: (context, index) {
                        final stu = filteredStudents[index];
                        final originalIndex = _students.indexOf(stu);
                        return _buildStudentRow(stu, originalIndex);
                      },
                    ),
            ),
          ],
        ),
      ),

      // 7. Attendance Update Bottom Bar with Multi-State Handling
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(bottom: 90.0),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1E2D).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: _buildBottomCTA(state),
        ),
      ),
    );
  }

  // ─── UPDATE STATUS BANNER ──────────────────────────────────────────────────
  Widget _buildUpdateStatusBanner(_ClassAttendanceState state) {
    if (state.updateCount == 0) {
      return const SizedBox.shrink();
    }

    final bool isLocked = state.updateCount >= 2;
    final int remaining = isLocked ? 0 : 2 - state.updateCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFF8F9FA) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isLocked ? const Color(0xFFE2E8F0) : const Color(0xFFBBF7D0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isLocked ? LucideIcons.shieldCheck : LucideIcons.checkCircle,
            size: 16,
            color: isLocked ? const Color(0xFF64748B) : const Color(0xFF16A34A),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Attendance Updated • Today at ${state.lastUpdatedTime ?? "10:30 AM"}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? const Color(0xFF334155) : const Color(0xFF15803D),
                  ),
                ),
                Text(
                  isLocked
                      ? 'Attendance can no longer be edited today.'
                      : '$remaining edit remaining today',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isLocked ? const Color(0xFF64748B) : const Color(0xFF166534),
                  ),
                ),
              ],
            ),
          ),
          if (!isLocked && !state.isEditing)
            GestureDetector(
              onTap: _startEditing,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.edit2, size: 12, color: Color(0xFF15803D)),
                    SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── MARK ALL PRESENT BUTTON WITH REACTIVE STATE ───────────────────────────
  Widget _buildMarkAllPresentButton() {
    final bool isHighlighted = _isAllPresent;
    final bool isLocked = _currentClassState.updateCount >= 2 ||
        (_currentClassState.updateCount == 1 && !_currentClassState.isEditing);

    return GestureDetector(
      onTap: isLocked ? null : () => _markAll('Present'),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFF10B981)
              : (isLocked ? const Color(0xFFF1F5F9) : Colors.white),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isHighlighted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          ),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHighlighted ? LucideIcons.checkCheck : LucideIcons.check,
              size: 13.0,
              color: isHighlighted ? Colors.white : (isLocked ? const Color(0xFF94A3B8) : const Color(0xFF10B981)),
            ),
            const SizedBox(width: 4.0),
            Text(
              'Mark All Present',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                color: isHighlighted ? Colors.white : (isLocked ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM CTA BUTTON (BEFORE SUBMIT, EDITING, LOCKED) ───────────────────
  Widget _buildBottomCTA(_ClassAttendanceState state) {
    if (state.updateCount == 0) {
      // Before first submission
      return SizedBox(
        height: AppSpacing.buttonHeight,
        child: ElevatedButton.icon(
          onPressed: _handleAttendanceSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C4CF1),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          icon: const Icon(LucideIcons.checkCheck, size: 18, color: Colors.white),
          label: const Text(
            'Update Attendance',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (state.updateCount == 1) {
      if (state.isEditing) {
        // Teacher is performing 2nd and final edit
        return SizedBox(
          height: AppSpacing.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: _handleAttendanceSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            icon: const Icon(LucideIcons.checkCheck, size: 18, color: Colors.white),
            label: const Text(
              'Save & Submit Final Update',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else {
        // After 1st update, prompt to edit if needed
        return SizedBox(
          height: AppSpacing.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: _startEditing,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6C4CF1),
              side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            icon: const Icon(LucideIcons.edit2, size: 17, color: Color(0xFF6C4CF1)),
            label: const Text(
              'Edit Attendance (1 edit left)',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } else {
      // After second update — disabled state (subtle and non-error)
      return Container(
        height: AppSpacing.buttonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.lock, size: 16, color: Color(0xFF64748B)),
            SizedBox(width: 8),
            Text(
              'Attendance Submitted • Editing Closed Today',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSummaryText(String label, String count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 3.0),
        Text(
          count,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ─── STUDENT ROW ──────────────────────────────────────────────────────────
  Widget _buildStudentRow(Map<String, dynamic> stu, int originalIndex) {
    final String status = stu['attendance'] ?? 'Present';
    final bool isPresent = status == 'Present';
    final bool isAbsent = status == 'Absent';
    final bool isLate = status == 'Late' || status == 'Leave';

    final bool isLocked = _currentClassState.updateCount >= 2 ||
        (_currentClassState.updateCount == 1 && !_currentClassState.isEditing);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Roll Number Badge
          Container(
            width: 34.0,
            height: 34.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                stu['rollNo'] ?? '01',
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),

          // 2. Student Name
          Expanded(
            child: Text(
              stu['name'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
                color: isLocked ? const Color(0xFF475569) : const Color(0xFF1E1E2D),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10.0),

          // 3. Segmented P / A / L Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAttendanceChip('P', isPresent, const Color(0xFF10B981), isLocked, () {
                _setAttendanceStatus(originalIndex, 'Present');
              }),
              const SizedBox(width: 6.0),
              _buildAttendanceChip('A', isAbsent, const Color(0xFFEF4444), isLocked, () {
                _setAttendanceStatus(originalIndex, 'Absent');
              }),
              const SizedBox(width: 6.0),
              _buildAttendanceChip('L', isLate, const Color(0xFFF59E0B), isLocked, () {
                _setAttendanceStatus(originalIndex, 'Late');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChip(
    String label,
    bool isSelected,
    Color activeColor,
    bool isLocked,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 38.0,
        height: 34.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isLocked ? activeColor.withValues(alpha: 0.8) : activeColor)
              : const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: isSelected && !isLocked
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.22),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
