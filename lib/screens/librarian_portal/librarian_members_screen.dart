import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import '../librarian_main_layout.dart';
import 'librarian_member_details_screen.dart';

class LibrarianMembersScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final VoidCallback? onAddStaff;
  final String initialRole;

  const LibrarianMembersScreen({
    super.key,
    required this.data,
    this.onBack,
    this.onAddStaff,
    this.initialRole = 'All',
  });

  @override
  State<LibrarianMembersScreen> createState() => _LibrarianMembersScreenState();
}

class _LibrarianMembersScreenState extends State<LibrarianMembersScreen> {
  late String _selectedRole;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = (widget.data['members'] as List? ?? []);
    final roles = ['All', 'Student', 'Teacher', 'Staff'];

    final filteredMembers = members.where((m) {
      final matchesRole = _selectedRole == 'All' || m['role'] == _selectedRole;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (m['name'] ?? '').toString().toLowerCase().contains(q) ||
          (m['memberId'] ?? '').toString().toLowerCase().contains(q);
      return matchesRole && matchesQuery;
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
                    'Library Members Directory',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.userPlus, color: Color(0xFF6C4CF1)),
                    onPressed: widget.onAddStaff ?? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add Staff Member Modal')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: AppSpacing.searchBarHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEBE8FF)),
                  boxShadow: AppShadows.soft,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search by Member Name or ID...',
                    prefixIcon: Icon(LucideIcons.search, size: 18, color: Color(0xFF7A7A9D)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Role Filter Chips
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  final isSelected = _selectedRole == role;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRole = role),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
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

            // Members List
            Expanded(
              child: filteredMembers.isEmpty
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
                            Icon(LucideIcons.userX, size: 36, color: Color(0xFFCDCBE0)),
                            SizedBox(height: 10),
                            Text(
                              'No matching members found',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try searching another member name, ID, or role filter.',
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
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final m = filteredMembers[index];
                        final int activeIssued = m['activeIssued'] ?? 0;
                        final String pendingFine = m['pendingFine'] ?? '₹0.00';
                        final bool hasFine = pendingFine != '₹0.00' && pendingFine != '\$0.00';

                        return InkWell(
                          onTap: () {
                            LibrarianMainLayout.pushSubScreen(
                              context,
                              LibrarianMemberDetailsScreen(
                                item: m,
                                onBack: () => LibrarianMainLayout.popSubScreen(context),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
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
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFFF3F0FF),
                                  child: Text(
                                    (m['name'] ?? '').toString().trim().isNotEmpty
                                        ? (m['name'] as String).trim()[0].toUpperCase()
                                        : 'M',
                                    style: const TextStyle(
                                      color: Color(0xFF6C4CF1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                               const SizedBox(width: 14),
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       m['name'] ?? '',
                                       style: AppTypography.cardTitle,
                                     ),
                                     const SizedBox(height: 2),
                                     Text(
                                       'ID: ${m['memberId']}  •  ${m['department']}',
                                       style: AppTypography.caption,
                                     ),
                                     const SizedBox(height: 4),
                                     Row(
                                       children: [
                                         Container(
                                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                           decoration: BoxDecoration(
                                             color: const Color(0xFFF3F0FF),
                                             borderRadius: BorderRadius.circular(6),
                                           ),
                                           child: Text(
                                             'Active Issues: $activeIssued',
                                             style: AppTypography.badgeText.copyWith(
                                               color: const Color(0xFF6C4CF1),
                                             ),
                                           ),
                                         ),
                                         if (hasFine) ...[
                                           const SizedBox(width: 6),
                                           Container(
                                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                             decoration: BoxDecoration(
                                               color: const Color(0xFFFEF2F2),
                                               borderRadius: BorderRadius.circular(6),
                                             ),
                                             child: Text(
                                               'Fine: $pendingFine',
                                               style: AppTypography.badgeText.copyWith(
                                                 color: const Color(0xFFEF4444),
                                               ),
                                             ),
                                           ),
                                         ],
                                       ],
                                     ),
                                   ],
                                 ),
                               ),
                               Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
                              ],
                            ),
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
