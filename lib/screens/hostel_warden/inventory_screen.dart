import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main_layout.dart';

class InventoryScreen extends StatefulWidget {
  final VoidCallback onBack;
  const InventoryScreen({super.key, required this.onBack});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'In Stock', 'Low Stock', 'Out of Stock', 'Grains', 'Groceries', 'Vegetables', 'Fuel'];

  List<Map<String, dynamic>> _inventoryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    MainLayout.globalSearchQuery.addListener(_onGlobalSearchChanged);
    _searchQuery = MainLayout.globalSearchQuery.value;
    _searchController.text = _searchQuery;
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/inventory.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _inventoryItems = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
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
      case 'leaf': return LucideIcons.leaf;
      case 'wheat': return LucideIcons.wheat;
      case 'droplets': return LucideIcons.droplets;
      case 'flame': return LucideIcons.flame;
      default: return LucideIcons.box;
    }
  }

  void _onGlobalSearchChanged() {
    if (mounted) {
      setState(() {
        _searchQuery = MainLayout.globalSearchQuery.value;
        _searchController.text = _searchQuery;
      });
    }
  }

  @override
  void dispose() {
    MainLayout.globalSearchQuery.removeListener(_onGlobalSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.transparent,
        child: const Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }

    final filteredItems = _inventoryItems.where((item) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          item['title'].toString().toLowerCase().contains(query) ||
          item['category'].toString().toLowerCase().contains(query) ||
          item['vendor'].toString().toLowerCase().contains(query) ||
          item['status'].toString().toLowerCase().contains(query);
      if (!matchesQuery) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'In Stock' || _selectedFilter == 'Low Stock' || _selectedFilter == 'Out of Stock') {
        return item['status'].toString().toLowerCase() == _selectedFilter.toLowerCase();
      }
      return item['category'].toString().toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildKPIs(),
              const SizedBox(height: 20),
              _buildSearchAndFilter(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    if (filteredItems.isEmpty)
                      _buildEmptyState()
                    else
                      ...filteredItems.map((item) => _buildInventoryItem(item)),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.packageSearch, color: Color(0xFF64748B), size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'No inventory items found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try adjusting your search query or filter criteria.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
                _selectedFilter = 'All';
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF6C4CF1)),
            label: const Text('Reset Filters', style: TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Inventory', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      Text('Manage stock and supplies', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddItemBottomSheet(context),
                icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                label: const Text('Add Item', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: textColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    final totalCount = _inventoryItems.length;
    final inStockCount = _inventoryItems.where((i) => i['status'] == 'In Stock').length;
    final lowStockCount = _inventoryItems.where((i) => i['status'] == 'Low Stock').length;
    final outOfStockCount = _inventoryItems.where((i) => i['status'] == 'Out of Stock').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildKpiCard('Total Items', '$totalCount', LucideIcons.boxes, const Color(0xFF6C4CF1), const Color(0xFFF3F0FF))),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard('In Stock', '$inStockCount', LucideIcons.package, const Color(0xFF10B981), const Color(0xFFDCFCE7))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildKpiCard('Low Stock', '$lowStockCount', LucideIcons.alertTriangle, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
              const SizedBox(width: 12),
              Expanded(child: _buildKpiCard('Out of Stock', '$outOfStockCount', LucideIcons.xCircle, const Color(0xFFEF4444), const Color(0xFFFEE2E2))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search items, categories, vendors...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showFilterBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedFilter != 'All' ? const Color(0xFF6C4CF1) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selectedFilter != 'All' ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    LucideIcons.slidersHorizontal,
                    color: _selectedFilter != 'All' ? Colors.white : const Color(0xFF6C4CF1),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : 'All';
                      });
                    },
                    selectedColor: const Color(0xFF6C4CF1),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
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
                  const Text('Filter Inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Filter by Status & Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        _selectedFilter = selected ? filter : 'All';
                      });
                      setState(() {
                        _selectedFilter = selected ? filter : 'All';
                      });
                    },
                    selectedColor: const Color(0xFF6C4CF1),
                    backgroundColor: const Color(0xFFF8FAFC),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'All';
                        });
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Reset', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        _showViewDetailsBottomSheet(context, item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _getColor(item['iconBg']), borderRadius: BorderRadius.circular(12)),
                child: Icon(_getIcon(item['iconStr']), color: _getColor(item['iconColor']), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(item['category'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _getColor(item['statusBg']), borderRadius: BorderRadius.circular(12)),
                child: Text(item['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _getColor(item['statusColor']))),
              ),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical, color: Color(0xFF64748B), size: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                elevation: 4,
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'view') {
                    _showViewDetailsBottomSheet(context, item);
                  } else if (value == 'restock') {
                    _showRestockBottomSheet(context, item);
                  } else if (value == 'edit') {
                    _showAddItemBottomSheet(context, item: item);
                  } else if (value == 'remove') {
                    setState(() {
                      _inventoryItems.removeWhere((i) => i['id'] == item['id']);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['title']} removed from inventory')));
                  }
                },
                itemBuilder: (context) => [
                  _buildPopupItem('view', LucideIcons.eye, 'View Details'),
                  _buildPopupItem('restock', LucideIcons.refreshCw, 'Restock'),
                  _buildPopupItem('edit', LucideIcons.edit2, 'Edit Item'),
                  _buildPopupItem('remove', LucideIcons.trash2, 'Remove Item', isDestructive: true),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Stock', '${item['stock']} ${item['unit']}'),
              _buildDetailItem('Min Level', '${item['minLevel']} ${item['unit']}'),
              _buildDetailItem('Vendor', item['vendor'] as String),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value, IconData icon, String text, {bool isDestructive = false}) {
    final color = isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1E1E2D);
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }

  void _showAddItemBottomSheet(BuildContext context, {Map<String, dynamic>? item}) {
    final isEditing = item != null;
    String selectedCategory = isEditing ? item['category'] as String : 'Vegetables';
    
    final nameController = TextEditingController(text: isEditing ? item['title'] : '');
    final unitController = TextEditingController(text: isEditing ? item['unit'] : '');
    final stockController = TextEditingController(text: isEditing ? item['stock'].toString() : '');
    final minLevelController = TextEditingController(text: isEditing ? item['minLevel'].toString() : '');
    final vendorController = TextEditingController(text: isEditing ? item['vendor'] : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isEditing ? 'Edit Inventory Item' : 'Add Inventory Item', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(LucideIcons.x, color: Color(0xFF64748B), size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildDialogLabel('Item Name'),
                      _buildDialogTextField('E.g., Tomato', controller: nameController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDialogLabel('Category'),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedCategory,
                                      isExpanded: true,
                                      icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF64748B), size: 18),
                                      items: ['Vegetables', 'Grains', 'Groceries', 'Dairy', 'Fuel'].map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option, style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 14)),
                                        );
                                      }).toList(),
                                      onChanged: (val) => setSheetState(() => selectedCategory = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDialogLabel('Unit'),
                                _buildDialogTextField('E.g., kg, litre', controller: unitController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDialogLabel('Initial Stock'),
                                _buildDialogTextField('0', controller: stockController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDialogLabel('Minimum Level'),
                                _buildDialogTextField('10', controller: minLevelController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDialogLabel('Vendor'),
                      _buildDialogTextField('Vendor name', controller: vendorController),
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Cancel', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              final newItem = {
                                'id': isEditing ? item['id'] : DateTime.now().millisecondsSinceEpoch.toString(),
                                'icon': 'box',
                                'iconBg': '0xFFE0E7FF',
                                'iconColor': '0xFF4F46E5',
                                'title': nameController.text.isNotEmpty ? nameController.text : 'New Item',
                                'category': selectedCategory,
                                'unit': unitController.text.isNotEmpty ? unitController.text : 'kg',
                                'stock': stockController.text.isNotEmpty ? stockController.text : '0',
                                'minLevel': minLevelController.text.isNotEmpty ? minLevelController.text : '10',
                                'vendor': vendorController.text.isNotEmpty ? vendorController.text : 'New Vendor',
                                'status': 'In Stock',
                                'statusColor': '0xFF16A34A',
                                'statusBg': '0xFFDCFCE7',
                              };
                              setState(() {
                                if (isEditing) {
                                  final index = _inventoryItems.indexWhere((i) => i['id'] == item['id']);
                                  if (index != -1) _inventoryItems[index] = newItem;
                                } else {
                                  _inventoryItems.insert(0, newItem);
                                }
                              });
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              Navigator.pop(context);
                              scaffoldMessenger.showSnackBar(SnackBar(content: Text(isEditing ? 'Item updated successfully!' : 'Item added successfully!')));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              elevation: 0,
                            ),
                            child: Text(isEditing ? 'Save Changes' : 'Add Item', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showViewDetailsBottomSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item['title']} Details', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, color: Color(0xFF64748B), size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: _getColor(item['iconBg']), borderRadius: BorderRadius.circular(12)),
                    child: Icon(_getIcon(item['iconStr']), color: _getColor(item['iconColor']), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        const SizedBox(height: 4),
                        Text(item['category'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(item['status'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _getColor(item['statusColor']))),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Color(0xFFF1F5F9), height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem('Current Stock', '${item['stock']} ${item['unit']}'),
                  _buildDetailItem('Minimum Level', '${item['minLevel']} ${item['unit']}'),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailItem('Primary Vendor', item['vendor'] as String),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showRestockBottomSheet(BuildContext context, Map<String, dynamic> item) {
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
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Restock Item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, color: Color(0xFF64748B), size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Add new stock for ${item['title']}', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              const SizedBox(height: 24),
              _buildDialogLabel('Quantity to Add (${item['unit']})'),
              _buildDialogTextField('Enter quantity'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    Navigator.pop(context);
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${item['title']} restocked successfully!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text('Update Stock', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
    );
  }

  Widget _buildDialogTextField(String hint, {TextEditingController? controller}) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
        ),
      ),
    );
  }
}
