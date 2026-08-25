import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'driver_details_screen.dart';
import '../main_layout.dart';

class TransportDriversScreen extends StatefulWidget {
  const TransportDriversScreen({super.key});

  @override
  State<TransportDriversScreen> createState() => _TransportDriversScreenState();
}

class _TransportDriversScreenState extends State<TransportDriversScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allStaff = [];
  List<Map<String, dynamic>> _filteredStaff = [];
  bool _isLoading = true;
  String _activeTab = 'All'; 

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _searchController.addListener(_filterStaff);
  }

  Future<void> _loadMockData() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/transport_drivers.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allStaff = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
        _filterStaff();
      });
    } catch (e) {
      debugPrint('Error loading mock data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterStaff() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStaff = _allStaff.where((staff) {
        final fullName = '${staff['firstName']} ${staff['lastName']}';
        final matchesSearch = fullName.toLowerCase().contains(query) ||
            staff['id'].toString().toLowerCase().contains(query) ||
            (staff['assignedVehicle']?.toString().toLowerCase().contains(query) ?? false);
        
        bool matchesTab = true;
        if (_activeTab != 'All') {
          matchesTab = staff['role'] == _activeTab;
        }

        return matchesSearch && matchesTab;
      }).toList();
    });
  }

  Widget _buildDetailListItem({required IconData icon, required Color iconColor, required String label, required String value, bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(value, style: const TextStyle(color: Color(0xFF1E1E2D), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF3EEFF), indent: 56),
      ],
    );
  }

  Widget _buildDetailSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            boxShadow: [
              BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }



  void _showAddStaffBottomSheet(BuildContext context, {Map<String, dynamic>? existingStaff}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddStaffBottomSheet(
        existingStaff: existingStaff,
        onSave: (Map<String, dynamic> newStaff) {
          setState(() {
            if (existingStaff != null) {
              final index = _allStaff.indexWhere((s) => s['id'] == existingStaff['id']);
              if (index != -1) {
                _allStaff[index] = Map<String, dynamic>.from(existingStaff)..addAll(newStaff);
              }
            } else {
              _allStaff.insert(0, newStaff);
            }
            _filterStaff();
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
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
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Drivers & Staff', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
          const Spacer(),
          GestureDetector(
            onTap: () => _showAddStaffBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6C4CF1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.plus, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Add Staff', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1)))
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      child: Row(
                        children: [
                          _buildTab('All'),
                          const SizedBox(width: 12),
                          _buildTab('Driver'),
                          const SizedBox(width: 12),
                          _buildTab('Attendant'),
                        ],
                      ),
                    ),
                  ),
                  
                  _filteredStaff.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text('No staff found', style: TextStyle(color: Colors.grey.shade500)),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final staff = _filteredStaff[index];
                              final fullName = '${staff['firstName']} ${staff['lastName']}';
                              return Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => DriverDetailsScreen(staff: staff),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFE8E3F8).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: const BoxDecoration(color: Color(0xFFF3F0FF), shape: BoxShape.circle),
                                          child: Center(
                                            child: Text(
                                              fullName.isNotEmpty ? fullName.substring(0, 1) : 'S',
                                              style: const TextStyle(color: Color(0xFF6C4CF1), fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(child: Text(fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), overflow: TextOverflow.ellipsis)),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFF3F0FF),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(staff['role'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(LucideIcons.phone, size: 14, color: Color(0xFF9CA3AF)),
                                                  const SizedBox(width: 6),
                                                  Text(staff['phone'] ?? 'N/A', style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(top: 2.0),
                                                    child: Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF9CA3AF)),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      '${staff['assignedRoute'] ?? 'No route assigned'} • ${staff['assignedVehicle'] ?? 'Unassigned'}',
                                                      style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: _filteredStaff.length,
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget _buildTab(String title) {
    final isActive = _activeTab == title;
    return GestureDetector(
      onTap: () => setState(() {
        _activeTab = title;
        _filterStaff();
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFFE5E7EB)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF6C6C80),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AddStaffBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? existingStaff;
  final Function(Map<String, dynamic>) onSave;

  const _AddStaffBottomSheet({this.existingStaff, required this.onSave});

  @override
  State<_AddStaffBottomSheet> createState() => _AddStaffBottomSheetState();
}

class _AddStaffBottomSheetState extends State<_AddStaffBottomSheet> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _licenseExpiryController = TextEditingController();
  final _medicalExpiryController = TextEditingController();
  final _trainingExpiryController = TextEditingController();
  final _salaryController = TextEditingController();
  
  String _selectedRole = 'Driver';
  String _selectedVehicle = 'Unassigned';

  @override
  void initState() {
    super.initState();
    if (widget.existingStaff != null) {
      final staff = widget.existingStaff!;
      _firstNameController.text = staff['firstName'] ?? '';
      _lastNameController.text = staff['lastName'] ?? '';
      _emailController.text = staff['email'] ?? '';
      _phoneController.text = staff['phone'] ?? '';
      _salaryController.text = staff['basicSalary']?.toString() ?? '';
      
      _medicalExpiryController.text = staff['medicalCertExpiry'] ?? '';
      _trainingExpiryController.text = staff['trainingCertExpiry'] ?? '';

      _licenseController.text = staff['licenseNumber'] == 'N/A' ? '' : (staff['licenseNumber'] ?? '');
      _licenseExpiryController.text = staff['licenseExpiry'] == 'N/A' ? '' : (staff['licenseExpiry'] ?? '');
      
      if (['Driver', 'Attendant'].contains(staff['role'])) _selectedRole = staff['role'];
      if (['BUS-01', 'BUS-02', 'VAN-01', 'Unassigned'].contains(staff['assignedVehicle'])) _selectedVehicle = staff['assignedVehicle'];
    }
  }

  void _handleSave() {
    final newStaff = {
      "id": widget.existingStaff != null ? widget.existingStaff!['id'] : (_selectedRole == 'Driver' ? "DRV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}" : "STF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}"),
      "firstName": _firstNameController.text.isNotEmpty ? _firstNameController.text : "Unknown",
      "lastName": _lastNameController.text.isNotEmpty ? _lastNameController.text : "User",
      "email": _emailController.text,
      "role": _selectedRole,
      "licenseNumber": _selectedRole == 'Driver' ? (_licenseController.text.isNotEmpty ? _licenseController.text : 'N/A') : 'N/A',
      "licenseExpiry": _selectedRole == 'Driver' ? (_licenseExpiryController.text.isNotEmpty ? _licenseExpiryController.text : 'N/A') : 'N/A',
      "medicalCertExpiry": _medicalExpiryController.text,
      "trainingCertExpiry": _trainingExpiryController.text,
      "basicSalary": _salaryController.text,
      "assignedVehicle": _selectedVehicle,
      "phone": _phoneController.text.isNotEmpty ? _phoneController.text : "N/A",
      "status": widget.existingStaff?['status'] ?? "Active", // Default to Active
    };
    
    widget.onSave(newStaff);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff details saved successfully!'), backgroundColor: Color(0xFF6C4CF1)),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF6C4CF1),
            colorScheme: const ColorScheme.light(primary: Color(0xFF6C4CF1)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.existingStaff != null ? 'Edit Transport Staff' : 'Add Transport Staff', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 4),
                      const Text('Create a driver, attendant, or other transport staff record', style: TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.close, color: Color(0xFF1E1E2D), size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTextField('First Name', _firstNameController, 'e.g. Ramesh')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Last Name', _lastNameController, 'e.g. Kumar')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Email', _emailController, 'name@school.edu')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Phone Number', _phoneController, '+91 98765 43210')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(child: _buildDropdown('Role', _selectedRole, ['Driver', 'Attendant'], (v) => setState(() => _selectedRole = v!))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDropdown('Assign Vehicle', _selectedVehicle, ['BUS-01', 'BUS-02', 'VAN-01', 'Unassigned'], (v) => setState(() => _selectedVehicle = v!))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('License Number', _licenseController, '')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDateField('License Expiry', _licenseExpiryController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(child: _buildDateField('Medical Certificate Expiry', _medicalExpiryController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDateField('Training Certificate Expiry', _trainingExpiryController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Basic Salary', _salaryController, ''),
                  
                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF6C6C80), fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Save Staff Record', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(controller),
          decoration: InputDecoration(
            hintText: 'dd/mm/yyyy',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            suffixIcon: const Icon(LucideIcons.calendar, color: Color(0xFF1E1E2D), size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF6C4CF1))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E1E2D)),
              items: items.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
