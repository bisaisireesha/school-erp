import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';
import 'transport_compliance_details_screen.dart';

class TransportComplianceScreen extends StatefulWidget {
  const TransportComplianceScreen({super.key});

  @override
  State<TransportComplianceScreen> createState() => _TransportComplianceScreenState();
}

class _TransportComplianceScreenState extends State<TransportComplianceScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All', 'Needs Action', 'Compliant', 'Expired'];
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _actionRequiredItems = [
    {
      'title': 'BUS-01',
      'type': 'Vehicle',
      'subtitle': 'Fitness Certificate',
      'date': 'Expires 15 Aug 2026',
      'status': 'Expiring Soon',
    },
    {
      'title': 'BUS-03',
      'type': 'Vehicle',
      'subtitle': 'Vehicle Insurance',
      'date': 'Expires 10 Aug 2026',
      'status': 'Expired',
    },
    {
      'title': 'Rajesh Kumar',
      'type': 'Driver',
      'subtitle': 'Driving License',
      'date': 'Expires 20 Aug 2026',
      'status': 'Expiring Soon',
    },
  ];

  final List<Map<String, dynamic>> _complianceListItems = [
    {
      'title': 'BUS-01',
      'type': 'Vehicle',
      'subtitle': 'PUC Certificate',
      'date': 'Expires 10 Nov 2026',
      'status': 'Compliant',
    },
    {
      'title': 'BUS-02',
      'type': 'Vehicle',
      'subtitle': 'Speed Governor',
      'date': 'Expires 05 Dec 2026',
      'status': 'Compliant',
    },
    {
      'title': 'Ravi Verma',
      'type': 'Driver',
      'subtitle': 'Medical Certificate',
      'date': 'Expires 22 Jan 2027',
      'status': 'Compliant',
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
                    if (_selectedTabIndex == 0 || _selectedTabIndex == 1 || _selectedTabIndex == 3) ...[
                      const Text(
                        'Action Required',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._actionRequiredItems.map((item) => _buildActionCard(item)),
                      const SizedBox(height: 24),
                    ],
                    if (_selectedTabIndex == 0 || _selectedTabIndex == 2) ...[
                      const Text(
                        'Compliance List',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._complianceListItems.map((item) => _buildCompliantCard(item)),
                      const SizedBox(height: 40),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
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
                  title: 'Total Staff',
                  value: '2',
                  icon: LucideIcons.users,
                  color: const Color(0xFF6C4CF1),
                  bgColor: const Color(0xFFF3F0FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKPICard(
                  title: 'Fully Compliant',
                  value: '0',
                  icon: LucideIcons.shieldCheck,
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
                  title: 'Needs Action',
                  value: '2',
                  icon: LucideIcons.alertTriangle,
                  color: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKPICard(
                  title: 'Total Issues',
                  value: '4',
                  icon: LucideIcons.alertCircle,
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Row(
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
            'Compliance',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
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
                        fontSize: 11,
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
                  hintText: 'Search vehicle, driver or document...',
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

  Widget _buildActionCard(Map<String, dynamic> item) {
    final isExpired = item['status'] == 'Expired';
    final statusColor = isExpired ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const TransportComplianceDetailsScreen(),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['type'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['subtitle'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C6C80),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['date'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4CF1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Review',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompliantCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const TransportComplianceDetailsScreen(),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['type'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Compliant',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['subtitle'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C6C80),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFF6C4CF1)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6C6C80)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C6C80),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E2D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceDocRow(IconData icon, String title, String subtitle, String status, bool isValid) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isValid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              color: isValid ? const Color(0xFF16A34A) : const Color(0xFFD97706), 
              size: 20
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isValid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isValid ? const Color(0xFF86EFAC) : const Color(0xFFFCD34D),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  size: 12,
                  color: isValid ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isValid ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6C6C80)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C6C80),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
      ],
    );
  }


  void _showDocumentViewer(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['title']} - ${item['subtitle']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Scanned PDF Document',
                            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Color(0xFF9CA3AF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.fileText, size: 64, color: Color(0xFFD1D5DB)),
                          SizedBox(height: 16),
                          Text(
                            'Document Preview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateDocument(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  'Update ${item['subtitle']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload a new document for ${item['title']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C6C80),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Upload Zone
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.uploadCloud, color: Color(0xFF6C4CF1), size: 28),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tap to upload or drag and drop',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'PDF, JPG, PNG up to 10MB',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Expiry Date Field
                const Text(
                  'New Expiry Date',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.calendar, size: 18, color: Color(0xFF9CA3AF)),
                      SizedBox(width: 12),
                      Text(
                        'Select date',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document uploaded successfully')),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4CF1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit Document',
                        style: TextStyle(
                          color: Colors.white,
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
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6C6C80),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF1E1E2D),
            ),
          ),
        ],
      ),
    );
  }
}
