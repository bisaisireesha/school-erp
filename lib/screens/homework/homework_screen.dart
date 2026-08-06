import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class HomeworkScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HomeworkScreen({super.key, required this.onBack});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  String _selectedFilter = 'All'; // 'All', 'Submitted', 'Pending'
  DateTime _selectedDate = DateTime(2024, 7, 22);

  String _formatDate(DateTime date) {
    final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${weekdays[date.weekday - 1]}';
  }

  String _formatShortDate(DateTime date) {
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1), 
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
              surface: Colors.white,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.white,
              elevation: 10,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C4CF1),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final List<Map<String, dynamic>> _assignments = [
    {
      'subject': 'English',
      'desc': 'Read Chapter 5 and\npractice reading aloud.',
      'icon': LucideIcons.bookOpen,
      'isToday': true,
      'status': 'Pending',
    },
    {
      'subject': 'Mathematics',
      'desc': 'Complete Worksheet 8',
      'icon': LucideIcons.calculator,
      'isToday': true,
      'status': 'Submitted',
    },
    {
      'subject': 'Science',
      'desc': 'Solar System Project',
      'icon': LucideIcons.flaskConical,
      'isToday': true,
      'status': 'Pending',
    },
    {
      'subject': 'Drawing',
      'desc': 'Draw Water Cycle',
      'icon': LucideIcons.palette,
      'isToday': false,
      'status': 'Submitted',
    },
    {
      'subject': 'Social Studies',
      'desc': 'Learn Chapter 3 - Our Environment',
      'icon': LucideIcons.globe,
      'isToday': false,
      'status': 'Pending',
    },
    {
      'subject': 'Computer',
      'desc': 'Complete Chapter 2 Exercise',
      'icon': LucideIcons.monitor,
      'isToday': false,
      'status': 'Submitted',
    },
    {
      'subject': 'Hindi',
      'desc': 'Learn and write 10 new words',
      'icon': LucideIcons.bookType,
      'isToday': false,
      'status': 'Pending',
    },
    {
      'subject': 'Physical Education',
      'desc': 'Morning Exercise Record',
      'icon': LucideIcons.personStanding,
      'isToday': false,
      'status': 'Submitted',
    },
    {
      'subject': 'General Knowledge',
      'desc': 'Read Current Affairs Page 20',
      'icon': LucideIcons.lightbulb,
      'isToday': false,
      'status': 'Pending',
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _assignmentsCache = {};

  List<Map<String, dynamic>> _getAssignmentsForDate(DateTime date) {
    String key = '${date.year}-${date.month}-${date.day}';
    if (!_assignmentsCache.containsKey(key)) {
       int count = (date.day % 5) + 3; // 3 to 7 items
       List<Map<String, dynamic>> result = [];
       for (int i = 0; i < count; i++) {
         int index = (date.day * 7 + i * 11) % _assignments.length;
         result.add(Map<String, dynamic>.from(_assignments[index]));
       }
       // Ensure at least one 'isToday' true and false for UI variety
       if (result.isNotEmpty) result[0]['isToday'] = true;
       if (result.length > 1) result[1]['isToday'] = false;
       _assignmentsCache[key] = result;
    }
    return _assignmentsCache[key]!;
  }

  @override
  Widget build(BuildContext context) {
    final currentAssignments = _getAssignmentsForDate(_selectedDate);
    
    // Filter logic
    final displayedAssignments = currentAssignments.where((item) {
      if (_selectedFilter == 'All') return true;
      return item['status'] == _selectedFilter;
    }).toList();

    final todays = displayedAssignments.where((item) => item['isToday'] == true).toList();
    final allOthers = displayedAssignments.where((item) => item['isToday'] == false).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                AppBackButton(onPressed: widget.onBack),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Homework & Assignments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Date selector has been moved to the filters row

          // Filters Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _buildFilterButton('All'),
                const SizedBox(width: 12),
                _buildFilterButton('Submitted'),
                const SizedBox(width: 12),
                _buildFilterButton('Pending'),
                const Spacer(),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.calendar, color: Color(0xFF6C4CF1), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _formatShortDate(_selectedDate),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        const SizedBox(width: 4),
                        Icon(LucideIcons.chevronDown, color: const Color(0xFF1E1E2D).withValues(alpha: 0.5), size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Today's Homework Section
          if (todays.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: "Today's Homework",
                    subtitle: "${todays.length} Assignments",
                    icon: LucideIcons.calendarCheck,
                  ),
                  const SizedBox(height: 16),
                  ...todays.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildHomeworkItem(
                        subject: item['subject'],
                        description: item['desc'],
                        icon: item['icon'],
                        status: item['status'],
                        item: item,
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // All Homework Section
          if (allOthers.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: "All Homework",
                    subtitle: "${allOthers.length} Assignments",
                    icon: LucideIcons.calendarDays,
                    showArrow: true,
                  ),
                  const SizedBox(height: 16),
                  ...allOthers.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildHomeworkItem(
                        subject: item['subject'],
                        description: item['desc'],
                        icon: item['icon'],
                        status: item['status'],
                        item: item,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          if (todays.isEmpty && allOthers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Center(
                child: Text(
                  'No assignments found.',
                  style: TextStyle(color: Color(0xFF7A7A9D), fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          const SizedBox(height: 120), // Bottom padding for navbar
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE8E3F8),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF7A7A9D),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle, required IconData icon, bool showArrow = false}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C4CF1), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4A4A68)),
              ),
            ],
          ),
        ),
        if (showArrow) ...[
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, color: Color(0xFF6C4CF1), size: 20),
        ]
      ],
    );
  }

  Widget _buildHomeworkItem({required String subject, required String description, required IconData icon, required String status, required Map<String, dynamic> item}) {
    final isSubmitted = status == 'Submitted';

    return GestureDetector(
      onTap: () => _showHomeworkDetails(context, subject, description, isSubmitted, item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSubmitted ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : const Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSubmitted ? Icons.check_circle_outline_rounded : icon, 
              color: isSubmitted ? const Color(0xFF4CAF50) : const Color(0xFF6C4CF1), 
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7A7A9D), height: 1.3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSubmitted 
                        ? const Color(0xFF4CAF50).withValues(alpha: 0.1) 
                        : const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSubmitted ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showHomeworkDetails(context, subject, description, isSubmitted, item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.eye, color: Color(0xFF6C4CF1), size: 14),
                  const SizedBox(width: 6),
                  const Text(
                    'View Details',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _showHomeworkDetails(BuildContext context, String subject, String description, bool isSubmitted, Map<String, dynamic> item) {
    bool fileSelected = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Close Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSubmitted 
                                  ? const Color(0xFF4CAF50).withValues(alpha: 0.1) 
                                  : const Color(0xFFFF9800).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isSubmitted ? 'Submitted' : 'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSubmitted ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.x, color: Color(0xFF1E1E2D), size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
              if (!isSubmitted) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.clock, color: Color(0xFFFF9800), size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Tomorrow, 11:59 PM',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF9800)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(DateTime(2026, 7, 25)),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7A7A9D)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Description / Instructions
              const Text(
                'Instructions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.fileText, color: Color(0xFF6C4CF1), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D), height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (isSubmitted) ...[
                const Text(
                  'Submitted File',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFBFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.fileText, color: Color(0xFF6C4CF1), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${subject}_Assignment.pdf',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '1.2 MB • Uploaded 2 hours ago',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7A7A9D)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.checkCircle2, color: Color(0xFF4CAF50), size: 20),
                    ],
                  ),
                ),
              ] else ...[
                const Text(
                  'Upload Work',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 12),
                if (fileSelected)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFBFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F0FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.fileText, color: Color(0xFF6C4CF1), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${subject}_Assignment.pdf',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Ready to submit',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7A7A9D)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              fileSelected = false;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: const Icon(LucideIcons.x, color: Color(0xFFEF4444), size: 20),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Upload Options',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                              ),
                              const SizedBox(height: 24),
                              _buildUploadOptionAction(context, LucideIcons.camera, 'Take a Photo', () {
                                setDialogState(() {
                                  fileSelected = true;
                                });
                              }),
                              const SizedBox(height: 16),
                              _buildUploadOptionAction(context, LucideIcons.image, 'Choose from Gallery', () {
                                setDialogState(() {
                                  fileSelected = true;
                                });
                              }),
                              const SizedBox(height: 16),
                              _buildUploadOptionAction(context, LucideIcons.fileText, 'Select a Document', () {
                                setDialogState(() {
                                  fileSelected = true;
                                });
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: CustomPaint(
                    painter: DashedBorderPainter(color: const Color(0xFFC0AFFE), radius: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F0FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.uploadCloud, color: Color(0xFF6C4CF1), size: 24),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Tap to upload file or photo',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'PDF, JPG, PNG up to 10MB',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7A7A9D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Note to Teacher (Optional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  minLines: 1,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
                  decoration: InputDecoration(
                    hintText: 'Type your message here (optional)...',
                    hintStyle: const TextStyle(color: Color(0xFF7A7A9D), fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8E3F8), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8E3F8), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                    ),
                    prefixIcon: const Icon(LucideIcons.messageSquare, color: Color(0xFF6C4CF1), size: 20),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B5EFA), Color(0xFF5A35EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        item['status'] = 'Submitted';
                      });
                    },
                    icon: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                    label: const Text(
                      'Submit Assignment',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  ));
}

  Widget _buildUploadOptionAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the upload options sheet
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6C4CF1), size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.radius = 0.0,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();
    
    for (var measurePath in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
