import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportMoreScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey) onNavigate;

  const TransportMoreScreen({
    super.key,
    required this.data,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'key': 'drivers',
        'title': 'Drivers & Staff',
        'icon': LucideIcons.users,
        'color': const Color(0xFF6C4CF1),
      },
      {
        'key': 'compliance',
        'title': 'Compliance',
        'icon': LucideIcons.shieldCheck,
        'color': const Color(0xFF10B981),
      },
      {
        'key': 'routes',
        'title': 'Route Builder',
        'icon': LucideIcons.mapPin,
        'color': const Color(0xFF3B82F6),
      },
      {
        'key': 'assignments',
        'title': 'Student Assignments',
        'icon': LucideIcons.userCheck,
        'color': const Color(0xFFF59E0B),
      },
      {
        'key': 'events',
        'title': 'Calendar & Events',
        'icon': LucideIcons.calendar,
        'color': const Color(0xFFF43F5E),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 90.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transport Management',
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),

          // Clean 2-Column Module Grid Layout
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (context, index) {
              final mod = modules[index];
              final Color color = mod['color'] as Color;
              return GestureDetector(
                onTap: () => onNavigate(mod['key'] as String),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          mod['icon'] as IconData,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        mod['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
