import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianReservationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianReservationDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String resId = item['id'] as String? ?? 'RES-77109';
    final String bookTitle = item['bookTitle'] as String? ?? item['bookName'] as String? ?? 'Modern Chemistry Vol 2';
    final String isbn = item['isbn'] as String? ?? '978-0-12-882190-1';
    final String memberName = item['memberName'] as String? ?? item['studentName'] as String? ?? 'Rohan Varma';
    final String memberId = item['memberId'] as String? ?? 'STU-1102';
    final String reservedDate = item['reservedDate'] as String? ?? item['date'] as String? ?? '04 Aug 2026';
    final String expiryDate = item['expiryDate'] as String? ?? '11 Aug 2026';
    final String queuePosition = item['queuePosition'] as String? ?? '1st in Queue';
    final String status = item['status'] as String? ?? 'Ready for Pickup';
    final bool isReady = status.contains('Ready') || status.contains('Available');

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
                    'Reservation Details',
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
                    // Banner Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isReady
                              ? [const Color(0xFF10B981), const Color(0xFF059669)]
                              : [const Color(0xFFD97706), const Color(0xFFB45309)],
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
                                  'RESERVATION ID: $resId',
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
                                  status.toUpperCase(),
                                  style: AppTypography.badgeText.copyWith(
                                    color: isReady ? const Color(0xFF10B981) : const Color(0xFFD97706),
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
                            'Reserved by $memberName ($memberId)',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reservation Metadata Card
                    _buildSectionHeader('Reservation Breakdown'),
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
                          _buildDetailRow('Reserved Date', reservedDate, icon: LucideIcons.calendar),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Pickup Expiry', expiryDate, icon: LucideIcons.calendarClock),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Queue Standing', queuePosition, icon: LucideIcons.users),
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
                                const SnackBar(content: Text('Reservation fulfilled! Book issued to member.')),
                              );
                              onBack();
                            },
                            icon: const Icon(LucideIcons.bookUp, size: 18),
                            label: const Text('Fulfill & Issue', style: AppTypography.buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
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
                                const SnackBar(content: Text('Reservation cancelled.')),
                              );
                              onBack();
                            },
                            icon: const Icon(LucideIcons.xCircle, size: 18, color: Color(0xFFEF4444)),
                            label: Text('Cancel', style: AppTypography.buttonText.copyWith(color: const Color(0xFFEF4444))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFEF4444)),
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

  Widget _buildDetailRow(String label, String value, {required IconData icon}) {
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
