import 'package:flutter/material.dart';

class YearViewScreen extends StatefulWidget {
  final int initialYear;
  final Function(DateTime) onMonthSelected;

  const YearViewScreen({
    super.key,
    required this.initialYear,
    required this.onMonthSelected,
  });

  @override
  State<YearViewScreen> createState() => _YearViewScreenState();
}

class _YearViewScreenState extends State<YearViewScreen> {
  final Key _centerKey = const ValueKey('centerYear');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF5B5FEF), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        center: _centerKey,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Negative index, subtract 1 because index starts at 0 for SliverList
                return _buildYearBlock(context, widget.initialYear - index - 1);
              },
            ),
          ),
          SliverList(
            key: _centerKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildYearBlock(context, widget.initialYear + index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearBlock(BuildContext context, int year) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    bool isCurrentYear = year == DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            year.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isCurrentYear ? const Color(0xFF5B5FEF) : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 12,
            itemBuilder: (context, monthIndex) {
              int month = monthIndex + 1;
              return GestureDetector(
                onTap: () {
                  widget.onMonthSelected(DateTime(year, month, 1));
                  Navigator.pop(context);
                },
                child: _buildMiniMonth(year, month, monthNames[monthIndex]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMonth(int year, int month, String monthName) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstWeekday = DateTime(year, month, 1).weekday % 7;

    List<Widget> dayWidgets = [];

    // Empty cells
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Days
    for (int day = 1; day <= daysInMonth; day++) {
      bool isToday = year == DateTime.now().year && 
                     month == DateTime.now().month && 
                     day == DateTime.now().day;

      dayWidgets.add(
        Center(
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF5B5FEF) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              day.toString(),
              style: TextStyle(
                fontSize: 8,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday ? Colors.white : const Color(0xFF4B5563), 
              ),
            ),
          ),
        ),
      );
    }

    bool isCurrentMonth = year == DateTime.now().year && month == DateTime.now().month;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isCurrentMonth ? const Color(0xFF5B5FEF) : const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: dayWidgets,
          ),
        ),
      ],
    );
  }
}
