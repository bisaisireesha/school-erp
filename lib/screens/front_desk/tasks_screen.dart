import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TasksScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const TasksScreen({super.key, this.onBack});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 'TSK-301',
      'title': 'Prepare Welcome Kits for Grade 11 Orientation',
      'category': 'Admissions',
      'priority': 'High',
      'status': 'Pending',
      'assignedTo': 'Aditi Tiwari',
      'assignedRole': 'Front Desk Executive',
      'dueDate': 'Oct 26, 2023',
      'dueTime': '11:00 AM',
      'dateCreated': 'Oct 24, 2023',
      'description': 'Assemble 120 student handbook folders, ID lanyard sets, campus map guides, and timetable sheets in auditorium reception.',
    },
    {
      'id': 'TSK-302',
      'title': 'Verify & Print 15 Bonafide Certificate Requests',
      'category': 'Certificates',
      'priority': 'Medium',
      'status': 'In Progress',
      'assignedTo': 'Aditi Tiwari',
      'assignedRole': 'Front Desk Executive',
      'dueDate': 'Oct 25, 2023',
      'dueTime': '03:30 PM',
      'dateCreated': 'Oct 24, 2023',
      'description': 'Cross-check fee clearance with accounts department, print on official school letterhead, and get Principal signature stamp.',
    },
    {
      'id': 'TSK-303',
      'title': 'Dispatch Board Exam Registration Postal Packages',
      'category': 'Postal & Courier',
      'priority': 'High',
      'status': 'In Progress',
      'assignedTo': 'Ramesh Kumar',
      'assignedRole': 'Office Assistant',
      'dueDate': 'Oct 25, 2023',
      'dueTime': '05:00 PM',
      'dateCreated': 'Oct 23, 2023',
      'description': 'Pack sealed CBSE nominal roll documents with Speed Post barcode tracking labels and submit at GPO counter.',
    },
    {
      'id': 'TSK-304',
      'title': 'Audit Visitor Gate Pass & RFID Badge Inventory',
      'category': 'Visitor Desk',
      'priority': 'Low',
      'status': 'Completed',
      'assignedTo': 'Aditi Tiwari',
      'assignedRole': 'Front Desk Executive',
      'dueDate': 'Oct 24, 2023',
      'dueTime': '04:00 PM',
      'dateCreated': 'Oct 22, 2023',
      'description': 'Count remaining blank visitor badges (RFID cards), test barcode scanner battery, and reorder 200 plastic badge sleeves.',
    },
    {
      'id': 'TSK-305',
      'title': 'Follow Up with 8 Parent Inquiries for Class 6 Admissions',
      'category': 'Communication',
      'priority': 'Medium',
      'status': 'Pending',
      'assignedTo': 'Sunita Rao',
      'assignedRole': 'Admissions Counselor',
      'dueDate': 'Oct 27, 2023',
      'dueTime': '02:00 PM',
      'dateCreated': 'Oct 24, 2023',
      'description': 'Make follow-up phone calls regarding scheduled entrance assessment dates and syllabus download confirmations.',
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Admissions':
        return LucideIcons.graduationCap;
      case 'Certificates':
        return LucideIcons.award;
      case 'Postal & Courier':
        return LucideIcons.mail;
      case 'Visitor Desk':
        return LucideIcons.users;
      case 'Communication':
        return LucideIcons.phoneCall;
      default:
        return LucideIcons.clipboardList;
    }
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final status = task['status'] as String;
    final priority = task['priority'] as String;
    final category = task['category'] as String;
    final isCompleted = status == 'Completed';

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Pending':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'In Progress':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'Completed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Cancelled':
      default:
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
    }

    Color priorityColor;
    switch (priority) {
      case 'High':
      case 'Urgent':
        priorityColor = const Color(0xFFEF4444);
        break;
      case 'Medium':
        priorityColor = const Color(0xFFF59E0B);
        break;
      case 'Low':
      default:
        priorityColor = const Color(0xFF10B981);
    }

    final categoryIcon = _getCategoryIcon(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Toggle Checkbox
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (task['status'] == 'Completed') {
                        task['status'] = 'Pending';
                      } else {
                        task['status'] = 'Completed';
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFF10B981) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF1E1E2D),
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(categoryIcon, size: 11, color: const Color(0xFF6C4CF1)),
                                const SizedBox(width: 4),
                                Text(
                                  task['category'],
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$priority Priority',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: priorityColor),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  icon: const Icon(LucideIcons.moreVertical, size: 18, color: Color(0xFF8F90A6)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onSelected: (val) {
                    if (val == 'View Details') {
                      _showTaskDetails(task);
                    } else if (val == 'Delete') {
                      setState(() {
                        _tasks.remove(task);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted.')));
                    } else {
                      setState(() {
                        task['status'] = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task marked as $val.')));
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'In Progress', child: Text('Mark as In Progress')),
                    const PopupMenuItem(value: 'Completed', child: Text('Mark as Completed')),
                    const PopupMenuItem(value: 'Pending', child: Text('Mark as Pending')),
                    const PopupMenuItem(
                      value: 'Cancelled',
                      child: Row(
                        children: [
                          Icon(LucideIcons.xCircle, size: 16, color: Color(0xFFEF4444)),
                          SizedBox(width: 8),
                          Text('Mark as Cancelled', style: TextStyle(color: Color(0xFFEF4444))),
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
          ),

          // Description snippet
          if ((task['description'] as String?)?.isNotEmpty ?? false)
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
                child: Text(
                  task['description'],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Footer Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusTextColor),
                  ),
                ),
                const Spacer(),
                const Icon(LucideIcons.user, size: 13, color: Color(0xFF8F90A6)),
                const SizedBox(width: 4),
                Text(
                  task['assignedTo'],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
                const SizedBox(width: 10),
                const Icon(LucideIcons.clock, size: 13, color: Color(0xFF8F90A6)),
                const SizedBox(width: 4),
                Text(
                  'Due: ${task['dueDate']}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    final status = task['status'] as String;
    final priority = task['priority'] as String;
    final category = task['category'] as String;

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Pending':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'In Progress':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'Completed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Cancelled':
      default:
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
    }

    Color priorityColor;
    switch (priority) {
      case 'High':
      case 'Urgent':
        priorityColor = const Color(0xFFEF4444);
        break;
      case 'Medium':
        priorityColor = const Color(0xFFF59E0B);
        break;
      case 'Low':
      default:
        priorityColor = const Color(0xFF10B981);
    }

    final categoryIcon = _getCategoryIcon(category);

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
                            task['id'],
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
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$priority Priority',
                                  style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold),
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

              // Body Details
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title Banner
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
                            'Task Objective',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task['title'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDetailItem(LucideIcons.layoutGrid, 'Module Category', task['category']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.user, 'Assigned Staff', '${task['assignedTo']} (${task['assignedRole']})'),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.calendarClock, 'Due Deadline', '${task['dueDate']} at ${task['dueTime']}'),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.calendarCheck, 'Date Created', task['dateCreated'] ?? 'Recent'),
                    if ((task['description'] as String?)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 14),
                      _buildDetailItem(LucideIcons.fileText, 'Action Steps & Checklist', task['description']),
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
    int totalTasks = _tasks.length;
    int pendingCount = _tasks.where((e) => e['status'] == 'Pending').length;
    int inProgressCount = _tasks.where((e) => e['status'] == 'In Progress').length;
    int completedCount = _tasks.where((e) => e['status'] == 'Completed').length;

    final displayedTasks = _tasks.where((task) {
      final title = (task['title'] as String).toLowerCase();
      final category = (task['category'] as String).toLowerCase();
      final assigned = (task['assignedTo'] as String).toLowerCase();
      final status = (task['status'] as String);
      final priority = (task['priority'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty ||
          title.contains(query) ||
          category.contains(query) ||
          assigned.contains(query);

      bool matchesStatus;
      if (_filterStatus == 'All') {
        matchesStatus = true;
      } else if (_filterStatus == 'High Priority') {
        matchesStatus = priority == 'High' || priority == 'Urgent';
      } else {
        matchesStatus = status == _filterStatus;
      }

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
                            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Expanded(
                      child: Text('Desk Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewTaskModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('New Task', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
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
                        Expanded(child: _buildKpiCard('Total Tasks', '$totalTasks', LucideIcons.clipboardList, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Pending', '$pendingCount', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('In Progress', '$inProgressCount', LucideIcons.playCircle, const Color(0xFF3B82F6), const Color(0xFFEFF6FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Completed', '$completedCount', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFD1FAE5))),
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
                    hintText: 'Search task, category, staff...',
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

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: ['All', 'Pending', 'In Progress', 'Completed', 'High Priority'].map((filter) {
                    final isSelected = _filterStatus == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _filterStatus = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          filter,
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

              // List of Tasks
              if (displayedTasks.isEmpty)
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
                          child: const Icon(LucideIcons.checkCheck, size: 48, color: Color(0xFF6C4CF1)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Tasks Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no tasks matching your selected filter.',
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
                    children: displayedTasks.map((t) => _buildTaskCard(t)).toList(),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewTaskModal() async {
    final newTask = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewTaskBottomSheet(),
    );

    if (newTask != null) {
      setState(() {
        _tasks.insert(0, newTask);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added successfully!')));
      }
    }
  }
}

class _NewTaskBottomSheet extends StatefulWidget {
  const _NewTaskBottomSheet();

  @override
  State<_NewTaskBottomSheet> createState() => _NewTaskBottomSheetState();
}

class _NewTaskBottomSheetState extends State<_NewTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _assignedToController = TextEditingController(text: 'Aditi Tiwari');
  final _roleController = TextEditingController(text: 'Front Desk Executive');
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'General Admin';
  String _selectedPriority = 'Medium';
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedDueTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void dispose() {
    _titleController.dispose();
    _assignedToController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
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
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _pickDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedDueTime,
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
        _selectedDueTime = picked;
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

  Widget _buildPriorityChip(String label, Color color) {
    final isSelected = _selectedPriority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.12) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? color : const Color(0xFFE2E8F0), width: isSelected ? 1.5 : 1),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Task Title.')));
      return;
    }

    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dueFormatted = '${monthNames[_selectedDueDate.month - 1]} ${_selectedDueDate.day}, ${_selectedDueDate.year}';
    final timeFormatted = _selectedDueTime.format(context);
    final now = DateTime.now();
    final createdFormatted = '${monthNames[now.month - 1]} ${now.day}, ${now.year}';

    final newTask = {
      'id': 'TSK-${now.millisecondsSinceEpoch.toString().substring(8)}',
      'title': _titleController.text.trim(),
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'status': 'Pending',
      'assignedTo': _assignedToController.text.trim().isEmpty ? 'Front Desk Staff' : _assignedToController.text.trim(),
      'assignedRole': _roleController.text.trim().isEmpty ? 'Staff' : _roleController.text.trim(),
      'dueDate': dueFormatted,
      'dueTime': timeFormatted,
      'dateCreated': createdFormatted,
      'description': _descriptionController.text.trim(),
    };

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dueDateDisplay = '${monthNames[_selectedDueDate.month - 1]} ${_selectedDueDate.day}, ${_selectedDueDate.year}';
    final dueTimeDisplay = _selectedDueTime.format(context);

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
          // Header
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
                      child: const Icon(LucideIcons.clipboardPlus, color: Color(0xFF6C4CF1), size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create New Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        SizedBox(height: 2),
                        Text('Assign operational task & deadline', style: TextStyle(fontSize: 12, color: Color(0xFF8F90A6))),
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
                  // Section 1: Task Overview
                  _buildSectionTitle('Task Overview', LucideIcons.fileText),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Task Title / Objective',
                    hint: 'e.g. Prepare Welcome Kits for Orientation',
                    controller: _titleController,
                    isRequired: true,
                    prefixIcon: LucideIcons.tag,
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: 'Task Category',
                    value: _selectedCategory,
                    prefixIcon: LucideIcons.layoutGrid,
                    items: [
                      'General Admin',
                      'Admissions',
                      'Visitor Desk',
                      'Certificates',
                      'Postal & Courier',
                      'Communication',
                      'Facilities',
                      'Other'
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Priority Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Priority Level',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildPriorityChip('Low', const Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          _buildPriorityChip('Medium', const Color(0xFFF59E0B)),
                          const SizedBox(width: 8),
                          _buildPriorityChip('High', const Color(0xFFEF4444)),
                          const SizedBox(width: 8),
                          _buildPriorityChip('Urgent', const Color(0xFF9333EA)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 2: Assignment & Deadlines
                  _buildSectionTitle('Assignment & Deadlines', LucideIcons.calendarClock),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Assigned Staff',
                          hint: 'e.g. Aditi Tiwari',
                          controller: _assignedToController,
                          prefixIcon: LucideIcons.user,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          label: 'Staff Role',
                          hint: 'e.g. Front Desk Executive',
                          controller: _roleController,
                          prefixIcon: LucideIcons.briefcase,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Due Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842))),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickDueDate,
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
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dueDateDisplay,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
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
                            const Text('Due Time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842))),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickDueTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.clock, size: 18, color: Color(0xFF6C4CF1)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dueTimeDisplay,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
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
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 3: Detailed Checklist & Instructions
                  _buildSectionTitle('Instructions & Checklist', LucideIcons.clipboardList),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Detailed Instructions / Steps',
                    hint: 'e.g. Assemble 120 folders, check nominal roll with accounts, obtain signatures...',
                    controller: _descriptionController,
                    maxLines: 3,
                    prefixIcon: LucideIcons.fileText,
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
                    onPressed: _submitForm,
                    icon: const Icon(LucideIcons.check, size: 18, color: Colors.white),
                    label: const Text('Create Task', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
