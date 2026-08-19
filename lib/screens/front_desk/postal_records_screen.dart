import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PostalRecordsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const PostalRecordsScreen({super.key, this.onBack});

  @override
  State<PostalRecordsScreen> createState() => _PostalRecordsScreenState();
}

class _PostalRecordsScreenState extends State<PostalRecordsScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _records = [
    {
      'id': 'POS-3001',
      'type': 'Receive',
      'sender': 'CBSE Board',
      'receiver': 'School Admin',
      'address': 'New Delhi',
      'referenceNo': 'CBSE/2023/102',
      'date': 'Oct 24, 2023',
      'status': 'Delivered',
    },
    {
      'id': 'POS-3002',
      'type': 'Dispatch',
      'sender': 'School Admin',
      'receiver': 'Mr. Rajesh Kumar',
      'address': 'Koramangala, Bangalore',
      'referenceNo': 'TC/2023/45',
      'date': 'Oct 23, 2023',
      'status': 'Pending',
    },
    {
      'id': 'POS-3003',
      'type': 'Receive',
      'sender': 'Amazon Delivery',
      'receiver': 'Stationery Dept',
      'address': 'Stationery Supplies',
      'referenceNo': 'AMZ-998877',
      'date': 'Oct 22, 2023',
      'status': 'Delivered',
    },
  ];

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: textColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final status = record['status'] as String;
    final type = record['type'] as String;
    
    Color statusBg;
    Color statusTextColor;
    
    switch (status) {
      case 'Pending':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Delivered':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Returned':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    final isReceive = type == 'Receive';
    final typeIcon = isReceive ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight;
    final typeColor = isReceive ? const Color(0xFF3B82F6) : const Color(0xFF8B5CF6);
    final typeBgColor = isReceive ? const Color(0xFFDBEAFE) : const Color(0xFFEDE9FE);

    return GestureDetector(
      onTap: () {
        _showRecordDetails(record);
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
                record['id'],
                style: const TextStyle(
                  color: Color(0xFF8F90A6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      record['status'],
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
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    icon: const Icon(LucideIcons.moreVertical, size: 18, color: Color(0xFF8F90A6)),
                    padding: EdgeInsets.zero,
                    onSelected: (action) {
                      if (action == 'Delete') {
                        setState(() {
                          _records.removeWhere((r) => r['id'] == record['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record deleted')));
                      } else if (action == 'View Details') {
                        _showRecordDetails(record);
                      } else {
                        setState(() {
                          record['status'] = action;
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Pending', child: Text('Mark as Pending')),
                      const PopupMenuItem(value: 'Delivered', child: Text('Mark as Delivered')),
                      const PopupMenuItem(value: 'Returned', child: Text('Mark as Returned')),
                      const PopupMenuDivider(),
                      const PopupMenuItem(value: 'View Details', child: Row(children: [Icon(LucideIcons.eye, size: 16), SizedBox(width: 8), Text('View Details')])),
                      const PopupMenuItem(value: 'Delete', child: Row(children: [Icon(LucideIcons.trash2, size: 16, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
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
                decoration: BoxDecoration(
                  color: typeBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F1F5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFF8F90A6), width: 2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'From: ', style: TextStyle(color: Color(0xFF8F90A6), fontSize: 13, fontWeight: FontWeight.w600)),
                                      TextSpan(text: record['sender'], style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 14, fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                            height: 12,
                            width: 2,
                            color: const Color(0xFFE2E8F0),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFF6C4CF1), width: 2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'To: ', style: TextStyle(color: Color(0xFF8F90A6), fontSize: 13, fontWeight: FontWeight.w600)),
                                      TextSpan(text: record['receiver'], style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 14, fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 11,
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Ref: ${record['referenceNo']}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
                    const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF8F90A6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        record['address'],
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
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF8F90A6)),
                    const SizedBox(width: 6),
                    Text(
                      record['date'],
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
        ],
      ),
    ));
  }

  void _showRecordDetails(Map<String, dynamic> record) {
    final type = record['type'] as String;
    final isReceive = type == 'Receive';
    final typeColor = isReceive ? const Color(0xFF3B82F6) : const Color(0xFF8B5CF6);
    final typeBgColor = isReceive ? const Color(0xFFEFF6FF) : const Color(0xFFF5F3FF);
    final typeIcon = isReceive ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight;

    final status = record['status'] as String;
    Color statusBg, statusColor;
    switch (status) {
      case 'Delivered':
        statusBg = const Color(0xFFD1FAE5);
        statusColor = const Color(0xFF10B981);
        break;
      case 'Pending':
        statusBg = const Color(0xFFFEF3C7);
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'Returned':
        statusBg = const Color(0xFFFEE2E2);
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusColor = const Color(0xFF64748B);
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
                        color: typeBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(typeIcon, color: typeColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record['id'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: typeBgColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(fontSize: 11, color: typeColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    // Timeline for From and To
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F1F5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFF8F90A6), width: 2.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('From (Sender)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6))),
                                    const SizedBox(height: 2),
                                    Text(record['sender'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5, top: 4, bottom: 4),
                            height: 16,
                            width: 2,
                            color: const Color(0xFFE2E8F0),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFF6C4CF1), width: 2.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('To (Receiver)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6))),
                                    const SizedBox(height: 2),
                                    Text(record['receiver'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Additional Details Rows
                    _buildDetailItem(LucideIcons.fileText, 'Reference Number', record['referenceNo']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.mapPin, 'Address / Location', record['address']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.calendar, 'Record Date', record['date']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.checkCircle2, 'Current Status', record['status']),
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
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalRecords = _records.length;
    int receiveCount = _records.where((e) => e['type'] == 'Receive').length;
    int dispatchCount = _records.where((e) => e['type'] == 'Dispatch').length;
    int pendingCount = _records.where((e) => e['status'] == 'Pending').length;

    final displayedRecords = _records.where((item) {
      final senderName = (item['sender'] as String).toLowerCase();
      final receiverName = (item['receiver'] as String).toLowerCase();
      final ref = (item['referenceNo'] as String).toLowerCase();
      final id = (item['id'] as String).toLowerCase();
      final status = (item['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || senderName.contains(query) || receiverName.contains(query) || ref.contains(query) || id.contains(query);
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
                            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Expanded(
                      child: Text('Postal Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewRecordModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('Add Record', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        Expanded(child: _buildKpiCard('Total Records', '$totalRecords', LucideIcons.mail, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Receive', '$receiveCount', LucideIcons.arrowDownLeft, const Color(0xFF3B82F6), const Color(0xFFDBEAFE))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Dispatch', '$dispatchCount', LucideIcons.arrowUpRight, const Color(0xFF8B5CF6), const Color(0xFFEDE9FE))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Pending', '$pendingCount', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
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
                    hintText: 'Search name, reference, ID...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 18),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: ['All', 'Pending', 'Delivered', 'Returned'].map((status) {
                    final isSelected = _filterStatus == status;
                    return GestureDetector(
                      onTap: () => setState(() => _filterStatus = status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // List of records
              if (displayedRecords.isEmpty)
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
                          child: const Icon(LucideIcons.mailbox, size: 48, color: Color(0xFF6C4CF1)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Records Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no postal records matching your filter.',
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
                    children: displayedRecords.map((r) => _buildRecordCard(r)).toList(),
                  ),
                ),
                
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewRecordModal() async {
    final newRecord = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewRecordBottomSheet(),
    );

    if (newRecord != null) {
      setState(() {
        _records.insert(0, newRecord);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record added successfully!')));
      }
    }
  }
}

class _NewRecordBottomSheet extends StatefulWidget {
  const _NewRecordBottomSheet();

  @override
  State<_NewRecordBottomSheet> createState() => _NewRecordBottomSheetState();
}

class _NewRecordBottomSheetState extends State<_NewRecordBottomSheet> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _addressController = TextEditingController();
  final _referenceNoController = TextEditingController();
  final _noteController = TextEditingController();
  
  String _recordType = 'Receive'; // 'Receive' or 'Dispatch'
  final DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _addressController.dispose();
    _referenceNoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildFormField(String label, String hint, {required TextEditingController controller, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444)))] : [],
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF3F4F6))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF3F4F6))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
          ),
        ),
      ],
    );
  }

  void _submitRecord() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields (*).')));
      return;
    }

    final newRec = {
      'id': 'POS-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      'type': _recordType,
      'sender': _fromController.text,
      'receiver': _toController.text,
      'address': _addressController.text.isEmpty ? 'N/A' : _addressController.text,
      'referenceNo': _referenceNoController.text.isEmpty ? 'N/A' : _referenceNoController.text,
      'date': '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
      'status': 'Pending',
    };
    Navigator.pop(context, newRec);
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
                    const Text('New Postal Record', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 4),
                    const Text('Add a new dispatch or receive entry', style: TextStyle(fontSize: 14, color: Color(0xFF8B8B8B))),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B)),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Type Selector
            const Text('Record Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _recordType = 'Receive'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _recordType == 'Receive' ? const Color(0xFF6C4CF1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _recordType == 'Receive' ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                      ),
                      child: Center(
                        child: Text(
                          'Receive',
                          style: TextStyle(
                            color: _recordType == 'Receive' ? Colors.white : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _recordType = 'Dispatch'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _recordType == 'Dispatch' ? const Color(0xFF6C4CF1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _recordType == 'Dispatch' ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                      ),
                      child: Center(
                        child: Text(
                          'Dispatch',
                          style: TextStyle(
                            color: _recordType == 'Dispatch' ? Colors.white : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _buildFormField('From (Sender)', 'e.g. CBSE Board', controller: _fromController, isRequired: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildFormField('To (Receiver)', 'e.g. School Admin', controller: _toController, isRequired: true)),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField('Address', 'e.g. New Delhi', controller: _addressController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildFormField('Reference No.', 'e.g. CBSE/102', controller: _referenceNoController)),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField('Notes / Description', 'Additional details about the package', controller: _noteController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Save Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
