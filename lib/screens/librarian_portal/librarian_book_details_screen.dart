import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianBookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianBookDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String title = item['title'] as String? ?? item['bookTitle'] as String? ?? 'Library Book Details';
    final String author = item['author'] as String? ?? 'Unknown Author';
    final String isbn = item['isbn'] as String? ?? '978-3-16-148410-0';
    final String category = item['category'] as String? ?? 'General Literature';
    final String rackNumber = item['rackNumber'] as String? ?? item['shelf'] as String? ?? 'A-12';
    final int totalCopies = item['totalCopies'] as int? ?? item['total'] as int? ?? 10;
    final int availableCopies = item['availableCopies'] as int? ?? item['available'] as int? ?? 7;
    final int issuedCopies = totalCopies - availableCopies;
    final String publisher = item['publisher'] as String? ?? 'Sunrise Academic Publications';
    final String year = item['year'] as String? ?? '2024';
    final String edition = item['edition'] as String? ?? '3rd Revised Edition';
    final String price = item['price'] as String? ?? '₹650.00';
    final String language = item['language'] as String? ?? 'English';

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
                    'Book Details',
                    style: AppTypography.pageTitle,
                  ),
                ],
              ),
            ),

            // Main Content Body
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
                          colors: [Color(0xFF6C4CF1), Color(0xFF4F46E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 76,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white38),
                            ),
                            child: const Center(
                              child: Icon(LucideIcons.bookOpen, color: Colors.white, size: 32),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTypography.displayHeader.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'By $author',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    category,
                                    style: AppTypography.badgeText.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Inventory & Location Stat Cards Row
                    Row(
                      children: [
                        _buildStatBox(
                          title: 'Available Copies',
                          value: '$availableCopies / $totalCopies',
                          subtitle: '$issuedCopies Currently Issued',
                          color: availableCopies > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          bgColor: availableCopies > 0 ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                          icon: LucideIcons.layers,
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          title: 'Rack / Location',
                          value: rackNumber,
                          subtitle: 'Shelf Location',
                          color: const Color(0xFF6C4CF1),
                          bgColor: const Color(0xFFF3F0FF),
                          icon: LucideIcons.mapPin,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Detailed Specifications Section
                    _buildSectionHeader('Book Information'),
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
                          _buildDetailRow('ISBN', isbn, icon: LucideIcons.barcode),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Publisher', publisher, icon: LucideIcons.building2),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Edition & Year', '$edition ($year)', icon: LucideIcons.calendar),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Language', language, icon: LucideIcons.languages),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Reference Price', price, icon: LucideIcons.indianRupee),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Active Borrowers Section
                    _buildSectionHeader('Current Active Borrowers'),
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
                          _buildBorrowerTile('Rahul Sharma (Grade 10-A)', 'Issued: 28 Jul 2026', 'Due: 11 Aug 2026', false),
                          const Divider(height: 14, color: Color(0xFFF0EDF8)),
                          _buildBorrowerTile('Priya Verma (Faculty)', 'Issued: 15 Jul 2026', 'Due: 01 Aug 2026', true),
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
                                const SnackBar(content: Text('Proceeding to Book Issue...')),
                              );
                            },
                            icon: const Icon(LucideIcons.bookUp, size: 18),
                            label: const Text('Issue Book', style: AppTypography.buttonText),
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
                                const SnackBar(content: Text('Book reserved successfully.')),
                              );
                            },
                            icon: const Icon(LucideIcons.bookmark, size: 18, color: Color(0xFF6C4CF1)),
                            label: Text('Reserve', style: AppTypography.buttonText.copyWith(color: const Color(0xFF6C4CF1))),
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

  Widget _buildStatBox({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
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
                    style: AppTypography.cardTitle.copyWith(
                      color: color,
                      fontSize: 15.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: AppTypography.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBorrowerTile(String name, String issued, String due, bool isOverdue) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFF3F0FF),
          child: Text(
            name.substring(0, 1),
            style: AppTypography.badgeText.copyWith(color: const Color(0xFF6C4CF1)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.cardTitle.copyWith(fontSize: 13.5)),
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
            isOverdue ? 'Overdue' : 'On Time',
            style: AppTypography.badgeText.copyWith(
              color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF10B981),
            ),
          ),
        ),
      ],
    );
  }
}
