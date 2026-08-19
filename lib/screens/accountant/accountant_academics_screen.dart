import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'accountant_quick_collection_screen.dart';

class AccountantAcademicsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantAcademicsScreen({super.key, required this.onBack});

  @override
  State<AccountantAcademicsScreen> createState() => _AccountantAcademicsScreenState();
}

class _AccountantAcademicsScreenState extends State<AccountantAcademicsScreen> {
  String _searchQuery = '';

  int _selectedFilter = 0; // 0: All, 1: Pre-Primary, 2: Primary, 3: Secondary

  final List<Map<String, dynamic>> _classes = [
    {
      'class': 'Nursery',
      'section': 'Morning Batch',
      'students': 45,
      'feeHead': 'Tuition + Activity',
      'annualFee': '₹25,000',
      'collected': '₹10.5L',
      'pending': '₹0.75L',
      'status': 'Active',
      'category': 'Pre-Primary',
    },
    {
      'class': 'LKG',
      'section': 'Section A',
      'students': 30,
      'feeHead': 'Tuition + Activity',
      'annualFee': '₹28,000',
      'collected': '₹7.5L',
      'pending': '₹0.9L',
      'status': 'Active',
      'category': 'Pre-Primary',
    },
    {
      'class': 'UKG',
      'section': 'Section B',
      'students': 35,
      'feeHead': 'Tuition + Activity',
      'annualFee': '₹28,000',
      'collected': '₹8.5L',
      'pending': '₹1.1L',
      'status': 'Active',
      'category': 'Pre-Primary',
    },
    {
      'class': 'Class 1',
      'section': 'Section A & B',
      'students': 85,
      'feeHead': 'Tuition + Transport',
      'annualFee': '₹35,000',
      'collected': '₹25.0L',
      'pending': '₹4.75L',
      'status': 'Active',
      'category': 'Primary',
    },
    {
      'class': 'Class 5',
      'section': 'All Sections',
      'students': 150,
      'feeHead': 'Tuition + Lab',
      'annualFee': '₹38,000',
      'collected': '₹45.0L',
      'pending': '₹7.5L',
      'status': 'Active',
      'category': 'Primary',
    },
    {
      'class': 'Class 8',
      'section': 'All Sections',
      'students': 150,
      'feeHead': 'Tuition',
      'annualFee': '₹35,000',
      'collected': '₹45.0L',
      'pending': '₹7.5L',
      'status': 'Active',
      'category': 'Secondary',
    },
    {
      'class': 'Class 10',
      'section': 'Section A & B',
      'students': 85,
      'feeHead': 'Tuition + Lab',
      'annualFee': '₹45,000',
      'collected': '₹28.5L',
      'pending': '₹9.75L',
      'status': 'Active',
      'category': 'Secondary',
    },
    {
      'class': 'Class 12',
      'section': 'Commerce Stream',
      'students': 60,
      'feeHead': 'Tuition',
      'annualFee': '₹40,000',
      'collected': '₹20.0L',
      'pending': '₹4.0L',
      'status': 'Active',
      'category': 'Secondary',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _classes.where((c) {
      if (_selectedFilter == 1 && c['category'] != 'Pre-Primary') return false;
      if (_selectedFilter == 2 && c['category'] != 'Primary') return false;
      if (_selectedFilter == 3 && c['category'] != 'Secondary') return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final cClass = (c['class'] as String?) ?? '';
      final feeHead = (c['feeHead'] as String?) ?? '';
      return cClass.toLowerCase().contains(q) ||
             feeHead.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildKPIs(),
                    const SizedBox(height: 24),
                    _buildFilters(),
                    _buildSearchBar(),
                    if (filteredClasses.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: _buildEmptyState(),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 900) {
                              return Wrap(
                                spacing: 16,
                                children: filteredClasses.map((c) => SizedBox(
                                  width: (constraints.maxWidth - 16) / 2,
                                  child: _buildClassCard(c),
                                )).toList(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: filteredClasses.length,
                              itemBuilder: (context, index) {
                                return _buildClassCard(filteredClasses[index]);
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Academic Fee Collection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountantQuickCollectionScreen(
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            icon: const Icon(LucideIcons.zap, size: 16, color: Colors.white),
            label: const Text('Quick Collection', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CF1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKPICard('Collected', '₹36,64,000', LucideIcons.indianRupee, const Color(0xFF16A34A), const Color(0xFFF0FDF4))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Pending', '₹9,30,000', LucideIcons.alertTriangle, const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildKPICard('Fee Groups', '9', LucideIcons.building, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
              const SizedBox(width: 16),
              Expanded(child: _buildKPICard('Collection Rate', '80%', LucideIcons.trendingUp, const Color(0xFF16A34A), const Color(0xFFF0FDF4))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterButton(0, 'All', LucideIcons.layoutGrid),
          _buildFilterButton(1, 'Pre-Primary', LucideIcons.baby),
          _buildFilterButton(2, 'Primary', LucideIcons.backpack),
          _buildFilterButton(3, 'Secondary', LucideIcons.graduationCap),
        ],
      ),
    );
  }

  Widget _buildFilterButton(int index, String title, IconData icon) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
          boxShadow: isSelected ? [
            BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: TextField(
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search classes or fee heads...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            prefixIcon: Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classInfo) {
    Color primaryColor;
    Color bgColor;
    IconData icon;
    
    if (classInfo['category'] == 'Pre-Primary') {
      primaryColor = const Color(0xFF0EA5E9); // Light Blue
      bgColor = const Color(0xFFE0F2FE);
      icon = LucideIcons.baby;
    } else if (classInfo['category'] == 'Primary') {
      primaryColor = const Color(0xFFF59E0B); // Amber
      bgColor = const Color(0xFFFEF3C7);
      icon = LucideIcons.backpack;
    } else {
      primaryColor = const Color(0xFF8B5CF6); // Purple
      bgColor = const Color(0xFFF3E8FF);
      icon = LucideIcons.graduationCap;
    }

    return GestureDetector(
      onTap: () => _showClassDetailsBottomSheet(classInfo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(icon, color: primaryColor, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classInfo['class'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${classInfo['category']} • ${classInfo['section']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Healthy',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('PERIOD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
              const Text('Academic Year 2026-27', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Collected', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              Text(classInfo['collected'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              Text(classInfo['pending'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                height: 6,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('79% collected', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              Text('${classInfo['annualFee']} total', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGridItem('Students', classInfo['students'].toString())),
              const SizedBox(width: 12),
              Expanded(child: _buildGridItem('Receipts', '42')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGridItem('Due today', '6')),
              const SizedBox(width: 12),
              Expanded(child: _buildGridItem('Last sync', '10:25 AM')),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTag('Tuition'),
                      const SizedBox(width: 8),
                      _buildTag('Activity'),
                      const SizedBox(width: 8),
                      if (classInfo['category'] == 'Secondary') _buildTag('Lab') else _buildTag('Books'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Text('View details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0EA5E9)),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
            ),
            child: const Icon(LucideIcons.searchX, size: 48, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Classes Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search query.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _mockStudents = [
    {'name': 'Saanvi Khan', 'id': 'ADM-260592 • NURSE-01', 'class': 'Nursery-A', 'progress': 1.0, 'progressText': '100%', 'paid': '₹3,750', 'pending': '₹0', 'status': 'Paid'},
    {'name': 'Samaira Nair', 'id': 'ADM-260629 • NURSE-02', 'class': 'Nursery-B', 'progress': 0.92, 'progressText': '92%', 'paid': '₹3,650', 'pending': '₹300', 'status': 'Partial'},
    {'name': 'Vihaan Shah', 'id': 'ADM-260666 • NURSE-03', 'class': 'Nursery-C', 'progress': 0.64, 'progressText': '64%', 'paid': '₹2,700', 'pending': '₹1,500', 'status': 'Partial'},
    {'name': 'Zoya Varma', 'id': 'ADM-260703 • NURSE-04', 'class': 'Nursery-D', 'progress': 0.81, 'progressText': '81%', 'paid': '₹3,600', 'pending': '₹850', 'status': 'Partial'},
    {'name': 'Aarav Patel', 'id': 'ADM-260711 • NURSE-05', 'class': 'Nursery-A', 'progress': 1.0, 'progressText': '100%', 'paid': '₹3,750', 'pending': '₹0', 'status': 'Paid'},
    {'name': 'Isha Singh', 'id': 'ADM-260722 • NURSE-06', 'class': 'Nursery-B', 'progress': 0.50, 'progressText': '50%', 'paid': '₹1,875', 'pending': '₹1,875', 'status': 'Partial'},
    {'name': 'Rohan Das', 'id': 'ADM-260733 • NURSE-07', 'class': 'Nursery-C', 'progress': 0.0, 'progressText': '0%', 'paid': '₹0', 'pending': '₹3,750', 'status': 'Pending'},
    {'name': 'Ananya Gupta', 'id': 'ADM-260744 • NURSE-08', 'class': 'Nursery-D', 'progress': 1.0, 'progressText': '100%', 'paid': '₹3,750', 'pending': '₹0', 'status': 'Paid'},
    {'name': 'Kabir Sharma', 'id': 'ADM-260755 • NURSE-09', 'class': 'Nursery-A', 'progress': 0.75, 'progressText': '75%', 'paid': '₹2,812', 'pending': '₹938', 'status': 'Partial'},
    {'name': 'Neha Reddy', 'id': 'ADM-260766 • NURSE-10', 'class': 'Nursery-B', 'progress': 1.0, 'progressText': '100%', 'paid': '₹3,750', 'pending': '₹0', 'status': 'Paid'},
  ];

  void _showClassDetailsBottomSheet(Map<String, dynamic> classInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: const Color(0xFF6C4CF1), borderRadius: BorderRadius.circular(14)),
                        child: const Center(child: Icon(LucideIcons.user, color: Colors.white, size: 24)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                Text('${classInfo['class']} Fee Roster', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                                Text('${classInfo['students']} STUDENTS', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Healthy', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${classInfo['category']} • ${classInfo['section']} • Academic Year 2026-27 • Click a student to open payment analytics',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, color: Color(0xFF94A3B8)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildRosterStatCard('TOTAL EXPECTED', classInfo['annualFee'], const Color(0xFF6C4CF1))),
                          const SizedBox(width: 16),
                          Expanded(child: _buildRosterStatCard('PAID', classInfo['collected'], const Color(0xFF16A34A))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildRosterStatCard('PENDING', classInfo['pending'], const Color(0xFFEF4444))),
                          const SizedBox(width: 16),
                          Expanded(child: _buildRosterStatCard('AVG PROGRESS', '80%', const Color(0xFF0EA5E9))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // List Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Student Payment List', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(6)),
                              child: const Text('All students', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      // List items
                      ..._mockStudents.map((s) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildStudentRosterRow(s),
                      )),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            
              // Bottom Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${classInfo['class'].toString().toUpperCase()} • ACADEMIC YEAR 2026-27', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.0)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _showExportDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2D),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('EXPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildRosterStatCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: valueColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: valueColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: valueColor.withValues(alpha: 0.8), letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildStudentRosterRow(Map<String, dynamic> s) {
    final bool isPaid = s['status'] == 'Paid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Circular Avatar with Progress Ring
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: s['progress'],
                  strokeWidth: 3,
                  backgroundColor: const Color(0xFFF1F5F9),
                  color: isPaid ? const Color(0xFF16A34A) : const Color(0xFF6C4CF1),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(s['name'].substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Middle: Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(s['id'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(4)),
                      child: Text(s['class'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Right: Financial Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(s['paid'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
              const SizedBox(height: 4),
              if (!isPaid)
                Text('Due: ${s['pending']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
              if (isPaid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Fully Paid', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Export Fee Roster', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Select the format you want to export the roster as.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 24),
              _buildExportOption(context, LucideIcons.table, 'Excel (.xlsx)', 'Detailed spreadsheet with all columns', const Color(0xFF16A34A)),
              const SizedBox(height: 12),
              _buildExportOption(context, LucideIcons.fileText, 'PDF Document (.pdf)', 'Print-ready formatted document', const Color(0xFFEF4444)),
              const SizedBox(height: 12),
              _buildExportOption(context, LucideIcons.fileJson, 'CSV File (.csv)', 'Raw comma-separated values', const Color(0xFF0EA5E9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return InkWell(
      onTap: () {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context); // Close dialog
        Navigator.pop(context); // Close bottom sheet
        messenger.showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('$title exported successfully!', style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(24),
          duration: const Duration(seconds: 3),
        ));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Color(0xFF94A3B8), size: 16),
          ],
        ),
      ),
    );
  }
}
