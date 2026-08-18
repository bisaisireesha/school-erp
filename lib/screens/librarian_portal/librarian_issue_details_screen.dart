import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianIssueDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianIssueDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String issueId = item['id'] as String? ?? 'ISS-88392';
    final String bookTitle = item['bookTitle'] as String? ?? item['bookName'] as String? ?? 'Physics Concepts & Applications';
    final String isbn = item['isbn'] as String? ?? '978-0-13-408231-8';
    final String studentName = item['studentName'] as String? ?? item['memberName'] as String? ?? 'Ananya Sharma';
    final String memberId = item['memberId'] as String? ?? 'STU-9921';
    final String memberType = item['memberType'] as String? ?? item['role'] as String? ?? 'Student (Grade 10-B)';
    final String issueDate = item['issueDate'] as String? ?? '22 Jul 2026';
    final String dueDate = item['dueDate'] as String? ?? '05 Aug 2026';
    final bool isOverdue = item['isOverdue'] as bool? ?? (item['fineAmount'] != null && item['fineAmount'] != '₹0');
    final String fineAmount = item['fineAmount'] as String? ?? (isOverdue ? '₹60.00' : '₹0.00');

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
                    'Active Issue Details',
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
                    // Status & Issue ID Banner Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isOverdue
                              ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                              : [const Color(0xFF6C4CF1), const Color(0xFF4F46E5)],
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
                                  'ISSUE ID: $issueId',
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
                                  isOverdue ? 'OVERDUE' : 'ACTIVE BORROW',
                                  style: AppTypography.badgeText.copyWith(
                                    color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF6C4CF1),
                                  ),
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
                            'ISBN: $isbn',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Borrower Summary Section
                    _buildSectionHeader('Borrower Details'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFFF3F0FF),
                            child: Text(
                              studentName.substring(0, 1),
                              style: AppTypography.cardTitle.copyWith(color: const Color(0xFF6C4CF1)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  studentName,
                                  style: AppTypography.cardTitle,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$memberId • $memberType',
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Issue Metadata Card
                    _buildSectionHeader('Transaction Dates & Fine Summary'),
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
                          _buildMetadataRow('Issue Date', issueDate, icon: LucideIcons.calendarCheck),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildMetadataRow('Due Date', dueDate, icon: LucideIcons.calendarClock),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildMetadataRow('Status', isOverdue ? 'Overdue' : 'On Schedule', icon: LucideIcons.info),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildMetadataRow('Accumulated Fine', fineAmount, icon: LucideIcons.indianRupee, isHighlight: isOverdue),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Book marked as returned successfully.')),
                              );
                              onBack();
                            },
                            icon: const Icon(LucideIcons.bookCheck, size: 18),
                            label: const Text('Mark Book as Returned', style: AppTypography.buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Due date extended by 7 days.')),
                                  );
                                },
                                icon: const Icon(LucideIcons.calendarPlus, size: 16, color: Color(0xFF6C4CF1)),
                                label: Text('Extend Due Date', style: AppTypography.buttonText.copyWith(color: const Color(0xFF6C4CF1))),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF6C4CF1)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Overdue notification sent to member.')),
                                  );
                                },
                                icon: const Icon(LucideIcons.bell, size: 16, color: Color(0xFFEF4444)),
                                label: Text('Remind Member', style: AppTypography.buttonText.copyWith(color: const Color(0xFFEF4444))),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFEF4444)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildMetadataRow(String label, String value, {required IconData icon, bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isHighlight ? const Color(0xFFEF4444) : const Color(0xFF7A7A9D)),
        const SizedBox(width: 10),
        Text(label, style: AppTypography.bodySmall),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isHighlight ? const Color(0xFFEF4444) : const Color(0xFF1E1E2D),
            ),
          ),
        ),
      ],
    );
  }
}
