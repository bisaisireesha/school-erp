import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class TransportStudentAssignmentScreen extends StatefulWidget {
  const TransportStudentAssignmentScreen({super.key});

  @override
  State<TransportStudentAssignmentScreen> createState() => _TransportStudentAssignmentScreenState();
}

class _TransportStudentAssignmentScreenState extends State<TransportStudentAssignmentScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Assigned', 'Unassigned'];
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _assignedStudents = [
    {
      'name': 'Yuvaan Kumar',
      'email': 'student29@aprogra.com',
      'class': 'Nursery-B',
      'route': 'Route 1 - North Bangalore',
      'stop': 'MG Road',
      'time': '07:00',
      'busReg': 'KA-01-CD-5...',
      'paymentStatus': 'Not Paid',
    },
    {
      'name': 'Trisha Singh',
      'email': 'student28@aprogra.com',
      'class': 'Nursery-B',
      'route': 'Route 3 - East Bangalore',
      'stop': 'Whitefield',
      'time': '06:45',
      'busReg': 'KA-01-AB-12...',
      'paymentStatus': 'Not Paid',
    },
    {
      'name': 'Param Patel',
      'email': 'student27@aprogra.com',
      'class': 'Nursery-B',
      'route': 'Route 2 - South Bangalore',
      'stop': 'Koramangala',
      'time': '07:00',
      'busReg': 'KA-01-EF-90...',
      'paymentStatus': 'Not Paid',
    },
  ];

  final List<Map<String, dynamic>> _unassignedStudents = [
    {
      'name': 'Meera Reddy',
      'email': 'student30@aprogra.com',
      'class': 'Class 2-A',
    },
    {
      'name': 'Arjun Singh',
      'email': 'student31@aprogra.com',
      'class': 'Class 6-B',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildKPICards(),
              _buildTabs(),
              _buildSearchBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedTabIndex == 0) ...[
                      const Text(
                        'Assigned Students',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._assignedStudents.map((student) => _buildAssignedCard(student)),
                    ] else ...[
                      const Text(
                        'Pending Assignments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._unassignedStudents.map((student) => _buildUnassignedCard(student)),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => MainLayout.popSubScreen(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF1E1E2D), size: 20),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Student Assignments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showAssignmentModal(context, {}, false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C4CF1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.plus, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Assign',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
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

  Widget _buildKPICards() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  title: 'Total Students',
                  value: '18',
                  icon: LucideIcons.users,
                  color: const Color(0xFF6C4CF1),
                  bgColor: const Color(0xFFF3F0FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKPICard(
                  title: 'Assigned',
                  value: '15',
                  icon: LucideIcons.userCheck,
                  color: const Color(0xFF10B981),
                  bgColor: const Color(0xFFDCFCE7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  title: 'Unassigned',
                  value: '3',
                  icon: LucideIcons.userMinus,
                  color: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKPICard(
                  title: 'Vehicles',
                  value: '12',
                  icon: LucideIcons.bus,
                  color: const Color(0xFFEF4444),
                  bgColor: const Color(0xFFFEE2E2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF6C6C80),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 12),
              child: Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 20),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by student name or class...',
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E1E2D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedCard(Map<String, dynamic> student) {
    final bool isPaid = student['paymentStatus'] == 'Paid';
    
    return GestureDetector(
      onTap: () => _showStudentDetails(context, student, isPaid),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          student['name'][0],
                          style: const TextStyle(
                            color: Color(0xFF6C4CF1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            student['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              student['class'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPaid ? Icons.check_circle_outline : Icons.cancel_outlined, 
                          size: 12, 
                          color: isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444)
                        ),
                        const SizedBox(width: 4),
                        Text(
                          student['paymentStatus'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                        SizedBox(width: 4),
                        Text(
                          'Assigned',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF3EEFF), thickness: 1.5),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF6C4CF1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['route'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C6C80),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${student['stop']} • ${student['time']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFF3EEFF),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.bus, size: 16, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bus Reg No',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student['busReg'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
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
        ],
      ),
      ),
    );
  }

  Widget _buildUnassignedCard(Map<String, dynamic> student) {
    return GestureDetector(
      onTap: () => _showStudentDetails(context, student, false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF2F8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    student['name'][0],
                    style: const TextStyle(
                      color: Color(0xFFDB2777),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student['class'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _showAssignmentModal(BuildContext context, [Map<String, dynamic>? student, bool isEdit = false]) {
    String? selectedStudent = student?['name'];
    String? selectedRoute = student?['route'];
    String? selectedVehicle = student?['busReg'];
    String? selectedStop = student?['stop'];
    DateTime selectedDate = DateTime.now();

    final List<String> studentOptions = ['Aarav Patel', 'Diya Sharma', 'Vihaan Kumar', 'Sara Singh', 'Trisha Singh'];
    final List<String> routeOptions = ['Route 1 - Whitefield', 'Route 2 - HSR Layout', 'Route 3 - East Bangalore'];
    final List<String> vehicleOptions = ['KA-01-AB-1234', 'KA-02-CD-5678', 'KA-03-EF-9012'];
    final List<String> stopOptions = ['Stop A', 'Stop B', 'Whitefield'];

    if (selectedStudent != null && !studentOptions.contains(selectedStudent)) studentOptions.add(selectedStudent);
    if (selectedRoute != null && !routeOptions.contains(selectedRoute)) routeOptions.add(selectedRoute);
    if (selectedVehicle != null && !vehicleOptions.contains(selectedVehicle)) vehicleOptions.add(selectedVehicle);
    if (selectedStop != null && !stopOptions.contains(selectedStop)) stopOptions.add(selectedStop);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit ? 'Edit Assignment' : 'Assign Student to Route',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Select a student, route, and stop. A fee account is created automatically if the stop has a fee.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6C6C80),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(LucideIcons.x, size: 16, color: Color(0xFF6C6C80)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Student Field
                    const Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdownField(
                      hintText: 'Select student...',
                      value: selectedStudent,
                      items: studentOptions,
                      onChanged: (val) => setModalState(() => selectedStudent = val),
                    ),
                    const SizedBox(height: 16),
                    
                    // Route Field
                    const Text(
                      'Route',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdownField(
                      hintText: 'Select route...',
                      value: selectedRoute,
                      items: routeOptions,
                      onChanged: (val) => setModalState(() => selectedRoute = val),
                    ),
                    const SizedBox(height: 16),
                    
                    // Vehicle and Pickup Stop Fields
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vehicle',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildDropdownField(
                                hintText: 'Select...',
                                value: selectedVehicle,
                                items: vehicleOptions,
                                onChanged: (val) => setModalState(() => selectedVehicle = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pickup Stop',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildDropdownField(
                                hintText: 'Select...',
                                value: selectedStop,
                                items: stopOptions,
                                onChanged: (val) => setModalState(() => selectedStop = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Start Date Field
                    const Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                              style: const TextStyle(
                                color: Color(0xFF1E1E2D),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF1E1E2D)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                              ),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color(0xFF1E1E2D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedStudent != null && selectedRoute != null) {
                                if (isEdit && student != null) {
                                  // Find and update
                                  final index = _assignedStudents.indexWhere((s) => s['name'] == student['name']);
                                  if (index != -1) {
                                    setState(() {
                                      _assignedStudents[index] = {
                                        ..._assignedStudents[index],
                                        'name': selectedStudent,
                                        'route': selectedRoute,
                                        'busReg': selectedVehicle ?? 'N/A',
                                        'stop': selectedStop ?? 'N/A',
                                      };
                                    });
                                  }
                                } else {
                                  // Add new assignment
                                  setState(() {
                                    _assignedStudents.insert(0, {
                                      'name': selectedStudent,
                                      'class': 'Class-X',
                                      'email': 'student@example.com',
                                      'route': selectedRoute,
                                      'stop': selectedStop ?? 'N/A',
                                      'time': '08:00 AM',
                                      'busReg': selectedVehicle ?? 'N/A',
                                      'paymentStatus': 'Paid',
                                    });
                                  });
                                }
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(isEdit ? 'Assignment updated!' : 'Student assigned successfully!')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please select at least a student and route.')),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C4CF1), // Primary purple
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  isEdit ? 'Save Changes' : 'Assign Student',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showStudentDetails(BuildContext context, Map<String, dynamic> student, bool isPaid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                student['name'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E2D),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${student['class']} · ${student['email'] ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6C6C80),
                ),
              ),
              const SizedBox(height: 32),
              _buildDetailRow(LucideIcons.bus, 'Vehicle', student['busReg'] ?? '—'),
              _buildDetailRow(LucideIcons.mapPin, 'Route', student['route'] ?? '—'),
              _buildDetailRow(LucideIcons.mapPin, 'Stop', student['stop'] ?? '—'),
              _buildDetailRow(LucideIcons.calendar, 'Start Date', '24/08/2026'),
              _buildDetailRow(null, 'Monthly Fee', '—'),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close details modal
                  _showAssignmentModal(context, student, true); // Open Edit modal
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      'Edit Assignment',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData? icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: const Color(0xFF6C6C80)),
                  const SizedBox(width: 14),
                ] else ...[
                  const SizedBox(width: 34),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6C6C80),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    String? value,
    List<String>? items,
    Function(String?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hintText,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF4B5563)),
          items: items?.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  color: Color(0xFF1E1E2D),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList() ?? [],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
