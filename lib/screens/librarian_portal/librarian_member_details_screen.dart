import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianMemberDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianMemberDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String name = item['name'] as String? ?? item['memberName'] as String? ?? 'Ananya Sharma';
    final String memberId = item['memberId'] as String? ?? item['id'] as String? ?? 'STU-9921';
    final String role = item['role'] as String? ?? item['memberType'] as String? ?? 'Student';
    final String department = item['department'] as String? ?? item['class'] as String? ?? 'Grade 10-A';
    final String email = item['email'] as String? ?? 'ananya.sharma@school.edu';
    final String phone = item['phone'] as String? ?? '+91 98765 43210';
    final int activeIssues = item['activeIssues'] as int? ?? item['active'] as int? ?? 2;
    final int maxAllowance = role == 'Staff' ? 5 : 3;
    final String pendingFine = item['pendingFine'] as String? ?? item['fineAmount'] as String? ?? '₹0.00';
    final bool hasFine = pendingFine != '₹0.00' && pendingFine != '₹0';

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
                    'Library Member Details',
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
                    // Member Profile Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C4CF1), Color(0xFF4F46E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            child: Text(
                              name.substring(0, 1),
                              style: AppTypography.displayHeader.copyWith(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: AppTypography.displayHeader.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$memberId • $role',
                                  style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    department,
                                    style: AppTypography.badgeText.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Stats Row
                    Row(
                      children: [
                        _buildStatBox('Active Issues', '$activeIssues / $maxAllowance Books', 'Allowed', const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), LucideIcons.bookOpen),
                        const SizedBox(width: 12),
                        _buildStatBox('Outstanding Fine', pendingFine, hasFine ? 'Action Needed' : 'No Overdue Fine', hasFine ? const Color(0xFFEF4444) : const Color(0xFF10B981), hasFine ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5), LucideIcons.indianRupee),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Contact & Membership Details Card
                    _buildSectionHeader('Membership Information'),
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
                          _buildDetailRow('Email Address', email, icon: LucideIcons.mail),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Contact Number', phone, icon: LucideIcons.phone),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Account Status', 'Active Membership', icon: LucideIcons.shieldCheck),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Library Card Expiry', '31 May 2027', icon: LucideIcons.creditCard),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Current Borrowed Books List
                    _buildSectionHeader('Currently Borrowed Books'),
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
                          _buildBorrowedBookItem('Fundamentals of Physics', 'Issued: 22 Jul', 'Due: 05 Aug 2026', false),
                          const Divider(height: 14, color: Color(0xFFF0EDF8)),
                          _buildBorrowedBookItem('World History & Civilizations', 'Issued: 10 Jul', 'Due: 24 Jul 2026', true),
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
                                const SnackBar(content: Text('Proceeding to Issue Book for Member...')),
                              );
                            },
                            icon: const Icon(LucideIcons.plusCircle, size: 18),
                            label: const Text('Issue Book', style: AppTypography.buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        if (hasFine) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Fine Payment...')),
                                );
                              },
                              icon: const Icon(LucideIcons.indianRupee, size: 18),
                              label: const Text('Collect Fine', style: AppTypography.buttonText),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildStatBox(String title, String value, String subtitle, Color color, Color bgColor, IconData icon) {
    return Expanded(
      child: Container(
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
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTypography.cardTitle.copyWith(color: color, fontSize: 14.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(title, style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildBorrowedBookItem(String title, String issued, String due, bool isOverdue) {
    return Row(
      children: [
        const Icon(LucideIcons.book, size: 18, color: Color(0xFF6C4CF1)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.cardTitle.copyWith(fontSize: 13.5)),
              const SizedBox(height: 2),
              Text('$issued  •  $due', style: AppTypography.caption),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: isOverdue ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isOverdue ? 'Overdue' : 'Active',
            style: AppTypography.badgeText.copyWith(
              color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF10B981),
            ),
          ),
        ),
      ],
    );
  }
}
