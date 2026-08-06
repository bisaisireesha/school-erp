import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ComplaintsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ComplaintsScreen({super.key, this.onBack});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'CMP-5001',
      'complainerName': 'Mr. Rahul Sharma',
      'role': 'Parent',
      'category': 'Transport',
      'title': 'Bus arrives late consistently',
      'priority': 'High',
      'date': 'Oct 24, 2023',
      'status': 'Open',
    },
    {
      'id': 'CMP-5002',
      'complainerName': 'Sneha Gupta',
      'role': 'Student',
      'category': 'Facilities',
      'title': 'AC not working in Classroom 10B',
      'priority': 'Medium',
      'date': 'Oct 23, 2023',
      'status': 'In Progress',
    },
    {
      'id': 'CMP-5003',
      'complainerName': 'Amit Singh',
      'role': 'Staff',
      'category': 'IT Support',
      'title': 'Smartboard calibration issue',
      'priority': 'Low',
      'date': 'Oct 21, 2023',
      'status': 'Resolved',
    },
  ];

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
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

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    final status = complaint['status'] as String;
    final priority = complaint['priority'] as String;
    final category = complaint['category'] as String;
    
    Color statusBg, statusTextColor;
    switch (status) {
      case 'Open':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      case 'In Progress':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Resolved':
      case 'Closed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = const Color(0xFFEF4444);
        break;
      case 'Medium':
        priorityColor = const Color(0xFFF59E0B);
        break;
      case 'Low':
        priorityColor = const Color(0xFF10B981);
        break;
      default:
        priorityColor = const Color(0xFF64748B);
    }

    IconData categoryIcon;
    switch (category) {
      case 'Transport': categoryIcon = LucideIcons.bus; break;
      case 'Facilities': categoryIcon = LucideIcons.building; break;
      case 'IT Support': categoryIcon = LucideIcons.monitor; break;
      case 'Academics': categoryIcon = LucideIcons.bookOpen; break;
      default: categoryIcon = LucideIcons.fileText;
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
                complaint['id'],
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
                      complaint['status'],
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
                          _complaints.removeWhere((c) => c['id'] == complaint['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complaint deleted')));
                      } else if (action == 'View Details') {
                        _showComplaintDetails(complaint);
                      } else {
                        setState(() {
                          complaint['status'] = action;
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Open', child: Text('Mark as Open')),
                      const PopupMenuItem(value: 'In Progress', child: Text('Mark as In Progress')),
                      const PopupMenuItem(value: 'Resolved', child: Text('Mark as Resolved')),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(categoryIcon, color: const Color(0xFF6C4CF1), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'By: ', style: TextStyle(color: Color(0xFF8F90A6), fontSize: 13, fontWeight: FontWeight.w500)),
                          TextSpan(text: complaint['complainerName'], style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 13, fontWeight: FontWeight.w700)),
                          TextSpan(text: ' (${complaint['role']})', style: const TextStyle(color: Color(0xFF8F90A6), fontSize: 13, fontWeight: FontWeight.w500)),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.folder, size: 16, color: Color(0xFF8F90A6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        complaint['category'],
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
                      complaint['date'],
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
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Priority:',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8F90A6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  border: Border.all(color: priorityColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      priority,
                      style: TextStyle(
                        fontSize: 11,
                        color: priorityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComplaintDetails(Map<String, dynamic> complaint) {
    final status = complaint['status'] as String;
    final priority = complaint['priority'] as String;
    final category = complaint['category'] as String;

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Open':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      case 'In Progress':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Resolved':
      case 'Closed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = const Color(0xFFEF4444);
        break;
      case 'Medium':
        priorityColor = const Color(0xFFF59E0B);
        break;
      case 'Low':
        priorityColor = const Color(0xFF10B981);
        break;
      default:
        priorityColor = const Color(0xFF64748B);
    }

    IconData categoryIcon;
    switch (category) {
      case 'Transport':
        categoryIcon = LucideIcons.bus;
        break;
      case 'Facilities':
        categoryIcon = LucideIcons.building;
        break;
      case 'IT Support':
        categoryIcon = LucideIcons.monitor;
        break;
      case 'Academics':
        categoryIcon = LucideIcons.bookOpen;
        break;
      default:
        categoryIcon = LucideIcons.fileText;
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(categoryIcon, color: const Color(0xFF6C4CF1), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint['id'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
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
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.1),
                                  border: Border.all(color: priorityColor.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: priorityColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$priority Priority',
                                      style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
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
                    // Title card
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
                            'Issue Title',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            complaint['title'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDetailItem(LucideIcons.user, 'Complainer Name', '${complaint['complainerName']} (${complaint['role']})'),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.folder, 'Category', complaint['category']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.calendar, 'Date Logged', complaint['date']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.activity, 'Current Status', complaint['status']),
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
    int totalComplaints = _complaints.length;
    int openCount = _complaints.where((e) => e['status'] == 'Open').length;
    int inProgressCount = _complaints.where((e) => e['status'] == 'In Progress').length;
    int resolvedCount = _complaints.where((e) => e['status'] == 'Resolved' || e['status'] == 'Closed').length;

    final displayedComplaints = _complaints.where((item) {
      final name = (item['complainerName'] as String).toLowerCase();
      final title = (item['title'] as String).toLowerCase();
      final id = (item['id'] as String).toLowerCase();
      final status = (item['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || name.contains(query) || title.contains(query) || id.contains(query);
      bool matchesStatus = _filterStatus == 'All' || status == _filterStatus;
      
      if (_filterStatus == 'Resolved') {
        matchesStatus = status == 'Resolved' || status == 'Closed';
      }

      return matchesQuery && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
                      child: Text('Complaints', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewComplaintModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('Add Complaint', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        Expanded(child: _buildKpiCard('Total', '$totalComplaints', LucideIcons.messageSquare, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Open', '$openCount', LucideIcons.alertCircle, const Color(0xFFEF4444), const Color(0xFFFEE2E2))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('In Progress', '$inProgressCount', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Resolved', '$resolvedCount', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFD1FAE5))),
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
                    hintText: 'Search title, name, ID...',
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
                  children: ['All', 'Open', 'In Progress', 'Resolved'].map((status) {
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

              // List of complaints
              if (displayedComplaints.isEmpty)
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
                          child: const Icon(LucideIcons.messageSquareOff, size: 48, color: Color(0xFF6C4CF1)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Complaints Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no complaints matching your filter.',
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
                    children: displayedComplaints.map((c) => _buildComplaintCard(c)).toList(),
                  ),
                ),
                
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewComplaintModal() async {
    final newComplaint = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewComplaintBottomSheet(),
    );

    if (newComplaint != null) {
      setState(() {
        _complaints.insert(0, newComplaint);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complaint logged successfully!')));
      }
    }
  }
}

class _NewComplaintBottomSheet extends StatefulWidget {
  const _NewComplaintBottomSheet();

  @override
  State<_NewComplaintBottomSheet> createState() => _NewComplaintBottomSheetState();
}

class _NewComplaintBottomSheetState extends State<_NewComplaintBottomSheet> {
  final _titleController = TextEditingController();
  final _complainerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customCategoryController = TextEditingController();
  
  String _selectedRole = 'Parent'; // Parent, Student, Staff
  String _selectedCategory = 'Facilities';
  String _selectedPriority = 'Medium';

  @override
  void dispose() {
    _titleController.dispose();
    _complainerController.dispose();
    _descriptionController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Widget _buildFormField(String label, String hint, {required TextEditingController controller, bool isRequired = false, int maxLines = 1}) {
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
          maxLines: maxLines,
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

  void _submitComplaint() {
    if (_titleController.text.isEmpty || _complainerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields (*).')));
      return;
    }

    if (_selectedCategory == 'Other' && _customCategoryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please specify the category (*).')));
      return;
    }

    final date = DateTime.now();
    final categoryName = (_selectedCategory == 'Other' && _customCategoryController.text.trim().isNotEmpty)
        ? _customCategoryController.text.trim()
        : _selectedCategory;

    final newCmp = {
      'id': 'CMP-${date.millisecondsSinceEpoch.toString().substring(9)}',
      'title': _titleController.text,
      'complainerName': _complainerController.text,
      'role': _selectedRole,
      'category': categoryName,
      'priority': _selectedPriority,
      'date': '${date.month}/${date.day}/${date.year}',
      'status': 'Open',
    };
    Navigator.pop(context, newCmp);
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF8B8B8B)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D))),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
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
                    const Text('Log Complaint', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 4),
                    const Text('Record a new issue or grievance', style: TextStyle(fontSize: 14, color: Color(0xFF8B8B8B))),
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
            
            _buildFormField('Issue Title', 'e.g. AC not working', controller: _titleController, isRequired: true),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(child: _buildFormField('Complainer Name', 'e.g. Mr. Sharma', controller: _complainerController, isRequired: true)),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown('Role', _selectedRole, ['Parent', 'Student', 'Staff'], (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildDropdown('Category', _selectedCategory, ['Facilities', 'Transport', 'IT Support', 'Academics', 'Other'], (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown('Priority', _selectedPriority, ['High', 'Medium', 'Low'], (val) {
                    if (val != null) setState(() => _selectedPriority = val);
                  }),
                ),
              ],
            ),
            if (_selectedCategory == 'Other') ...[
              const SizedBox(height: 20),
              _buildFormField('Specify Category', 'e.g. Canteen, Sports, Library', controller: _customCategoryController, isRequired: true),
            ],
            const SizedBox(height: 20),

            _buildFormField('Description / Notes', 'Additional details about the issue...', controller: _descriptionController, maxLines: 3),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Save Complaint', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
