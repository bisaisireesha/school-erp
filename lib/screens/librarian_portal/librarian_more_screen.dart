import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianMoreScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key) onNavigate;

  const LibrarianMoreScreen({
    super.key,
    required this.data,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // 5 Options matching user requirements, cloned from Driver App More screen design system
    final modules = [
      {
        'key': 'fines_overdue',
        'title': 'Fines & Overdue',
        'icon': LucideIcons.receipt,
        'color': const Color(0xFFEF4444),
        'subtitle': 'Overdue & Payments',
      },
      {
        'key': 'categories',
        'title': 'Categories',
        'icon': LucideIcons.shapes,
        'color': const Color(0xFF3B82F6),
        'subtitle': 'Book Genres & Subjects',
      },
      {
        'key': 'shelves',
        'title': 'Shelves / Rack Management',
        'icon': LucideIcons.boxes,
        'color': const Color(0xFFF59E0B),
        'subtitle': 'Aisles & Locations',
      },
      {
        'key': 'lost_damaged',
        'title': 'Lost & Damaged Books',
        'icon': LucideIcons.alertTriangle,
        'color': const Color(0xFFF43F5E),
        'subtitle': 'Audit & Replacement',
      },
      {
        'key': 'staff_members',
        'title': 'Staff Members',
        'icon': LucideIcons.userCheck,
        'color': const Color(0xFF10B981),
        'subtitle': 'Staff Directory & Access',
      },
      {
        'key': 'calendar',
        'title': 'Library Calendar',
        'icon': LucideIcons.calendar,
        'color': const Color(0xFF8B5CF6),
        'subtitle': 'Events & Fairs',
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Library Management',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),

          // Clean 2-Column Module Grid Layout (Identical to Driver App More Screen)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.40,
            ),
            itemBuilder: (context, index) {
              final mod = modules[index];
              final Color color = mod['color'] as Color;

              return GestureDetector(
                onTap: () => onNavigate(mod['key'] as String),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      const SizedBox(height: 8),
                      Text(
                        mod['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.0,
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
