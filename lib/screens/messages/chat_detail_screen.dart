import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chatData;
  final VoidCallback onBack;
  final VoidCallback? onStar;
  final VoidCallback? onArchive;

  const ChatDetailScreen({
    super.key,
    required this.chatData,
    required this.onBack,
    this.onStar,
    this.onArchive,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Mock Messages
  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    // If it's a new chat (lastMessage is empty), don't show mock messages
    if (widget.chatData['lastMessage'] == '') {
      _messages = [];
    } else {
      _messages = [
        {
          'text': 'Hello! Just checking in on how things are going this week.',
          'isMe': false,
          'time': '09:00 AM',
        },
        {
          'text': 'Everything is going great! Thank you for asking.',
          'isMe': true,
          'time': '09:15 AM',
        },
        {
          'text': widget.chatData['lastMessage'], // The message shown in the list
          'isMe': false,
          'time': widget.chatData['time'],
        },
      ];
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': 'Just now',
        });
      });
      _messageController.clear();
      _scrollToBottom();
      
      // Simulate reply after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'text': 'Thanks for your message. I will look into it and get back to you shortly.',
              'isMe': false,
              'time': 'Just now',
            });
          });
          _scrollToBottom();
        }
      });
    }
  }

  void _sendFileMessage(String fileName) {
    setState(() {
      _messages.add({
        'text': 'Sent file: $fileName',
        'isMe': true,
        'time': 'Just now',
      });
    });
    _scrollToBottom();
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attachment Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
              ),
              const SizedBox(height: 24),
              _buildUploadOptionAction(context, LucideIcons.camera, 'Take a Photo', () async {
                final picker = ImagePicker();
                final photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) _sendFileMessage(photo.name);
              }),
              const SizedBox(height: 16),
              _buildUploadOptionAction(context, LucideIcons.image, 'Choose from Gallery', () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) _sendFileMessage(image.name);
              }),
              const SizedBox(height: 16),
              _buildUploadOptionAction(context, LucideIcons.fileText, 'Select a Document', () async {
                FilePickerResult? result = await FilePicker.pickFiles();
                if (result != null) _sendFileMessage(result.files.single.name);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOptionAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6C4CF1), size: 20),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
          ],
        ),
      ),
    );
  }


  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Report User'),
        content: const Text('Are you sure you want to report this user? They will be reviewed by our moderation team.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('User reported successfully'),
                backgroundColor: const Color(0xFFE11D48),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isStarred = widget.chatData['isStarred'] ?? false;
    bool isArchived = widget.chatData['isArchived'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Integrated Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                  
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.chatData['avatarColor'].withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.chatData['name'].substring(0, 1),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.chatData['avatarColor']),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Name and Role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.chatData['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        Text(widget.chatData['role'], style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                      ],
                    ),
                  ),
                  
                  // Options Action
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(LucideIcons.moreVertical, size: 18, color: Color(0xFF1E1E2D)),
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      offset: const Offset(0, 40),
                      onSelected: (value) {
                        if (value == 'Star Chat') {
                          if (widget.onStar != null) {
                            widget.onStar!();
                          } else {
                            widget.chatData['isStarred'] = !isStarred;
                          }
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(!isStarred ? 'Chat starred' : 'Chat unstarred'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        } else if (value == 'Archive Chat') {
                          if (widget.onArchive != null) {
                            widget.onArchive!();
                          } else {
                            widget.chatData['isArchived'] = !isArchived;
                          }
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(!isArchived ? 'Chat archived' : 'Chat unarchived'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        } else if (value == 'Report') {
                          _showReportDialog();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Selected: $value'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Star Chat',
                          child: Row(
                            children: [
                              Icon(isStarred ? Icons.star : LucideIcons.star, size: 18, color: isStarred ? const Color(0xFFF59E0B) : const Color(0xFF1E1E2D)),
                              const SizedBox(width: 12),
                              Text(isStarred ? 'Unstar Chat' : 'Star Chat', style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Archive Chat',
                          child: Row(
                            children: [
                              Icon(isArchived ? Icons.archive : LucideIcons.archive, size: 18, color: isArchived ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D)),
                              const SizedBox(width: 12),
                              Text(isArchived ? 'Unarchive Chat' : 'Archive Chat', style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'Report',
                          child: Row(
                            children: const [
                              Icon(LucideIcons.flag, size: 18, color: Color(0xFFE11D48)),
                              SizedBox(width: 12),
                              Text('Report', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFE11D48))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages Area
            Expanded(
              child: _messages.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.messageSquare, size: 48, color: const Color(0xFF9E9E9E).withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      const Text('No messages yet.', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16)),
                      const Text('Send a message to start the conversation.', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isMe = msg['isMe'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: widget.chatData['avatarColor'].withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.chatData['name'].substring(0, 1),
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: widget.chatData['avatarColor']),
                                ),
                              ),
                            ),
                          ],
                          
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isMe ? const Color(0xFF6C4CF1) : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                                ),
                                border: isMe ? null : Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg['text'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isMe ? Colors.white : const Color(0xFF1E1E2D),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    msg['time'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          if (isMe) const SizedBox(width: 32), // spacer for alignment
                        ],
                      ),
                    );
                  },
                ),
            ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32), // extra padding for bottom safe area
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: const Color(0xFFF3EEFF), width: 1.5)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showAttachmentOptions,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.paperclip, size: 20, color: Color(0xFF9E9E9E)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
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
