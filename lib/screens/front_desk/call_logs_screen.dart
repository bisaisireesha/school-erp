import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CallLogsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const CallLogsScreen({super.key, this.onBack});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  String _searchQuery = '';
  String _filterType = 'All';

  final List<Map<String, dynamic>> _callLogs = [
    {
      'id': 'CALL-101',
      'callerName': 'Rajesh Verma',
      'phone': '+91 98765 43210',
      'callType': 'Incoming',
      'category': 'Parent',
      'purpose':
          'Enquiry regarding Class 11 Science admission criteria and fee schedule',
      'staff': 'Mrs. Sunita (Admissions)',
      'date': 'Oct 25, 2023',
      'time': '10:30 AM',
      'duration': '3m 45s',
      'status': 'Completed',
      'followUpDate': 'Oct 28, 2023',
      'notes':
          'Sent admission brochure and fee structure via WhatsApp. Requested entrance syllabus.',
    },
    {
      'id': 'CALL-102',
      'callerName': 'Dr. Kavita Menon',
      'phone': '+91 98234 56789',
      'callType': 'Outgoing',
      'category': 'Parent',
      'purpose': 'Inform parent regarding student annual health checkup report',
      'staff': 'Dr. Joshi (Clinic)',
      'date': 'Oct 25, 2023',
      'time': '11:15 AM',
      'duration': '2m 10s',
      'status': 'Completed',
      'followUpDate': '',
      'notes':
          'Parent notified to collect original physician prescription from front office.',
    },
    {
      'id': 'CALL-103',
      'callerName': 'Modern Book Depot',
      'phone': '+91 94123 45678',
      'callType': 'Incoming',
      'category': 'Vendor',
      'purpose':
          'Library textbook consignment delivery status and invoice submission',
      'staff': 'Mr. R.K. Sharma (Librarian)',
      'date': 'Oct 24, 2023',
      'time': '02:40 PM',
      'duration': '5m 12s',
      'status': 'Follow-up',
      'followUpDate': 'Oct 26, 2023',
      'notes':
          'Delivery scheduled for Thursday morning 10 AM. Gate pass prepared.',
    },
    {
      'id': 'CALL-104',
      'callerName': 'Sunil Deshmukh',
      'phone': '+91 97123 98765',
      'callType': 'Missed',
      'category': 'Prospective Parent',
      'purpose': 'Missed call on main reception desk line during break',
      'staff': 'Front Desk Executive',
      'date': 'Oct 24, 2023',
      'time': '04:15 PM',
      'duration': '0s',
      'status': 'Pending',
      'followUpDate': 'Oct 25, 2023',
      'notes':
          'Callback required to enquire about primary wing admission query.',
    },
    {
      'id': 'CALL-105',
      'callerName': 'Ananya Sengupta',
      'phone': '+91 98456 12345',
      'callType': 'Outgoing',
      'category': 'Parent',
      'purpose': 'Bus route #14 delay notification due to road maintenance',
      'staff': 'Transport Incharge',
      'date': 'Oct 23, 2023',
      'time': '03:20 PM',
      'duration': '1m 50s',
      'status': 'Completed',
      'followUpDate': '',
      'notes':
          'Informed that drop off will be 20 mins delayed at South Ext stop.',
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

  Widget _buildCallLogCard(Map<String, dynamic> call) {
    final callType = call['callType'] as String;
    final status = call['status'] as String;

    Color typeBg, typeTextColor;
    IconData typeIcon;

    switch (callType) {
      case 'Incoming':
        typeBg = const Color(0xFFD1FAE5);
        typeTextColor = const Color(0xFF10B981);
        typeIcon = LucideIcons.phoneIncoming;
        break;
      case 'Outgoing':
        typeBg = const Color(0xFFEFF6FF);
        typeTextColor = const Color(0xFF3B82F6);
        typeIcon = LucideIcons.phoneOutgoing;
        break;
      case 'Missed':
        typeBg = const Color(0xFFFEE2E2);
        typeTextColor = const Color(0xFFEF4444);
        typeIcon = LucideIcons.phoneMissed;
        break;
      case 'Follow-up':
      default:
        typeBg = const Color(0xFFFEF3C7);
        typeTextColor = const Color(0xFFF59E0B);
        typeIcon = LucideIcons.phoneForwarded;
        break;
    }

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Completed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Follow-up':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Cancelled':
      case 'Rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    return GestureDetector(
      onTap: () {
        _showCallDetails(call);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: typeBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(typeIcon, color: typeTextColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                call['callerName'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F0FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                call['category'] ?? 'Caller',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C4CF1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.phone,
                              size: 13,
                              color: Color(0xFF8F90A6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              call['phone'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    icon: const Icon(
                      LucideIcons.moreVertical,
                      size: 18,
                      color: Color(0xFF8F90A6),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onSelected: (val) {
                      if (val == 'View Details') {
                        _showCallDetails(call);
                      } else if (val == 'Delete') {
                        setState(() {
                          _callLogs.remove(call);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Call log deleted.')),
                        );
                      } else {
                        setState(() {
                          call['status'] = val;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Status marked as $val.')),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Completed',
                        child: Text('Mark as Completed'),
                      ),
                      const PopupMenuItem(
                        value: 'Follow-up',
                        child: Text('Mark as Follow-up'),
                      ),
                      const PopupMenuItem(
                        value: 'Cancelled',
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.xCircle,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Mark as Cancelled',
                              style: TextStyle(color: Color(0xFFEF4444)),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'View Details',
                        child: Row(
                          children: [
                            Icon(LucideIcons.eye, size: 16),
                            SizedBox(width: 8),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.trash2,
                              size: 16,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Purpose snippet
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F1F5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.helpCircle,
                          size: 14,
                          color: Color(0xFF6C4CF1),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Call Purpose',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8F90A6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      call['purpose'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E2D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Footer Row with Meta Tags
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(typeIcon, size: 12, color: typeTextColor),
                        const SizedBox(width: 4),
                        Text(
                          callType,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: typeTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    LucideIcons.clock,
                    size: 13,
                    color: Color(0xFF8F90A6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${call['date']} • ${call['time']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8F90A6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDetails(Map<String, dynamic> call) {
    final callType = call['callType'] as String;
    final status = call['status'] as String;

    Color typeBg, typeTextColor;
    IconData typeIcon;

    switch (callType) {
      case 'Incoming':
        typeBg = const Color(0xFFD1FAE5);
        typeTextColor = const Color(0xFF10B981);
        typeIcon = LucideIcons.phoneIncoming;
        break;
      case 'Outgoing':
        typeBg = const Color(0xFFEFF6FF);
        typeTextColor = const Color(0xFF3B82F6);
        typeIcon = LucideIcons.phoneOutgoing;
        break;
      case 'Missed':
        typeBg = const Color(0xFFFEE2E2);
        typeTextColor = const Color(0xFFEF4444);
        typeIcon = LucideIcons.phoneMissed;
        break;
      case 'Follow-up':
      default:
        typeBg = const Color(0xFFFEF3C7);
        typeTextColor = const Color(0xFFF59E0B);
        typeIcon = LucideIcons.phoneForwarded;
        break;
    }

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Completed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Follow-up':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Cancelled':
      case 'Rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
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
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: typeBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(typeIcon, color: typeTextColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            call['id'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: typeBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  callType,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: typeTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: statusTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B)),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Purpose Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F1F5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Call Purpose / Topic',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8F90A6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            call['purpose'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDetailItem(
                      LucideIcons.user,
                      'Caller Name',
                      call['callerName'],
                    ),
                    const SizedBox(height: 14),
                    _buildDetailItem(
                      LucideIcons.phone,
                      'Phone Number',
                      call['phone'],
                    ),
                    const SizedBox(height: 14),
                    _buildDetailItem(
                      LucideIcons.tag,
                      'Caller Category',
                      call['category'] ?? 'General Caller',
                    ),
                    const SizedBox(height: 14),
                    _buildDetailItem(
                      LucideIcons.userCheck,
                      'Handled / Assigned Staff',
                      call['staff'],
                    ),
                    const SizedBox(height: 14),
                    _buildDetailItem(
                      LucideIcons.calendar,
                      'Date & Time',
                      '${call['date']} at ${call['time']}',
                    ),
                    const SizedBox(height: 14),
                    _buildDetailItem(
                      LucideIcons.timer,
                      'Call Duration',
                      call['duration'] ?? 'N/A',
                    ),
                    if ((call['followUpDate'] as String?)?.isNotEmpty ??
                        false) ...[
                      const SizedBox(height: 14),
                      _buildDetailItem(
                        LucideIcons.calendarPlus,
                        'Next Follow-up Date',
                        call['followUpDate'],
                      ),
                    ],
                    if ((call['notes'] as String?)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 14),
                      _buildDetailItem(
                        LucideIcons.fileText,
                        'Discussion Notes / Remarks',
                        call['notes'],
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8F90A6),
                ),
              ),
              const SizedBox(height: 2),
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

  @override
  Widget build(BuildContext context) {
    int totalCalls = _callLogs.length;
    int incomingCount = _callLogs
        .where((e) => e['callType'] == 'Incoming')
        .length;
    int outgoingCount = _callLogs
        .where((e) => e['callType'] == 'Outgoing')
        .length;
    int followUpCount = _callLogs
        .where(
          (e) =>
              e['callType'] == 'Follow-up' ||
              e['callType'] == 'Missed' ||
              e['status'] == 'Follow-up',
        )
        .length;

    final displayedCallLogs = _callLogs.where((item) {
      final name = (item['callerName'] as String).toLowerCase();
      final phone = (item['phone'] as String).toLowerCase();
      final purpose = (item['purpose'] as String).toLowerCase();
      final staff = (item['staff'] as String).toLowerCase();
      final type = (item['callType'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery =
          query.isEmpty ||
          name.contains(query) ||
          phone.contains(query) ||
          purpose.contains(query) ||
          staff.contains(query);

      bool matchesType = _filterType == 'All' || type == _filterType;

      return matchesQuery && matchesType;
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
              // Header Row
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
                        'Call Logs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewCallLogModal,
                      icon: const Icon(
                        LucideIcons.plus,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Log Call',
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

              // KPI Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Total Calls',
                            '$totalCalls',
                            LucideIcons.phoneCall,
                            const Color(0xFF6C4CF1),
                            const Color(0xFFF3F0FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Incoming',
                            '$incomingCount',
                            LucideIcons.phoneIncoming,
                            const Color(0xFF10B981),
                            const Color(0xFFD1FAE5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            'Outgoing',
                            '$outgoingCount',
                            LucideIcons.phoneOutgoing,
                            const Color(0xFF3B82F6),
                            const Color(0xFFEFF6FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            'Follow-up / Missed',
                            '$followUpCount',
                            LucideIcons.phoneForwarded,
                            const Color(0xFFF59E0B),
                            const Color(0xFFFEF3C7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search caller, phone, purpose, staff...',
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

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children:
                      [
                        'All',
                        'Incoming',
                        'Outgoing',
                        'Follow-up',
                        'Missed',
                      ].map((type) {
                        final isSelected = _filterType == type;
                        return GestureDetector(
                          onTap: () => setState(() => _filterType = type),
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
                              type,
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

              // List of Call Logs
              if (displayedCallLogs.isEmpty)
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
                            LucideIcons.phoneOff,
                            size: 48,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Call Logs Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no call records matching your filter.',
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
                    children: displayedCallLogs
                        .map((c) => _buildCallLogCard(c))
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

  void _showNewCallLogModal() async {
    final newCall = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewCallLogBottomSheet(),
    );

    if (newCall != null) {
      setState(() {
        _callLogs.insert(0, newCall);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Call log recorded successfully!')),
        );
      }
    }
  }
}

class _NewCallLogBottomSheet extends StatefulWidget {
  const _NewCallLogBottomSheet();

  @override
  State<_NewCallLogBottomSheet> createState() => _NewCallLogBottomSheetState();
}

class _NewCallLogBottomSheetState extends State<_NewCallLogBottomSheet> {
  final _callerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();
  final _staffController = TextEditingController();
  final _durationController = TextEditingController(text: '3m 00s');
  final _notesController = TextEditingController();

  String _selectedCategory = 'Parent';
  String _selectedCallType = 'Incoming';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _selectedFollowUpDate;

  @override
  void dispose() {
    _callerNameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _staffController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickFollowUpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedFollowUpDate ?? DateTime.now().add(const Duration(days: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedFollowUpDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF323842),
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E2D),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: const Color(0xFF8F90A6))
                : null,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? prefixIcon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF323842),
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18, color: const Color(0xFF8F90A6)),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(
                      LucideIcons.chevronDown,
                      color: Color(0xFF8F90A6),
                      size: 18,
                    ),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E2D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitCallLog() {
    if (_callerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Caller Name.')),
      );
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Phone Number.')),
      );
      return;
    }
    if (_purposeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify Call Purpose / Topic.')),
      );
      return;
    }

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final formattedDate =
        '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
    final formattedTime = _selectedTime.format(context);

    String followUpStr = '';
    if (_selectedFollowUpDate != null) {
      followUpStr =
          '${monthNames[_selectedFollowUpDate!.month - 1]} ${_selectedFollowUpDate!.day}, ${_selectedFollowUpDate!.year}';
    }

    final newCall = {
      'id':
          'CALL-${_selectedDate.millisecondsSinceEpoch.toString().substring(8)}',
      'callerName': _callerNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'callType': _selectedCallType,
      'category': _selectedCategory,
      'purpose': _purposeController.text.trim(),
      'staff': _staffController.text.trim().isEmpty
          ? 'Front Desk'
          : _staffController.text.trim(),
      'date': formattedDate,
      'time': formattedTime,
      'duration': _durationController.text.trim().isEmpty
          ? 'N/A'
          : _durationController.text.trim(),
      'status': _selectedCallType == 'Missed'
          ? 'Pending'
          : (_selectedCallType == 'Follow-up' ? 'Follow-up' : 'Completed'),
      'followUpDate': followUpStr,
      'notes': _notesController.text.trim(),
    };

    Navigator.pop(context, newCall);
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateDisplay =
        '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
    final timeDisplay = _selectedTime.format(context);
    final followUpDisplay = _selectedFollowUpDate != null
        ? '${monthNames[_selectedFollowUpDate!.month - 1]} ${_selectedFollowUpDate!.day}, ${_selectedFollowUpDate!.year}'
        : 'Select (Optional)';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.phoneCall,
                        color: Color(0xFF6C4CF1),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log Phone Call',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Record incoming / outgoing call info',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8F90A6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    LucideIcons.x,
                    color: Color(0xFF8B8B8B),
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Scrollable Form Fields
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Caller Details
                  _buildSectionTitle('Caller Details', LucideIcons.user),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Caller Full Name',
                    hint: 'e.g. Rajesh Verma, Dr. Menon',
                    controller: _callerNameController,
                    isRequired: true,
                    prefixIcon: LucideIcons.user,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Phone Number',
                          hint: '+91 98765 43210',
                          controller: _phoneController,
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          prefixIcon: LucideIcons.phone,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Caller Category',
                          value: _selectedCategory,
                          prefixIcon: LucideIcons.tag,
                          items: [
                            'Parent',
                            'Student',
                            'Vendor',
                            'Prospective Parent',
                            'Alumni',
                            'Staff',
                            'Other',
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCategory = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 2: Call Type & Purpose
                  _buildSectionTitle('Call Details', LucideIcons.phoneIncoming),
                  const SizedBox(height: 16),

                  // Call Type Selector Chips
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Call Type',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF323842),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTypeOption(
                            'Incoming',
                            LucideIcons.phoneIncoming,
                            const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          _buildTypeOption(
                            'Outgoing',
                            LucideIcons.phoneOutgoing,
                            const Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 8),
                          _buildTypeOption(
                            'Follow-up',
                            LucideIcons.phoneForwarded,
                            const Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 8),
                          _buildTypeOption(
                            'Missed',
                            LucideIcons.phoneMissed,
                            const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Call Purpose / Topic',
                    hint:
                        'e.g. Admission enquiry, Fee schedule, Bus delay info',
                    controller: _purposeController,
                    isRequired: true,
                    maxLines: 2,
                    prefixIcon: LucideIcons.helpCircle,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Handled / Assigned Staff',
                          hint: 'e.g. Admissions Desk',
                          controller: _staffController,
                          prefixIcon: LucideIcons.userCheck,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          label: 'Duration',
                          hint: 'e.g. 3m 45s',
                          controller: _durationController,
                          prefixIcon: LucideIcons.timer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 3: Timeline & Follow-up
                  _buildSectionTitle('Timeline & Remarks', LucideIcons.clock),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Call Date',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF323842),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.calendar,
                                      size: 18,
                                      color: Color(0xFF6C4CF1),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dateDisplay,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1E1E2D),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                            const Text(
                              'Call Time',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF323842),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.clock,
                                      size: 18,
                                      color: Color(0xFF6C4CF1),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        timeDisplay,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1E1E2D),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next Follow-up Date (Optional)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF323842),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickFollowUpDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.calendarPlus,
                                size: 18,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                followUpDisplay,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _selectedFollowUpDate != null
                                      ? const Color(0xFF1E1E2D)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Discussion Notes / Remarks',
                    hint:
                        'e.g. Sent admission brochure on email, parent requested callback on Friday',
                    controller: _notesController,
                    maxLines: 2,
                    prefixIcon: LucideIcons.messageSquare,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Action Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F1F5))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _submitCallLog,
                    icon: const Icon(
                      LucideIcons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Save Call Log',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String type, IconData icon, Color color) {
    final isSelected = _selectedCallType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCallType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : const Color(0xFF8F90A6),
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
