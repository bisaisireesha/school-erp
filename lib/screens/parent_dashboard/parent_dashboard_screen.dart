import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Dashboard Body Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildAkshaarDashboardCard(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildHighlightsSection(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildTodaysActivitySection(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildPriorityOverviewSection(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildAttendanceSummarySection(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildUpcomingEventsSection(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildQuickActionsSection(),
                    ),
        const SizedBox(height: 120), // Bottom padding for navbar
      ],
    ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
        const Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
      ],
    );
  }

  Widget _buildAkshaarDashboardCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'AK',
                style: TextStyle(
                  color: Color(0xFF6C4CF1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Akshara\'s Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Text('Grade 5-C · Mrs. Kavita Menon', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Text('View profile', style: TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.w600, fontSize: 11)),
                SizedBox(width: 4),
                Icon(Icons.more_vert_rounded, color: Color(0xFF6C4CF1), size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Highlights'),
        const SizedBox(height: 16),
        const FlippableHighlightCard(),
      ],
    );
  }

  Widget _buildTodaysActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Today\'s Activity'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          ),
          child: Column(
            children: [
              _buildActivityRow(
                icon: Icons.event_available_rounded,
                iconColor: const Color(0xFF6C4CF1),
                iconBg: const Color(0xFFF3F0FF),
                title: 'Assignment Added',
                subtitle: 'Maths - Worksheet 12',
                time: '10:30 AM',
              ),
              const Divider(height: 1, color: Color(0xFFF3EEFF)),
              _buildActivityRow(
                icon: Icons.fact_check_outlined,
                iconColor: const Color(0xFF4CAF50),
                iconBg: const Color(0xFFE8F5E9),
                title: 'Attendance Marked',
                subtitle: 'Today\'s attendance has been updated',
                time: '09:15 AM',
              ),
              const Divider(height: 1, color: Color(0xFFF3EEFF)),
              _buildActivityRow(
                icon: Icons.campaign_rounded,
                iconColor: const Color(0xFFFF9800),
                iconBg: const Color(0xFFFFF3E0),
                title: 'Notice Published',
                subtitle: 'Holiday on Friday',
                time: 'Yesterday',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityOverviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFaff),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Priority Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard(
                        icon: Icons.event_available_rounded,
                        iconColor: const Color(0xFF11B136),
                        iconBg: const Color(0xFFE8F5E9),
                        title: 'Attendance',
                        valueRichText: const TextSpan(
                          children: [
                            TextSpan(text: 'Present ', style: TextStyle(color: Color(0xFF1E1E2D))),
                            TextSpan(text: '92%', style: TextStyle(color: Color(0xFF11B136))),
                          ],
                        ),
                        bottomText: '92% this month',
                        bottomTextColor: const Color(0xFF4A4A68),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildKpiCard(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: const Color(0xFFFF9800),
                        iconBg: const Color(0xFFFFF3E0),
                        title: 'Fees Due',
                        valueRichText: const TextSpan(text: '₹12,500', style: TextStyle(color: Color(0xFF1E1E2D))),
                        bottomText: 'Due on 25 May',
                        bottomTextColor: const Color(0xFFFF4B4B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard(
                        icon: Icons.school_outlined,
                        iconColor: const Color(0xFF6C4CF1),
                        iconBg: const Color(0xFFF3F0FF),
                        title: 'Exams &\nResults',
                        valueRichText: const TextSpan(text: '4 upcoming', style: TextStyle(color: Color(0xFF1E1E2D))),
                        bottomText: 'Latest avg: 86%',
                        bottomTextColor: const Color(0xFF4A4A68),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildKpiCard(
                        icon: Icons.pending_actions_outlined,
                        iconColor: const Color(0xFF2196F3),
                        iconBg: const Color(0xFFE3F2FD),
                        title: 'Leave Request',
                        valueRichText: const TextSpan(text: '1 pending', style: TextStyle(color: Color(0xFF1E1E2D))),
                        bottomText: '2 approved',
                        bottomTextColor: const Color(0xFF4A4A68),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required TextSpan valueRichText,
    required String bottomText,
    required Color bottomTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), height: 1.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
              children: [valueRichText],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3EEFF)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bottomText,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: bottomTextColor),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 1.5),
                ),
                child: Icon(Icons.arrow_forward_ios_rounded, color: iconColor, size: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow({required IconData icon, required Color iconColor, required Color iconBg, required String title, required String subtitle, required String time}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF9E9E9E), size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
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
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
            children: [
              _buildActionItem(Icons.people_outline_rounded, 'My Children'),
              _buildActionItem(Icons.event_available_outlined, 'Attendance'),
              _buildActionItem(Icons.assignment_outlined, 'Grades'),
              _buildActionItem(Icons.menu_book_rounded, 'Homework'),
              _buildActionItem(Icons.calendar_today_outlined, 'Events'),
              _buildActionItem(Icons.campaign_outlined, 'Notices'),
              _buildActionItem(Icons.directions_bus_outlined, 'Transport'),
              _buildActionItem(Icons.account_balance_wallet_outlined, 'Fees & Payments'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF6C4CF1).withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF6C4CF1), size: 26),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAttendanceSummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Attendance Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
              Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Donut Chart
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: DonutChartPainter(
                          percentage1: 92, // Green
                          percentage2: 5,  // Red
                          percentage3: 3,  // Orange
                          strokeWidth: 16,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('92%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D), height: 1.1)),
                        Text('Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Stats List
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBFaff),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.0),
                  ),
                  child: Column(
                    children: [
                      _buildAttendanceStatRow(color: const Color(0xFF22C55E), label: 'Present', value: '92% (23 Days)'),
                      const Divider(height: 16, color: Color(0xFFF3EEFF)),
                      _buildAttendanceStatRow(color: const Color(0xFFEF4444), label: 'Absent', value: '5% (2 Days)'),
                      const Divider(height: 16, color: Color(0xFFF3EEFF)),
                      _buildAttendanceStatRow(color: const Color(0xFFF59E0B), label: 'Late', value: '3% (1 Day)'),
                      const Divider(height: 16, color: Color(0xFFF3EEFF)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.calendar_month_outlined, color: Color(0xFF6C4CF1), size: 16),
                              SizedBox(width: 8),
                              Text('Total Days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                            ],
                          ),
                          const Text('26', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatRow({required Color color, required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4A4A68))),
      ],
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFaff),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Upcoming Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
              Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            ],
          ),
          const SizedBox(height: 24),
          _buildEventRow(
            dateDay: '21',
            dateMonth: 'MAY',
            color: const Color(0xFF6C4CF1),
            bgColor: const Color(0xFFF3F0FF),
            title: 'PTM (Parent Teacher Meeting)',
            subtitle: 'Tuesday, 21 May 2024',
            rightText: '11:00 AM',
          ),
          const Divider(height: 32, thickness: 1, color: Color(0xFFF3EEFF)),
          _buildEventRow(
            dateDay: '25',
            dateMonth: 'MAY',
            color: const Color(0xFF11B136),
            bgColor: const Color(0xFFE8F5E9),
            title: 'Science Exhibition',
            subtitle: 'Saturday, 25 May 2024',
            rightText: '09:00 AM',
          ),
          const Divider(height: 32, thickness: 1, color: Color(0xFFF3EEFF)),
          _buildEventRow(
            dateDay: '01',
            dateMonth: 'JUN',
            color: const Color(0xFFFF9800),
            bgColor: const Color(0xFFFFF3E0),
            title: 'Summer Break Begins',
            subtitle: 'Saturday, 01 June 2024',
            rightText: 'All Day',
          ),
        ],
      ),
    );
  }

  Widget _buildEventRow({
    required String dateDay,
    required String dateMonth,
    required Color color,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String rightText,
  }) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateDay, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color, height: 1.1)),
              Text(dateMonth, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
            ],
          ),
        ),
        Row(
          children: [
            Text(rightText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF4A4A68), size: 14),
          ],
        ),
      ],
    );
  }



}

class DonutChartPainter extends CustomPainter {
  final double percentage1;
  final double percentage2;
  final double percentage3;
  final double strokeWidth;

  DonutChartPainter({
    required this.percentage1,
    required this.percentage2,
    required this.percentage3,
    this.strokeWidth = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;
    
    final paint1 = Paint()
      ..color = const Color(0xFF22C55E) // Green
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
      
    final paint2 = Paint()
      ..color = const Color(0xFFEF4444) // Red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
      
    final paint3 = Paint()
      ..color = const Color(0xFFF59E0B) // Orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final double total = percentage1 + percentage2 + percentage3;
    final double sweepGreen = (percentage1 / total) * 2 * math.pi;
    final double sweepRed = (percentage2 / total) * 2 * math.pi;
    final double sweepOrange = (percentage3 / total) * 2 * math.pi;

    double startAngle = -math.pi / 2;
    
    // Orange
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepOrange, false, paint3);
    startAngle += sweepOrange;
    // Green
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepGreen, false, paint1);
    startAngle += sweepGreen;
    // Red
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepRed, false, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FlippableHighlightCard extends StatefulWidget {
  const FlippableHighlightCard({super.key});

  @override
  State<FlippableHighlightCard> createState() => _FlippableHighlightCardState();
}

class _FlippableHighlightCardState extends State<FlippableHighlightCard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragOffset = 0.0;
  bool _isAnimating = false;

  static const double _revealDistance = 90.0;
  static const double _peek = 18.0;
  static const double _behindScale = 0.93;
  static const double _behindOpacity = 0.55;
  static const double _lift = 48.0;
  static const double _cardHeight = 116.0;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  Animation<double>? _anim;

  final List<Map<String, dynamic>> _cardsData = [
    {
      'icon': Icons.menu_book_rounded,
      'iconBg': const Color(0xFFEADDF8),
      'iconColor': const Color(0xFF1E1E2D),
      'title': '2 Assignments',
      'subtitle': 'Due Today',
      'tagColor': const Color(0xFF6C4CF1),
      'tagBgColor': const Color(0xFFF3EEFF),
      'tagText': 'Pending',
    },
    {
      'icon': Icons.directions_bus_rounded,
      'iconBg': const Color(0xFFEADDF8),
      'iconColor': const Color(0xFF1E1E2D),
      'title': 'Transport Update',
      'subtitle': 'Bus Green 12 is near',
      'tagColor': const Color(0xFF6C4CF1),
      'tagBgColor': const Color(0xFFF3EEFF),
      'tagText': 'Live',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'iconBg': const Color(0xFFEADDF8),
      'iconColor': const Color(0xFF1E1E2D),
      'title': 'Fee Reminder',
      'subtitle': 'Term 2 Tuition Fee',
      'tagColor': const Color(0xFF6C4CF1),
      'tagBgColor': const Color(0xFFF3EEFF),
      'tagText': 'Unpaid',
    },
    {
      'icon': Icons.event_available_rounded,
      'iconBg': const Color(0xFFEADDF8),
      'iconColor': const Color(0xFF1E1E2D),
      'title': 'Annual Sports Day',
      'subtitle': 'In 3 days',
      'tagColor': const Color(0xFF6C4CF1),
      'tagBgColor': const Color(0xFFF3EEFF),
      'tagText': 'Upcoming',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _len => _cardsData.length;

  int _mod(int i) => ((i % _len) + _len) % _len;

  double _clamp01(double v) => v < 0.0 ? 0.0 : (v > 1.0 ? 1.0 : v);

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy)
          .clamp(-_revealDistance, _revealDistance);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final velocity = details.primaryVelocity ?? 0.0;
    final threshold = _revealDistance * 0.35;
    if (_dragOffset <= -threshold || velocity <= -300) {
      _animateTo(-_revealDistance);
    } else if (_dragOffset >= threshold || velocity >= 300) {
      _animateTo(_revealDistance);
    } else {
      _animateTo(0.0);
    }
  }

  void _animateTo(double target) {
    _isAnimating = true;
    _anim = Tween<double>(begin: _dragOffset, end: target)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic))
      ..addListener(() {
        setState(() => _dragOffset = _anim!.value);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _finalize(target);
        }
      });
    _controller.forward(from: 0.0);
  }

  void _finalize(double target) {
    if (target < 0) {
      _currentIndex = _mod(_currentIndex + 1);
    } else if (target > 0) {
      _currentIndex = _mod(_currentIndex - 1);
    }
    _dragOffset = 0.0;
    _isAnimating = false;
    _controller.reset();
    _anim = null;
    setState(() {});
  }

  ({double dy, double scale, double opacity}) _transformFor(int index) {
    final int rel = ((index - _currentIndex) % _len + _len) % _len;
    final double dy = _dragOffset;
    final double pUp = _clamp01(-dy / _revealDistance);
    final double pDown = _clamp01(dy / _revealDistance);
    final bool isPrev = rel == _len - 1;
    final bool isNextNext = rel == 2 && !isPrev;

    if (rel == 0) {
      if (pUp > 0) {
        return (dy: -pUp * _lift, scale: 1.0 - 0.06 * pUp, opacity: 1.0 - pUp);
      }
      if (pDown > 0) {
        return (dy: pDown * _peek, scale: 1.0 - 0.07 * pDown, opacity: 1.0 - pDown);
      }
      return (dy: 0.0, scale: 1.0, opacity: 1.0);
    }

    if (rel == 1) {
      if (pUp > 0) {
        return (
          dy: _peek * (1.0 - pUp),
          scale: _behindScale + (1.0 - _behindScale) * pUp,
          opacity: _behindOpacity + (1.0 - _behindOpacity) * pUp,
        );
      }
      return (
        dy: _peek + pDown * _peek,
        scale: _behindScale,
        opacity: _behindOpacity * (1.0 - pDown),
      );
    }

    if (isNextNext) {
      if (pUp > 0) {
        return (
          dy: _peek * 2.0 - _peek * pUp,
          scale: _behindScale,
          opacity: _behindOpacity * pUp,
        );
      }
      return (dy: _peek * 2.0, scale: _behindScale, opacity: 0.0);
    }

    if (isPrev) {
      if (pDown > 0) {
        return (
          dy: -_revealDistance * (1.0 - pDown),
          scale: _behindScale + (1.0 - _behindScale) * pDown,
          opacity: pDown,
        );
      }
      return (dy: -_revealDistance, scale: _behindScale, opacity: 0.0);
    }

    return (dy: 0.0, scale: 1.0, opacity: 0.0);
  }

  Widget _layer(int index) {
    final t = _transformFor(index);
    final double op = _clamp01(t.opacity);
    return IgnorePointer(
      ignoring: op < 0.5,
      child: Opacity(
        opacity: op,
        child: Transform.translate(
          offset: Offset(0, t.dy),
          child: Transform.scale(
            scale: t.scale,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: _buildCardShell(_cardsData[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardShell(Map<String, dynamic> cardData) {
    return Container(
      height: _cardHeight,
      padding: const EdgeInsets.all(16),
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
      child: _buildCardContent(cardData),
    );
  }

  Widget _buildCardContent(Map<String, dynamic> cardData) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: cardData['iconBg'] as Color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            cardData['icon'] as IconData,
            color: cardData['iconColor'] as Color,
            size: 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cardData['subtitle'] as String,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cardData['tagBgColor'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: cardData['tagColor'] as Color, size: 8),
                    const SizedBox(width: 4),
                    Text(
                      cardData['tagText'] as String,
                      style: TextStyle(
                        color: cardData['tagColor'] as Color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz_rounded, color: Color(0xFF9E9E9E), size: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int cur = _currentIndex;
    final int next = _mod(cur + 1);
    final int nextNext = _mod(cur + 2);
    final int prev = _mod(cur - 1);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: SizedBox(
        height: _cardHeight + _peek,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _layer(prev),
            _layer(nextNext),
            _layer(next),
            _layer(cur),
          ],
        ),
      ),
    );
  }
}



