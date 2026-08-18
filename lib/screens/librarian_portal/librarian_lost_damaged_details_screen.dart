import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianLostDamagedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianLostDamagedDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String reportId = item['id'] as String? ?? 'INC-9012';
    final String type = item['type'] as String? ?? 'Damaged';
    final String bookTitle = item['bookTitle'] as String? ?? item['title'] as String? ?? 'Advanced Macroeconomics';
    final String isbn = item['isbn'] as String? ?? '978-0-07-351137-5';
    final String reportedBy = item['reportedBy'] as String? ?? item['memberName'] as String? ?? 'Karan Singh (STU-8812)';
    final String date = item['date'] as String? ?? item['reportedDate'] as String? ?? '03 Aug 2026';
    final String fee = item['fee'] as String? ?? item['penaltyFee'] as String? ?? '₹450.00';
    final String notes = item['notes'] as String? ?? 'Water damage to spine and front cover during loan period.';
    final String status = item['status'] as String? ?? 'Pending Fine Payment';
    final bool isDamaged = type.contains('Damage');

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
                    'Incident Report Details',
                    style: AppTypography.pageTitle,
                  ),
                ],
              ),
            ),

            // Content Body
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
                        gradient: LinearGradient(
                          colors: isDamaged
                              ? [const Color(0xFFD97706), const Color(0xFFB45309)]
                              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
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
                                  'REPORT ID: $reportId',
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
                                  type.toUpperCase(),
                                  style: AppTypography.badgeText.copyWith(
                                    color: isDamaged ? const Color(0xFFD97706) : const Color(0xFFEF4444),
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
                            'Reported by $reportedBy',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Incident Breakdown Card
                    _buildSectionHeader('Report Overview & Penalty'),
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
                          _buildDetailRow('Book ISBN', isbn, icon: LucideIcons.barcode),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Reported Date', date, icon: LucideIcons.calendar),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Replacement / Repair Fee', fee, icon: LucideIcons.indianRupee, isHighlight: true),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Current Status', status, icon: LucideIcons.info),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Condition Notes Card
                    _buildSectionHeader('Condition & Incident Summary'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Text(
                        notes,
                        style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF4A4A68)),
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
                                const SnackBar(content: Text('Processing Penalty Fee Collection...')),
                              );
                            },
                            icon: const Icon(LucideIcons.indianRupee, size: 18),
                            label: const Text('Collect Fee', style: AppTypography.buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ordering Replacement Copy...')),
                              );
                            },
                            icon: const Icon(LucideIcons.packagePlus, size: 18, color: Color(0xFF6C4CF1)),
                            label: Text('Order Replace', style: AppTypography.buttonText.copyWith(color: const Color(0xFF6C4CF1))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF6C4CF1)),
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

  Widget _buildDetailRow(String label, String value, {required IconData icon, bool isHighlight = false}) {
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
