import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DriverMessagesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const DriverMessagesScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<DriverMessagesScreen> createState() => _DriverMessagesScreenState();
}

class _DriverMessagesScreenState extends State<DriverMessagesScreen> {
  int _activeTab = 0; // 0 = Chats, 1 = Transport Alerts
  final TextEditingController _chatInputController = TextEditingController();

  Map<String, dynamic>? _selectedChat;

  final List<Map<String, dynamic>> _chats = [
    {
      "id": "1",
      "name": "Transport Manager (Mr. Sharma)",
      "role": "Admin",
      "unread": 2,
      "time": "07:10 AM",
      "lastMessage": "Please make sure to verify all student boarding at Stop 3 today.",
      "avatarColor": Color(0xFF6C4CF1),
      "messages": [
        {"sender": "Mr. Sharma", "text": "Good morning Rajesh! Is Bus-01 ready?", "time": "07:00 AM"},
        {"sender": "Driver", "text": "Good morning sir, fuel is checked & bus is ready.", "time": "07:02 AM"},
        {"sender": "Mr. Sharma", "text": "Please make sure to verify all student boarding at Stop 3 today.", "time": "07:10 AM"},
      ]
    },
    {
      "id": "2",
      "name": "Route 1 Parents Group",
      "role": "Group (38 Members)",
      "unread": 5,
      "time": "07:28 AM",
      "lastMessage": "Parent of Aarav: Thank you driver, Aarav has boarded.",
      "avatarColor": Color(0xFF10B981),
      "messages": [
        {"sender": "Driver", "text": "Bus KA-05-EX-4029 has started the morning trip.", "time": "07:15 AM"},
        {"sender": "Parent of Ananya", "text": "Will reach Stop 1 in 2 mins!", "time": "07:18 AM"},
        {"sender": "Parent of Aarav", "text": "Thank you driver, Aarav has boarded.", "time": "07:28 AM"},
      ]
    },
    {
      "id": "3",
      "name": "Ramesh Chandra (Attendant)",
      "role": "Conductor",
      "unread": 0,
      "time": "Yesterday",
      "lastMessage": "All seats clean and seatbelts inspected.",
      "avatarColor": Color(0xFFFF9800),
      "messages": [
        {"sender": "Attendant", "text": "All seats clean and seatbelts inspected.", "time": "Yesterday"},
      ]
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Route Construction Notice",
      "body": "Road repair near Pine Street Crossing. Use Metro Bypass detour for Stop 4.",
      "time": "Today, 06:30 AM",
      "type": "Warning"
    },
    {
      "title": "Monthly Safety Inspection Passed",
      "body": "Vehicle BUS-01 passed safety & brake test with 100% score.",
      "time": "28 July 2026",
      "type": "Success"
    },
    {
      "title": "Weather Alert - Heavy Rain Expected",
      "body": "Drive cautiously in evening return trip. Reduced speed limit 30 km/h.",
      "time": "27 July 2026",
      "type": "Alert"
    },
  ];

  final List<String> _quickResponses = [
    "On my way 🚌",
    "Arriving in 5 mins ⏰",
    "Traffic delay ~10 mins 🚦",
    "All students boarded safely 👍",
    "Route completed 🏁",
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _selectedChat == null) return;
    setState(() {
      _selectedChat!['messages'].add({
        "sender": "Driver",
        "text": text.trim(),
        "time": "Just now",
      });
      _selectedChat!['lastMessage'] = text.trim();
      _selectedChat!['time'] = "Just now";
    });
    _chatInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChat != null) {
      return _buildIndividualChatScreen();
    }

    return Column(
      children: [
        if (widget.onBack != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 4),
            child: Row(
              children: [
                AppBackButton(onPressed: widget.onBack!),
                const SizedBox(width: 8),
                const Text('Messages & Announcements', style: AppTypography.cardTitle),
              ],
            ),
          ),

        // Tab Selector (Chats vs Notifications)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeTab == 0 ? const Color(0xFF6C4CF1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Direct & Group Chats',
                      style: TextStyle(
                        color: _activeTab == 0 ? Colors.white : const Color(0xFF7A7A9D),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeTab == 1 ? const Color(0xFF6C4CF1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Transport Updates (${_notifications.length})',
                      style: TextStyle(
                        color: _activeTab == 1 ? Colors.white : const Color(0xFF7A7A9D),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: _activeTab == 0 ? _buildChatsList() : _buildNotificationsList(),
        ),
      ],
    );
  }

  Widget _buildChatsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: 90,
      ),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.cardSpacing),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.card,
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              onTap: () {
                setState(() {
                  _selectedChat = chat;
                chat['unread'] = 0;
              });
            },
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: chat['avatarColor'].withValues(alpha: 0.15),
              child: Text(
                chat['name'].substring(0, 1),
                style: TextStyle(color: chat['avatarColor'], fontWeight: FontWeight.bold),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    chat['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  chat['time'],
                  style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    chat['lastMessage'],
                    style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (chat['unread'] > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C4CF1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat['unread']}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: 90,
      ),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        final isWarn = notif['type'] == 'Warning';
        final isSucc = notif['type'] == 'Success';

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.cardSpacing),
          padding: const EdgeInsets.all(AppSpacing.internalCardPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isWarn
                      ? const Color(0xFFFFF3E0)
                      : isSucc
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isWarn
                      ? Icons.warning_amber_rounded
                      : isSucc
                          ? Icons.check_circle_rounded
                          : Icons.campaign_rounded,
                  color: isWarn
                      ? const Color(0xFFFF9800)
                      : isSucc
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6C4CF1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['title'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['body'],
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif['time'],
                      style: const TextStyle(fontSize: 10.5, color: Color(0xFFB0B0CC), fontWeight: FontWeight.w500),
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

  Widget _buildIndividualChatScreen() {
    final chat = _selectedChat!;
    final List messages = chat['messages'];

    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              AppBackButton(onPressed: () => setState(() => _selectedChat = null)),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 18,
                backgroundColor: chat['avatarColor'].withValues(alpha: 0.15),
                child: Text(
                  chat['name'].substring(0, 1),
                  style: TextStyle(color: chat['avatarColor'], fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat['name'],
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      chat['role'],
                      style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Quick Driver Response Chips (Optimized for One-Handed Tap while parked)
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            itemCount: _quickResponses.length,
            itemBuilder: (context, index) {
              final resp = _quickResponses[index];
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(resp),
                  backgroundColor: const Color(0xFFF3F0FF),
                  labelStyle: const TextStyle(color: Color(0xFF6C4CF1), fontSize: 11.5, fontWeight: FontWeight.bold),
                  onPressed: () => _sendMessage(resp),
                ),
              );
            },
          ),
        ),

        // Messages Feed
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg['sender'] == 'Driver';

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF6C4CF1) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: isMe ? const Radius.circular(14) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(14),
                    ),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Text(
                          msg['sender'],
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                        ),
                      Text(
                        msg['text'],
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isMe ? Colors.white : const Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        msg['time'],
                        style: AppTypography.caption.copyWith(
                          color: isMe ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF7A7A9D),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Input Field Bar
        Container(
          padding: const EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            top: 8,
            bottom: 90,
          ),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatInputController,
                  decoration: InputDecoration(
                    hintText: 'Type message...',
                    filled: true,
                    fillColor: const Color(0xFFF9F8FF),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _sendMessage(_chatInputController.text),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6C4CF1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
