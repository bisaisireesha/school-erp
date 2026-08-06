import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentTransportScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const StudentTransportScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final tr = data['transport'] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: onBack),
        title: const Text('School Bus Tracking', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr['routeName'] ?? 'Route 14B', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text('Bus No: ${tr['busNumber']}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.navigation, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(tr['status'] ?? 'On Route', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text('Driver & Route Contacts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    child: const Icon(LucideIcons.user, color: Color(0xFF6366F1), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr['driverName'] ?? 'Mr. Ramesh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Contact: ${tr['driverPhone']}', style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.phoneCall, color: Color(0xFF10B981), size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _buildTimeRow('Morning Pickup', tr['pickupTime'] ?? '07:35 AM', tr['pickupPoint'] ?? 'Gate 2'),
            const SizedBox(height: 8),
            _buildTimeRow('Afternoon Drop', tr['dropTime'] ?? '03:45 PM', tr['pickupPoint'] ?? 'Gate 2'),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String title, String time, String point) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text('$time at $point', style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
