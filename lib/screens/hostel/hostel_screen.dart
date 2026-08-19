import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HostelScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HostelScreen({super.key, required this.onBack});

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  int _selectedSegment = 0;
  String _wardenInitials = 'HW';

  Map<String, dynamic> _mockHostelData = {
    'hostelName': '',
    'block': '',
    'room': '',
    'bed': '',
    'wardenName': '',
    'wardenContact': '',
  };

  List<Map<String, dynamic>> _mockOutings = [];
  List<Map<String, dynamic>> _menuItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHostelData();
  }

  Future<void> _loadHostelData() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/hostel_student_dashboard.json');
      final data = await json.decode(response);
      
      final String authResponse = await rootBundle.loadString('assets/mock/auth.json', cache: false);
      final authData = json.decode(authResponse);
      final users = authData['users'] as List;
      final warden = users.firstWhere((u) => u['role'] == 'warden', orElse: () => null);

      if (mounted) {
        setState(() {
          _mockHostelData = Map<String, dynamic>.from(data['hostelData']);
          _mockOutings = List<Map<String, dynamic>>.from(data['outings']);
          _menuItems = List<Map<String, dynamic>>.from(data['messMenu']);
          
          if (warden != null) {
            _mockHostelData['wardenName'] = warden['name'];
            _mockHostelData['wardenContact'] = warden['email'];
            
            final names = (warden['name'] as String).split(' ');
            if (names.length > 1) {
              _wardenInitials = '${names[0][0]}${names[1][0]}'.toUpperCase();
            } else {
              _wardenInitials = names[0].substring(0, 2).toUpperCase();
            }
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading hostel data: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr));
  }
  
  IconData _getIcon(String iconStr) {
    switch (iconStr) {
      case 'coffee': return LucideIcons.coffee;
      case 'utensils': return LucideIcons.utensils;
      case 'cookie': return LucideIcons.cookie;
      case 'utensils_crossed': return LucideIcons.utensilsCrossed;
      default: return LucideIcons.utensils;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Hostel & Accommodation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile/Allocation Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildAllocationCard(),
            ),
            const SizedBox(height: 32),

            // Segmented Control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildSegmentButton('Overview', 0)),
                    Expanded(child: _buildSegmentButton('Outings', 1)),
                    Expanded(child: _buildSegmentButton('Mess Menu', 2)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Content Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
              child: _buildDynamicContent(),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildAllocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C4CF1), Color(0xFF8B6BF3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C4CF1).withValues(alpha: 0.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
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
                    const Text('Allocated Room', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text('${_mockHostelData['block']} - ${_mockHostelData['room']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.bedDouble, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildAllocationDetail(LucideIcons.building, 'Hostel', _mockHostelData['hostelName']),
              ),
              Expanded(
                child: _buildAllocationDetail(LucideIcons.bedSingle, 'Bed', _mockHostelData['bed']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicContent() {
    switch (_selectedSegment) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return _buildOutingsContent();
      case 2:
        return _buildMessMenu();
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Warden Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(_wardenInitials, style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_mockHostelData['wardenName'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 4),
                    Text(_mockHostelData['wardenContact'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling Warden ${_mockHostelData['wardenName']}...')));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF8F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.phone, color: Color(0xFF22C55E), size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening email for ${_mockHostelData['wardenContact']}...')));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.mail, color: Color(0xFF0284C7), size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Hostel Rules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 16),
        _buildRuleItem(LucideIcons.clock, 'In-time is strictly 8:30 PM.'),
        _buildRuleItem(LucideIcons.volumeX, 'Silence hours from 10:30 PM to 6:00 AM.'),
        _buildRuleItem(LucideIcons.users, 'Visitors allowed only on Sundays (10 AM - 5 PM).'),
      ],
    );
  }

  Widget _buildRuleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C4CF1)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D), height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildOutingsContent() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isStudent = authProvider.currentUser?.role == 'student';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request New Outing Button (Only visible for Parents / Non-students)
        if (!isStudent)
          GestureDetector(
            onTap: () => _showNewOutingModal(),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C4CF1), Color(0xFF8B6BF3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.plus, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Request New Outing',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        if (_mockOutings.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text('No outings found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          )
        else
          ..._mockOutings.map((outing) {
            final isApproved = outing['status'] == 'Approved';
            final isCompleted = outing['status'] == 'Completed';
            final statusColor = isApproved ? const Color(0xFF16A34A) : (isCompleted ? const Color(0xFF6C6C80) : const Color(0xFFE11D48));
            final statusBg = isApproved ? const Color(0xFFF0FDF4) : (isCompleted ? const Color(0xFFF3F4F6) : const Color(0xFFFFF1F2));

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(outing['date'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(outing['status'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: statusColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(outing['reason'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 14, color: Color(0xFF6C6C80)),
                      const SizedBox(width: 6),
                      Text('Duration: ${outing['duration']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80))),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSegmentButton(String title, int index) {
    final isSelected = _selectedSegment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSegment = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF6C6C80),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessMenu() {
    if (_menuItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text('No menu found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Daily Meal Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                SizedBox(height: 2),
                Text("Nutritious & hygienic meals", style: TextStyle(fontSize: 12, color: Color(0xFF6C6C80), fontWeight: FontWeight.w500)),
              ],
            ),
            InkWell(
              onTap: () => _showPrintMenuModal(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E7FF)),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.printer, size: 16, color: Color(0xFF6C4CF1)),
                    SizedBox(width: 6),
                    Text('Print Menu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._menuItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMenuCard(item['meal'], item['menu'], _getIcon(item['iconStr']), _getColor(item['bgColor']), _getColor(item['iconColor'])),
        )),
      ],
    );
  }

  Widget _buildPreviewMealSummary(String meal, String items) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
            const SizedBox(height: 2),
            Text(items, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  void _showPrintMenuModal() {
    int copies = 1;
    String selectedPrinter = 'HP LaserJet Pro MFP (Office)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.printer, color: Color(0xFF6C4CF1), size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Print Mess Menu',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            Text(
                              'Hostel Dining Schedule',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.utensils, size: 16, color: Color(0xFF6C4CF1)),
                              SizedBox(width: 8),
                              Text(
                                'SPRINGFIELD HOSTEL MESS',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF6C4CF1), letterSpacing: 0.8),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('ACTIVE SCHEDULE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Daily Mess Dining Menu',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Academic Year 2024-25 • 4 Meals Daily • Timings: 7:30 AM - 9:00 PM',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFE2E8F0), height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildPreviewMealSummary('Breakfast', 'Poha, Jalebi, Tea/Coffee'),
                          const SizedBox(width: 8),
                          _buildPreviewMealSummary('Lunch', 'Rice, Dal Makhani, Paneer'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildPreviewMealSummary('Snacks', 'Samosa, Tea/Coffee'),
                          const SizedBox(width: 8),
                          _buildPreviewMealSummary('Dinner', 'Fried Rice, Manchurian'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Printer Settings', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.printer, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 10),
                          Text(selectedPrinter, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Copies', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (copies > 1) {
                                      setModalState(() => copies--);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: const Icon(Icons.remove, size: 14, color: Color(0xFF1E1E2D)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('$copies', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => setModalState(() => copies++),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: const Icon(Icons.add, size: 14, color: Color(0xFF1E1E2D)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Paper', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                            Text('A4 • 1 Page', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9), height: 1),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(LucideIcons.fileText, size: 16, color: Color(0xFF64748B)),
                        label: const Text('Save PDF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        onPressed: () {
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Mess Menu PDF exported successfully to Downloads!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(LucideIcons.printer, size: 16, color: Colors.white),
                        label: const Text('Print Now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                        onPressed: () {
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text('Print job for $copies cop${copies > 1 ? "ies" : "y"} sent to $selectedPrinter successfully! 🖨️')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String meal, String menu, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 6),
                Text(menu, style: const TextStyle(fontSize: 14, color: Color(0xFF6C6C80), height: 1.4, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewOutingModal() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String fromDate = 'Select Date';
        String toDate = 'Select Date';

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Request Outing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('Submit an outing permission request.', style: TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                    const SizedBox(height: 20),
                    const Text('Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Medical Checkup',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Reason', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g., Need to visit the dentist for scheduled checkup',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('From Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setModalState(() => fromDate = "${date.day}/${date.month}/${date.year}");
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(fromDate, style: TextStyle(color: fromDate == 'Select Date' ? const Color(0xFF94A3B8) : const Color(0xFF1E1E2D), fontWeight: FontWeight.w600, fontSize: 13)),
                                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C4CF1)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('To Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setModalState(() => toDate = "${date.day}/${date.month}/${date.year}");
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(toDate, style: TextStyle(color: toDate == 'Select Date' ? const Color(0xFF94A3B8) : const Color(0xFF1E1E2D), fontWeight: FontWeight.w600, fontSize: 13)),
                                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C4CF1)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final titleText = titleController.text;
                              final reasonText = reasonController.text;
                              Navigator.pop(context);
                              if (mounted) {
                                setState(() {
                                  _selectedSegment = 1;
                                  _mockOutings.insert(0, {
                                    'date': 'Today',
                                    'reason': titleText.isNotEmpty ? titleText : (reasonText.isNotEmpty ? reasonText : 'New Outing Request'),
                                    'duration': (fromDate != 'Select Date' && toDate != 'Select Date') ? '$fromDate - $toDate' : 'Dates Pending',
                                    'status': 'Pending',
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Outing Request Submitted & Saved Successfully')));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Submit Request', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
