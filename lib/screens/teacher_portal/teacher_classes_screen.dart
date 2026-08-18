import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';

class TeacherClassesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final Function(String screenKey, {Map<String, dynamic>? arguments}) onNavigate;

  const TeacherClassesScreen({
    super.key,
    required this.data,
    this.onBack,
    required this.onNavigate,
  });

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Marked'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only classes allotted to the logged-in teacher
    final classesList = (widget.data['classes'] as List? ?? []);

    final filtered = classesList.where((c) {
      final bool isPending = c['isAttendancePending'] == true;
      if (_selectedFilter == 'Pending' && !isPending) return false;
      if (_selectedFilter == 'Marked' && isPending) return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final String subject = (c['subject'] ?? '').toString().toLowerCase();
      final String className = (c['className'] ?? '').toString().toLowerCase();
      final String section = (c['section'] ?? '').toString().toLowerCase();
      final String room = (c['room'] ?? '').toString().toLowerCase();

      return subject.contains(q) ||
          className.contains(q) ||
          section.contains(q) ||
          room.contains(q) ||
          '$className-$section'.contains(q);
    }).toList();

    final int pendingCount = classesList.where((c) => c['isAttendancePending'] == true).length;
    final int markedCount = classesList.where((c) => c['isAttendancePending'] != true).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              Row(
                children: [
                  const Text(
                    'My Classes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${classesList.length} Allocated',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 2. Simple Search Bar
              TeacherSearchBar(
                controller: _searchController,
                hintText: 'Search by subject, class, or room...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
              const SizedBox(height: 12),

              // 3. Simple, Useful Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All Classes (${classesList.length})', 'All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending Attendance ($pendingCount)', 'Pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Attendance Marked ($markedCount)', 'Marked'),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 4. Class Cards List (Clean, Minimal, Essential Hierarchy)
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.bookX, size: 36, color: Color(0xFF94A3B8)),
                      SizedBox(height: 10),
                      Text(
                        'No classes found',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Try adjusting your search or filter criteria.',
                        style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                )
              else
                ...filtered.map((cls) => _buildClassCard(cls)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
          ),
          boxShadow: isSelected ? AppShadows.soft : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
          ),
        ),
      ),
    );
  }

  // ─── CLEAN, MINIMAL CLASS CARD ─────────────────────────────────────────────
  // Hierarchy: Subject → Class & Section → Room → Student Count → Attendance Status → Open Class
  Widget _buildClassCard(Map<String, dynamic> cls) {
    final String subject = cls['subject'] ?? 'Subject';
    final String className = cls['className'] ?? 'Class 10';
    final String section = cls['section'] != null ? 'Section ${cls['section']}' : '';
    final String room = cls['room'] ?? 'Room 204';
    final int studentCount = cls['studentCount'] ?? 34;
    final bool isPending = cls['isAttendancePending'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EDF8)),
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => widget.onNavigate('class_details', arguments: cls),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Subject & Class/Section Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.bookOpen, color: Color(0xFF6C4CF1), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            section.isNotEmpty ? '$className • $section' : className,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Attendance Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPending ? 'Pending' : 'Marked',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: isPending ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 12),

                // 2. Room & Student Count Details Row + Open Class Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            room,
                            style: const TextStyle(fontSize: 13.0, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 12),
                          const Icon(LucideIcons.users, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            '$studentCount Students',
                            style: const TextStyle(fontSize: 13.0, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    // Open Class Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Open Class',
                            style: TextStyle(
                              color: Color(0xFF6C4CF1),
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF6C4CF1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
