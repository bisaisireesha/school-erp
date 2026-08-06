import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'transport_chat_screen.dart';

class TransportNewMessageScreen extends StatefulWidget {
  const TransportNewMessageScreen({super.key});

  @override
  State<TransportNewMessageScreen> createState() => _TransportNewMessageScreenState();
}

class _TransportNewMessageScreenState extends State<TransportNewMessageScreen> {
  String _selectedFilter = 'All'; // 'All', 'Parents', 'Drivers', 'Staff', 'Admin', 'Teachers'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allContacts = [
    {
      'id': 'u1',
      'name': 'Rajesh Kumar',
      'role': 'Driver',
      'roleColor': const Color(0xFF6C4CF1),
      'subtitle': 'Senior Fleet Driver • BUS-01 (Route 1)',
      'isOnline': true,
    },
    {
      'id': 'u2',
      'name': 'Suresh Verma',
      'role': 'Parent',
      'roleColor': const Color(0xFF10B981),
      'subtitle': 'Parent of Aarav Sharma (Grade 10-A)',
      'isOnline': true,
    },
    {
      'id': 'u3',
      'name': 'Anil Verma',
      'role': 'Driver',
      'roleColor': const Color(0xFF6C4CF1),
      'subtitle': 'Van Fleet Driver • VAN-04 (Route 4)',
      'isOnline': false,
    },
    {
      'id': 'u4',
      'name': 'Mrs. Deepa Mehta',
      'role': 'Teacher',
      'roleColor': const Color(0xFFEC4899),
      'subtitle': 'Class Teacher • Grade 10-A (Bus Coordinator)',
      'isOnline': true,
    },
    {
      'id': 'u5',
      'name': 'Rohan Gupta Parent',
      'role': 'Parent',
      'roleColor': const Color(0xFF10B981),
      'subtitle': 'Parent of Rohan Gupta (Grade 9-C)',
      'isOnline': false,
    },
    {
      'id': 'u6',
      'name': 'Priya Nair',
      'role': 'Admin',
      'roleColor': const Color(0xFF8B5CF6),
      'subtitle': 'Head of Transport & Safety',
      'isOnline': true,
    },
    {
      'id': 'u7',
      'name': 'Vikram Singh',
      'role': 'Driver',
      'roleColor': const Color(0xFF6C4CF1),
      'subtitle': 'Bus Fleet Driver • BUS-03 (Route 3)',
      'isOnline': false,
    },
    {
      'id': 'u8',
      'name': 'Kavita Sharma',
      'role': 'Staff',
      'roleColor': const Color(0xFFF59E0B),
      'subtitle': 'Transport Desk Operations Crew',
      'isOnline': true,
    },
    {
      'id': 'u9',
      'name': 'Mr. Ramesh Iyer',
      'role': 'Teacher',
      'roleColor': const Color(0xFFEC4899),
      'subtitle': 'Physics Teacher • Senior Transport Escort',
      'isOnline': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredContacts {
    return _allContacts.where((c) {
      final role = c['role'] as String;
      final name = (c['name'] as String).toLowerCase();
      final subtitle = (c['subtitle'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase().trim();

      bool matchesCategory = true;
      if (_selectedFilter == 'Parents') {
        matchesCategory = role == 'Parent';
      } else if (_selectedFilter == 'Drivers') {
        matchesCategory = role == 'Driver';
      } else if (_selectedFilter == 'Staff') {
        matchesCategory = role == 'Staff';
      } else if (_selectedFilter == 'Admin') {
        matchesCategory = role == 'Admin';
      } else if (_selectedFilter == 'Teachers') {
        matchesCategory = role == 'Teacher';
      }

      bool matchesSearch = query.isEmpty || name.contains(query) || subtitle.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openChatWithContact(Map<String, dynamic> contact) {
    final Map<String, dynamic> conversation = {
      'id': contact['id'],
      'name': contact['name'],
      'role': contact['role'],
      'roleColor': contact['roleColor'],
      'lastMessage': 'Tap to start conversation...',
      'time': 'Now',
      'unreadCount': 0,
      'isOnline': contact['isOnline'],
      'isGroup': false,
      'isStarred': false,
      'isMuted': false,
      'isPinned': false,
      'isArchived': false,
      'chatHistory': [],
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransportChatScreen(conversation: conversation),
      ),
    );
  }

  void _createNewGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewGroupBottomSheet(
        contacts: _allContacts,
        onCreateGroup: (groupName, selectedIds) {
          final newGroupConv = {
            'id': 'g_${DateTime.now().millisecondsSinceEpoch}',
            'name': groupName,
            'role': 'Group',
            'roleColor': const Color(0xFF3B82F6),
            'lastMessage': 'Group created with ${selectedIds.length} members',
            'time': 'Just now',
            'unreadCount': 0,
            'isGroup': true,
            'isStarred': false,
            'isMuted': false,
            'isPinned': false,
            'isArchived': false,
            'chatHistory': [
              {
                'id': 'm0',
                'senderName': 'System',
                'text': 'You created group "$groupName"',
                'time': 'Just now',
                'isMe': true,
                'status': 'read',
              }
            ],
          };

          Navigator.pop(context); // Close bottom sheet
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TransportChatScreen(conversation: newGroupConv),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredContacts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => Navigator.pop(context)),
        title: const Text(
          'New Message',
          style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18.5, letterSpacing: -0.3),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ElevatedButton.icon(
              onPressed: _createNewGroup,
              icon: const Icon(LucideIcons.users, size: 14, color: Colors.white),
              label: const Text(
                'New Group',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar at Top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w500),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search contacts by name, role or bus route...',
                  hintStyle: TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.0, fontWeight: FontWeight.w500),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  isDense: true,
                ),
              ),
            ),
          ),

          // Role Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: ['All', 'Parents', 'Drivers', 'Staff', 'Admin', 'Teachers'].map((filter) {
                final bool isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF4A4A68),
                        fontSize: 12.0,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Contact List Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Text(
              'Select Contact (${filtered.length})',
              style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF7A7A9D)),
            ),
          ),

          // Contact List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No contacts found matching criteria.', style: TextStyle(color: Color(0xFF7A7A9D), fontSize: 13.5)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      final Color roleColor = c['roleColor'] as Color;

                      return GestureDetector(
                        onTap: () => _openChatWithContact(c),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                            boxShadow: AppShadows.soft,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFFF3EEFF),
                                child: const Icon(LucideIcons.user, color: Color(0xFF6C4CF1), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            c['name'] as String,
                                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: roleColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            c['role'] as String,
                                            style: TextStyle(color: roleColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      c['subtitle'] as String,
                                      style: const TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFCDCBE0), size: 14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Fully Functional New Group Bottom Sheet ─────────────────────────────────

class _NewGroupBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> contacts;
  final Function(String groupName, List<String> selectedIds) onCreateGroup;

  const _NewGroupBottomSheet({
    required this.contacts,
    required this.onCreateGroup,
  });

  @override
  State<_NewGroupBottomSheet> createState() => _NewGroupBottomSheetState();
}

class _NewGroupBottomSheetState extends State<_NewGroupBottomSheet> {
  final TextEditingController _nameController = TextEditingController(text: 'Route 1 Parents & Crew');
  final Set<String> _selectedContactIds = {};

  @override
  void initState() {
    super.initState();
    // Default select first two contacts
    if (widget.contacts.length >= 2) {
      _selectedContactIds.add(widget.contacts[0]['id'] as String);
      _selectedContactIds.add(widget.contacts[1]['id'] as String);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    final String name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onCreateGroup(name, _selectedContactIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DDF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            const Text(
              'Create New Group',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Group parents, drivers or transport crew members',
              style: TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),

            // Group Name Input
            const Text(
              'Group Name',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 6),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 14.0, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  hintText: 'e.g. Route 3 Parents Group',
                  hintStyle: TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.5),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Members selection heading
            Text(
              'Select Members (${_selectedContactIds.length} Selected)',
              style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 8),

            // Members List with Checkboxes
            Expanded(
              child: ListView.builder(
                itemCount: widget.contacts.length,
                itemBuilder: (context, index) {
                  final c = widget.contacts[index];
                  final String id = c['id'] as String;
                  final bool isSelected = _selectedContactIds.contains(id);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedContactIds.remove(id);
                        } else {
                          _selectedContactIds.add(id);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF3EEFF) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF0EDF8)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFCDCBE0),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['name'] as String, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D))),
                                Text(c['role'] as String, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E6E8D))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Color(0xFF6C4CF1))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Create Group', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
