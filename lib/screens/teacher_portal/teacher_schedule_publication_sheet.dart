import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TeacherSchedulePublicationSheet extends StatefulWidget {
  final Map<String, dynamic> exam;
  final Function(Map<String, dynamic> scheduleResult) onSchedule;
  final VoidCallback onPublishNow;

  const TeacherSchedulePublicationSheet({
    super.key,
    required this.exam,
    required this.onSchedule,
    required this.onPublishNow,
  });

  static Future<void> show({
    required BuildContext context,
    required Map<String, dynamic> exam,
    required Function(Map<String, dynamic> scheduleResult) onSchedule,
    required VoidCallback onPublishNow,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TeacherSchedulePublicationSheet(
        exam: exam,
        onSchedule: onSchedule,
        onPublishNow: onPublishNow,
      ),
    );
  }

  @override
  State<TeacherSchedulePublicationSheet> createState() =>
      _TeacherSchedulePublicationSheetState();
}

class _TeacherSchedulePublicationSheetState
    extends State<TeacherSchedulePublicationSheet> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    // Default to +3 days at 10:00 AM or use existing schedule
    _selectedDate = DateTime.now().add(const Duration(days: 3));
    _selectedTime = const TimeOfDay(hour: 10, minute: 0);

    final existingDateStr = widget.exam['scheduledPublishDate'];
    if (existingDateStr != null && existingDateStr is String) {
      // Try parsing if possible or keep default
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
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
      initialDate: _selectedDate,
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
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
        _selectedTime = picked;
      });
    }
  }

  void _handleConfirmSchedule() {
    final dateStr = _formatDate(_selectedDate);
    final timeStr = _formatTime(_selectedTime);

    widget.onSchedule({
      'scheduledPublishDate': dateStr,
      'scheduledPublishTime': timeStr,
      'status': 'Results Scheduled',
    });
    Navigator.pop(context);
  }

  void _handlePublishNow() {
    Navigator.pop(context);
    widget.onPublishNow();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(_selectedDate);
    final timeStr = _formatTime(_selectedTime);
    final examTitle = widget.exam['title'] ?? 'Exam Assessment';
    final subject = widget.exam['subject'] ?? 'Subject';
    final className = widget.exam['className'] ?? 'Class';
    final totalStudents = widget.exam['totalStudents'] ?? 34;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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

            // Header Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.calendarClock,
                      size: 20, color: Color(0xFF6C4CF1)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Result Publication',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Set when students and parents can view results',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Exam Info Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F8FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEBE8FF)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.fileCheck2,
                      size: 16, color: Color(0xFF6C4CF1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$examTitle ($subject • $className)',
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
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

            // Date & Time Selectors Row
            Row(
              children: [
                // Date Selector
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
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F8FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEBE8FF)),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.calendar,
                                  size: 16, color: Color(0xFF6C4CF1)),
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

                // Time Selector
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
                        onTap: _pickTime,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F8FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEBE8FF)),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.clock,
                                  size: 16, color: Color(0xFF6C4CF1)),
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

            // Clear Summary Box before confirmation
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
                      const Icon(LucideIcons.checkCircle2,
                          size: 16, color: Color(0xFF6C4CF1)),
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

            // Action Buttons
            Row(
              children: [
                // Publish Now Button
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
          ],
        ),
      ),
    );
  }
}
