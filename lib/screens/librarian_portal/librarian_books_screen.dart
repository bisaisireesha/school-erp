import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'librarian_search_bar.dart';

class LibrarianBooksScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final VoidCallback? onAddBook;

  const LibrarianBooksScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onAddBook,
  });

  @override
  State<LibrarianBooksScreen> createState() => _LibrarianBooksScreenState();
}

class _LibrarianBooksScreenState extends State<LibrarianBooksScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = (widget.data['books'] as List? ?? []);
    final categories = ['All', 'Fiction', 'Science', 'Technology', 'History', 'Social Science'];

    final filteredBooks = books.where((b) {
      final matchesCategory = _selectedCategory == 'All' || b['category'] == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (b['title'] ?? '').toString().toLowerCase().contains(q) ||
          (b['author'] ?? '').toString().toLowerCase().contains(q) ||
          (b['isbn'] ?? '').toString().toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
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
                  const Text(
                    'Book Catalog',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.bookPlus, color: Color(0xFF6C4CF1)),
                    onPressed: widget.onAddBook ?? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Open Add Book Modal')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LibrarianSearchBar(
                controller: _searchController,
                hintText: 'Search books by title, author, or ISBN...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
            ),
            const SizedBox(height: 12),

            // Category Chips List
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Books List
            Expanded(
              child: filteredBooks.isEmpty
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
                            Icon(LucideIcons.bookX, size: 36, color: Color(0xFFCDCBE0)),
                            SizedBox(height: 10),
                            Text(
                              'No matching books found',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try searching another title, author, or category filter.',
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
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final b = filteredBooks[index];
                        final int available = b['availableCopies'] ?? 0;
                        final int total = b['totalCopies'] ?? 0;

                        Color statusColor = available > 2
                            ? const Color(0xFF10B981)
                            : (available > 0 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));
                        Color statusBg = available > 2
                            ? const Color(0xFFECFDF5)
                            : (available > 0 ? const Color(0xFFFFFBEB) : const Color(0xFFFEF2F2));

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                            boxShadow: AppShadows.soft,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(LucideIcons.book, color: Color(0xFF6C4CF1), size: 22),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b['title'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E1E2D),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'by ${b['author']}',
                                      style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'Rack: ${b['rackNumber'] ?? 'N/A'}',
                                          style: const TextStyle(fontSize: 11.0, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'ISBN: ${b['isbn'] ?? ''}',
                                          style: const TextStyle(fontSize: 11.0, color: Color(0xFF7A7A9D)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                    decoration: BoxDecoration(
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '$available / $total Left',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
