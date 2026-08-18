import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'librarian_search_bar.dart';
import 'librarian_fine_details_screen.dart';

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

  Map<String, dynamic>? _selectedDetailItem;

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
        "author": "H. C. Verma",
        "isbn": "978-0-123456-78-9",
        "category": "Science / Physics",
        "dueDate": "02 Aug 2026",
        "daysOverdue": 4,
        "fineRate": 10,
        "fineAmount": 40,
        "status": "Pending",
        "phone": "+91 98765 43210",
        "history": [
          {"event": "Book Issued", "date": "19 Jul 2026, 10:30 AM"},
          {"event": "Due Date Passed", "date": "02 Aug 2026, 11:59 PM"},
          {"event": "Overdue Notice Sent", "date": "03 Aug 2026, 09:00 AM"},
        ]
      },
      {
        "id": "OD-102",
        "studentName": "Ananya Verma",
        "memberId": "STU-9102",
        "className": "Grade 12-B",
        "bookTitle": "Organic Chemistry Vol 2",
        "author": "O. P. Tandon",
        "isbn": "978-0-987654-32-1",
        "category": "Chemistry",
        "dueDate": "01 Aug 2026",
        "daysOverdue": 5,
        "fineRate": 10,
        "fineAmount": 50,
        "status": "Pending",
        "phone": "+91 98765 43211",
        "history": [
          {"event": "Book Issued", "date": "18 Jul 2026, 02:15 PM"},
          {"event": "Due Date Passed", "date": "01 Aug 2026, 11:59 PM"},
          {"event": "Overdue Reminder Sent", "date": "02 Aug 2026, 10:00 AM"},
        ]
      },
      {
        "id": "OD-103",
        "studentName": "Rohan Gupta",
        "memberId": "STU-7751",
        "className": "Grade 9-C",
        "bookTitle": "World History Encyclopedia",
        "author": "Philip Parker",
        "isbn": "978-1-405341-23-4",
        "category": "Social Studies",
        "dueDate": "28 Jul 2026",
        "daysOverdue": 9,
        "fineRate": 10,
        "fineAmount": 90,
        "status": "Pending",
        "phone": "+91 98765 43212",
        "history": [
          {"event": "Book Issued", "date": "14 Jul 2026, 11:00 AM"},
          {"event": "Due Date Passed", "date": "28 Jul 2026, 11:59 PM"},
          {"event": "First Overdue Notice", "date": "29 Jul 2026, 09:30 AM"},
          {"event": "Second Overdue Notice", "date": "02 Aug 2026, 10:30 AM"},
        ]
      },
      {
        "id": "OD-104",
        "studentName": "Priya Nair",
        "memberId": "STU-6620",
        "className": "Grade 11-A",
        "bookTitle": "Calculus & Analytical Geometry",
        "author": "George Thomas",
        "isbn": "978-0-201531-74-9",
        "category": "Mathematics",
        "dueDate": "06 Aug 2026",
        "daysOverdue": 0,
        "fineRate": 10,
        "fineAmount": 0,
        "status": "Paid",
        "phone": "+91 98765 43213",
        "history": [
          {"event": "Book Issued", "date": "23 Jul 2026, 03:00 PM"},
          {"event": "Book Returned & Fine Paid", "date": "06 Aug 2026, 09:15 AM"},
        ]
      },
      {
        "id": "OD-105",
        "studentName": "Kabir Patel",
        "memberId": "STU-8819",
        "className": "Grade 7-B",
        "bookTitle": "Tales of Shakespeare",
        "author": "Charles Lamb",
        "isbn": "978-0-140620-85-6",
        "category": "Literature",
        "dueDate": "30 Jul 2026",
        "daysOverdue": 7,
        "fineRate": 10,
        "fineAmount": 70,
        "status": "Pending",
        "phone": "+91 98765 43214",
        "history": [
          {"event": "Book Issued", "date": "16 Jul 2026, 01:20 PM"},
          {"event": "Due Date Passed", "date": "30 Jul 2026, 11:59 PM"},
        ]
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
          "author": "Standard Author",
          "isbn": "978-0-000000-00-0",
          "category": "General Catalog",
          "dueDate": raw['dueDate'] ?? '03 Aug 2026',
          "daysOverdue": raw['daysOverdue'] ?? 3,
          "fineRate": 10,
          "fineAmount": (raw['daysOverdue'] ?? 3) * 10,
          "status": "Pending",
          "phone": "+91 98765 00000",
          "history": [
            {"event": "Book Issued", "date": "20 Jul 2026"},
            {"event": "Due Date Passed", "date": raw['dueDate'] ?? '03 Aug 2026'},
          ]
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
    if (_selectedDetailItem != null) {
      return LibrarianFineDetailsScreen(
        item: _selectedDetailItem!,
        onBack: () => setState(() => _selectedDetailItem = null),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Screen 1: App Bar Header
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

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Single KPI Card (Total Pending Fines)
                    _buildPendingFinesKpiCard(),
                    const SizedBox(height: 14),

                    // Standard Search Bar
                    LibrarianSearchBar(
                      controller: _searchController,
                      hintText: 'Search student name or book title...',
                      onChanged: (val) => setState(() => _searchQuery = val),
                      onClear: () => setState(() => _searchQuery = ''),
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips: All, Pending, Paid
                    _buildFilterChips(),
                    const SizedBox(height: 16),

                    // Vertical List Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Overdue Records',
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${_filteredItems.length} items',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Clean Vertical List (No Buttons Inside List Rows)
                    _buildCleanVerticalList(),
                    const SizedBox(height: 24),

                    // Simple Recently Collected Fines Card
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

  // ─── 1. KPI CARD ───────────────────────────────────────────────────────────
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
          Expanded(
            child: Column(
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
          ),
          const SizedBox(width: 8),
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

  // ─── 2. FILTER CHIPS ──────────────────────────────────────────────────────
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

  // ─── 3. CLEAN VERTICAL LIST (SCREEN 1 - NO BUTTONS INSIDE LIST ROWS) ──────
  Widget _buildCleanVerticalList() {
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
              'No Overdue Records',
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
          onTap: () => setState(() => _selectedDetailItem = item),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                        item['studentName'],
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['bookTitle'],
                        style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Due: ${item['dueDate']}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${item['fineAmount']}',
                      style: AppTypography.cardTitle.copyWith(
                        color: isPaid ? const Color(0xFF10B981) : const Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isPaid ? 'Paid' : '${item['daysOverdue']}d Overdue',
                            style: AppTypography.badgeText.copyWith(
                              color: isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF7A7A9D)),
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

  // ─── 4. RECENTLY COLLECTED FINES CARD ──────────────────────────────────────
  Widget _buildRecentlyCollectedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Recently Collected',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
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



}
