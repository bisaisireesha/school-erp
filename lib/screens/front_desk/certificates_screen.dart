import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CertificatesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const CertificatesScreen({super.key, this.onBack});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _certificates = [
    {
      'id': 'CERT-1001',
      'studentName': 'Aarav Sharma',
      'grade': 'Grade 10-A',
      'rollNo': '10045',
      'certificateType': 'Transfer Certificate (TC)',
      'purpose': 'Relocating to another city',
      'date': 'Oct 24, 2023',
      'status': 'Ready',
    },
    {
      'id': 'CERT-1002',
      'studentName': 'Diya Patel',
      'grade': 'Grade 8-B',
      'rollNo': '08022',
      'certificateType': 'Bonafide Certificate',
      'purpose': 'Passport Application',
      'date': 'Oct 23, 2023',
      'status': 'Issued',
    },
    {
      'id': 'CERT-1003',
      'studentName': 'Rohan Varma',
      'grade': 'Grade 12-C',
      'rollNo': '12019',
      'certificateType': 'Character Certificate',
      'purpose': 'College Admissions',
      'date': 'Oct 22, 2023',
      'status': 'Pending',
    },
    {
      'id': 'CERT-1004',
      'studentName': 'Ananya Reddy',
      'grade': 'Grade 9-A',
      'rollNo': '09015',
      'certificateType': 'Fee Clearance Certificate',
      'purpose': 'Bank Loan Verification',
      'date': 'Oct 20, 2023',
      'status': 'Issued',
    },
  ];

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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

  Widget _buildCertificateCard(Map<String, dynamic> cert) {
    final status = cert['status'] as String;
    final certType = cert['certificateType'] as String;

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Pending':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Ready':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'Issued':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    IconData typeIcon;
    Color typeColor = const Color(0xFF6C4CF1);
    Color typeBg = const Color(0xFFF3F0FF);

    if (certType.contains('Transfer')) {
      typeIcon = LucideIcons.fileOutput;
      typeColor = const Color(0xFFF97316);
      typeBg = const Color(0xFFFFF7ED);
    } else if (certType.contains('Bonafide')) {
      typeIcon = LucideIcons.award;
      typeColor = const Color(0xFF6C4CF1);
      typeBg = const Color(0xFFF3F0FF);
    } else if (certType.contains('Character')) {
      typeIcon = LucideIcons.shieldCheck;
      typeColor = const Color(0xFF10B981);
      typeBg = const Color(0xFFECFDF5);
    } else if (certType.contains('Fee')) {
      typeIcon = LucideIcons.receipt;
      typeColor = const Color(0xFF3B82F6);
      typeBg = const Color(0xFFEFF6FF);
    } else {
      typeIcon = LucideIcons.fileText;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                cert['id'],
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
                      cert['status'],
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
                          _certificates.removeWhere((c) => c['id'] == cert['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Certificate record deleted')));
                      } else if (action == 'View Details') {
                        _showCertificateDetails(cert);
                      } else {
                        setState(() {
                          cert['status'] = action;
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Pending', child: Text('Mark as Pending')),
                      const PopupMenuItem(value: 'Ready', child: Text('Mark as Ready')),
                      const PopupMenuItem(value: 'Issued', child: Text('Mark as Issued')),
                      const PopupMenuItem(
                        value: 'Rejected',
                        child: Row(
                          children: [
                            Icon(LucideIcons.xCircle, size: 16, color: Color(0xFFEF4444)),
                            SizedBox(width: 8),
                            Text('Mark as Rejected', style: TextStyle(color: Color(0xFFEF4444))),
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
                            Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cert['certificateType'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Student: ', style: TextStyle(color: Color(0xFF8F90A6), fontSize: 13, fontWeight: FontWeight.w500)),
                          TextSpan(text: cert['studentName'], style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 13, fontWeight: FontWeight.w700)),
                          TextSpan(text: ' (${cert['grade']})', style: const TextStyle(color: Color(0xFF8F90A6), fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.userCheck, size: 16, color: Color(0xFF8F90A6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Roll: ${cert['rollNo']}',
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
                      cert['date'],
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
          if (cert['purpose'] != null && cert['purpose'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.info, size: 15, color: Color(0xFF8F90A6)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Purpose: ${cert['purpose']}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8F90A6), fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCertificateDetails(Map<String, dynamic> cert) {
    final status = cert['status'] as String;
    final certType = cert['certificateType'] as String;

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Pending':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Ready':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'Issued':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    IconData typeIcon;
    Color typeColor = const Color(0xFF6C4CF1);
    Color typeBg = const Color(0xFFF3F0FF);

    if (certType.contains('Transfer')) {
      typeIcon = LucideIcons.fileOutput;
      typeColor = const Color(0xFFF97316);
      typeBg = const Color(0xFFFFF7ED);
    } else if (certType.contains('Bonafide')) {
      typeIcon = LucideIcons.award;
      typeColor = const Color(0xFF6C4CF1);
      typeBg = const Color(0xFFF3F0FF);
    } else if (certType.contains('Character')) {
      typeIcon = LucideIcons.shieldCheck;
      typeColor = const Color(0xFF10B981);
      typeBg = const Color(0xFFECFDF5);
    } else if (certType.contains('Fee')) {
      typeIcon = LucideIcons.receipt;
      typeColor = const Color(0xFF3B82F6);
      typeBg = const Color(0xFFEFF6FF);
    } else {
      typeIcon = LucideIcons.fileText;
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
                      child: Icon(typeIcon, color: typeColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert['id'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(fontSize: 11, color: statusTextColor, fontWeight: FontWeight.bold),
                            ),
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
                    // Certificate Type banner
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
                            'Certificate Type',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cert['certificateType'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDetailItem(LucideIcons.user, 'Student Name', cert['studentName']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.graduationCap, 'Class / Grade', cert['grade']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.hash, 'Roll / Student ID', cert['rollNo']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.calendar, 'Request / Issue Date', cert['date']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.info, 'Purpose / Reason', cert['purpose'] ?? 'General Purpose'),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.checkCircle2, 'Status', cert['status']),
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
    int totalCertificates = _certificates.length;
    int pendingCount = _certificates.where((e) => e['status'] == 'Pending').length;
    int readyCount = _certificates.where((e) => e['status'] == 'Ready').length;
    int issuedCount = _certificates.where((e) => e['status'] == 'Issued').length;

    final displayedCertificates = _certificates.where((item) {
      final name = (item['studentName'] as String).toLowerCase();
      final type = (item['certificateType'] as String).toLowerCase();
      final id = (item['id'] as String).toLowerCase();
      final roll = (item['rollNo'] as String).toLowerCase();
      final status = (item['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || name.contains(query) || type.contains(query) || id.contains(query) || roll.contains(query);
      bool matchesStatus = _filterStatus == 'All' || status == _filterStatus;

      return matchesQuery && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
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
                      child: Text('Certificates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewCertificateModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('Issue Certificate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        Expanded(child: _buildKpiCard('Total', '$totalCertificates', LucideIcons.award, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Pending', '$pendingCount', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Ready', '$readyCount', LucideIcons.fileCheck, const Color(0xFF3B82F6), const Color(0xFFEFF6FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Issued', '$issuedCount', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFD1FAE5))),
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
                    hintText: 'Search student, certificate, roll no...',
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
                  children: ['All', 'Pending', 'Ready', 'Issued', 'Rejected'].map((status) {
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

              // List of certificates
              if (displayedCertificates.isEmpty)
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
                          child: const Icon(LucideIcons.fileX, size: 48, color: Color(0xFF6C4CF1)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Certificates Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no certificate records matching your filter.',
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
                    children: displayedCertificates.map((c) => _buildCertificateCard(c)).toList(),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewCertificateModal() async {
    final newCertificate = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewCertificateBottomSheet(),
    );

    if (newCertificate != null) {
      setState(() {
        _certificates.insert(0, newCertificate);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Certificate request created successfully!')));
      }
    }
  }
}

class _NewCertificateBottomSheet extends StatefulWidget {
  const _NewCertificateBottomSheet();

  @override
  State<_NewCertificateBottomSheet> createState() => _NewCertificateBottomSheetState();
}

class _NewCertificateBottomSheetState extends State<_NewCertificateBottomSheet> {
  final _studentNameController = TextEditingController();
  final _admissionNoController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _purposeController = TextEditingController();
  final _customTypeController = TextEditingController();
  final _remarksController = TextEditingController();

  String _selectedGrade = 'Grade 10-A';
  String _selectedAcademicYear = '2024-2025';
  String _selectedType = 'Bonafide Certificate';
  String _selectedUrgency = 'Normal';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _studentNameController.dispose();
    _admissionNoController.dispose();
    _rollNoController.dispose();
    _purposeController.dispose();
    _customTypeController.dispose();
    _remarksController.dispose();
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold))] : [],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: const Color(0xFF8F90A6)) : null,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold))] : [],
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
                    icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF8F90A6), size: 18),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
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

  void _submitCertificate() {
    if (_studentNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the Student Full Name.')));
      return;
    }
    if (_rollNoController.text.trim().isEmpty && _admissionNoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Roll Number or Admission ID.')));
      return;
    }

    if (_selectedType == 'Other' && _customTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please specify the Certificate Type.')));
      return;
    }

    final typeName = (_selectedType == 'Other' && _customTypeController.text.trim().isNotEmpty)
        ? _customTypeController.text.trim()
        : _selectedType;

    final roll = _rollNoController.text.trim().isNotEmpty
        ? _rollNoController.text.trim()
        : _admissionNoController.text.trim();

    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final formattedDate = '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';

    final newCert = {
      'id': 'CERT-${_selectedDate.millisecondsSinceEpoch.toString().substring(8)}',
      'studentName': _studentNameController.text.trim(),
      'grade': _selectedGrade,
      'rollNo': roll,
      'certificateType': typeName,
      'purpose': _purposeController.text.trim().isEmpty ? 'General Purpose' : _purposeController.text.trim(),
      'date': formattedDate,
      'status': 'Pending',
      'academicYear': _selectedAcademicYear,
      'urgency': _selectedUrgency,
      'remarks': _remarksController.text.trim(),
    };

    Navigator.pop(context, newCert);
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateDisplay = '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';

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
                      child: const Icon(LucideIcons.award, color: Color(0xFF6C4CF1), size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Issue Certificate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        SizedBox(height: 2),
                        Text('Fill student & certificate details', style: TextStyle(fontSize: 12, color: Color(0xFF8F90A6))),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B), size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  // Section 1: Student Information
                  _buildSectionTitle('Student Information', LucideIcons.user),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Student Full Name',
                    hint: 'e.g. Aarav Sharma',
                    controller: _studentNameController,
                    isRequired: true,
                    prefixIcon: LucideIcons.userCheck,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Roll Number',
                          hint: 'e.g. 10045',
                          controller: _rollNoController,
                          isRequired: true,
                          prefixIcon: LucideIcons.hash,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          label: 'Admission ID (Opt)',
                          hint: 'e.g. ADM-2023-45',
                          controller: _admissionNoController,
                          prefixIcon: LucideIcons.idCard,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Class & Section',
                          value: _selectedGrade,
                          isRequired: true,
                          prefixIcon: LucideIcons.graduationCap,
                          items: [
                            'Grade 6-A', 'Grade 6-B',
                            'Grade 7-A', 'Grade 7-B',
                            'Grade 8-A', 'Grade 8-B',
                            'Grade 9-A', 'Grade 9-B',
                            'Grade 10-A', 'Grade 10-B',
                            'Grade 11-A', 'Grade 11-B',
                            'Grade 12-A', 'Grade 12-B',
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedGrade = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Academic Year',
                          value: _selectedAcademicYear,
                          prefixIcon: LucideIcons.calendar,
                          items: ['2024-2025', '2023-2024', '2022-2023'],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedAcademicYear = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 2: Certificate Details
                  _buildSectionTitle('Certificate Specification', LucideIcons.fileText),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: 'Certificate Type',
                    value: _selectedType,
                    isRequired: true,
                    prefixIcon: LucideIcons.award,
                    items: [
                      'Bonafide Certificate',
                      'Transfer Certificate (TC)',
                      'Character Certificate',
                      'Study & Conduct Certificate',
                      'Fee Clearance Certificate',
                      'Sports & Merit Certificate',
                      'Migration Certificate',
                      'Other',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),

                  if (_selectedType == 'Other') ...[
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Specify Certificate Type',
                      hint: 'e.g. Olympiad Winner, Attendance Certificate',
                      controller: _customTypeController,
                      isRequired: true,
                      prefixIcon: LucideIcons.edit3,
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Purpose / Reason Input
                  _buildInputField(
                    label: 'Purpose / Reason',
                    hint: 'e.g. Passport application, Higher studies admission, Visa verification',
                    controller: _purposeController,
                    isRequired: true,
                    maxLines: 2,
                    prefixIcon: LucideIcons.helpCircle,
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 3: Date & Urgency
                  _buildSectionTitle('Issuance Timeline & Urgency', LucideIcons.clock),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Issue / Request Date',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF6C4CF1)),
                                    const SizedBox(width: 10),
                                    Text(
                                      dateDisplay,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
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
                              'Urgency',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedUrgency = 'Normal'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _selectedUrgency == 'Normal' ? const Color(0xFF6C4CF1) : const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: _selectedUrgency == 'Normal' ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                                      ),
                                      child: Text(
                                        'Normal',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedUrgency == 'Normal' ? Colors.white : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedUrgency = 'Urgent'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _selectedUrgency == 'Urgent' ? const Color(0xFFEF4444) : const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: _selectedUrgency == 'Urgent' ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0)),
                                      ),
                                      child: Text(
                                        'Urgent',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedUrgency == 'Urgent' ? Colors.white : const Color(0xFF64748B),
                                        ),
                                      ),
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

                  _buildInputField(
                    label: 'Additional Remarks / Notes',
                    hint: 'e.g. Verified by class teacher, fee dues cleared',
                    controller: _remarksController,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _submitCertificate,
                    icon: const Icon(LucideIcons.check, size: 18, color: Colors.white),
                    label: const Text('Save & Issue Certificate', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
}
