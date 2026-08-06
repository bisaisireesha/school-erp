import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StudentTimetableScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const StudentTimetableScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<StudentTimetableScreen> createState() => _StudentTimetableScreenState();
}

class _StudentTimetableScreenState extends State<StudentTimetableScreen> {
  String _selectedDay = 'Monday';
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    final periods = widget.data['timetable']?['periods'] as List? ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: widget.onBack),
        title: const Text('Class Timetable', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day selector pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _days.map((day) {
                  final isSelected = day == _selectedDay;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = day),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF4A4A68),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: ListView.builder(
                itemCount: periods.length,
                itemBuilder: (context, index) {
                  final item = periods[index];
                  final isActive = item['active'] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFF3EEFF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFE2E2F0),
                        width: isActive ? 1.5 : 1,
                      ),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFF8F8FC),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${item['period']}',
                            style: TextStyle(
                              color: isActive ? Colors.white : const Color(0xFF1E1E2D),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['subject'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                                ),
                              ),
                              Text(
                                'Teacher: ${item['teacher']} • Room: ${item['room']}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D)),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item['time']?.split(' - ')[0] ?? '',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
