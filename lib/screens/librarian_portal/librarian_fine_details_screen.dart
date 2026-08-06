import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianFineDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianFineDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  State<LibrarianFineDetailsScreen> createState() => _LibrarianFineDetailsScreenState();
}

class _LibrarianFineDetailsScreenState extends State<LibrarianFineDetailsScreen> {
  late Map<String, dynamic> _item;

  @override
  void initState() {
    super.initState();
    _item = Map<String, dynamic>.from(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPaid = _item['status'] == 'Paid';
    final List history = (_item['history'] as List? ?? [
      {"event": "Book Issued", "date": "19 Jul 2026, 10:30 AM"},
      {"event": "Due Date Passed", "date": "${_item['dueDate'] ?? '02 Aug 2026'}, 11:59 PM"},
      {"event": "Overdue Notice Sent", "date": "03 Aug 2026, 09:00 AM"},
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Header with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  AppBackButton(onPressed: widget.onBack),
                  const SizedBox(width: 8),
                  const Text(
                    'Fine Details',
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

            // Scrollable Content Feed
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Student Profile Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                            child: Text(
                              (_item['studentName'] ?? 'S').toString().substring(0, 1),
                              style: TextStyle(
                                color: isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _item['studentName'] ?? 'Student Member',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'ID: ${_item['memberId'] ?? 'STU-8842'}  •  ${_item['className'] ?? 'Grade 10'}',
                                  style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Phone: ${_item['phone'] ?? '+91 98765 43210'}',
                                  style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section 2: Book Information Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Book Information',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Book Title', _item['bookTitle'] ?? 'Library Resource'),
                          _buildDetailRow('Author', _item['author'] ?? 'H. C. Verma'),
                          _buildDetailRow('ISBN', _item['isbn'] ?? '978-0-123456-78-9'),
                          _buildDetailRow('Category', _item['category'] ?? 'Science / Physics'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section 3: Fine Calculation Breakdown Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overdue & Fine Calculation',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Due Date', _item['dueDate'] ?? '02 Aug 2026'),
                          _buildDetailRow('Days Overdue', '${_item['daysOverdue'] ?? 4} Days'),
                          _buildDetailRow('Fine Rate', '₹${_item['fineRate'] ?? 10} / day'),
                          const SizedBox(height: 8),

                          // Calculation Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isPaid ? const Color(0xFFA7F3D0) : const Color(0xFFFCA5A5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Fine (${_item['daysOverdue'] ?? 4}d × ₹${_item['fineRate'] ?? 10}):',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: isPaid ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                                  ),
                                ),
                                Text(
                                  '₹${_item['fineAmount'] ?? 40}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isPaid ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section 4: Payment & Activity Log Timeline
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Activity & Payment History',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              final h = history[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6C4CF1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        h['event'] ?? 'Event',
                                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                                      ),
                                    ),
                                    Text(
                                      h['date'] ?? '',
                                      style: const TextStyle(fontSize: 11.0, color: Color(0xFF7A7A9D)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 5: Secondary Action (Send Reminder)
                    if (!isPaid)
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: _sendReminder,
                          icon: const Icon(LucideIcons.bell, size: 16),
                          label: const Text('Send Overdue Reminder'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C4CF1),
                            side: const BorderSide(color: Color(0xFFEBE8FF)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Primary CTA Button: Collect Fine
            if (!isPaid)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF0EDF8))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _showCollectFineModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Collect Fine', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        ),
      ),
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

  void _showCollectFineModal() {
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
                  Text('Student: ${_item['studentName']}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  Text('Book: ${_item['bookTitle']}', style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D))),
                  const SizedBox(height: 14),

                  const Text('Fine Amount', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 4),
                  Text('₹${_item['fineAmount']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
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
                          _item['status'] = 'Paid';
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('₹${_item['fineAmount']} collected from ${_item['studentName']} via $selectedPaymentMethod!'),
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

  void _sendReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Overdue reminder sent to ${_item['studentName']}.'),
        backgroundColor: const Color(0xFF6C4CF1),
      ),
    );
  }
}
