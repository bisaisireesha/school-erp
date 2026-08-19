import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TimetableScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TimetableScreen({super.key, required this.onBack});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedDateIndex = 0;
  final DateTime _startDate = DateTime.now();
  Map<String, List<Map<String, dynamic>>> _timetableData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/student_timetable.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _timetableData = {
            'oddDay': List<Map<String, dynamic>>.from(data['oddDay']),
            'evenDay': List<Map<String, dynamic>>.from(data['evenDay']),
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  IconData _getIcon(String iconStr) {
    switch (iconStr) {
      case 'flaskConical': return LucideIcons.flaskConical;
      case 'bookOpen': return LucideIcons.bookOpen;
      case 'coffee': return LucideIcons.coffee;
      case 'globe': return LucideIcons.globe;
      case 'calculator': return LucideIcons.calculator;
      case 'monitor': return LucideIcons.monitor;
      case 'utensils': return LucideIcons.utensils;
      case 'palette': return LucideIcons.palette;
      case 'music': return LucideIcons.music;
      default: return LucideIcons.circle;
    }
  }

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Class Timetable', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryCards(),
            const SizedBox(height: 24),

            // Calendar Strip
            Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 6,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                    final dates = ['27 May', '28 May', '29 May', '30 May', '31 May', '01 Jun'];
                    final isSelected = index == _selectedDateIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDateIndex = index;
                        });
                      },
                      child: Container(
                        width: 75,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              days[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dates[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF6C6C80),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

            // Main Schedule White Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _isLoading 
                  ? const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
                    )
                  : Column(
                      children: [
                        ..._buildDailySchedule(_selectedDateIndex),
                        const SizedBox(height: 120), // Padding for bottom nav
                      ],
                    ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  List<Widget> _buildDailySchedule(int dayIndex) {
    if (_timetableData.isEmpty) return [];
    final isOddDay = dayIndex % 2 != 0;
    List<Map<String, dynamic>> scheduleData = isOddDay ? _timetableData['oddDay']! : _timetableData['evenDay']!;

    return [
      const SizedBox(height: 16),
      ...scheduleData.map((item) {
        if (item['type'] == 'break') {
          return _buildBreakRow(item['startTime'], item['endTime'], item['label'], _getIcon(item['icon']), _getColor(item['bgColor']), _getColor(item['iconColor']));
        }
        return _buildScheduleRow(
          startTime: item['startTime'],
          endTime: item['endTime'],
          subject: item['subject'],
          room: item['room'],
          teacher: item['teacher'],
          icon: _getIcon(item['icon']),
          iconColor: _getColor(item['iconColor']),
          iconBg: _getColor(item['iconBg']),
        );
      }),
    ];
  }

  Widget _buildScheduleRow({
    required String startTime,
    required String endTime,
    required String subject,
    required String room,
    required String teacher,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 20),
          // Time Column
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                Text(startTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                Text(endTime, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Timeline Line
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(color: iconColor.withValues(alpha: 0.3), blurRadius: 4),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12, right: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(subject, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: iconColor)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 12, color: Color(0xFF4A4A68)),
                            const SizedBox(width: 4),
                            Text(room, style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A68), fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(LucideIcons.user, size: 12, color: Color(0xFF4A4A68)),
                            const SizedBox(width: 4),
                            Text(teacher, style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A68), fontWeight: FontWeight.w500)),
                          ],
                        ),
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

  Widget _buildBreakRow(String startTime, String endTime, String label, IconData icon, Color bgColor, Color iconColor) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 20),
          // Time Column
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                Text(startTime, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: iconColor)),
                Text(endTime, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: iconColor.withValues(alpha: 0.7))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Timeline Line
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12, right: 20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: iconColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.bookOpen,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  value: '6',
                  label: 'Classes Today',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.clock,
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFF0FDF4),
                  value: '5h',
                  label: 'Total Hours',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.userCheck,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFFFBEB),
                  value: '98%',
                  label: 'Attendance',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.calendar,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBg: const Color(0xFFF3E8FF),
                  value: 'Week 4',
                  label: 'Current Term',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80), height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
