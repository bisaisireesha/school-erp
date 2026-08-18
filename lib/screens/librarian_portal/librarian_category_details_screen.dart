import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianCategoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianCategoryDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String title = item['title'] as String? ?? item['name'] as String? ?? 'Category Details';
    final String code = item['code'] as String? ?? 'CAT-SCI';
    final String description = item['description'] as String? ?? 'Scientific reference journals, research textbooks, and lab guides.';
    final int count = item['count'] as int? ?? 142;
    final int racks = item['racks'] as int? ?? 4;

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
                    'Category Details',
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C4CF1), Color(0xFF4F46E5)],
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
                                  code,
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
                                  '$count Books',
                                  style: AppTypography.badgeText.copyWith(color: const Color(0xFF6C4CF1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: AppTypography.displayHeader.copyWith(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category Breakdown Cards
                    Row(
                      children: [
                        _buildStatBox('Total Books', '$count Volumes', 'In Catalog', const Color(0xFF6C4CF1), const Color(0xFFF3F0FF), LucideIcons.bookOpen),
                        const SizedBox(width: 12),
                        _buildStatBox('Assigned Racks', '$racks Racks', 'Dedicated Shelves', const Color(0xFF10B981), const Color(0xFFECFDF5), LucideIcons.archive),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Books in Category List
                    _buildSectionHeader('Books in this Category'),
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
                          _buildBookItem('Advanced Theoretical Physics', 'Rack A-12', '8 / 10 Available'),
                          const Divider(height: 14, color: Color(0xFFF0EDF8)),
                          _buildBookItem('Organic Chemistry & Reactions', 'Rack A-14', '3 / 6 Available'),
                          const Divider(height: 14, color: Color(0xFFF0EDF8)),
                          _buildBookItem('Calculus & Analytical Geometry', 'Rack B-02', '12 / 15 Available'),
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
                                const SnackBar(content: Text('Opening Add Book to Category form...')),
                              );
                            },
                            icon: const Icon(LucideIcons.plusCircle, size: 18),
                            label: const Text('Add Book to Category', style: AppTypography.buttonText),
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
                  Text(value, style: AppTypography.cardTitle.copyWith(color: color, fontSize: 14.5)),
                  const SizedBox(height: 2),
                  Text(title, style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookItem(String title, String rack, String availability) {
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
              Text('$rack  •  $availability', style: AppTypography.caption),
            ],
          ),
        ),
        const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF7A7A9D)),
      ],
    );
  }
}
