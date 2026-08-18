import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../homework/homework_screen.dart';
import '../attendance/attendance_screen.dart';
import '../my_child/my_child_screen.dart';
import '../transport/transport_screen.dart';
import '../cctv_cameras/cctv_cameras_screen.dart';
import '../leave_request/leave_request_screen.dart';
import '../main_layout.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    // Quick Actions Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildQuickActions(),
                    ),
                    const SizedBox(height: 32),
                    // Activity Updates Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildActivityUpdates(),
                    ),
        const SizedBox(height: 120), // Bottom padding for navbar
      ],
    ),
    );
  }

  final List<Map<String, dynamic>> _quickActions = [
    {'title': 'My Child', 'icon': LucideIcons.users},
    {'title': 'Homework', 'icon': LucideIcons.edit},
    {'title': 'Attendance', 'icon': LucideIcons.calendarCheck}, 
    {'title': 'Exams & Results', 'icon': LucideIcons.graduationCap},
    {'title': 'Timetable', 'icon': LucideIcons.calendarDays},
    {'title': 'Fees & Payments', 'icon': LucideIcons.wallet},
    {'title': 'Hostel', 'icon': LucideIcons.building},
    {'title': 'Calendar', 'icon': LucideIcons.calendar},
    {'title': 'Leave Request', 'icon': LucideIcons.fileCheck},
    {'title': 'Transport', 'icon': LucideIcons.bus},
    {'title': 'CCTV Cameras', 'icon': LucideIcons.video},
    {'title': 'Resources', 'icon': LucideIcons.folder},
  ];

  Widget _buildQuickActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickActions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 20,
              mainAxisExtent: 112, // Fixed height to prevent bottom overflow
            ),
            itemBuilder: (context, index) {
              final item = _quickActions[index];
              return GestureDetector(
                onTap: () {
                  if (item['title'] == 'My Child') {
                    MainLayout.pushSubScreen(context, MyChildScreen(
                      onBack: () {
                        MainLayout.popSubScreen(context);
                      },
                    ));
                  } else if (item['title'] == 'Transport') {
                    MainLayout.pushSubScreen(context, TransportScreen(
                      onBack: () {
                        MainLayout.popSubScreen(context);
                      },
                    ));
                  } else if (item['title'] == 'CCTV Cameras') {
                    MainLayout.pushSubScreen(context, CctvCamerasScreen(
                      onBack: () {
                        MainLayout.popSubScreen(context);
                      },
                    ));
                  } else if (item['title'] == 'Leave Request') {
                    MainLayout.pushSubScreen(context, LeaveRequestScreen(
                      onBack: () {
                        MainLayout.popSubScreen(context);
                      },
                    ));
                  } else if (item['title'] == 'Homework') {
                    MainLayout.pushSubScreen(context, HomeworkScreen(
                      onBack: () {
                        MainLayout.popSubScreen(context);
                      },
                    ));
                  } else if (item['title'] == 'Attendance') {
                    MainLayout.pushSubScreen(context, AttendanceScreen(
                      onBack: () {
                        MainLayout.popSubScreen(context);
                      },
                    ));
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['title'] as String, 
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), 
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityUpdates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Activity Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            Text('View All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<String>(
          future: rootBundle.loadString('assets/mock/activities.json'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final data = json.decode(snapshot.data!)['activities'] as List;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 225 / 180,
              ),
              itemBuilder: (context, index) {
                final item = data[index];
                return _buildActivityCard(item);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> item) {
    IconData iconData;
    switch (item['iconType']) {
      case 'class': iconData = Icons.image_outlined; break;
      case 'art': iconData = Icons.palette_outlined; break;
      case 'sports': iconData = Icons.directions_run_rounded; break;
      case 'event': iconData = Icons.theater_comedy_outlined; break;
      default: iconData = Icons.event_note_outlined;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.6),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 100,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                item['imageUrl'],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200, child: const Center(child: Icon(Icons.image, color: Colors.grey))),
              ),
            ),
          ),
          Expanded(
            flex: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(iconData, color: const Color(0xFF6C4CF1), size: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(item['subtitle'], style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
