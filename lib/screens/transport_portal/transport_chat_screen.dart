import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportChatScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;

  const TransportChatScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<TransportChatScreen> createState() => _TransportChatScreenState();
}

class _TransportChatScreenState extends State<TransportChatScreen> {
  late List<Map<String, dynamic>> _messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final initialHistory = widget.conversation['chatHistory'] as List?;
    if (initialHistory != null && initialHistory.isNotEmpty) {
      _messages = List<Map<String, dynamic>>.from(initialHistory);
    } else {
      _messages = [
        {
          'id': 'm1',
          'senderName': widget.conversation['name'],
          'text': widget.conversation['lastMessage'] ?? 'Hello, regarding transport updates.',
          'time': widget.conversation['time'] ?? '10:30 AM',
          'isMe': false,
          'status': 'read',
        },
        {
          'id': 'm2',
          'senderName': 'You (Transport Admin)',
          'text': 'Acknowledged! We are monitoring live updates from the depot.',
          'time': '10:32 AM',
          'isMe': true,
          'status': 'read',
        },
      ];
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderName': 'You (Transport Admin)',
        'text': text,
        'time': 'Just now',
        'isMe': true,
        'status': 'sent',
      });
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Share Attachment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentTile(LucideIcons.image, 'Gallery', const Color(0xFF6C4CF1), () {
                    Navigator.pop(context);
                    _addAttachmentMessage('Photo_BusRoute_Log.jpg', 'Image Attachment');
                  }),
                  _buildAttachmentTile(LucideIcons.camera, 'Camera', const Color(0xFF10B981), () {
                    Navigator.pop(context);
                    _addAttachmentMessage('Live_Bus_Photo.jpg', 'Camera Photo');
                  }),
                  _buildAttachmentTile(LucideIcons.fileText, 'Document', const Color(0xFF3B82F6), () {
                    Navigator.pop(context);
                    _addAttachmentMessage('Transport_Rules_2026.pdf', 'Document PDF');
                  }),
                  _buildAttachmentTile(LucideIcons.mapPin, 'Location', const Color(0xFFF59E0B), () {
                    Navigator.pop(context);
                    _addAttachmentMessage('GPS Stop Location', 'Live Location');
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _addAttachmentMessage(String title, String type) {
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderName': 'You (Transport Admin)',
        'text': 'Attachment: $title ($type)',
        'time': 'Just now',
        'isMe': true,
        'status': 'sent',
        'isAttachment': true,
        'fileName': title,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.conversation['name'] ?? 'Chat';
    final String role = widget.conversation['role'] ?? 'User';
    final bool isOnline = widget.conversation['isOnline'] ?? false;
    final bool isGroup = widget.conversation['isGroup'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leadingWidth: 48,
        leading: AppBackButton(onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isGroup ? const Color(0xFFEBF5FF) : const Color(0xFFF3EEFF),
                  child: Icon(
                    isGroup ? LucideIcons.users : LucideIcons.user,
                    color: isGroup ? const Color(0xFF3B82F6) : const Color(0xFF6C4CF1),
                    size: 18,
                  ),
                ),
                if (isOnline && !isGroup)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF1E1E2D),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    isGroup ? 'Group Chat • 18 Members' : (isOnline ? 'Active Now • $role' : 'Offline • $role'),
                    style: TextStyle(
                      color: isOnline ? const Color(0xFF10B981) : const Color(0xFF7A7A9D),
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.moreVertical, color: Color(0xFF1E1E2D), size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final bool isMe = m['isMe'] == true;
                final bool isAttachment = m['isAttachment'] == true;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.76,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF6C4CF1) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                        bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                      border: isMe ? null : Border.all(color: const Color(0xFFF0ECF9), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe && isGroup) ...[
                          Text(
                            m['senderName'] ?? 'Member',
                            style: const TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4CF1),
                            ),
                          ),
                          const SizedBox(height: 3),
                        ],
                        if (isAttachment) ...[
                          Row(
                            children: [
                              Icon(
                                LucideIcons.fileText,
                                color: isMe ? Colors.white : const Color(0xFF6C4CF1),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  m['fileName'] ?? 'File',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: isMe ? Colors.white : const Color(0xFF1E1E2D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          m['text'] ?? '',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isMe ? Colors.white : const Color(0xFF1E1E2D),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              m['time'] ?? '',
                              style: TextStyle(
                                fontSize: 10.0,
                                color: isMe ? Colors.white70 : const Color(0xFF7A7A9D),
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                LucideIcons.checkCheck,
                                color: Colors.white70,
                                size: 13,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Fixed Message Composer Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E1E2D).withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Attachment Paperclip Icon
                  IconButton(
                    icon: const Icon(LucideIcons.paperclip, color: Color(0xFF7A7A9D), size: 22),
                    onPressed: _showAttachmentOptions,
                    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  ),
                  // Camera Icon
                  IconButton(
                    icon: const Icon(LucideIcons.camera, color: Color(0xFF7A7A9D), size: 22),
                    onPressed: () => _addAttachmentMessage('Photo_Capture.jpg', 'Camera'),
                    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  ),

                  // Message Input Field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1E2D)),
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13.0),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Emoji Picker Opened'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Icon(LucideIcons.smile, color: Color(0xFF7A7A9D), size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Send Button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C4CF1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.send, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
          ),
        ],
      ),
    );
  }
}
