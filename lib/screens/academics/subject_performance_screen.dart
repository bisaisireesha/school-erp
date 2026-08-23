import 'package:flutter/material.dart';

class SubjectPerformanceScreen extends StatelessWidget {
  final VoidCallback onBack;
  final List<Map<String, dynamic>> subjects;

  const SubjectPerformanceScreen({
    super.key,
    required this.onBack,
    required this.subjects,
  });

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr.replaceAll('0x', ''), radix: 16));
  }

  IconData _getIcon(String iconStr) {
    switch (iconStr) {
      case 'calculate_outlined':
        return Icons.calculate_outlined;
      case 'science_outlined':
        return Icons.science_outlined;
      case 'menu_book_outlined':
      case 'menu_book_rounded':
        return Icons.menu_book_rounded;
      case 'public_outlined':
        return Icons.public_outlined;
      case 'computer_outlined':
        return Icons.computer_outlined;
      default:
        return Icons.book_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF3EEFF),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF1E1E2D),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Subject Performance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ],
              ),
            ),
            
            // List of subjects
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: subjects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                  final subject = subjects[index];
// ignore: unused_local_variable
                  final color = _getColor(subject['color']);
                  final int percentage = subject['percentage'];
                  
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F0FF),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getIcon(subject['icon']),
                                color: const Color(0xFF6C4CF1),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Subject info
                            Expanded(
                              child: Text(
                                subject['subject'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                            ),
                            
                            // Grade
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F0FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                subject['grade'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF6C4CF1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Progress Bar & Percentage
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3EEFF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: percentage / 100,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6C4CF1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    ));
  }
}
