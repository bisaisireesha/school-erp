import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianLostDamagedScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const LibrarianLostDamagedScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<LibrarianLostDamagedScreen> createState() => _LibrarianLostDamagedScreenState();
}

class _LibrarianLostDamagedScreenState extends State<LibrarianLostDamagedScreen> {
  String _selectedFilter = 'All';

  List<Map<String, dynamic>> get _items {
    final stockAlerts = (widget.data['stockAlerts'] as List? ?? []);

    final list = <Map<String, dynamic>>[];

    // Incorporate data from stockAlerts
    for (var sa in stockAlerts) {
      if (sa['type'].toString().contains('Damaged') || sa['type'].toString().contains('Lost')) {
        list.add({
          'id': sa['id'] ?? 'ALT-101',
          'title': sa['label'] ?? 'Book Title',
          'type': sa['type'].toString().contains('Damaged') ? 'Damaged' : 'Lost',
          'description': sa['description'] ?? 'Reported during return',
          'reportedBy': 'Member Return Desk',
          'date': '03 Aug 2026',
          'penalty': sa['type'].toString().contains('Damaged') ? '₹250' : '₹600',
          'status': sa['type'].toString().contains('Damaged') ? 'Sent for Rebinding' : 'Billed & Replacement Ordered',
        });
      }
    }

    if (list.isEmpty) {
      list.addAll([
        {
          'id': 'DMG-101',
          'title': 'Data Structures & Algorithms in Java',
          'type': 'Damaged',
          'description': 'Torn cover & liquid damage reported by Ethan Vance (STU-9921)',
          'reportedBy': 'Ethan Vance (STU-9921)',
          'date': '02 Aug 2026',
          'penalty': '₹250',
          'status': 'Sent for Rebinding',
        },
        {
          'id': 'LST-102',
          'title': 'Advanced Organic Chemistry Vol 1',
          'type': 'Lost',
          'description': 'Unreturned after 60 days, reported lost by Prof. David Miller',
          'reportedBy': 'Prof. David Miller (FAC-2041)',
          'date': '28 Jul 2026',
          'penalty': '₹600',
          'status': 'Billed & Replacement Ordered',
        },
        {
          'id': 'DMG-103',
          'title': 'Principles of Physics Vol. 2',
          'type': 'Damaged',
          'description': 'Spine wear and torn pages reported during check-in',
          'reportedBy': 'Emily Watson (STU-9104)',
          'date': '30 Jul 2026',
          'penalty': '₹150',
          'status': 'In Repair Desk',
        },
      ]);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((i) {
      if (_selectedFilter == 'All') return true;
      return i['type'] == _selectedFilter;
    }).toList();

    int damagedCount = _items.where((i) => i['type'] == 'Damaged').length;
    int lostCount = _items.where((i) => i['type'] == 'Lost').length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  if (widget.onBack != null)
                    AppBackButton(onPressed: widget.onBack!)
                  else
                    const SizedBox(width: 8),
                  const Text(
                    'Lost & Damaged Books Audit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Summary Metric Cards (2 Columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.alertTriangle, color: Color(0xFFF59E0B), size: 16),
                              SizedBox(width: 6),
                              Text('Damaged Books', style: TextStyle(fontSize: 11.5, color: Color(0xFFD97706), fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$damagedCount items',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const Text('Marked for repair/binding', style: TextStyle(fontSize: 10.5, color: Color(0xFF7A7A9D))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.bookX, color: Color(0xFFF43F5E), size: 16),
                              SizedBox(width: 6),
                              Text('Lost Books', style: TextStyle(fontSize: 11.5, color: Color(0xFFE11D48), fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$lostCount items',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const Text('Replacement ordered', style: TextStyle(fontSize: 10.5, color: Color(0xFF7A7A9D))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', 'Damaged', 'Lost'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF43F5E) : const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFFF43F5E),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Audit Items List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF0EDF8)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.shieldCheck, size: 36, color: Color(0xFF10B981)),
                            SizedBox(height: 10),
                            Text(
                              'No damaged or lost books',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'All collection items are currently intact & in good condition.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final bool isDamaged = item['type'] == 'Damaged';
                        final Color badgeColor = isDamaged ? const Color(0xFFF59E0B) : const Color(0xFFF43F5E);
                        final Color badgeBg = isDamaged ? const Color(0xFFFFFBEB) : const Color(0xFFFFF1F2);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                            boxShadow: AppShadows.soft,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      isDamaged ? LucideIcons.alertTriangle : LucideIcons.bookX,
                                      color: badgeColor,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E1E2D),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Reported by: ${item['reportedBy']}',
                                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item['type'] as String,
                                      style: TextStyle(color: badgeColor, fontSize: 10.5, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['description'] as String,
                                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Penalty Billed: ${item['penalty']}',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                  ),
                                  Text(
                                    item['status'] as String,
                                    style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: badgeColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
