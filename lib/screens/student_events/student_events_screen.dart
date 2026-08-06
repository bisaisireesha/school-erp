import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentEventsScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const StudentEventsScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final events = data['events'] as List? ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: onBack),
        title: const Text('Calendar & Events', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final evt = events[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(evt['category'] ?? '', style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    Text(evt['date'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF6C4CF1))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(evt['title'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Text(evt['description'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A68))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 13, color: Color(0xFF7A7A9D)),
                    const SizedBox(width: 4),
                    Text(evt['location'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
