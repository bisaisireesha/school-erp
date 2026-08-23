import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppointmentsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const AppointmentsScreen({super.key, this.onBack});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _appointments = [
    {
      'id': 'APT-1001',
      'title': 'Admission Enquiry',
      'visitorName': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'email': 'rajesh.k@example.com',
      'hostName': 'Mr. Sharma (Principal)',
      'purpose': 'Admission for Grade 5',
      'date': 'Oct 24, 2023',
      'time': '10:30 AM',
      'duration': '30',
      'status': 'Scheduled',
    },
    {
      'id': 'APT-1002',
      'title': 'Parent-Teacher Meeting',
      'visitorName': 'Sneha Gupta',
      'phone': '+91 99887 76655',
      'email': 'sneha.g@example.com',
      'hostName': 'Mrs. Verma (Class 10 Teacher)',
      'purpose': 'Discuss academic progress',
      'date': 'Oct 24, 2023',
      'time': '11:15 AM',
      'duration': '45',
      'status': 'In Progress',
    },
    {
      'id': 'APT-1003',
      'title': 'Fee Submission',
      'visitorName': 'Amit Singh',
      'phone': '+91 91234 56780',
      'email': 'amit.s@example.com',
      'hostName': 'Admin Office',
      'purpose': 'Clear pending dues',
      'date': 'Oct 25, 2023',
      'time': '09:00 AM',
      'duration': '15',
      'status': 'Scheduled',
    },
    {
      'id': 'APT-0999',
      'title': 'Disciplinary Meeting',
      'visitorName': 'Priya Desai',
      'phone': '+91 98761 23450',
      'email': 'priya.d@example.com',
      'hostName': 'Mr. Iyer (Vice Principal)',
      'purpose': 'Discuss student behavior',
      'date': 'Oct 23, 2023',
      'time': '02:00 PM',
      'duration': '60',
      'status': 'Completed',
    },
    {
      'id': 'APT-0998',
      'title': 'Counseling Session',
      'visitorName': 'Vikram Patel',
      'phone': '+91 99881 12233',
      'email': 'vikram.p@example.com',
      'hostName': 'Mrs. Das (Counselor)',
      'purpose': 'Career guidance',
      'date': 'Oct 23, 2023',
      'time': '11:30 AM',
      'duration': '30',
      'status': 'Cancelled',
    },
  ];

  Widget _buildKpiCard(
    String label,
    String count,
    IconData icon,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: textColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> apt) {
    final status = apt['status'] as String;
    Color statusBg;
    Color statusTextColor;

    switch (status) {
      case 'Scheduled':
        statusBg = const Color(0xFFDBEAFE);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'In Progress':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Completed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Cancelled':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    return GestureDetector(
      onTap: () {
        _showAppointmentDetails(apt);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F1F5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  apt['id'],
                  style: const TextStyle(
                    color: Color(0xFF8F90A6),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        apt['status'],
                        style: TextStyle(
                          color: statusTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      color: Colors.white,
                      icon: const Icon(
                        LucideIcons.moreVertical,
                        size: 18,
                        color: Color(0xFF8F90A6),
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (newStatus) {
                        setState(() {
                          apt['status'] = newStatus;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Scheduled',
                          child: Text('Scheduled'),
                        ),
                        const PopupMenuItem(
                          value: 'In Progress',
                          child: Text('In Progress'),
                        ),
                        const PopupMenuItem(
                          value: 'Completed',
                          child: Text('Completed'),
                        ),
                        const PopupMenuItem(
                          value: 'Cancelled',
                          child: Text('Cancelled'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.user,
                    color: Color(0xFF6C4CF1),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apt['title'] ?? apt['purpose'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${apt['visitorName']} • ${apt['phone'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8F90A6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F1F5)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.users,
                        size: 16,
                        color: Color(0xFF8F90A6),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          apt['hostName'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4A4A68),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.calendar,
                        size: 16,
                        color: Color(0xFF8F90A6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        apt['date'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4A4A68),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.clock,
                        size: 16,
                        color: Color(0xFF8F90A6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        apt['time'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4A4A68),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (apt['status'] != 'Completed' &&
                apt['status'] != 'Cancelled') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (apt['status'] == 'Requested') ...[
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          apt['status'] = 'Scheduled';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E1E2D),
                        side: const BorderSide(color: Color(0xFFE8E3F8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (apt['status'] == 'Scheduled' ||
                      apt['status'] == 'In Progress') ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          apt['status'] = 'Completed';
                        });
                      },
                      icon: const Icon(LucideIcons.checkCircle2, size: 16),
                      label: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E1E2D),
                        side: const BorderSide(color: Color(0xFFE8E3F8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        apt['status'] = 'Cancelled';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFFEE2E2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: const Icon(LucideIcons.x, size: 16),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalAppointments = _appointments.length;
    int scheduledCount = _appointments
        .where((a) => a['status'] == 'Scheduled')
        .length;
    int completedCount = _appointments
        .where((a) => a['status'] == 'Completed')
        .length;
    int cancelledCount = _appointments
        .where((a) => a['status'] == 'Cancelled')
        .length;

    final displayedAppointments = _appointments.where((item) {
      final name = (item['visitorName'] as String).toLowerCase();
      final host = (item['hostName'] as String).toLowerCase();
      final id = (item['id'] as String).toLowerCase();
      final status = (item['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery =
          query.isEmpty ||
          name.contains(query) ||
          host.contains(query) ||
          id.contains(query);
      bool matchesStatus = _filterStatus == 'All' || status == _filterStatus;

      return matchesQuery && matchesStatus;
    }).toList();

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Custom Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    if (widget.onBack != null) ...[
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFF3EEFF),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF1E1E2D),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Expanded(
                      child: Text(
                        'Appointments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showBookAppointmentModal,
                      icon: const Icon(
                        LucideIcons.plus,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4 KPI Cards — 2 Rows x 2 Columns Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Total Today',
                            '$totalAppointments',
                            LucideIcons.calendarDays,
                            const Color(0xFF6C4CF1),
                            const Color(0xFFF3F0FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Scheduled',
                            '$scheduledCount',
                            LucideIcons.clock,
                            const Color(0xFF3B82F6),
                            const Color(0xFFDBEAFE),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Completed',
                            '$completedCount',
                            LucideIcons.checkCircle2,
                            const Color(0xFF10B981),
                            const Color(0xFFD1FAE5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Cancelled',
                            '$cancelledCount',
                            LucideIcons.xCircle,
                            const Color(0xFFEF4444),
                            const Color(0xFFFEE2E2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search visitor, host, ID...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      LucideIcons.search,
                      color: Color(0xFF6C4CF1),
                      size: 18,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF6C4CF1),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children:
                      [
                        'All',
                        'Requested',
                        'Scheduled',
                        'In Progress',
                        'Completed',
                        'Cancelled',
                      ].map((status) {
                        final isSelected = _filterStatus == status;
                        return GestureDetector(
                          onTap: () => setState(() => _filterStatus = status),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6C4CF1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF6C4CF1)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // List of appointments
              if (displayedAppointments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F0FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.calendarX,
                            size: 48,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Appointments Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no appointments matching your filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8F90A6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: displayedAppointments
                        .map((apt) => _buildAppointmentCard(apt))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> apt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8E3F8),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (apt['visitorName'] as String)[0],
                            style: const TextStyle(
                              color: Color(0xFF6C4CF1),
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              apt['title'] ?? apt['purpose'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              apt['visitorName'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          LucideIcons.x,
                          color: Color(0xFF8B8B8B),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        LucideIcons.phone,
                        'Phone Number',
                        apt['phone'],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(LucideIcons.mail, 'Email', apt['email']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: Color(0xFFF3EEFF),
                          height: 1,
                          thickness: 1.5,
                        ),
                      ),
                      _buildDetailRow(
                        LucideIcons.calendar,
                        'Date & Time',
                        '${apt['date']} at ${apt['time']}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        LucideIcons.clock,
                        'Duration',
                        '${apt['duration']} minutes',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: Color(0xFFF3EEFF),
                          height: 1,
                          thickness: 1.5,
                        ),
                      ),
                      _buildDetailRow(
                        LucideIcons.briefcase,
                        'Purpose',
                        apt['purpose'],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        LucideIcons.user,
                        'Host (Whom to Meet)',
                        apt['hostName'],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF8B8B8B)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B8B8B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBookAppointmentModal() async {
    final newAppointment = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BookAppointmentBottomSheet(),
    );

    if (newAppointment != null) {
      setState(() {
        _appointments.insert(0, newAppointment);
      });
    }
  }
}

class _BookAppointmentBottomSheet extends StatefulWidget {
  const _BookAppointmentBottomSheet();

  @override
  State<_BookAppointmentBottomSheet> createState() =>
      _BookAppointmentBottomSheetState();
}

class _BookAppointmentBottomSheetState
    extends State<_BookAppointmentBottomSheet> {
  final _titleController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _hostController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _purposeController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _visitorNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _hostController.dispose();
    _durationController.dispose();
    _purposeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _bookAppointment() {
    if (_titleController.text.isEmpty ||
        _visitorNameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields (*).')),
      );
      return;
    }

    final newApt = {
      'id':
          'APT-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      'title': _titleController.text,
      'visitorName': _visitorNameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'hostName': _hostController.text,
      'purpose': _purposeController.text,
      'date':
          '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
      'time': _selectedTime!.format(context),
      'duration': _durationController.text,
      'status': 'Requested',
    };
    Navigator.pop(context, newApt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Book Appointment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Schedule a visitor meeting',
                      style: TextStyle(fontSize: 14, color: Color(0xFF8B8B8B)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B)),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildFormField(
              'Title',
              'e.g. Parent-Teacher Meeting',
              controller: _titleController,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Visitor Name',
                    'e.g. Mr. Verma',
                    controller: _visitorNameController,
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    'Phone',
                    '+91 98765 43210',
                    controller: _phoneController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Email',
                    'parent@example.com',
                    controller: _emailController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    'Host (Staff)',
                    'e.g. Mrs. Sharma (Principal)',
                    controller: _hostController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Scheduled Date',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E2D),
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xFFEF4444)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Select date'
                                    : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? Colors.grey.shade400
                                      : const Color(0xFF1E1E2D),
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(
                                LucideIcons.calendar,
                                color: Color(0xFF8B8B8B),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Scheduled Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E2D),
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xFFEF4444)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedTime == null
                                    ? 'Select time'
                                    : _selectedTime!.format(context),
                                style: TextStyle(
                                  color: _selectedTime == null
                                      ? Colors.grey.shade400
                                      : const Color(0xFF1E1E2D),
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(
                                LucideIcons.clock,
                                color: Color(0xFF8B8B8B),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Duration (mins)',
                    '30',
                    controller: _durationController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    'Purpose',
                    'e.g. Discuss Grade 5 admission',
                    controller: _purposeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField(
              'Note',
              'Optional remark',
              controller: _noteController,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(
                        color: Color(0xFFE8E3F8),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF1E1E2D),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _bookAppointment,
                    icon: const Icon(
                      LucideIcons.calendarPlus,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Book Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String hint, {
    bool isRequired = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E2D),
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF6C4CF1),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
