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
      'id': '5',
      'name': 'Sports Committee',
      'role': 'GROUP',
      'subtitle': '12 Members',
      'lastMessage': 'The basketball tournament schedule is out!',
      'time': '9:00 AM',
      'unread': 2,
      'avatarColor': const Color(0xFF10B981),
      'isStarred': true,
      'isArchived': false,
      'isGroup': true,
    },
    {
      'id': '6',
      'name': 'Principal Office',
      'role': 'STAFF',
      'subtitle': 'Administration',
      'lastMessage': 'Reminder: Parent-Teacher meeting on Friday.',
      'time': 'Yesterday',
      'unread': 1,
      'avatarColor': const Color(0xFFEF4444),
      'isStarred': false,
      'isArchived': true,
      'isGroup': false,
    },
    {
      'id': '7',
      'name': 'Mrs. Sunita Verma',
      'role': 'TEACHER',
      'subtitle': 'Science Teacher • Grade 10-A',
      'lastMessage': 'Project submissions are due next week.',
      'time': 'Mon',
      'unread': 0,
      'avatarColor': const Color(0xFF0EA5E9),
      'isStarred': false,
      'isArchived': true,
      'isGroup': false,
    },
    {
      'id': '8',
      'name': 'Library Services',
      'role': 'STAFF',
      'subtitle': 'School Library',
      'lastMessage': 'Your requested book is now available.',
      'time': 'May 20',
      'unread': 0,
      'avatarColor': const Color(0xFF8B5CF6),
      'isStarred': false,
      'isArchived': false,
      'isGroup': false,
    },
    {
      'id': '9',
      'name': 'Grade 10 Parents',
      'role': 'GROUP',
      'subtitle': '50 Members',
      'lastMessage': 'Could someone share the syllabus syllabus?',
      'time': 'May 18',
      'unread': 5,
      'avatarColor': const Color(0xFF10B981),
      'isStarred': false,
      'isArchived': true,
      'isGroup': true,
    },
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
    },
  ];

  // Filter and Search State
  String _selectedFilter = 'All';
  // Show all filter options in modal
  List<String> get _filterOptions => ['All', 'Unread', 'Starred', 'Groups', 'Archived'];
  // Show all filter options on the screen horizontally
  List<String> get _screenFilterOptions => [
    'All',
    'Unread',
    'Starred',
    'Groups',
    'Archived',
  ];

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

      bool matchesSearch =
          chat['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          chat['lastMessage'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'New Message',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for staff, teachers...',
                      hintStyle: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        LucideIcons.search,
                        color: Color(0xFF9E9E9E),
                        size: 20,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Text(
                        'Suggested Contacts',
                        style: TextStyle(
                          color: Color(0xFF6C6C80),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _buildStaffContact(
                      'Anita Rao',
                      'Class Teacher • Grade 10-A',
                      const Color(0xFF10B981),
                    ),
                    _buildStaffContact(
                      'R. Khan',
                      'School Principal',
                      const Color(0xFFF59E0B),
                    ),
                    _buildStaffContact(
                      'IT Support',
                      'Technical Helpdesk',
                      const Color(0xFF3B82F6),
                    ),
                    _buildStaffContact(
                      'Library Admin',
                      'Librarian',
                      const Color(0xFF8B5CF6),
                    ),
                    _buildStaffContact(
                      'Sports Coach',
                      'Physical Education',
                      const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
            child: Text(
              name[0],
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            role,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80)),
          ),
        ),
        trailing: const Icon(
          LucideIcons.chevronRight,
          size: 20,
          color: Color(0xFFD1D5DB),
        ),
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'Filter Messages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xFFF3EEFF),
                  height: 32,
                  thickness: 1.5,
                ),
                ..._filterOptions.map(
                  (filter) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 16,
                        color: filter == _selectedFilter
                            ? const Color(0xFF6C4CF1)
                            : const Color(0xFF1E1E2D),
                        fontWeight: filter == _selectedFilter
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: filter == _selectedFilter
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF6C4CF1),
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
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
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF1E1E2D),
                      size: 28,
                    ),
                  ),
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showNewMessageModal,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.edit2,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
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
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
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
                          hintStyle: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 15,
                          ),
                          icon: Icon(
                            LucideIcons.search,
                            color: Color(0xFF9E9E9E),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        size: 20,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _screenFilterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF4B5563),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF3F4F6), height: 1, thickness: 1),

            // Messages List
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final chat = filteredList[index];
                        return _buildMessageItem(chat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> chat) {
    final avatarColor = chat['avatarColor'] as Color;
    
    // Determine role badge colors
    Color roleBgColor;
    Color roleTextColor;
    
    if (chat['role'] == 'PARENT') {
      roleBgColor = const Color(0xFFE8E3F8);
      roleTextColor = const Color(0xFF6C4CF1);
    } else if (chat['role'] == 'TEACHER') {
      roleBgColor = const Color(0xFFE0F2FE);
      roleTextColor = const Color(0xFF0EA5E9);
    } else if (chat['role'] == 'STAFF') {
      roleBgColor = const Color(0xFFFEF3C7);
      roleTextColor = const Color(0xFFF59E0B);
    } else if (chat['role'] == 'GROUP') {
      roleBgColor = const Color(0xFFD1FAE5);
      roleTextColor = const Color(0xFF10B981);
    } else {
      roleBgColor = const Color(0xFFFCE7F3);
      roleTextColor = const Color(0xFFEC4899);
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF9FAFB), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  chat['name'][0],
                  style: TextStyle(
                    color: avatarColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        chat['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: (chat['unread'] ?? 0) > 0 ? Colors.black : const Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: roleBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          chat['role'],
                          style: TextStyle(
                            color: roleTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        chat['time'],
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            color: (chat['unread'] ?? 0) > 0 ? const Color(0xFF1E1E2D) : const Color(0xFF6B7280),
                            fontWeight: (chat['unread'] ?? 0) > 0 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        (chat['isArchived'] ?? false) ? Icons.archive : Icons.archive_outlined,
                        color: (chat['isArchived'] ?? false) ? const Color(0xFF6C4CF1) : const Color(0xFFD1D5DB),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        (chat['isStarred'] ?? false) ? Icons.star : Icons.star_border,
                        color: (chat['isStarred'] ?? false) ? const Color(0xFFF59E0B) : const Color(0xFFD1D5DB),
                        size: 20,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.messageSquare,
              size: 48,
              color: Color(0xFFD1D5DB),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No messages found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
