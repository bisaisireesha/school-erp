import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'librarian_search_bar.dart';

class LibrarianDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey) onNavigate;
  final Function(String actionKey) onQuickAction;

  const LibrarianDashboardScreen({
    super.key,
    required this.data,
    required this.onNavigate,
    required this.onQuickAction,
  });

  @override
  State<LibrarianDashboardScreen> createState() => _LibrarianDashboardScreenState();
}

class _LibrarianDashboardScreenState extends State<LibrarianDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activityFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.data['quickStats'] ?? {};
    final overdueList = (widget.data['overdueBooks'] as List? ?? []);
    final dueReturnsList = (widget.data['todaysDueReturns'] as List? ?? []);
    final recentActivities = (widget.data['recentActivity'] as List? ?? []);
    final stockAlerts = (widget.data['stockAlerts'] as List? ?? []);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Title & Search Field Header
          _buildHeaderSearchRow(),
          const SizedBox(height: 16),

          // 1. KPI Cards (2x2 Grid)
          _buildKpiGrid(stats),
          const SizedBox(height: 24),

          // 2. Quick Actions (2x2 Grid)
          _buildQuickActionsGrid(),
          const SizedBox(height: 26),

          // 3. Overdue Books (Compact List + View All)
          _buildOverdueBooksSection(overdueList),
          const SizedBox(height: 26),

          // 4. Today's Due Returns (Compact List + View All)
          _buildTodaysDueReturnsSection(dueReturnsList),
          const SizedBox(height: 26),

          // 5. Recent Activity (Issued & Returned Books)
          _buildRecentActivitySection(recentActivities),
          const SizedBox(height: 26),

          // 6. Inventory & Stock Alerts
          _buildInventoryAlertsSection(stockAlerts),
        ],
      ),
    );
  }

  // Header Title & Search Field
  Widget _buildHeaderSearchRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Library Dashboard',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 14),
        LibrarianSearchBar(
          controller: _searchController,
          hintText: 'Search books by title, author, or ISBN...',
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
          onClear: () {
            setState(() {
              _searchQuery = '';
            });
          },
        ),
      ],
    );
  }

  // ─── 1. KPI Cards (2x2 Grid) ────────────────────────────────────────────────
  Widget _buildKpiGrid(Map<String, dynamic> stats) {
    final totalBooks = stats['totalBooks'] ?? 12450;
    final availableBooks = stats['availableBooks'] ?? 9820;
    final issuedToday = stats['issuedToday'] ?? 48;
    final overdueBooks = stats['overdueBooks'] ?? 14;

    final kpis = [
      {
        'title': 'Total Books',
        'value': totalBooks.toString(),
        'chipText': 'Cataloged',
        'chipColor': const Color(0xFF3B82F6),
        'chipBg': const Color(0xFFEFF6FF),
        'icon': LucideIcons.library,
        'iconColor': const Color(0xFF3B82F6),
        'navKey': 'books',
      },
      {
        'title': 'Available Books',
        'value': availableBooks.toString(),
        'chipText': 'In Shelves',
        'chipColor': const Color(0xFF10B981),
        'chipBg': const Color(0xFFECFDF5),
        'icon': LucideIcons.bookCheck,
        'iconColor': const Color(0xFF10B981),
        'navKey': 'books',
      },
      {
        'title': 'Issued Today',
        'value': issuedToday.toString(),
        'chipText': 'Active Circulation',
        'chipColor': const Color(0xFF6C4CF1),
        'chipBg': const Color(0xFFF3F0FF),
        'icon': LucideIcons.bookUp2,
        'iconColor': const Color(0xFF6C4CF1),
        'navKey': 'issue_return',
      },
      {
        'title': 'Overdue Books',
        'value': overdueBooks.toString(),
        'chipText': 'Action Needed',
        'chipColor': const Color(0xFFEF4444),
        'chipBg': const Color(0xFFFEF2F2),
        'icon': LucideIcons.clockAlert,
        'iconColor': const Color(0xFFEF4444),
        'navKey': 'overdue',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kpis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.30,
      ),
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        final Color iconColor = kpi['iconColor'] as Color;
        final Color chipColor = kpi['chipColor'] as Color;
        final Color chipBg = kpi['chipBg'] as Color;

        return GestureDetector(
          onTap: () => widget.onNavigate(kpi['navKey'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(kpi['icon'] as IconData, color: iconColor, size: 16),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFCDCBE0),
                      size: 18,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kpi['value'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      kpi['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6E6E8D),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    kpi['chipText'] as String,
                    style: TextStyle(
                      color: chipColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── 2. Quick Actions (2x2 Grid) ───────────────────────────────────────────
  Widget _buildQuickActionsGrid() {
    final actions = [
      {
        'title': 'Issue Book',
        'icon': LucideIcons.bookUp,
        'color': const Color(0xFF6C4CF1),
        'actionKey': 'issue_book',
        'subtitle': 'Circulation',
      },
      {
        'title': 'Return Book',
        'icon': LucideIcons.bookDown,
        'color': const Color(0xFF10B981),
        'actionKey': 'return_book',
        'subtitle': 'Check-in Desk',
      },
      {
        'title': 'Add Book',
        'icon': LucideIcons.bookPlus,
        'color': const Color(0xFF3B82F6),
        'actionKey': 'add_book',
        'subtitle': 'New Catalog Entry',
      },
      {
        'title': 'Add Staff Member',
        'icon': LucideIcons.userPlus,
        'color': const Color(0xFFF59E0B),
        'actionKey': 'add_staff',
        'subtitle': 'Library Access',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.1,
          ),
          itemBuilder: (context, index) {
            final act = actions[index];
            final Color color = act['color'] as Color;

            return InkWell(
              onTap: () => widget.onQuickAction(act['actionKey'] as String),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(act['icon'] as IconData, color: color, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            act['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            act['subtitle'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Color(0xFF7A7A9D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── 3. Overdue Books Section (Compact List + View All) ────────────────────
  Widget _buildOverdueBooksSection(List overdueList) {
    final filtered = overdueList.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final member = (item['memberName'] ?? '').toString().toLowerCase();
      final title = (item['bookTitle'] ?? '').toString().toLowerCase();
      return member.contains(q) || title.contains(q);
    }).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Overdue Books',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${overdueList.length}',
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => widget.onNavigate('overdue'),
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6C4CF1), size: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.checkCircle2, size: 28, color: Color(0xFF10B981)),
                SizedBox(height: 6),
                Text(
                  'No Overdue Books',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                SizedBox(height: 2),
                Text(
                  'All borrowed books are returned on schedule.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
          )
        else
          Column(
            children: filtered.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFFEF2F2),
                      child: Text(
                        item['avatar'] ?? 'MB',
                        style: const TextStyle(
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['bookTitle'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item['memberName']} (${item['memberType']})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF7A7A9D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.calendar, size: 12, color: Color(0xFFEF4444)),
                              const SizedBox(width: 4),
                              Text(
                                'Due: ${item['dueDate']}',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Fine: ${item['fineAmount']}',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFFD97706),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => widget.onNavigate('overdue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F0FF),
                        foregroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: const Size(60, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Return',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ─── 4. Today's Due Returns (Compact List + View All) ──────────────────────
  Widget _buildTodaysDueReturnsSection(List dueReturnsList) {
    final filtered = dueReturnsList.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final member = (item['memberName'] ?? '').toString().toLowerCase();
      final title = (item['bookTitle'] ?? '').toString().toLowerCase();
      return member.contains(q) || title.contains(q);
    }).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Today\'s Due Returns',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${dueReturnsList.length}',
                    style: const TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => widget.onNavigate('due_today'),
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6C4CF1), size: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.calendarCheck2, size: 28, color: Color(0xFF3B82F6)),
                SizedBox(height: 6),
                Text(
                  'No Due Returns Today',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                SizedBox(height: 2),
                Text(
                  'No books scheduled for return check-in today.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
          )
        else
          Column(
            children: filtered.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFEFF6FF),
                      child: Text(
                        item['avatar'] ?? 'AW',
                        style: const TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['bookTitle'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item['memberName']} (${item['memberType']})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF7A7A9D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.clock, size: 12, color: Color(0xFF3B82F6)),
                              const SizedBox(width: 4),
                              Text(
                                item['dueTime'] ?? 'Today',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => widget.onNavigate('due_today'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF10B981),
                        side: const BorderSide(color: Color(0xFF10B981)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: const Size(60, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Check-in',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ─── 5. Recent Activity ────────────────────────────────────────────────────
  Widget _buildRecentActivitySection(List recentActivities) {
    final filteredActivities = recentActivities.where((act) {
      if (_activityFilter == 'Issued') return act['type'] == 'Issued';
      if (_activityFilter == 'Returned') return act['type'] == 'Returned';
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
            ),
            Row(
              children: ['All', 'Issued', 'Returned'].map((filter) {
                final isSelected = _activityFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _activityFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filteredActivities.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8)),
              boxShadow: AppShadows.soft,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.history, size: 28, color: Color(0xFF6C4CF1)),
                SizedBox(height: 6),
                Text(
                  'No Recent Activity',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                SizedBox(height: 2),
                Text(
                  'Issued and returned book transactions will appear here.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
          )
        else
          Column(
            children: filteredActivities.map((act) {
              final isIssued = act['type'] == 'Issued';
              final Color iconBg = isIssued ? const Color(0xFFF3F0FF) : const Color(0xFFECFDF5);
              final Color iconColor = isIssued ? const Color(0xFF6C4CF1) : const Color(0xFF10B981);
              final IconData icon = isIssued ? LucideIcons.bookUp : LucideIcons.bookCheck;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act['bookTitle'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${act['memberName']} • ${act['timestamp']}',
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: Color(0xFF7A7A9D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        act['statusBadge'] ?? act['type'],
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ─── 6. Inventory & Stock Alerts ───────────────────────────────────────────
  Widget _buildInventoryAlertsSection(List stockAlerts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inventory & Stock Alerts',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: stockAlerts.map((alert) {
            final String type = alert['type'] ?? '';
            final int count = alert['count'] ?? 0;
            final String label = alert['label'] ?? '';
            final String description = alert['description'] ?? '';

            Color cardColor;
            Color bgColor;
            IconData alertIcon;

            if (type.contains('Low Stock')) {
              cardColor = const Color(0xFFD97706);
              bgColor = const Color(0xFFFFFBEB);
              alertIcon = LucideIcons.packageMinus;
            } else if (type.contains('Damaged')) {
              cardColor = const Color(0xFFEF4444);
              bgColor = const Color(0xFFFEF2F2);
              alertIcon = LucideIcons.alertTriangle;
            } else {
              cardColor = const Color(0xFF9333EA);
              bgColor = const Color(0xFFF3E8FF);
              alertIcon = LucideIcons.fileX;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardColor.withValues(alpha: 0.3)),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(alertIcon, color: cardColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              type,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$count item(s)',
                                style: TextStyle(
                                  color: cardColor,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF7A7A9D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () => widget.onNavigate('books'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
