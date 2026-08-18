import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/teacher_attachment_picker.dart';

enum TeacherCreateType { homework, assignment, studyMaterial, marks }

class TeacherCreateBottomSheet extends StatefulWidget {
  final TeacherCreateType type;
  final Map<String, dynamic>? initialData;
  final List<String>? classList;
  final List<String>? subjectList;
  final Function(Map<String, dynamic> data) onSubmit;

  const TeacherCreateBottomSheet({
    super.key,
    required this.type,
    this.initialData,
    this.classList,
    this.subjectList,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required TeacherCreateType type,
    Map<String, dynamic>? initialData,
    List<String>? classList,
    List<String>? subjectList,
    required Function(Map<String, dynamic> data) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TeacherCreateBottomSheet(
        type: type,
        initialData: initialData,
        classList: classList,
        subjectList: subjectList,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<TeacherCreateBottomSheet> createState() => _TeacherCreateBottomSheetState();
}

class _TeacherCreateBottomSheetState extends State<TeacherCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _marksController;

  late String _selectedClass;
  late String _selectedSubject;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 3));
  String _selectedFileType = 'PDF';
  List<AttachedFile> _attachments = [
    const AttachedFile(
      id: 'init-1',
      name: 'Trigonometry_ProblemSet_Ch4.pdf',
      size: '2.4 MB',
      type: 'pdf',
    ),
  ];

  List<String> get _classes => widget.classList ?? const ['Class 10-A', 'Class 10-B', 'Class 9-C'];
  List<String> get _subjects => widget.subjectList ?? const ['Mathematics', 'Physics'];

  // Marks Entry & Scheduling Flow State
  int _marksStep = 0; // 0 = Enter Marks, 1 = Schedule Result Publication
  late DateTime _scheduledPublishDate;
  late TimeOfDay _scheduledPublishTime;
  late List<Map<String, dynamic>> _studentMarksList;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
    _marksController = TextEditingController(text: widget.initialData?['totalMarks']?.toString() ?? '80');

    final initialClassName = widget.initialData?['className'];
    if (initialClassName != null && _classes.contains(initialClassName)) {
      _selectedClass = initialClassName;
    } else {
      _selectedClass = _classes.isNotEmpty ? _classes.first : 'Class 10-A';
    }

    final initialSubj = widget.initialData?['subject'];
    if (initialSubj != null && _subjects.contains(initialSubj)) {
      _selectedSubject = initialSubj;
    } else {
      _selectedSubject = _subjects.isNotEmpty ? _subjects.first : 'Mathematics';
    }

    final int maxMarks = int.tryParse(widget.initialData?['totalMarks']?.toString() ?? '') ?? 80;
    _studentMarksList = [
      {'name': 'Ethan Harris', 'roll': '01', 'marks': '${(maxMarks * 0.90).round()}', 'max': maxMarks},
      {'name': 'Olivia Smith', 'roll': '02', 'marks': '${(maxMarks * 0.96).round()}', 'max': maxMarks},
      {'name': 'Liam Johnson', 'roll': '03', 'marks': '${(maxMarks * 0.84).round()}', 'max': maxMarks},
      {'name': 'Emma Davis', 'roll': '04', 'marks': '${(maxMarks * 0.98).round()}', 'max': maxMarks},
      {'name': 'Noah Wilson', 'roll': '05', 'marks': '${(maxMarks * 0.78).round()}', 'max': maxMarks},
      {'name': 'Ava Brown', 'roll': '06', 'marks': '${(maxMarks * 0.94).round()}', 'max': maxMarks},
      {'name': 'Sophia Martinez', 'roll': '07', 'marks': '${(maxMarks * 0.88).round()}', 'max': maxMarks},
      {'name': 'Lucas Taylor', 'roll': '08', 'marks': '${(maxMarks * 0.82).round()}', 'max': maxMarks},
    ];

    _scheduledPublishDate = DateTime.now().add(const Duration(days: 3));
    _scheduledPublishTime = const TimeOfDay(hour: 10, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.type) {
      case TeacherCreateType.homework:
        return 'Assign New Homework';
      case TeacherCreateType.assignment:
        return 'Create Assignment';
      case TeacherCreateType.studyMaterial:
        return 'Upload Study Material';
      case TeacherCreateType.marks:
        return _marksStep == 0 ? 'Upload & Record Exam Marks' : 'Schedule Result Publication';
    }
  }

  String get _buttonText {
    switch (widget.type) {
      case TeacherCreateType.homework:
        return 'Publish Homework';
      case TeacherCreateType.assignment:
        return 'Create & Assign';
      case TeacherCreateType.studyMaterial:
        return 'Upload Document';
      case TeacherCreateType.marks:
        return 'Save Marks';
    }
  }

  void _handleSaveMarks() {
    final int maxMarks = int.tryParse(widget.initialData?['totalMarks']?.toString() ?? '') ?? 80;

    // Validate marks inputs
    for (var stu in _studentMarksList) {
      final marksVal = int.tryParse(stu['marks']?.toString() ?? '');
      if (marksVal == null || marksVal < 0 || marksVal > maxMarks) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Marks for "${stu['name']}" must be between 0 and $maxMarks.'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
    }

    // Successfully validated: Immediately transition to Schedule Result Publication
    setState(() {
      _marksStep = 1;
    });
  }

  void _handleConfirmSchedule() {
    final dateStr = _formatDate(_scheduledPublishDate);
    final timeStr = _formatTime(_scheduledPublishTime);

    widget.onSubmit({
      'examId': widget.initialData?['id'] ?? 'EXM-302',
      'marksData': _studentMarksList,
      'status': 'Results Scheduled',
      'scheduledPublishDate': dateStr,
      'scheduledPublishTime': timeStr,
    });
    Navigator.pop(context);
  }

  void _handlePublishNow() {
    widget.onSubmit({
      'examId': widget.initialData?['id'] ?? 'EXM-302',
      'marksData': _studentMarksList,
      'status': 'Results Published',
      'publishedDate': '20 Aug 2026, 10:00 AM',
    });
    Navigator.pop(context);
  }

  void _handleSubmit() {
    if (widget.type == TeacherCreateType.marks) {
      if (_marksStep == 0) {
        _handleSaveMarks();
      } else {
        _handleConfirmSchedule();
      }
      return;
    }

    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{
        'title': _titleController.text.trim(),
        'className': _selectedClass,
        'subject': _selectedSubject,
        'description': _descriptionController.text.trim(),
      };

      if (widget.type == TeacherCreateType.homework) {
        data['dueDate'] = '${_selectedDueDate.day} ${_monthName(_selectedDueDate.month)} ${_selectedDueDate.year}';
        data['attachments'] = _attachments.isNotEmpty ? _attachments.map((f) => f.name).join(', ') : 'Worksheet.pdf';
        data['status'] = 'Active';
      } else if (widget.type == TeacherCreateType.assignment) {
        data['dueDate'] = '${_selectedDueDate.day} ${_monthName(_selectedDueDate.month)} ${_selectedDueDate.year}';
        data['totalMarks'] = int.tryParse(_marksController.text) ?? 50;
        data['attachments'] = _attachments.isNotEmpty ? _attachments.map((f) => f.name).join(', ') : 'Rubric.pdf';
        data['status'] = 'Open';
      } else if (widget.type == TeacherCreateType.studyMaterial) {
        data['fileType'] = _selectedFileType;
        data['fileSize'] = _attachments.isNotEmpty ? _attachments.first.size : '4.2 MB';
        data['fileName'] = _attachments.isNotEmpty ? _attachments.first.name : 'Document.pdf';
        data['uploadDate'] = '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}';
        data['downloads'] = 0;
      }

      widget.onSubmit(data);
      Navigator.pop(context);
    }
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _pickPublishDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduledPublishDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
        _scheduledPublishDate = picked;
      });
    }
  }

  Future<void> _pickPublishTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _scheduledPublishTime,
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
        _scheduledPublishTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
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

            // Header Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.type == TeacherCreateType.marks && _marksStep == 1)
                  GestureDetector(
                    onTap: () => setState(() => _marksStep = 0),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF6C4CF1)),
                    ),
                  ),
                Expanded(
                  child: Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F0FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF6C4CF1)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF0EDF8)),
            const SizedBox(height: 16),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.type == TeacherCreateType.marks)
                        _marksStep == 0
                            ? _buildMarksEntrySection()
                            : _buildSchedulePublicationSection()
                      else ...[
                        // Title Field
                        _buildLabel('Title'),
                        TextFormField(
                          controller: _titleController,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                          decoration: _inputDecoration(
                            hint: widget.type == TeacherCreateType.homework
                                ? 'e.g. Chapter 4 Practice Problems'
                                : widget.type == TeacherCreateType.assignment
                                    ? 'e.g. Real-world Trigonometry Portfolio'
                                    : 'e.g. Math Quadratic Notes Part 1',
                            prefixIcon: LucideIcons.fileText,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Class and Subject Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Class & Section'),
                                  _buildDropdown(
                                    value: _classes.contains(_selectedClass) ? _selectedClass : _classes.first,
                                    items: _classes,
                                    onChanged: (val) => setState(() => _selectedClass = val!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Subject'),
                                  _buildDropdown(
                                    value: _subjects.contains(_selectedSubject) ? _selectedSubject : _subjects.first,
                                    items: _subjects,
                                    onChanged: (val) => setState(() => _selectedSubject = val!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Due Date Picker (for Homework & Assignment)
                        if (widget.type == TeacherCreateType.homework || widget.type == TeacherCreateType.assignment) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Due Submission Date'),
                                    GestureDetector(
                                      onTap: _pickDate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F8FF),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: const Color(0xFFEBE8FF)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(LucideIcons.calendar, size: 17, color: Color(0xFF6C4CF1)),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${_selectedDueDate.day} ${_monthName(_selectedDueDate.month)} ${_selectedDueDate.year}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E1E2D)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.type == TeacherCreateType.assignment) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Total Marks'),
                                      TextFormField(
                                        controller: _marksController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                        decoration: _inputDecoration(hint: '50', prefixIcon: LucideIcons.award),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Study Material: File type selector
                        if (widget.type == TeacherCreateType.studyMaterial) ...[
                          _buildLabel('Resource File Format'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ['PDF', 'Slides (PPTX)', 'Doc (Word)', 'Video Link'].map((type) {
                                final isSel = _selectedFileType == type;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedFileType = type),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSel ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSel ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
                                      ),
                                    ),
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: isSel ? Colors.white : const Color(0xFF1E1E2D),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Description Field
                        _buildLabel('Description & Instructions'),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 14.0, color: Color(0xFF1E1E2D)),
                          decoration: _inputDecoration(
                            hint: 'Provide clear instructions, rubric details, or student expectations...',
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Unified Drag & Drop / Browse Attachment Component
                        TeacherAttachmentPicker(
                          label: 'Attachments & Resources',
                          initialFiles: _attachments,
                          onChanged: (files) {
                            setState(() {
                              _attachments = files;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Standard Submit Button for other forms
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text(
                              _buttonText,
                              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
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

  // ─── Step 1: Marks Entry List Form ─────────────────────────────────────────
  Widget _buildMarksEntrySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Student Roster Marks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color(0xFF1E1E2D))),
            Text('Class: $_selectedClass', style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 13.0)),
          ],
        ),
        const SizedBox(height: 12),
        ..._studentMarksList.asMap().entries.map((entry) {
          final idx = entry.key;
          final stu = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F8FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEBE8FF)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                  child: Text(stu['roll'], style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    stu['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
                  ),
                ),
                SizedBox(
                  width: 55,
                  height: 34,
                  child: TextFormField(
                    initialValue: stu['marks'],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _studentMarksList[idx]['marks'] = v,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
                const SizedBox(width: 6),
                Text('/ ${stu['max']}', style: const TextStyle(fontSize: 13.0, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
              ],
            ),
          );
        }),
        const SizedBox(height: 20),

        // Primary Save Marks Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _handleSaveMarks,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(LucideIcons.save, size: 16, color: Colors.white),
            label: const Text(
              'Save Marks',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── Step 2: Schedule Result Publication Form ──────────────────────────────
  Widget _buildSchedulePublicationSection() {
    final dateStr = _formatDate(_scheduledPublishDate);
    final timeStr = _formatTime(_scheduledPublishTime);
    final examTitle = widget.initialData?['title'] ?? 'Exam Assessment';
    final totalStudents = widget.initialData?['totalStudents'] ?? 34;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Marks Saved Confirmation Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: const Row(
            children: [
              Icon(LucideIcons.checkCircle2, size: 18, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                'Marks Saved ✓',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF065F46),
                ),
              ),
              Spacer(),
              Text(
                'Ready to Schedule',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF047857),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Exam Target Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F8FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEBE8FF)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.award, size: 16, color: Color(0xFF6C4CF1)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$examTitle ($_selectedSubject • $_selectedClass)',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Date & Time Picker Pickers
        Row(
          children: [
            // Date Picker
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Publish Date',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickPublishDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Time Picker
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Publish Time',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickPublishTime,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.clock, size: 16, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              timeStr,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Live Confirmation Summary Card
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
                  const Icon(LucideIcons.calendarClock, size: 16, color: Color(0xFF6C4CF1)),
                  const SizedBox(width: 6),
                  const Text(
                    'Results scheduled',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$totalStudents students',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFE0D8FD)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Publish on: ',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Time: ',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Action Buttons Row
        Row(
          children: [
            // Publish Now Option
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: _handlePublishNow,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6C4CF1),
                  side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Publish Now',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Primary Schedule Publication Button
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: _handleConfirmSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Schedule Publication',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEBE8FF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF6C4CF1)),
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 17, color: const Color(0xFF6C4CF1)) : null,
      filled: true,
      fillColor: const Color(0xFFF9F8FF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
    );
  }
}
