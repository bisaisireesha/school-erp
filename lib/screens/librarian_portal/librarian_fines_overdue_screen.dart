import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'librarian_search_bar.dart';

class LibrarianFinesOverdueScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const LibrarianFinesOverdueScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<LibrarianFinesOverdueScreen> createState() => _LibrarianFinesOverdueScreenState();
}

class _LibrarianFinesOverdueScreenState extends State<LibrarianFinesOverdueScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All'; // All, Pending, Paid

  late List<Map<String, dynamic>> _overdueItems;
  late List<Map<String, dynamic>> _recentlyCollected;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final rawOverdue = (widget.data['overdueBooks'] as List? ?? []);

    _overdueItems = [
      {
        "id": "OD-101",
        "studentName": "Aarav Sharma",
        "memberId": "STU-8842",
        "className": "Grade 10-A",
        "bookTitle": "Fundamentals of Physics",
        "dueDate": "02 Aug 2026",
        "daysOverdue": 4,
        "fineAmount": 40,
        "status": "Pending",
        "phone": "+91 98765 43210",
      },
      {
        "id": "OD-102",
        "studentName": "Ananya Verma",
        "memberId": "STU-9102",
        "className": "Grade 12-B",
        "bookTitle": "Organic Chemistry Vol 2",
        "dueDate": "01 Aug 2026",
        "daysOverdue": 5,
        "fineAmount": 50,
        "status": "Pending",
        "phone": "+91 98765 43211",
      },
      {
        "id": "OD-103",
        "studentName": "Rohan Gupta",
        "memberId": "STU-7751",
        "className": "Grade 9-C",
        "bookTitle": "World History Encyclopedia",
        "dueDate": "28 Jul 2026",
        "daysOverdue": 9,
        "fineAmount": 90,
        "status": "Pending",
        "phone": "+91 98765 43212",
      },
      {
        "id": "OD-104",
        "studentName": "Priya Nair",
        "memberId": "STU-6620",
        "className": "Grade 11-A",
        "bookTitle": "Calculus & Analytical Geometry",
        "dueDate": "06 Aug 2026",
        "daysOverdue": 0,
        "fineAmount": 0,
        "status": "Paid",
        "phone": "+91 98765 43213",
      },
      {
        "id": "OD-105",
        "studentName": "Kabir Patel",
        "memberId": "STU-8819",
        "className": "Grade 7-B",
        "bookTitle": "Tales of Shakespeare",
        "dueDate": "30 Jul 2026",
        "daysOverdue": 7,
        "fineAmount": 70,
        "status": "Pending",
        "phone": "+91 98765 43214",
      },
    ];

    for (var i = 0; i < rawOverdue.length; i++) {
      final raw = rawOverdue[i];
      if (_overdueItems.indexWhere((item) => item['id'] == (raw['id'] ?? 'OD-${200 + i}')) == -1) {
        _overdueItems.add({
          "id": raw['id'] ?? 'OD-${200 + i}',
          "studentName": raw['memberName'] ?? 'Student Member',
          "memberId": raw['memberId'] ?? 'STU-${1000 + i}',
          "className": raw['class'] ?? 'Grade 10',
          "bookTitle": raw['bookTitle'] ?? 'Library Resource',
          "dueDate": raw['dueDate'] ?? '03 Aug 2026',
          "daysOverdue": raw['daysOverdue'] ?? 3,
          "fineAmount": (raw['daysOverdue'] ?? 3) * 10,
          "status": "Pending",
          "phone": "+91 98765 00000",
        });
      }
    }

    _recentlyCollected = [
      {
        "id": "PAY-901",
        "studentName": "Isha Malhotra",
        "bookTitle": "Advanced Biology Reader",
        "amountPaid": 60,
        "paymentMethod": "UPI",
        "paidDateTime": "Today, 09:30 AM",
      },
      {
        "id": "PAY-902",
        "studentName": "Vikram Singh",
        "bookTitle": "Macroeconomics 101",
        "amountPaid": 30,
        "paymentMethod": "Cash",
        "paidDateTime": "Today, 08:45 AM",
      },
      {
        "id": "PAY-903",
        "studentName": "Meera Joshi",
        "bookTitle": "Modern World Atlas",
        "amountPaid": 120,
        "paymentMethod": "Card",
        "paidDateTime": "Yesterday, 04:15 PM",
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    return _overdueItems.where((item) {
      if (_activeFilter == 'Pending' && item['status'] != 'Pending') return false;
      if (_activeFilter == 'Paid' && item['status'] != 'Paid') return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = item['studentName'].toString().toLowerCase();
      final title = item['bookTitle'].toString().toLowerCase();
      return name.contains(q) || title.contains(q);
    }).toList();
  }

  int get _totalPendingAmount {
    int sum = 0;
    for (var item in _overdueItems) {
      if (item['status'] == 'Pending') {
        sum += (item['fineAmount'] as int);
      }
    }
    return sum;
  }

  int get _pendingCount {
    return _overdueItems.where((i) => i['status'] == 'Pending').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Fines & Overdue',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Single Top KPI Card (Pending Fines)
                    _buildPendingFinesKpiCard(),
                    const SizedBox(height: 14),

                    // 2. Standard Search Bar Directly Below KPI Card
                    LibrarianSearchBar(
                      controller: _searchController,
                      hintText: 'Search student name or book name...',
                      onChanged: (val) => setState(() => _searchQuery = val),
                      onClear: () => setState(() => _searchQuery = ''),
                    ),
                    const SizedBox(height: 12),

                    // 3. Simple Filter Chips: All, Pending, Paid
                    _buildFilterChips(),
                    const SizedBox(height: 16),

                    // Overdue Task List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overdue Fines List',
                          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        Text(
                          '${_filteredItems.length} items',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 4. Clean Task List Rows
                    _buildTaskListRows(),
                    const SizedBox(height: 24),

                    // 5. Simple Recently Collected Section
                    _buildRecentlyCollectedSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 1. SINGLE KPI CARD (PENDING FINES) ────────────────────────────────────
  Widget _buildPendingFinesKpiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EDF8)),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Pending Fines',
                style: TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                '₹$_totalPendingAmount',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), letterSpacing: -0.5),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$_pendingCount Pending',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. SIMPLE FILTER CHIPS (ALL, PENDING, PAID) ──────────────────────────
  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Paid'];

    return Row(
      children: filters.map((f) {
        final bool isSelected = _activeFilter == f;

        return GestureDetector(
          onTap: () => setState(() => _activeFilter = f),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              f,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF6C4CF1),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── 3. CLEAN TASK-LIST ROWS ───────────────────────────────────────────────
  Widget _buildTaskListRows() {
    final list = _filteredItems;

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0EDF8)),
          boxShadow: AppShadows.soft,
        ),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 30),
            SizedBox(height: 6),
            Text(
              'No Overdue Items Found',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final bool isPaid = item['status'] == 'Paid';

        return GestureDetector(
          onTap: () => _showFineDetailsSheet(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Student Name, Fine Amount & Overdue Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        item['studentName'],
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${item['fineAmount']}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: isPaid ? const Color(0xFF10B981) : const Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPaid ? 'Paid' : '${item['daysOverdue']}d Overdue',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subtitle Row: Book Name & Due Date
                Text(
                  '${item['bookTitle']}  •  Due ${item['dueDate']}',
                  style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Bottom Action Bar: Collect Fine (Single Primary Button) & Card Menu
                Row(
                  children: [
                    const Spacer(),
                    if (!isPaid)
                      ElevatedButton(
                        onPressed: () => _showCollectFineModal(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Collect Fine'),
                      ),
                    const SizedBox(width: 4),

                    // Context Menu for Secondary Actions (Reminder, Details)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF7A7A9D), size: 18),
                      onSelected: (action) {
                        if (action == 'reminder') {
                          _sendReminder(item);
                        } else if (action == 'details') {
                          _showFineDetailsSheet(item);
                        }
                      },
                      itemBuilder: (context) => [
                        if (!isPaid)
                          const PopupMenuItem(
                            value: 'reminder',
                            child: Row(
                              children: [
                                Icon(LucideIcons.bell, size: 16, color: Color(0xFF6C4CF1)),
                                SizedBox(width: 8),
                                Text('Send Reminder'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'details',
                          child: Row(
                            children: [
                              Icon(LucideIcons.fileText, size: 16, color: Color(0xFF7A7A9D)),
                              SizedBox(width: 8),
                              Text('Fine Details'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── 4. FINE DETAILS BOTTOM SHEET ──────────────────────────────────────────
  void _showFineDetailsSheet(Map<String, dynamic> item) {
    final bool isPaid = item['status'] == 'Paid';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fine Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded, color: Color(0xFF7A7A9D)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Student Name', item['studentName']),
              _buildDetailRow('Member ID', item['memberId']),
              _buildDetailRow('Class', item['className']),
              _buildDetailRow('Contact Phone', item['phone']),
              _buildDetailRow('Book Title', item['bookTitle']),
              _buildDetailRow('Due Date', item['dueDate']),
              _buildDetailRow('Overdue Duration', '${item['daysOverdue']} Days'),
              _buildDetailRow('Fine Calculation', '₹10/day × ${item['daysOverdue']} days = ₹${item['fineAmount']}'),
              _buildDetailRow('Status', item['status']),
              const SizedBox(height: 20),
              if (!isPaid)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _sendReminder(item);
                        },
                        icon: const Icon(LucideIcons.bell, size: 16),
                        label: const Text('Reminder'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6C4CF1),
                          side: const BorderSide(color: Color(0xFFEBE8FF)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCollectFineModal(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Collect Fine', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A7A9D))),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        ],
      ),
    );
  }

  // ─── 5. RECENTLY COLLECTED FINES LIST ──────────────────────────────────────
  Widget _buildRecentlyCollectedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recently Collected',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Viewing all collected fines history.')),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentlyCollected.length,
          itemBuilder: (context, index) {
            final rec = _recentlyCollected[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0EDF8)),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec['studentName'],
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        Text(
                          '${rec['bookTitle']}  •  ${rec['paidDateTime']}',
                          style: const TextStyle(fontSize: 11.0, color: Color(0xFF7A7A9D)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${rec['amountPaid']}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── 6. COLLECT FINE BOTTOM SHEET MODAL ────────────────────────────────────
  void _showCollectFineModal(Map<String, dynamic> item) {
    String selectedPaymentMethod = 'UPI';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Collect Fine Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close_rounded, color: Color(0xFF7A7A9D)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Student: ${item['studentName']}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  Text('Book: ${item['bookTitle']}', style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D))),
                  const SizedBox(height: 14),

                  const Text('Fine Amount', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 4),
                  Text('₹${item['fineAmount']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                  const SizedBox(height: 14),

                  const Text('Payment Method', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 8),
                  Row(
                    children: ['UPI', 'Cash', 'Card'].map((pm) {
                      final isSelected = selectedPaymentMethod == pm;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedPaymentMethod = pm),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              pm,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          item['status'] = 'Paid';
                          _recentlyCollected.insert(0, {
                            "id": "PAY-${DateTime.now().millisecondsSinceEpoch}",
                            "studentName": item['studentName'],
                            "bookTitle": item['bookTitle'],
                            "amountPaid": item['fineAmount'],
                            "paymentMethod": selectedPaymentMethod,
                            "paidDateTime": "Just now",
                          });
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('₹${item['fineAmount']} collected from ${item['studentName']} via $selectedPaymentMethod!'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Collect Payment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _sendReminder(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Overdue reminder sent to ${item['studentName']}.'),
        backgroundColor: const Color(0xFF6C4CF1),
      ),
    );
  }
}
