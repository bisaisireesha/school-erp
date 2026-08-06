import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverMoreScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey) onNavigate;

  const DriverMoreScreen({
    super.key,
    required this.data,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final modules = [
      {
        'key': 'attendance',
        'title': 'Attendance',
        'icon': LucideIcons.userCheck,
        'color': const Color(0xFF10B981),
      },
      {
        'key': 'payslips',
        'title': 'Payslips',
        'icon': LucideIcons.wallet,
        'color': const Color(0xFF6C4CF1),
      },
      {
        'key': 'leave_request',
        'title': 'Leave Request',
        'icon': LucideIcons.calendarOff,
        'color': const Color(0xFFF43F5E),
      },
      {
        'key': 'calendar',
        'title': 'Calendar',
        'icon': LucideIcons.calendar,
        'color': const Color(0xFFF59E0B),
      },
      {
        'key': 'expense',
        'title': 'Expenses',
        'icon': LucideIcons.receipt,
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 90.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver Management',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),

          // Clean 2-Column Module Grid Layout (Identical to Transport Portal More Screen)
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
