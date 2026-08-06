import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'librarian_create_bottom_sheet.dart';
import 'librarian_search_bar.dart';

class LibrarianCategoriesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const LibrarianCategoriesScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<LibrarianCategoriesScreen> createState() => _LibrarianCategoriesScreenState();
}

class _LibrarianCategoriesScreenState extends State<LibrarianCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _mockCategories = [
    {
      'name': 'Fiction & Literature',
      'code': 'FIC',
      'count': 2450,
      'racks': 12,
      'icon': LucideIcons.bookOpenCheck,
      'color': const Color(0xFF6C4CF1),
      'bg': const Color(0xFFF3F0FF),
      'description': 'Novels, classic literature, sci-fi, & mystery collections',
    },
    {
      'name': 'Science & Technology',
      'code': 'SCI',
      'count': 1820,
      'racks': 8,
      'icon': LucideIcons.atom,
      'color': const Color(0xFF3B82F6),
      'bg': const Color(0xFFEFF6FF),
      'description': 'Physics, chemistry, computer engineering & AI texts',
    },
    {
      'name': 'History & World Civ',
      'code': 'HIS',
      'count': 1290,
      'racks': 5,
      'icon': LucideIcons.landmark,
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
      'description': 'Ancient civilizations, modern warfare & biographies',
    },
    {
      'name': 'Social Science & Econ',
      'code': 'SOC',
      'count': 980,
      'racks': 4,
      'icon': LucideIcons.globe,
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
      'description': 'Microeconomics, sociology, civics & public policy',
    },
    {
      'name': 'Reference & Journals',
      'code': 'REF',
      'count': 750,
      'racks': 3,
      'icon': LucideIcons.bookMarked,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF3E8FF),
      'description': 'Encyclopedias, dictionaries, research journals & almanacs',
    },
    {
      'name': 'Arts & Music',
      'code': 'ART',
      'count': 620,
      'racks': 3,
      'icon': LucideIcons.palette,
      'color': const Color(0xFFF43F5E),
      'bg': const Color(0xFFFFF1F2),
      'description': 'Fine arts, architectural history & musical compositions',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddCategoryModal() {
    LibrarianCreateBottomSheet.show(
      context: context,
      type: LibrarianCreateType.category,
      onSubmit: (data) {
        final name = data['name'] ?? '';
        final code = data['code'] ?? 'GEN';
        final desc = data['description'] ?? 'General catalog section';

        setState(() {
          _mockCategories.insert(0, {
            'name': name,
            'code': code,
            'count': 120,
            'racks': 2,
            'icon': LucideIcons.bookmark,
            'color': const Color(0xFF6C4CF1),
            'bg': const Color(0xFFF3F0FF),
            'description': desc,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "$name" ($code) added successfully!'),
            backgroundColor: const Color(0xFF6C4CF1),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _mockCategories.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return c['name'].toString().toLowerCase().contains(q) ||
          c['code'].toString().toLowerCase().contains(q) ||
          c['description'].toString().toLowerCase().contains(q);
    }).toList();

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
                    'Book Categories & Genres',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.plus, color: Color(0xFF3B82F6)),
                    onPressed: _showAddCategoryModal,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LibrarianSearchBar(
                controller: _searchController,
                hintText: 'Search categories by name or code...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
            ),
            const SizedBox(height: 14),

            // Categories List
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
                            Icon(LucideIcons.shapes, size: 36, color: Color(0xFFCDCBE0)),
                            SizedBox(height: 10),
                            Text(
                              'No matching categories found',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try searching another category name, code, or keyword.',
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
                        final cat = filtered[index];
                        final Color color = cat['color'] as Color;
                        final Color bg = cat['bg'] as Color;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF0EDF8)),
                            boxShadow: AppShadows.soft,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(cat['icon'] as IconData, color: color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          cat['name'] as String,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E1E2D),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: bg,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            cat['code'] as String,
                                            style: TextStyle(
                                              color: color,
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      cat['description'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          '${cat['count']} Books',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${cat['racks']} Racks Assigned',
                                          style: const TextStyle(fontSize: 11.0, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
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
