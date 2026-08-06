import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentHostelScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const StudentHostelScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final h = data['hostel'] ?? {};
    final menu = h['messMenuToday'] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: onBack),
        title: const Text('Hostel & Mess Menu', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hostel Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(h['roomNo'] ?? 'Room 302', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(6)),
                        child: Text(h['block'] ?? 'Block B', style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Roommate: ${h['roommate']}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('Hostel Warden: ${h['wardenName']}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('Today\'s Mess Menu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 10),

            _buildMealCard('Breakfast (07:30 AM - 08:30 AM)', menu['breakfast'] ?? '', LucideIcons.coffee),
            const SizedBox(height: 8),
            _buildMealCard('Lunch (12:30 PM - 02:00 PM)', menu['lunch'] ?? '', LucideIcons.utensils),
            const SizedBox(height: 8),
            _buildMealCard('Evening Snacks (05:00 PM - 06:00 PM)', menu['snacks'] ?? '', LucideIcons.apple),
            const SizedBox(height: 8),
            _buildMealCard('Dinner (08:00 PM - 09:30 PM)', menu['dinner'] ?? '', LucideIcons.soup),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Night Outing Pass request sent to Warden! 🎟️')),
                );
              },
              icon: const Icon(LucideIcons.ticket, color: Colors.white, size: 16),
              label: const Text('Apply for Night Outing Pass', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(String meal, String items, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF14B8A6), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 1),
                Text(items, style: const TextStyle(fontSize: 11, color: Color(0xFF4A4A68))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
