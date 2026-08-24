import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final String dateString;
  final Color eventColor;
  final VoidCallback? onBack;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.dateString,
    required this.eventColor,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    String monthName = 'Calendar';
    if (dateString.contains(' ')) {
      monthName = dateString.split(' ')[0];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Off-white background for the screen
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: onBack ?? () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(left: 8.0),
            color: Colors.transparent,
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF5B5FEF),
                  size: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  monthName,
                  style: const TextStyle(
                    color: Color(0xFF5B5FEF),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Card: Event Info
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Box
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          LucideIcons.calendar,
                          color: Color(0xFF5B5FEF),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title & Badge
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['title'] ?? 'Event',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EEFF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.calendarRange,
                                    color: Color(0xFF5B5FEF),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    event['type'] ?? 'School Event',
                                    style: const TextStyle(
                                      color: Color(0xFF5B5FEF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Details List
                  _buildDetailRow(LucideIcons.calendar, 'Date', dateString),
                  const SizedBox(height: 16),
                  _buildDetailRow(LucideIcons.clock, 'Time', event['time'] ?? 'All-day'),
                  
                  if (event['location'] != null && event['location'] != 'N/A') ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(LucideIcons.mapPin, 'Location', event['location']),
                  ],
                  
                  // Mock details based on the design
                  const SizedBox(height: 16),
                  _buildDetailRow(LucideIcons.users, 'Organized By', 'School Administration'),
                  
                  const SizedBox(height: 16),
                  _buildDetailRow(LucideIcons.bell, 'Reminder', '1 day before at 08:00 AM'),
                ],
              ),
            ),
            
            // Second Card: About This Event
            if (event['description'] != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.fileText,
                          color: Color(0xFF5B5FEF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'About This Event',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            const SizedBox(height: 24),
            
            // Upcoming Events Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UPCOMING',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildUpcomingListItem('23 Aug', 'Career Counseling Session'),
                  const SizedBox(height: 16),
                  _buildUpcomingListItem('24 Aug', 'Science Fair'),
                  const SizedBox(height: 16),
                  _buildUpcomingListItem('26 Aug', 'Music Concert'),
                  const SizedBox(height: 16),
                  _buildUpcomingListItem('28 Aug', 'Parent-Teacher Meet'),
                  const SizedBox(height: 16),
                  _buildUpcomingListItem('31 Aug', 'Art Exhibition'),
                  const SizedBox(height: 16),
                  _buildUpcomingListItem('02 Sept', 'Book Fair'),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingListItem(String date, String title) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Purple dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF5B5FEF),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Date
          SizedBox(
            width: 70,
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1E1E2D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1E1E2D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
