import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianRackDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBack;

  const LibrarianRackDetailsScreen({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final String rackCode = item['code'] as String? ?? item['rackNumber'] as String? ?? 'Rack A-12';
    final String category = item['category'] as String? ?? 'Science & Technology';
    final String aisle = item['aisle'] as String? ?? 'Aisle 3';
    final String floor = item['floor'] as String? ?? '1st Floor (East Wing)';
    final int capacity = item['capacity'] as int? ?? item['maxCapacity'] as int? ?? 150;
    final int currentCount = item['currentCount'] as int? ?? item['current'] as int? ?? 118;
    final double occupancyRatio = (currentCount / capacity).clamp(0.0, 1.0);
    final String status = item['status'] as String? ?? (occupancyRatio > 0.9 ? 'Full' : 'Available');

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
                    'Shelf & Rack Details',
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
                                  rackCode,
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
                                  style: AppTypography.badgeText.copyWith(color: const Color(0xFF6C4CF1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$category Rack',
                            style: AppTypography.displayHeader.copyWith(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$aisle • $floor',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Occupancy Progress Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('Rack Occupancy', style: AppTypography.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Text('${(occupancyRatio * 100).toStringAsFixed(1)}%', style: AppTypography.badgeText.copyWith(color: const Color(0xFF6C4CF1))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: occupancyRatio,
                              backgroundColor: const Color(0xFFF0EDF8),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$currentCount of $capacity Shelf Spaces Occupied',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Rack Location Info
                    _buildSectionHeader('Location Specifications'),
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
                          _buildDetailRow('Aisle Number', aisle, icon: LucideIcons.mapPin),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Floor Level', floor, icon: LucideIcons.layers),
                          const Divider(height: 16, color: Color(0xFFF0EDF8)),
                          _buildDetailRow('Assigned Category', category, icon: LucideIcons.folder),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Stored Books List
                    _buildSectionHeader('Books Stored on Rack'),
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
                          _buildBookItem('Physics Concepts & Applications', 'Shelf A-1', '10 Copies'),
                          const Divider(height: 14, color: Color(0xFFF0EDF8)),
                          _buildBookItem('Quantum Mechanics Principles', 'Shelf A-2', '5 Copies'),
                          const Divider(height: 14, color: Color(0xFFF0EDF8)),
                          _buildBookItem('Astronomy & Astrophysics', 'Shelf A-3', '8 Copies'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Opening Assign Books to Rack interface...')),
                              );
                            },
                            icon: const Icon(LucideIcons.plusCircle, size: 18),
                            label: const Text('Add Books to Rack', style: AppTypography.buttonText),
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

  Widget _buildBookItem(String title, String shelf, String copies) {
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
              Text('$shelf  •  $copies', style: AppTypography.caption),
            ],
          ),
        ),
        const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF7A7A9D)),
      ],
    );
  }
}
