import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';

class TeacherMessagesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherMessagesScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherMessagesScreen> createState() => _TeacherMessagesScreenState();
}

class _TeacherMessagesScreenState extends State<TeacherMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _chatInputController = TextEditingController();
  final ScrollController _messagesScrollController = ScrollController();
  String _searchQuery = '';
  String _activeTab = 'All'; // 'All', 'Parents', 'Admin', 'Groups', 'Archived'
  Map<String, dynamic>? _selectedChat;

  late List<Map<String, dynamic>> _chats;

  final List<String> _quickResponses = [
    "Homework verified ✅",
    "Coaching at 3 PM 📚",
    "Please share leave note 📄",
    "Great improvement in Math! 🌟",
    "Meeting confirmed 🤝",
  ];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    final raw = widget.data['messages'] as List? ?? [];
    final list = raw.map((item) {
      final map = Map<String, dynamic>.from(item);
      map['isPinned'] = map['isPinned'] ?? false;
      map['isMuted'] = map['isMuted'] ?? false;
      map['isArchived'] = map['isArchived'] ?? false;
      map['unread'] = map['unread'] ?? 0;
      return map;
    }).toList();

    if (mounted) {
      setState(() {
        _chats = list;
      });
    } else {
      _chats = list;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chatInputController.dispose();
    _messagesScrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _selectedChat == null) return;
    setState(() {
      final List msgs = _selectedChat!['messages'] as List? ?? [];
      msgs.add({
        "sender": "Sarah Williams",
        "text": text.trim(),
        "time": "Just now",
      });
      _selectedChat!['messages'] = msgs;
      _selectedChat!['lastMessage'] = text.trim();
      _selectedChat!['time'] = "Just now";
    });
    _chatInputController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messagesScrollController.hasClients) {
        _messagesScrollController.animateTo(
          _messagesScrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── CHAT ACTION HANDLERS (Functional State Mutations) ─────────────────────

  void _togglePinChat(Map<String, dynamic> chat) {
    setState(() {
      chat['isPinned'] = !(chat['isPinned'] == true);
    });
    _showFeedback(chat['isPinned'] == true ? 'Chat pinned to top' : 'Chat unpinned');
  }

  void _toggleMuteChat(Map<String, dynamic> chat) {
    setState(() {
      chat['isMuted'] = !(chat['isMuted'] == true);
    });
    _showFeedback(chat['isMuted'] == true ? 'Notifications muted' : 'Notifications unmuted');
  }

  void _toggleArchiveChat(Map<String, dynamic> chat) {
    setState(() {
      chat['isArchived'] = !(chat['isArchived'] == true);
      if (chat['isArchived'] == true && _selectedChat?['id'] == chat['id']) {
        _selectedChat = null;
      }
    });
    _showFeedback(chat['isArchived'] == true ? 'Chat moved to Archive' : 'Chat unarchived');
  }

  void _toggleReadStatus(Map<String, dynamic> chat) {
    setState(() {
      final int current = chat['unread'] ?? 0;
      chat['unread'] = current > 0 ? 0 : 1;
    });
    _showFeedback((chat['unread'] ?? 0) > 0 ? 'Marked as unread' : 'Marked as read');
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        backgroundColor: const Color(0xFF1E1E2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─── LONG PRESS ACTIONS BOTTOM SHEET ───────────────────────────────────────

  void _showChatOptionsBottomSheet(Map<String, dynamic> chat) {
    final bool isPinned = chat['isPinned'] == true;
    final bool isMuted = chat['isMuted'] == true;
    final bool isArchived = chat['isArchived'] == true;
    final int unread = chat['unread'] ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Chat header in sheet
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFF3F0FF),
                      child: Text(
                        chat['name'].toString().substring(0, 1),
                        style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat['name'] ?? '',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            chat['role'] ?? '',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 8),

                // Mark Read / Unread
                _buildSheetActionTile(
                  icon: unread > 0 ? LucideIcons.mailOpen : LucideIcons.mail,
                  title: unread > 0 ? 'Mark as Read' : 'Mark as Unread',
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleReadStatus(chat);
                  },
                ),

                // Pin / Unpin
                _buildSheetActionTile(
                  icon: isPinned ? LucideIcons.pinOff : LucideIcons.pin,
                  title: isPinned ? 'Unpin from Top' : 'Pin to Top',
                  onTap: () {
                    Navigator.pop(ctx);
                    _togglePinChat(chat);
                  },
                ),

                // Mute / Unmute
                _buildSheetActionTile(
                  icon: isMuted ? LucideIcons.volume2 : LucideIcons.volumeX,
                  title: isMuted ? 'Unmute Notifications' : 'Mute Notifications',
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleMuteChat(chat);
                  },
                ),

                // Archive / Unarchive
                _buildSheetActionTile(
                  icon: isArchived ? LucideIcons.archiveRestore : LucideIcons.archive,
                  title: isArchived ? 'Unarchive Chat' : 'Archive Chat',
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleArchiveChat(chat);
                  },
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final textCol = color ?? const Color(0xFF1E1E2D);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        child: Row(
          children: [
            Icon(icon, size: 19, color: textCol),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: textCol,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── REPORT CHAT ACTION SHEET ──────────────────────────────────────────────

  void _showReportChatBottomSheet(BuildContext context, Map<String, dynamic> chat) {
    String selectedReason = 'Inappropriate language or behavior';
    bool blockContact = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Report Chat',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: -0.3,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F0FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF6C4CF1)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Report conversation with ${chat['name'] ?? 'this contact'} to School Administration.',
                      style: const TextStyle(fontSize: 13.0, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFF0EDF8)),
                    const SizedBox(height: 12),

                    // Contact preview card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFF3F0FF),
                            child: Text(
                              chat['name'].toString().substring(0, 1),
                              style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat['name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Color(0xFF1E1E2D)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  chat['role'] ?? '',
                                  style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Reason selection label
                    const Text(
                      'Reason for Reporting',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 8),

                    // Radio list of reasons
                    ...[
                      'Inappropriate language or behavior',
                      'Spam, advertising, or unsolicited messages',
                      'Harassment or bullying',
                      'Academic dishonesty or concern',
                      'Other safety or policy violation',
                    ].map((reason) {
                      final isSelected = selectedReason == reason;
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedReason = reason),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFF3F0FF) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF0EDF8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                size: 17,
                                color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  reason,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? const Color(0xFF1E1E2D) : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),

                    // Block contact checkbox option
                    GestureDetector(
                      onTap: () => setSheetState(() => blockContact = !blockContact),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: blockContact,
                              onChanged: (val) => setSheetState(() => blockContact = val ?? false),
                              activeColor: const Color(0xFF6C4CF1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Also block this contact from direct messaging',
                              style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Action buttons (Cancel & Submit Report)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF475569),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Cancel', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showFeedback('Chat report submitted to School Administration. Thank you.');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Report Chat', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─── MAIN BUILD ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_selectedChat != null) {
      return _buildIndividualChatScreen();
    }

    // Sort chats: Pinned chats first, then chronological
    final List<Map<String, dynamic>> sortedChats = List.from(_chats);
    sortedChats.sort((a, b) {
      final aPinned = a['isPinned'] == true ? 1 : 0;
      final bPinned = b['isPinned'] == true ? 1 : 0;
      return bPinned.compareTo(aPinned);
    });

    final filteredChats = sortedChats.where((c) {
      final bool isArchived = c['isArchived'] == true;

      // In Archived tab, show only archived chats
      if (_activeTab == 'Archived') {
        if (!isArchived) return false;
      } else {
        // In active tabs, exclude archived chats
        if (isArchived) return false;
        if (_activeTab == 'Parents' && c['category'] != 'Parents') return false;
        if (_activeTab == 'Admin' && c['category'] != 'Admin') return false;
        if (_activeTab == 'Groups' && c['category'] != 'Groups') return false;
      }

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (c['name'] ?? '').toString().toLowerCase().contains(q) ||
          (c['role'] ?? '').toString().toLowerCase().contains(q) ||
          (c['lastMessage'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    final int archivedCount = _chats.where((c) => c['isArchived'] == true).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Messages & Chats',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_chats.where((c) => c['isArchived'] != true).length} Active',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Bar
              TeacherSearchBar(
                controller: _searchController,
                hintText: 'Search chats by name, role, or text...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
              const SizedBox(height: 14),

              // 5-Tab Bar (All, Parents, Admin, Groups, Archived)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildTabItem('All'),
                    const SizedBox(width: 8),
                    _buildTabItem('Parents'),
                    const SizedBox(width: 8),
                    _buildTabItem('Admin'),
                    const SizedBox(width: 8),
                    _buildTabItem('Groups'),
                    const SizedBox(width: 8),
                    _buildTabItem('Archived', badge: archivedCount > 0 ? '$archivedCount' : null),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Chats List
              if (filteredChats.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _activeTab == 'Archived' ? LucideIcons.archive : LucideIcons.messageSquareOff,
                        size: 34,
                        color: const Color(0xFF64748B),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _activeTab == 'Archived' ? 'No archived chats' : 'No messages found',
                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      if (_activeTab == 'Archived') ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Conversations you archive will appear here.',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ],
                  ),
                )
              else
                ...filteredChats.map((chat) {
                  final int colorVal = int.tryParse(chat['avatarColor'] ?? '') ?? 0xFF6C4CF1;
                  final avatarColor = Color(colorVal);
                  final int unread = chat['unread'] ?? 0;
                  final bool isPinned = chat['isPinned'] == true;
                  final bool isMuted = chat['isMuted'] == true;
                  final bool isArchived = chat['isArchived'] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isPinned ? const Color(0xFFFCFBFF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isPinned ? const Color(0xFFE5DEFF) : const Color(0xFFF0EDF8),
                      ),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedChat = chat;
                            chat['unread'] = 0;
                          });
                        },
                        onLongPress: () => _showChatOptionsBottomSheet(chat),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 21,
                                backgroundColor: avatarColor.withValues(alpha: 0.12),
                                child: Text(
                                  chat['name'].toString().substring(0, 1),
                                  style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (isPinned) ...[
                                          const Icon(LucideIcons.pin, size: 13, color: Color(0xFF6C4CF1)),
                                          const SizedBox(width: 4),
                                        ],
                                        Expanded(
                                          child: Text(
                                            chat['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.5,
                                              color: Color(0xFF1E1E2D),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isMuted) ...[
                                          const Icon(LucideIcons.volumeX, size: 13, color: Color(0xFF94A3B8)),
                                          const SizedBox(width: 4),
                                        ],
                                        if (isArchived) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Archived',
                                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Text(
                                          chat['time'] ?? '',
                                          style: const TextStyle(fontSize: 12.0, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat['lastMessage'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: unread > 0 ? const Color(0xFF1E1E2D) : const Color(0xFF475569),
                                              fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w400,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (unread > 0)
                                          Container(
                                            margin: const EdgeInsets.only(left: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF6C4CF1),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Text(
                                              '$unread',
                                              style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),
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
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String tabName, {String? badge}) {
    final isSelected = _activeTab == tabName;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tabName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tabName,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── INDIVIDUAL CHAT SCREEN (Simple Header: Back → Profile → 3-Dot Menu) ─

  Widget _buildIndividualChatScreen() {
    final chat = _selectedChat!;
    final List messages = chat['messages'] as List? ?? [];
    final int colorVal = int.tryParse(chat['avatarColor'] ?? '') ?? 0xFF6C4CF1;
    final avatarColor = Color(colorVal);
    final bool isPinned = chat['isPinned'] == true;
    final bool isMuted = chat['isMuted'] == true;
    final bool isArchived = chat['isArchived'] == true;

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Simple, Clean Header: Back → Profile/Name → 3-Dot Menu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF0EDF8))),
              ),
              child: Row(
                children: [
                  AppBackButton(onPressed: () => setState(() => _selectedChat = null)),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: avatarColor.withValues(alpha: 0.12),
                    child: Text(
                      chat['name'].toString().substring(0, 1),
                      style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                chat['name'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color(0xFF1E1E2D)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isMuted) ...[
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.volumeX, size: 13, color: Color(0xFF94A3B8)),
                            ],
                          ],
                        ),
                        Text(
                          chat['role'] ?? 'Parent / Staff',
                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Functional 3-Dot Menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1E1E2D), size: 22),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    onSelected: (value) {
                      if (value == 'pin') {
                        _togglePinChat(chat);
                      } else if (value == 'mute') {
                        _toggleMuteChat(chat);
                      } else if (value == 'archive') {
                        _toggleArchiveChat(chat);
                      } else if (value == 'report') {
                        _showReportChatBottomSheet(context, chat);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'pin',
                        child: Row(
                          children: [
                            Icon(isPinned ? LucideIcons.pinOff : LucideIcons.pin, size: 16, color: const Color(0xFF1E1E2D)),
                            const SizedBox(width: 10),
                            Text(isPinned ? 'Unpin Chat' : 'Pin Chat', style: const TextStyle(fontSize: 13.5)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'mute',
                        child: Row(
                          children: [
                            Icon(isMuted ? LucideIcons.volume2 : LucideIcons.volumeX, size: 16, color: const Color(0xFF1E1E2D)),
                            const SizedBox(width: 10),
                            Text(isMuted ? 'Unmute Notifications' : 'Mute Notifications', style: const TextStyle(fontSize: 13.5)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(isArchived ? LucideIcons.archiveRestore : LucideIcons.archive, size: 16, color: const Color(0xFF1E1E2D)),
                            const SizedBox(width: 10),
                            Text(isArchived ? 'Unarchive Chat' : 'Archive Chat', style: const TextStyle(fontSize: 13.5)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(height: 1),
                      const PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(LucideIcons.flag, size: 16, color: Color(0xFFEF4444)),
                            SizedBox(width: 10),
                            Text('Report Chat', style: TextStyle(fontSize: 13.5, color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Natural Conversation Layout (Fills available space cleanly)
            Expanded(
              child: ListView.builder(
                controller: _messagesScrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final bool isMe = msg['sender'] == 'Sarah Williams';

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF6C4CF1) : const Color(0xFFF6F5FA),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                        border: isMe ? null : Border.all(color: const Color(0xFFEBE8F8)),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg['text'] ?? '',
                            style: TextStyle(
                              color: isMe ? Colors.white : const Color(0xFF1E1E2D),
                              fontSize: 14.0,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            msg['time'] ?? '',
                            style: TextStyle(
                              color: isMe ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF64748B),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 3. Quick Responses
            Container(
              height: 34,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _quickResponses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _sendMessage(_quickResponses[index]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: Text(
                        _quickResponses[index],
                        style: const TextStyle(fontSize: 12.0, color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 4. Message Composer Directly Above Bottom Navigation / Keyboard
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, isKeyboardOpen ? 12 : 92),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF0EDF8))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8FF),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: TextField(
                        controller: _chatInputController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                          border: InputBorder.none,
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _sendMessage(_chatInputController.text),
                    icon: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C4CF1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.send, color: Colors.white, size: 16),
                    ),
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
