import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class DriverLeaveRequestScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverLeaveRequestScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverLeaveRequestScreen> createState() => _DriverLeaveRequestScreenState();
}

class _DriverLeaveRequestScreenState extends State<DriverLeaveRequestScreen> {
  String _selectedLeaveType = 'Casual Leave';
  DateTime _fromDate = DateTime(2026, 8, 5);
  DateTime _toDate = DateTime(2026, 8, 6);
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;
  Map<String, dynamic>? _medicalCertificateFile;

  final List<Map<String, dynamic>> _leaveHistory = [
    {
      "type": "Casual Leave",
      "startDate": "12 Jul 2026",
      "endDate": "12 Jul 2026",
      "days": 1,
      "reason": "Personal work at RTO office for vehicle documentation update.",
      "status": "Approved",
      "appliedOn": "08 Jul 2026",
      "certificate": null,
    },
    {
      "type": "Sick Leave",
      "startDate": "20 Jun 2026",
      "endDate": "21 Jun 2026",
      "days": 2,
      "reason": "Fever & doctor prescribed rest.",
      "status": "Approved",
      "appliedOn": "19 Jun 2026",
      "certificate": "medical_cert_dr_verma.pdf",
    },
    {
      "type": "Casual Leave",
      "startDate": "10 May 2026",
      "endDate": "11 May 2026",
      "days": 2,
      "reason": "Family event in native town.",
      "status": "Approved",
      "appliedOn": "05 May 2026",
      "certificate": null,
    },
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _simulatePickCertificate(String source) {
    setState(() {
      _medicalCertificateFile = {
        'name': source == 'camera'
            ? 'medical_cert_${DateTime.now().millisecondsSinceEpoch}.jpg'
            : 'doctor_prescription_clinic.pdf',
        'size': '1.2 MB',
        'type': source == 'camera' ? 'JPG Image' : 'PDF Document',
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medical Certificate attached (${_medicalCertificateFile!['name']})'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeCertificate() {
    setState(() {
      _medicalCertificateFile = null;
    });
  }

  void _submitLeaveRequest() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reason for your leave request'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final fromStr = '${_fromDate.day} ${months[(_fromDate.month - 1).clamp(0, 11)]} ${_fromDate.year}';
    final toStr = '${_toDate.day} ${months[(_toDate.month - 1).clamp(0, 11)]} ${_toDate.year}';

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _leaveHistory.insert(0, {
          "type": _selectedLeaveType,
          "startDate": fromStr,
          "endDate": toStr,
          "days": (_toDate.difference(_fromDate).inDays + 1).clamp(1, 30),
          "reason": _reasonController.text.trim(),
          "status": "Pending",
          "appliedOn": "02 Aug 2026",
          "certificate": _selectedLeaveType == 'Sick Leave' && _medicalCertificateFile != null
              ? _medicalCertificateFile!['name']
              : null,
        });
        _reasonController.clear();
        _medicalCertificateFile = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(LucideIcons.checkCircle, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Leave request submitted for Transport Manager approval!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showLeaveDetailsBottomSheet(Map<String, dynamic> item) {
    final String type = item['type'];
    final String status = item['status'];
    final String startDate = item['startDate'];
    final String endDate = item['endDate'];
    final int days = item['days'] ?? 1;
    final String reason = item['reason'] ?? 'No detailed reason provided.';
    final String appliedOn = item['appliedOn'] ?? 'N/A';
    final String? certificate = item['certificate'];

    Color statusBg;
    Color statusColor;
    if (status == 'Approved') {
      statusBg = const Color(0xFFECFDF5);
      statusColor = const Color(0xFF10B981);
    } else if (status == 'Pending') {
      statusBg = const Color(0xFFFFFBEB);
      statusColor = const Color(0xFFD97706);
    } else {
      statusBg = const Color(0xFFFEF2F2);
      statusColor = const Color(0xFFEF4444);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header Title & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 14),

                // Detail Rows
                _buildModalDetailRow('Leave Dates', '$startDate - $endDate'),
                const SizedBox(height: 10),
                _buildModalDetailRow('Duration', '$days Day${days > 1 ? 's' : ''}'),
                const SizedBox(height: 10),
                _buildModalDetailRow('Applied On', appliedOn),
                const SizedBox(height: 10),
                _buildModalDetailRow('Reason', reason),

                if (certificate != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Medical Certificate',
                        style: TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          const Icon(LucideIcons.fileCheck, size: 14, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 4),
                          Text(
                            certificate,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF1E1E2D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSickLeaveSelected = _selectedLeaveType == 'Sick Leave';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 90.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Back Arrow & Page Title
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Leave Request',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Apply for Leave Form (Starts directly below header, no balance cards)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Apply for Leave',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Leave Type Field
                    const Text('Leave Type *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLeaveType,
                          isExpanded: true,
                          icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF64748B)),
                          items: ['Casual Leave', 'Sick Leave', 'Earned Leave', 'Unpaid Leave']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedLeaveType = val;
                                if (val != 'Sick Leave') {
                                  _medicalCertificateFile = null;
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // From Date & To Date 2-Column Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('From Date *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _fromDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2027),
                                  );
                                  if (picked != null) setState(() => _fromDate = picked);
                                },
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FD),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_fromDate.day}/${_fromDate.month}/${_fromDate.year}',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('To Date *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _toDate,
                                    firstDate: _fromDate,
                                    lastDate: DateTime(2027),
                                  );
                                  if (picked != null) setState(() => _toDate = picked);
                                },
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FD),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_toDate.day}/${_toDate.month}/${_toDate.year}',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
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

                    const SizedBox(height: 14),

                    // Reason Field
                    const Text('Reason *', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Enter reason for leave...',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FD),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                      ),
                    ),

                    // Dynamic Optional Medical Certificate Upload (Shown ONLY when Sick Leave is selected)
                    if (isSickLeaveSelected) ...[
                      const SizedBox(height: 14),
                      const Text('Medical Certificate (Optional)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      const SizedBox(height: 6),
                      _medicalCertificateFile == null
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FD),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFC7D2FE), width: 1.2),
                              ),
                              child: Column(
                                children: [
                                  const Icon(LucideIcons.uploadCloud, color: Color(0xFF6C4CF1), size: 24),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Attach medical certificate (JPG, PNG, PDF)',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _simulatePickCertificate('camera'),
                                        icon: const Icon(LucideIcons.camera, size: 14),
                                        label: const Text('Camera'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF6C4CF1),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      OutlinedButton.icon(
                                        onPressed: () => _simulatePickCertificate('gallery'),
                                        icon: const Icon(LucideIcons.fileText, size: 14),
                                        label: const Text('Browse File'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF1E1E2D),
                                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFBBF7D0)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.fileCheck, color: Color(0xFF10B981), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _medicalCertificateFile!['name'],
                                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${_medicalCertificateFile!['type']} • ${_medicalCertificateFile!['size']}',
                                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                                    onPressed: _removeCertificate,
                                  ),
                                ],
                              ),
                            ),
                    ],

                    const SizedBox(height: 18),

                    // Single Primary CTA Button ("Apply Leave")
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitLeaveRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Apply Leave'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Leave History Title
              const Text(
                'Leave History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Leave History Simple List (Leave Type, Date, Status, Chevron)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _leaveHistory.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0EDF8)),
                itemBuilder: (context, index) {
                  final item = _leaveHistory[index];
                  final String type = item['type'];
                  final String startDate = item['startDate'];
                  final String status = item['status'];

                  Color statusBg;
                  Color statusColor;
                  if (status == 'Approved') {
                    statusBg = const Color(0xFFECFDF5);
                    statusColor = const Color(0xFF10B981);
                  } else if (status == 'Pending') {
                    statusBg = const Color(0xFFFFFBEB);
                    statusColor = const Color(0xFFD97706);
                  } else {
                    statusBg = const Color(0xFFFEF2F2);
                    statusColor = const Color(0xFFEF4444);
                  }

                  return InkWell(
                    onTap: () => _showLeaveDetailsBottomSheet(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Type & Date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                startDate,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF7A7A9D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Status Badge & Chevron
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
