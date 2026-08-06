import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LeaveRequestScreen extends StatefulWidget {
  final VoidCallback onBack;

  const LeaveRequestScreen({super.key, required this.onBack});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  Map<String, dynamic>? _leaveData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaveData();
  }

  Future<void> _loadLeaveData() async {
    final String response = await rootBundle.loadString('assets/mock/leave_request.json');
    final data = json.decode(response);
    setState(() {
      _leaveData = data;
      _isLoading = false;
    });
  }

  void _openApplyLeaveModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplyLeaveModal(
        leaveTypes: List<String>.from(_leaveData!['leaveTypes']),
        onSubmit: (newRequest) {
          setState(() {
            _leaveData!['history'].insert(0, newRequest);
          });
        },
      ),
    );
  }

  void _openLeaveDetailsModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeaveDetailsModal(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final history = _leaveData!['history'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Back Row
          Row(
            children: [
              AppBackButton(onPressed: widget.onBack),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text(
                  'Leave Request',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Primary Apply Leave Button
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _openApplyLeaveModal,
              icon: const Icon(LucideIcons.plusCircle, color: Colors.white, size: 20),
              label: const Text(
                'Apply Leave',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Section Title
          const Text(
            'Leave History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: AppSpacing.md),

          // Vertically Scrollable Leave History Cards
          ...history.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.cardSpacing),
                child: _buildLeaveCard(item),
              )),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(Map<String, dynamic> item) {
    Color statusBg;
    Color statusText;

    if (item['status'] == 'APPROVED') {
      statusBg = const Color(0xFFDCFCE7);
      statusText = const Color(0xFF15803D);
    } else if (item['status'] == 'PENDING') {
      statusBg = const Color(0xFFFEF3C7);
      statusText = const Color(0xFFD97706);
    } else {
      statusBg = const Color(0xFFFEE2E2);
      statusText = const Color(0xFFB91C1C);
    }

    return GestureDetector(
      onTap: () => _openLeaveDetailsModal(item),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.internalCardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['type'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(color: statusText, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF7A7A9D)),
                      const SizedBox(width: 4),
                      Text(
                        '${item['fromDate']} - ${item['toDate']} (${item['days']})',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['reason'],
                    style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A68)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(LucideIcons.chevronRight, color: Color(0xFF7A7A9D), size: 20),
          ],
        ),
      ),
    );
  }
}

/// Apply Leave Modal Form
class ApplyLeaveModal extends StatefulWidget {
  final List<String> leaveTypes;
  final Function(Map<String, dynamic>) onSubmit;

  const ApplyLeaveModal({super.key, required this.leaveTypes, required this.onSubmit});

  @override
  State<ApplyLeaveModal> createState() => _ApplyLeaveModalState();
}

class _ApplyLeaveModalState extends State<ApplyLeaveModal> {
  late String _selectedType;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _reasonController = TextEditingController();
  String? _attachmentName;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.leaveTypes.first;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate.isBefore(_fromDate)) {
            _toDate = _fromDate;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _handleSubmit() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reason for leave'), backgroundColor: Color(0xFFEF4444)),
      );
      return;
    }

    final int dayCount = _toDate.difference(_fromDate).inDays + 1;

    final newRequest = {
      "id": "LV-2024-${(100 + DateTime.now().second)}",
      "type": _selectedType,
      "fromDate": _formatDate(_fromDate),
      "toDate": _formatDate(_toDate),
      "days": "$dayCount ${dayCount == 1 ? 'Day' : 'Days'}",
      "reason": _reasonController.text.trim(),
      "status": "PENDING",
      "appliedOn": _formatDate(DateTime.now()),
      "approvedBy": "Pending Review",
      "attachment": _attachmentName,
    };

    widget.onSubmit(newRequest);

    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.screenPadding,
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.screenPadding,
      ),
      child: _isSubmitted ? _buildSuccessView() : _buildFormView(),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Apply Leave Request',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF7A7A9D)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Leave Type Dropdown
          const Text('Leave Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F8FF),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: const Color(0xFFE8E3F8)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: widget.leaveTypes
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // From Date & To Date Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('From Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _pickDate(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8FF),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: const Color(0xFFE8E3F8)),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C4CF1)),
                            const SizedBox(width: 6),
                            Text(_formatDate(_fromDate), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('To Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _pickDate(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8FF),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: const Color(0xFFE8E3F8)),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C4CF1)),
                            const SizedBox(width: 6),
                            Text(_formatDate(_toDate), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Reason TextField
          const Text('Reason for Leave', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 6),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Provide reason for absence...',
              filled: true,
              fillColor: const Color(0xFFF9F8FF),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: Color(0xFFE8E3F8))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: Color(0xFFE8E3F8))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Optional Attachment Button
          GestureDetector(
            onTap: () {
              setState(() {
                _attachmentName = "Medical_Doc_${DateTime.now().millisecond}.pdf";
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FF),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: const Color(0xFFE8E3F8)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.paperclip, color: Color(0xFF6C4CF1), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _attachmentName ?? 'Attach Document (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _attachmentName != null ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                      ),
                    ),
                  ),
                  if (_attachmentName != null)
                    const Icon(LucideIcons.checkCircle2, color: Color(0xFF22C55E), size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
                elevation: 0,
              ),
              child: const Text('Submit Leave Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.check, color: Color(0xFF15803D), size: 36),
        ),
        const SizedBox(height: 16),
        const Text(
          'Leave Request Submitted!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your leave application has been submitted to the class teacher for review.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF7A7A9D)),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
            ),
            child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Leave Details Modal
class LeaveDetailsModal extends StatelessWidget {
  final Map<String, dynamic> item;

  const LeaveDetailsModal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['id'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF6C4CF1)),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF7A7A9D)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: Color(0xFFF3EEFF)),
          const SizedBox(height: AppSpacing.md),

          _buildDetailRow('Leave Type', item['type']),
          _buildDetailRow('Duration', '${item['fromDate']} - ${item['toDate']} (${item['days']})'),
          _buildDetailRow('Applied On', item['appliedOn']),
          _buildDetailRow('Status', item['status']),
          _buildDetailRow('Reviewed By', item['approvedBy']),
          _buildDetailRow('Reason', item['reason']),
          if (item['attachment'] != null)
            _buildDetailRow('Attachment', item['attachment']),

          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
              ),
              child: const Text('Close', style: TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D))),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          ),
        ],
      ),
    );
  }
}
