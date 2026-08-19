import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'chat_detail_screen.dart';
import '../main_layout.dart';

class MessagesScreen extends StatefulWidget {
  final VoidCallback onBack;

  const MessagesScreen({super.key, required this.onBack});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Mock Data for Messages
  final List<Map<String, dynamic>> _chatList = [
    {
      'id': '1',
      'name': 'Priya Sharma',
      'role': 'PARENT',
      'subtitle': 'Parent of Aarav Sharma • Grade 10-A',
      'lastMessage': 'Regarding annual examination sche...',
      'time': '10:24 AM',
      'unread': 0,
      'avatarColor': const Color(0xFF6C4CF1),
      'isStarred': true,
      'isArchived': false,
      'isGroup': false,
    },
    {
      'id': '2',
      'name': 'Mr. Arun Kumar',
      'role': 'TEACHER',
      'subtitle': 'Class Teacher • Grade 10-A',
      'lastMessage': 'Class 10 attendance report attac...',
      'time': 'Yesterday',
      'unread': 0,
      'avatarColor': const Color(0xFF0EA5E9),
      'isStarred': true,
      'isArchived': false,
      'isGroup': false,
    },
    {
      'id': '3',
      'name': 'Finance Department',
      'role': 'STAFF',
      'subtitle': 'School Accounts',
      'lastMessage': 'Pending fee follow-up list updated.',
      'time': 'Yesterday',
      'unread': 0,
      'avatarColor': const Color(0xFFF59E0B),
      'isStarred': false,
      'isArchived': false,
      'isGroup': false,
    },
    {
      'id': '4',
      'name': 'Grade 8 Parents Group',
      'role': 'GROUP',
      'subtitle': '45 Members',
      'lastMessage': 'Field trip confirmation details...',
      'time': 'May 21',
      'unread': 1,
      'avatarColor': const Color(0xFF10B981),
      'isStarred': false,
      'isArchived': false,
      'isGroup': true,
    }
  ];
  
  // Filter and Search State
  String _selectedFilter = 'All';
  // Show all filter options in modal
  List<String> get _filterOptions => ['All', 'Unread', 'Starred', 'Archived'];
  // Show all filter options on the screen horizontally
  List<String> get _screenFilterOptions => ['All', 'Unread', 'Starred', 'Archived'];
  
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = MainLayout.globalSearchQuery.value;
    });
  }

  @override
  void dispose() {
    MainLayout.globalSearchQuery.removeListener(_onSearchChanged);
    super.dispose();
  }
  
  List<Map<String, dynamic>> get _filteredChats {
    return _chatList.where((chat) {
      bool matchesFilter = false;
      
      if (_selectedFilter == 'Archived') {
        matchesFilter = (chat['isArchived'] ?? false) == true;
      } else {
        bool isArchived = (chat['isArchived'] ?? false) == true;
        if (isArchived) return false;
        
        if (_selectedFilter == 'All') {
          matchesFilter = true;
        } else if (_selectedFilter == 'Unread') {
          matchesFilter = (chat['unread'] ?? 0) > 0;
        } else if (_selectedFilter == 'Groups') {
          matchesFilter = (chat['isGroup'] ?? false) == true;
        } else if (_selectedFilter == 'Starred') {
          matchesFilter = (chat['isStarred'] ?? false) == true;
        }
      }
      
      bool matchesSearch = chat['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           chat['lastMessage'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _showNewMessageModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(3)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    const Expanded(child: Text('New Message', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFFF8F9FA), shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 20, color: Color(0xFF1E1E2D)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for staff, teachers...',
                      hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 15),
                      prefixIcon: Icon(LucideIcons.search, color: Color(0xFF9E9E9E), size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Text('Suggested Contacts', style: TextStyle(color: Color(0xFF6C6C80), fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    _buildStaffContact('Anita Rao', 'Class Teacher • Grade 10-A', const Color(0xFF10B981)),
                    _buildStaffContact('R. Khan', 'School Principal', const Color(0xFFF59E0B)),
                    _buildStaffContact('IT Support', 'Technical Helpdesk', const Color(0xFF3B82F6)),
                    _buildStaffContact('Library Admin', 'Librarian', const Color(0xFF8B5CF6)),
                    _buildStaffContact('Sports Coach', 'Physical Education', const Color(0xFFEF4444)),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildStaffContact(String name, String role, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D), fontSize: 16)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(role, style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFFD1D5DB)),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                chatData: {
                  'id': DateTime.now().toString(),
                  'name': name,
                  'role': role.split(' • ').first.toUpperCase(),
                  'subtitle': role,
                  'lastMessage': '',
                  'time': 'Just now',
                  'unread': 0,
                  'avatarColor': color,
                  'isStarred': false,
                  'isArchived': false,
                },
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text('Filter Messages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ),
                const Divider(color: Color(0xFFF3EEFF), height: 32, thickness: 1.5),
                ..._filterOptions.map((filter) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(filter, style: TextStyle(
                    fontSize: 16,
                    color: filter == _selectedFilter ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D),
                    fontWeight: filter == _selectedFilter ? FontWeight.bold : FontWeight.w500,
                  )),
                  trailing: filter == _selectedFilter ? const Icon(Icons.check_circle, color: Color(0xFF6C4CF1)) : null,
                  onTap: () {
                    setState(() => _selectedFilter = filter);
                    Navigator.pop(context);
                  },
                )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredChats;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Messages', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
            ),


            // Search Bar & Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search messages...',
                          hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                          icon: Icon(LucideIcons.search, color: Color(0xFF9E9E9E), size: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Row(
                        children: const [
                          Icon(LucideIcons.filter, size: 16, color: Color(0xFF6C6C80)),
                          SizedBox(width: 8),
                          Text('Filter', style: TextStyle(color: Color(0xFF6C6C80), fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // New Message Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showNewMessageModal,
                  icon: const Icon(Icons.add, size: 20, color: Colors.white),
                  label: const Text('New Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filter Chips & New Message Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _screenFilterOptions.map((filter) {
                          final isSelected = filter == _selectedFilter;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF6C6C80),
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3EEFF)),
            
            // Chat List
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(child: Text('No messages found', style: TextStyle(color: Color(0xFF6C6C80))))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 900) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: filteredList.asMap().entries.map((entry) {
                                int index = entry.key;
                                var chat = entry.value;
                                return SizedBox(
                                  width: (constraints.maxWidth - 48) / 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: _buildChatListItem(chat, index == 0),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Color(0xFFF3EEFF)),
                            itemBuilder: (context, index) {
                              return _buildChatListItem(filteredList[index], index == 0);
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListItem(Map<String, dynamic> chat, bool isFirst) {
    bool hasUnread = (chat['unread'] ?? 0) > 0;
    bool isStarred = chat['isStarred'] ?? false;
    bool isArchived = chat['isArchived'] ?? false;
    
    // Tag background colors based on role
    Color tagBgColor;
    Color tagTextColor;
    if (chat['role'] == 'PARENT') {
      tagBgColor = const Color(0xFFF3EEFF); // light purple
      tagTextColor = const Color(0xFF6C4CF1); // purple
    } else if (chat['role'] == 'TEACHER') {
      tagBgColor = const Color(0xFFE0F2FE); // light sky
      tagTextColor = const Color(0xFF0284C7); // sky
    } else if (chat['role'] == 'STAFF') {
      tagBgColor = const Color(0xFFFEF3C7); // light amber
      tagTextColor = const Color(0xFFD97706); // amber
    } else {
      tagBgColor = const Color(0xFFD1FAE5); // light emerald
      tagTextColor = const Color(0xFF059669); // emerald
    }
    
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              chatData: chat,
              onBack: () => Navigator.pop(context),
              onStar: () {
                setState(() {
                  chat['isStarred'] = !(chat['isStarred'] ?? false);
                });
              },
              onArchive: () {
                setState(() {
                  chat['isArchived'] = !(chat['isArchived'] ?? false);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: isFirst ? const Border(left: BorderSide(color: Color(0xFF6C4CF1), width: 4)) : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: chat['avatarColor'].withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  chat['name'].substring(0, 1).toUpperCase() + (chat['name'].contains(' ') ? chat['name'].split(' ').last.substring(0, 1).toUpperCase() : ''),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: chat['avatarColor']),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Name and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'], 
                          style: TextStyle(fontSize: 16, fontWeight: isFirst ? FontWeight.bold : FontWeight.w600, color: const Color(0xFF1E1E2D)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(chat['time'], style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Row 2: Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tagBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      chat['role'],
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: tagTextColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Row 3: Message and Icons
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF6C6C80),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isStarred)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                        ),
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C4CF1),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chat['isStarred'] = !(chat['isStarred'] ?? false);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isStarred ? const Color(0xFFFFFBEB) : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isStarred ? const Color(0xFFFDE68A) : const Color(0xFFE5E7EB)),
                            ),
                            child: Row(
                              children: [
                                Icon(isStarred ? Icons.star : Icons.star_border, size: 14, color: isStarred ? const Color(0xFFF59E0B) : const Color(0xFF6C6C80)),
                                const SizedBox(width: 4),
                                Text(isStarred ? 'Starred' : 'Star', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isStarred ? const Color(0xFFF59E0B) : const Color(0xFF6C6C80))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chat['isArchived'] = !(chat['isArchived'] ?? false);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (chat['isArchived'] ?? false) ? 'Chat archived' : 'Chat unarchived',
                                  style: const TextStyle(fontWeight: FontWeight.bold)
                                ),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isArchived ? const Color(0xFFE0F2FE) : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isArchived ? const Color(0xFFBAE6FD) : const Color(0xFFE5E7EB)),
                            ),
                            child: Row(
                              children: [
                                Icon(isArchived ? Icons.unarchive : LucideIcons.archive, size: 14, color: isArchived ? const Color(0xFF0284C7) : const Color(0xFF6C6C80)),
                                const SizedBox(width: 4),
                                Text(isArchived ? 'Unarchive' : 'Archive', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isArchived ? const Color(0xFF0284C7) : const Color(0xFF6C6C80))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
