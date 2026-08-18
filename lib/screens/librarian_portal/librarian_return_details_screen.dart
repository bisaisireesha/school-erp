import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianReturnDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianReturnDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String returnId = item['id'] as String? ?? 'RET-44102';
    final String bookTitle = item['bookTitle'] as String? ?? item['bookName'] as String? ?? 'Organic Chemistry 10th Ed';
    final String isbn = item['isbn'] as String? ?? '978-0-07-351124-5';
    final String studentName = item['studentName'] as String? ?? item['memberName'] as String? ?? 'Siddharth Patel';
    final String memberId = item['memberId'] as String? ?? 'STU-4401';
    final String returnDate = item['returnDate'] as String? ?? item['timestamp'] as String? ?? '06 Aug 2026';
    final String issueDate = item['issueDate'] as String? ?? '20 Jul 2026';
    final String condition = item['condition'] as String? ?? 'Good Condition';
    final String fineCollected = item['fineCollected'] as String? ?? '₹0.00 (No Fine)';
    final String inspectedBy = item['inspectedBy'] as String? ?? 'Sunita Rao (Head Librarian)';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  AppBackButton(onPressed: onBack),
                  const SizedBox(width: 8),
                  const Text(
                    'Return Receipt & Audit',
                    style: AppTypography.pageTitle,
                  ),
                ],
              ),
            ),

            // Content Feed
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'RETURN ID: $returnId',
                                  style: AppTypography.badgeText.copyWith(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'COMPLETED',
                                  style: AppTypography.badgeText.copyWith(color: const Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            bookTitle,
                            style: AppTypography.displayHeader.copyWith(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Returned by $studentName ($memberId)',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Audit Details Card
                    _buildSectionHeader('Return Inspection Summary'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        children: [
                          _buildAuditRow('Book ISBN', isbn, icon: LucideIcons.barcode),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildAuditRow('Original Issue Date', issueDate, icon: LucideIcons.calendar),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildAuditRow('Return Date & Time', returnDate, icon: LucideIcons.calendarCheck),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildAuditRow('Book Condition', condition, icon: LucideIcons.checkCircle2),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildAuditRow('Fine Assessed', fineCollected, icon: LucideIcons.indianRupee),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildAuditRow('Inspected By', inspectedBy, icon: LucideIcons.userCheck),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Generating Return Receipt PDF...')),
                              );
                            },
                            icon: const Icon(LucideIcons.printer, size: 18),
                            label: const Text('Print Receipt', style: AppTypography.buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.sectionTitle.copyWith(fontSize: 16.0),
    );
  }

  Widget _buildAuditRow(String label, String value, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF7A7A9D)),
        const SizedBox(width: 10),
        Text(label, style: AppTypography.bodySmall),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
