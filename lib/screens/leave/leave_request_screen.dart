import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LeaveRequestScreen extends StatefulWidget {
  final VoidCallback onBack;

  const LeaveRequestScreen({super.key, required this.onBack});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  List<Map<String, dynamic>> _mockLeaveRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaveRequests();
  }

  Future<void> _loadLeaveRequests() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/student_leave_requests.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _mockLeaveRequests = List<Map<String, dynamic>>.from(data['leaveRequests']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showNewLeaveBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return NewLeaveBottomSheet(
          onSubmit: (leaveData) {
            setState(() {
              _mockLeaveRequests.insert(0, leaveData);
            });
          }
        );
      },
    );
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
                    const Text('Leave Request', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Main Content Area
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Apply for Leave Banner
                    GestureDetector(
                      onTap: _showNewLeaveBottomSheet,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C4CF1), Color(0xFF8B73F5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(LucideIcons.filePlus, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Apply for Leave',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Submit a new leave application',
                                    style: TextStyle(fontSize: 13, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Leave History Header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Leave History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Leave Requests List
                    Builder(
                      builder: (context) {
                        if (_isLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
                          );
                        }
                        if (_mockLeaveRequests.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text('No leave requests found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 900) {
                              return Wrap(
                                spacing: 16,
                                runSpacing: 0,
                                children: _mockLeaveRequests.map((request) {
                                  return SizedBox(
                                    width: (constraints.maxWidth - 16) / 2,
                                    child: _buildLeaveCard(request),
                                  );
                                }).toList(),
                              );
                            } else {
                              return Column(
                                children: _mockLeaveRequests.map((request) => _buildLeaveCard(request)).toList(),
                              );
                            }
                          },
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveCard(Map<String, dynamic> request) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    switch (request['status']) {
      case 'Approved':
        statusColor = const Color(0xFF16A34A);
        statusBg = const Color(0xFFF0FDF4);
        statusIcon = LucideIcons.checkCircle2;
        break;
      case 'Rejected':
        statusColor = const Color(0xFFE11D48);
        statusBg = const Color(0xFFFFF1F2);
        statusIcon = LucideIcons.xCircle;
        break;
      case 'Pending':
      default:
        statusColor = const Color(0xFFF59E0B);
        statusBg = const Color(0xFFFEF3C7);
        statusIcon = LucideIcons.clock3;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request['reason'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      request['status'],
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: statusColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDateInfo(LucideIcons.calendarDays, 'From', _formatDisplayDate(request['fromDate'])),
              const SizedBox(width: 24),
              _buildDateInfo(LucideIcons.calendarCheck2, 'To', _formatDisplayDate(request['toDate'])),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Applied on: ', style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
              Text(
                _formatDisplayDate(request['appliedOn']),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: const Color(0xFF6C6C80)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          ],
        ),
      ],
    );
  }

  String _formatDisplayDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class NewLeaveBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const NewLeaveBottomSheet({super.key, required this.onSubmit});
  
  @override
  State<NewLeaveBottomSheet> createState() => _NewLeaveBottomSheetState();
}

class _NewLeaveBottomSheetState extends State<NewLeaveBottomSheet> {
  final _otherTypeController = TextEditingController();
  final _reasonController = TextEditingController();
  String _leaveType = 'Sick Leave';
  DateTime? _fromDate;
  DateTime? _toDate;
  
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        if (isFromDate) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = picked;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Apply for Leave', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(LucideIcons.x, size: 20, color: Color(0xFF1E1E2D)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              const Text('Leave Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _leaveType,
                    isExpanded: true,
                    icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF6C6C80)),
                    items: ['Sick Leave', 'Family Trip', 'Personal', 'Other']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 15))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _leaveType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              if (_leaveType == 'Other') ...[
                const Text('Other Leave Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 8),
                TextField(
                  controller: _otherTypeController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Enter other leave type...',
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF3EEFF), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF3EEFF), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('From', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C6C80)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatDate(_fromDate),
                                    style: TextStyle(fontSize: 14, color: _fromDate == null ? const Color(0xFF9E9E9E) : const Color(0xFF1E1E2D)),
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
                        const Text('To', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C6C80)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatDate(_toDate),
                                    style: TextStyle(fontSize: 14, color: _toDate == null ? const Color(0xFF9E9E9E) : const Color(0xFF1E1E2D)),
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
              const SizedBox(height: 20),
              
              const Text('Reason', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter reason for leave...',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF3EEFF), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF3EEFF), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_fromDate == null || _toDate == null) return;
                    if (_reasonController.text.trim().isEmpty) return;
                    if (_leaveType == 'Other' && _otherTypeController.text.trim().isEmpty) return;
                    
                    final now = DateTime.now();
                    final appliedOn = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                    
                    final finalLeaveType = _leaveType == 'Other' ? _otherTypeController.text.trim() : _leaveType;
                    
                    widget.onSubmit({
                      'reason': _reasonController.text.trim(),
                      'fromDate': _formatDate(_fromDate),
                      'toDate': _formatDate(_toDate),
                      'status': 'Pending',
                      'appliedOn': appliedOn,
                      'type': finalLeaveType,
                    });
                    
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Submit Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
