import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I pay my child\'s fees?',
        'answer': 'You can pay the fees by navigating to the "Fees" section in the dashboard. From there, select the pending term and click on "Pay Now". We accept credit/debit cards and bank transfers.'
      },
      {
        'question': 'How can I apply for leave for my child?',
        'answer': 'Go to the Student Dashboard and click on "Leave Request" under the Today\'s Activity section. Fill in the required dates and reason, then submit the request for approval.'
      },
      {
        'question': 'Where can I see the report cards?',
        'answer': 'Report cards are available in the "Exams & Results" section, accessible from the Quick Actions menu in the More tab. You can view and download previous and current term results.'
      },
      {
        'question': 'Can I track the school bus?',
        'answer': 'Yes, you can track the school bus in real-time by going to the "Transport" section. It will show the live location of the bus during morning pickup and afternoon drop-off times.'
      },
      {
        'question': 'How do I switch between multiple children profiles?',
        'answer': 'On the top of the Parent Dashboard or More screen, you will see your child\'s profile picture and name. Tapping on it will open a bottom sheet where you can select a different child.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: faqs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  faqs[index]['question']!,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
                iconColor: const Color(0xFF6C4CF1),
                collapsedIconColor: const Color(0xFF9090A7),
                childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                children: [
                  Text(
                    faqs[index]['answer']!,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF6C6C80), height: 1.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
