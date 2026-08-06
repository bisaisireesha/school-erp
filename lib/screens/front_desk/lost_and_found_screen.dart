import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LostAndFoundScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LostAndFoundScreen({super.key, this.onBack});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _items = [
    {
      'id': 'LF-101',
      'title': 'Titan Fastrack Smartwatch',
      'category': 'Electronics',
      'itemType': 'Found',
      'status': 'Found',
      'location': 'Junior Computer Lab 2 (Desk 4)',
      'storageLocation': 'Locker Shelf B-02',
      'date': 'Oct 25, 2023',
      'time': '02:30 PM',
      'reportedBy': 'Mr. Suresh Raina (Lab Assistant)',
      'reporterRole': 'Staff',
      'reporterContact': '+91 98112 34567',
      'claimedBy': '',
      'claimDate': '',
      'description': 'Black silicone strap with slight scratch on upper bezel edge. Screen locked with PIN.',
    },
    {
      'id': 'LF-102',
      'title': 'Navy Blue Winter Blazer (Size 34)',
      'category': 'Clothing & Uniform',
      'itemType': 'Found',
      'status': 'Claimed',
      'location': 'School Auditorium (Row F, Seat 12)',
      'storageLocation': 'Wardrobe Locker 05',
      'date': 'Oct 24, 2023',
      'time': '11:45 AM',
      'reportedBy': 'Aarav Gupta (Student Grade 9A)',
      'reporterRole': 'Student',
      'reporterContact': '+91 98765 00011',
      'claimedBy': 'Rohan Sharma (Grade 9A)',
      'claimDate': 'Oct 25, 2023',
      'description': 'School crest on pocket. Student name tag "Rohan S." stitched inside inner collar.',
    },
    {
      'id': 'LF-103',
      'title': 'Milton Stainless Steel Thermos Flask (750ml)',
      'category': 'Bottles & Tiffins',
      'itemType': 'Found',
      'status': 'Found',
      'location': 'Football Field Bleachers',
      'storageLocation': 'Box #04 Front Reception',
      'date': 'Oct 24, 2023',
      'time': '04:15 PM',
      'reportedBy': 'Coach Mahender (Sports Dept)',
      'reporterRole': 'Staff',
      'reporterContact': '+91 98450 99887',
      'claimedBy': '',
      'claimDate': '',
      'description': 'Silver steel finish with bright orange flip cap and superhero sticker on bottom base.',
    },
    {
      'id': 'LF-104',
      'title': 'Class 10 NCERT Mathematics Book & Geometry Kit',
      'category': 'Books & Stationery',
      'itemType': 'Lost',
      'status': 'Lost Reported',
      'location': 'Library Reading Hall 1',
      'storageLocation': 'N/A',
      'date': 'Oct 23, 2023',
      'time': '01:10 PM',
      'reportedBy': 'Sneha Kulkarni (Grade 10B)',
      'reporterRole': 'Student',
      'reporterContact': '+91 98221 44556',
      'claimedBy': '',
      'claimDate': '',
      'description': 'Covered in brown wrapper with Camlin transparent geometry compass box inside.',
    },
    {
      'id': 'LF-105',
      'title': 'Student ID Card & Bus Pass',
      'category': 'ID Card & Wallet',
      'itemType': 'Found',
      'status': 'Found',
      'location': 'Bus Route #14 (Seat 8)',
      'storageLocation': 'Reception ID Drawer',
      'date': 'Oct 23, 2023',
      'time': '08:15 AM',
      'reportedBy': 'Driver Balwant Singh',
      'reporterRole': 'Support Staff',
      'reporterContact': '+91 97110 33221',
      'claimedBy': '',
      'claimDate': '',
      'description': 'ID belongs to Ananya Deshpande, Admission No. ADM-2022-8874, Grade 7-C.',
    },
  ];

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: textColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return LucideIcons.laptop;
      case 'Clothing & Uniform':
        return LucideIcons.shirt;
      case 'Bottles & Tiffins':
        return LucideIcons.coffee;
      case 'Books & Stationery':
        return LucideIcons.bookOpen;
      case 'ID Card & Wallet':
        return LucideIcons.creditCard;
      case 'Sports & Bags':
        return LucideIcons.briefcase;
      default:
        return LucideIcons.package;
    }
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final status = item['status'] as String;
    final category = item['category'] as String;

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Found':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Claimed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Lost Reported':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'Disposed':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    final categoryIcon = _getCategoryIcon(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categoryIcon, color: const Color(0xFF6C4CF1), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(
                              item['category'],
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusTextColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  icon: const Icon(LucideIcons.moreVertical, size: 18, color: Color(0xFF8F90A6)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onSelected: (val) {
                    if (val == 'View Details') {
                      _showItemDetails(item);
                    } else if (val == 'Mark as Claimed') {
                      _showClaimDialog(item);
                    } else if (val == 'Delete') {
                      setState(() {
                        _items.remove(item);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item record deleted.')));
                    } else {
                      setState(() {
                        item['status'] = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item marked as $val.')));
                    }
                  },
                  itemBuilder: (context) => [
                    if (status != 'Claimed')
                      const PopupMenuItem(
                        value: 'Mark as Claimed',
                        child: Row(
                          children: [
                            Icon(LucideIcons.checkCircle2, size: 16, color: Color(0xFF10B981)),
                            SizedBox(width: 8),
                            Text('Mark as Claimed', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    const PopupMenuItem(value: 'Found', child: Text('Mark as Found (In Custody)')),
                    const PopupMenuItem(value: 'Lost Reported', child: Text('Mark as Lost Reported')),
                    const PopupMenuItem(value: 'Disposed', child: Text('Mark as Disposed')),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'View Details',
                      child: Row(
                        children: [
                          Icon(LucideIcons.eye, size: 16),
                          SizedBox(width: 8),
                          Text('View Details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: Row(
                        children: [
                          Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Location & Storage Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F1F5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 13, color: Color(0xFF6C4CF1)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['location'],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (item['storageLocation'] != 'N/A' && item['storageLocation'] != '') ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(LucideIcons.archive, size: 13, color: Color(0xFF8F90A6)),
                        const SizedBox(width: 6),
                        Text(
                          'Storage: ${item['storageLocation']}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Footer Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                const Icon(LucideIcons.user, size: 13, color: Color(0xFF8F90A6)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item['reportedBy'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(LucideIcons.calendar, size: 13, color: Color(0xFF8F90A6)),
                const SizedBox(width: 4),
                Text(
                  item['date'],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClaimDialog(Map<String, dynamic> item) {
    final claimantController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 22),
            SizedBox(width: 10),
            Text('Claim Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mark "${item['title']}" as claimed and returned.', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 16),
            TextField(
              controller: claimantController,
              decoration: InputDecoration(
                labelText: 'Claimant Full Name & Class *',
                hintText: 'e.g. Rohan Sharma (Grade 9-A)',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              if (claimantController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Claimant Name.')));
                return;
              }
              final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
              final now = DateTime.now();
              setState(() {
                item['status'] = 'Claimed';
                item['claimedBy'] = claimantController.text.trim();
                item['claimDate'] = '${monthNames[now.month - 1]} ${now.day}, ${now.year}';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item marked as claimed & returned!')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Confirm Claim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    final status = item['status'] as String;
    final category = item['category'] as String;

    Color statusBg, statusTextColor;
    switch (status) {
      case 'Found':
        statusBg = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFFF59E0B);
        break;
      case 'Claimed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF10B981);
        break;
      case 'Lost Reported':
        statusBg = const Color(0xFFEFF6FF);
        statusTextColor = const Color(0xFF3B82F6);
        break;
      case 'Disposed':
        statusBg = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusTextColor = const Color(0xFF64748B);
    }

    final categoryIcon = _getCategoryIcon(category);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(categoryIcon, color: const Color(0xFF6C4CF1), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['id'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(fontSize: 11, color: statusTextColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['category'],
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B)),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Body Details
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Title Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F1F5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Item Title',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['title'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDetailItem(LucideIcons.mapPin, 'Location Found / Lost', item['location']),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.archive, 'Storage Custody Location', item['storageLocation'] ?? 'Front Desk Custody'),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.calendar, 'Date & Time Reported', '${item['date']} at ${item['time']}'),
                    const SizedBox(height: 14),
                    _buildDetailItem(LucideIcons.user, 'Reported By', '${item['reportedBy']} (${item['reporterRole']})'),
                    if ((item['reporterContact'] as String?)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 14),
                      _buildDetailItem(LucideIcons.phone, 'Reporter Contact', item['reporterContact']),
                    ],
                    if (status == 'Claimed') ...[
                      const SizedBox(height: 14),
                      _buildDetailItem(LucideIcons.checkCircle2, 'Claimed By', '${item['claimedBy']} on ${item['claimDate']}'),
                    ],
                    if ((item['description'] as String?)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 14),
                      _buildDetailItem(LucideIcons.fileText, 'Distinct Features & Details', item['description']),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = _items.length;
    int foundCount = _items.where((e) => e['status'] == 'Found').length;
    int claimedCount = _items.where((e) => e['status'] == 'Claimed').length;
    int lostCount = _items.where((e) => e['status'] == 'Lost Reported').length;

    final displayedItems = _items.where((item) {
      final title = (item['title'] as String).toLowerCase();
      final category = (item['category'] as String).toLowerCase();
      final location = (item['location'] as String).toLowerCase();
      final reportedBy = (item['reportedBy'] as String).toLowerCase();
      final status = (item['status'] as String);
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty ||
          title.contains(query) ||
          category.contains(query) ||
          location.contains(query) ||
          reportedBy.contains(query);

      bool matchesStatus = _filterStatus == 'All' || status == _filterStatus;

      return matchesQuery && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    if (widget.onBack != null) ...[
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
                    ],
                    const Expanded(
                      child: Text('Lost & Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewItemModal,
                      icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                      label: const Text('Report Item', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // KPI Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Total Items', '$totalItems', LucideIcons.package, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('In Custody', '$foundCount', LucideIcons.packageCheck, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard('Claimed', '$claimedCount', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFD1FAE5))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard('Lost Reported', '$lostCount', LucideIcons.helpCircle, const Color(0xFF3B82F6), const Color(0xFFEFF6FF))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search items, categories, locations...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 18),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: ['All', 'Found', 'Claimed', 'Lost Reported', 'Disposed'].map((status) {
                    final isSelected = _filterStatus == status;
                    return GestureDetector(
                      onTap: () => setState(() => _filterStatus = status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // List of Items
              if (displayedItems.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F0FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.inbox, size: 48, color: Color(0xFF6C4CF1)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Items Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no lost or found records matching your filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8F90A6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: displayedItems.map((item) => _buildItemCard(item)).toList(),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewItemModal() async {
    final newItem = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewLostAndFoundBottomSheet(),
    );

    if (newItem != null) {
      setState(() {
        _items.insert(0, newItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item record saved successfully!')));
      }
    }
  }
}

class _NewLostAndFoundBottomSheet extends StatefulWidget {
  const _NewLostAndFoundBottomSheet();

  @override
  State<_NewLostAndFoundBottomSheet> createState() => _NewLostAndFoundBottomSheetState();
}

class _NewLostAndFoundBottomSheetState extends State<_NewLostAndFoundBottomSheet> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _storageController = TextEditingController();
  final _reportedByController = TextEditingController();
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Electronics';
  String _selectedType = 'Found';
  String _selectedReporterRole = 'Student';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _storageController.dispose();
    _reportedByController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4CF1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF6C4CF1)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold))] : [],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: const Color(0xFF8F90A6)) : null,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? prefixIcon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842)),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold))] : [],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18, color: const Color(0xFF8F90A6)),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF8F90A6), size: 18),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Item Title.')));
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Location Found / Lost.')));
      return;
    }
    if (_reportedByController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Reported By.')));
      return;
    }

    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final formattedDate = '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
    final nowTime = TimeOfDay.now().format(context);

    final newItem = {
      'id': 'LF-${_selectedDate.millisecondsSinceEpoch.toString().substring(8)}',
      'title': _titleController.text.trim(),
      'category': _selectedCategory,
      'itemType': _selectedType,
      'status': _selectedType == 'Found' ? 'Found' : 'Lost Reported',
      'location': _locationController.text.trim(),
      'storageLocation': _storageController.text.trim().isEmpty ? 'Front Desk Custody' : _storageController.text.trim(),
      'date': formattedDate,
      'time': nowTime,
      'reportedBy': _reportedByController.text.trim(),
      'reporterRole': _selectedReporterRole,
      'reporterContact': _contactController.text.trim(),
      'claimedBy': '',
      'claimDate': '',
      'description': _descriptionController.text.trim(),
    };

    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateDisplay = '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.packagePlus, color: Color(0xFF6C4CF1), size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Report Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                        SizedBox(height: 2),
                        Text('Record lost or found article details', style: TextStyle(fontSize: 12, color: Color(0xFF8F90A6))),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B), size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Scrollable Form
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Item Info
                  _buildSectionTitle('Item Information', LucideIcons.package),
                  const SizedBox(height: 16),

                  // Found or Lost Type selector
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedType = 'Found'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedType == 'Found' ? const Color(0xFFF59E0B).withOpacity(0.12) : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedType == 'Found' ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                                width: _selectedType == 'Found' ? 1.5 : 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.packageCheck, size: 16, color: Color(0xFFF59E0B)),
                                SizedBox(width: 8),
                                Text('Found Item (Custody)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedType = 'Lost'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedType == 'Lost' ? const Color(0xFF3B82F6).withOpacity(0.12) : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedType == 'Lost' ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                                width: _selectedType == 'Lost' ? 1.5 : 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.helpCircle, size: 16, color: Color(0xFF3B82F6)),
                                SizedBox(width: 8),
                                Text('Lost Item (Reported)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Item Title',
                    hint: 'e.g. Fastrack Watch, Navy Blue Blazer, Milton Bottle',
                    controller: _titleController,
                    isRequired: true,
                    prefixIcon: LucideIcons.tag,
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: 'Item Category',
                    value: _selectedCategory,
                    prefixIcon: LucideIcons.layoutGrid,
                    items: [
                      'Electronics',
                      'Clothing & Uniform',
                      'Bottles & Tiffins',
                      'Books & Stationery',
                      'ID Card & Wallet',
                      'Sports & Bags',
                      'Other'
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 2: Location & Storage
                  _buildSectionTitle('Location & Storage', LucideIcons.mapPin),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: _selectedType == 'Found' ? 'Location Found' : 'Last Seen Location',
                    hint: 'e.g. Junior Lab 2, Bus #14, Auditorium Row F',
                    controller: _locationController,
                    isRequired: true,
                    prefixIcon: LucideIcons.mapPin,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Storage / Locker Location',
                          hint: 'e.g. Shelf B-02, Locker 05',
                          controller: _storageController,
                          prefixIcon: LucideIcons.archive,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date Reported', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF323842))),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF6C4CF1)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dateDisplay,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                  const Divider(color: Color(0xFFF1F1F5), height: 1),
                  const SizedBox(height: 20),

                  // Section 3: Reporter & Remarks
                  _buildSectionTitle('Reporter & Description', LucideIcons.user),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildInputField(
                          label: 'Reported By (Full Name)',
                          hint: 'e.g. Suresh Raina, Aarav Gupta',
                          controller: _reportedByController,
                          isRequired: true,
                          prefixIcon: LucideIcons.user,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: _buildDropdownField(
                          label: 'Role',
                          value: _selectedReporterRole,
                          items: ['Student', 'Staff', 'Support Staff', 'Parent', 'Security', 'Other'],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedReporterRole = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Reporter Contact Number (Optional)',
                    hint: '+91 98765 43210',
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: LucideIcons.phone,
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    label: 'Distinct Physical Features / Notes',
                    hint: 'e.g. Black silicone strap, initial engraved, specific sticker on the side',
                    controller: _descriptionController,
                    maxLines: 2,
                    prefixIcon: LucideIcons.fileText,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Action Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F1F5))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(LucideIcons.check, size: 18, color: Colors.white),
                    label: const Text('Save Item Record', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
