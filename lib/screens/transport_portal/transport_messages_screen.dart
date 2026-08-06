import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'transport_chat_screen.dart';

class TransportMessagesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TransportMessagesScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TransportMessagesScreen> createState() => _TransportMessagesScreenState();
}

class _TransportMessagesScreenState extends State<TransportMessagesScreen> {
  String _selectedFilter = 'All'; // 'All', 'Unread', 'Groups'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _conversations;

  @override
  void initState() {
    super.initState();
    _initConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initConversations() {
    _conversations = [
      {
        'id': 'c1',
        'name': 'Transport Supervisor (Depot)',
        'role': 'Admin',
        'lastMessage': 'BUS-01 tank refilled to 100% at HP Station. On schedule.',
        'time': '10:42 AM',
        'unreadCount': 2,
        'isGroup': false,
        'isPinned': true,
        'chatHistory': [
          {
            'id': 'm1',
            'senderName': 'Supervisor',
            'text': 'Good morning! Starting morning pick up for Route 1.',
            'time': '07:10 AM',
            'isMe': false,
            'status': 'read',
          },
          {
            'id': 'm2',
            'senderName': 'You',
            'text': 'Great! Please confirm fuel status at depot.',
            'time': '07:15 AM',
            'isMe': true,
            'status': 'read',
          },
          {
            'id': 'm3',
            'senderName': 'Supervisor',
            'text': 'BUS-01 tank refilled to 100% at HP Station. On schedule.',
            'time': '10:42 AM',
            'isMe': false,
            'status': 'unread',
          },
        ],
      },
      {
        'id': 'c2',
        'name': 'Route 1 Parents Group',
        'role': 'Group',
        'lastMessage': 'Suresh Verma: Vehicle reached Stop 4 (Green Glen Gate 2).',
        'time': '09:15 AM',
        'unreadCount': 1,
        'isGroup': true,
        'isPinned': false,
        'chatHistory': [
          {
            'id': 'm1',
            'senderName': 'Transport Admin',
            'text': 'Morning Bus 01 has departed school premises on time.',
            'time': '07:00 AM',
            'isMe': true,
            'status': 'read',
          },
          {
            'id': 'm2',
            'senderName': 'Suresh Verma',
            'text': 'Vehicle reached Stop 4 (Green Glen Gate 2).',
            'time': '09:15 AM',
            'isMe': false,
            'status': 'unread',
          },
        ],
      },
      {
        'id': 'c3',
        'name': 'Suresh Verma (Parent)',
        'role': 'Parent',
        'lastMessage': 'Thank you! Aarav boarded safely at Stop 2.',
        'time': 'Yesterday',
        'unreadCount': 0,
        'isGroup': false,
        'isPinned': false,
        'chatHistory': [
          {
            'id': 'm1',
            'senderName': 'Suresh Verma',
            'text': 'Thank you! Aarav boarded safely at Stop 2.',
            'time': 'Yesterday, 07:35 AM',
            'isMe': false,
            'status': 'read',
          },
        ],
      },
      {
        'id': 'c4',
        'name': 'Fleet Safety Broadcast',
        'role': 'Group',
        'lastMessage': 'Admin: Reminder: Quarterly fleet safety inspection tomorrow at 9 AM.',
        'time': 'Yesterday',
        'unreadCount': 0,
        'isGroup': true,
        'isPinned': false,
      },
      {
        'id': 'c5',
        'name': 'Anil Verma (Backup Driver)',
        'role': 'Driver',
        'lastMessage': 'VAN-04 maintenance check completed at service center.',
        'time': '27 Jul',
        'unreadCount': 0,
        'isGroup': false,
        'isPinned': false,
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredConversations {
    List<Map<String, dynamic>> list = _conversations;

    if (_selectedFilter == 'Unread') {
      list = list.where((c) => (c['unreadCount'] as int? ?? 0) > 0).toList();
    } else if (_selectedFilter == 'Groups') {
      list = list.where((c) => c['isGroup'] == true).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
          (c['name'] as String? ?? '').toLowerCase().contains(q) ||
          (c['lastMessage'] as String? ?? '').toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredConversations;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 90.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Page Title (22px bold)
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2D),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar (#F8F9FD Fill, 12px Radius)
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0EDF8)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w500),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search messages...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.0, fontWeight: FontWeight.w500),
                    prefixIcon: Icon(LucideIcons.search, color: Color(0xFF64748B), size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Essential Filter Chips: All, Unread, Groups
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ['All', 'Unread', 'Groups'].map((filter) {
                    final bool isSelected = _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF8F9FD),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF0EDF8)),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                            fontSize: 12.0,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Clean Chat Cards List
              if (filtered.isEmpty)
                _buildEmptyState()
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final conv = filtered[index];
                    final String name = conv['name'] ?? 'Contact';
                    final String lastMsg = conv['lastMessage'] ?? '';
                    final String time = conv['time'] ?? '';
                    final int unread = conv['unreadCount'] ?? 0;
                    final bool isGroup = conv['isGroup'] == true;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransportChatScreen(conversation: conv),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFF0EDF8)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Avatar Icon
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isGroup ? const Color(0xFFEBF5FF) : const Color(0xFFF3EEFF),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  isGroup ? LucideIcons.users : LucideIcons.user,
                                  color: isGroup ? const Color(0xFF3B82F6) : const Color(0xFF6C4CF1),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Sender / Group Name (16px bold) & Preview (14px)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E1E2D),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        time,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: unread > 0 ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                                          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          lastMsg,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: unread > 0 ? const Color(0xFF1E1E2D) : const Color(0xFF64748B),
                                            fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (unread > 0) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6C4CF1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '$unread',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(color: Color(0xFFF3EEFF), shape: BoxShape.circle),
              child: const Icon(LucideIcons.messageSquare, color: Color(0xFF6C4CF1), size: 30),
            ),
            const SizedBox(height: 12),
            const Text(
              'No messages found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try a different search term or filter.',
              style: TextStyle(fontSize: 12.0, color: Color(0xFF7A7A9D)),
            ),
          ],
        ),
      ),
    );
  }
}
