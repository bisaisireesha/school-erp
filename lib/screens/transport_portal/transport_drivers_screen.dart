import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'transport_driver_details_screen.dart';

class TransportDriversScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const TransportDriversScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  State<TransportDriversScreen> createState() => _TransportDriversScreenState();
}

class _TransportDriversScreenState extends State<TransportDriversScreen> {
  String _selectedRoleFilter = 'All'; // 'All', 'Drivers', 'Attendants', 'Staff'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDriverStaffBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return _AddDriverStaffBottomSheet(
          onSave: (newStaff) {
            setState(() {
              final list = widget.data['drivers'] as List?;
              if (list != null) {
                list.add(newStaff);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${newStaff['name']} registered successfully'),
                backgroundColor: const Color(0xFF6C4CF1),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.data['drivers'] as List? ?? [];

    final filtered = list.where((d) {
      final role = d['role'] as String? ?? 'Driver';
      final name = (d['name'] as String? ?? '').toLowerCase();
      final phone = (d['phone'] as String? ?? '').toLowerCase();
      final vehicle = (d['assignedVehicle'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase().trim();

      bool matchesRole = true;
      if (_selectedRoleFilter == 'Drivers') {
        matchesRole = role == 'Driver';
      } else if (_selectedRoleFilter == 'Attendants') {
        matchesRole = role == 'Attendant';
      } else if (_selectedRoleFilter == 'Staff') {
        matchesRole = role == 'Supervisor' || role == 'Staff';
      }

      bool matchesSearch = query.isEmpty || name.contains(query) || phone.contains(query) || vehicle.contains(query);

      return matchesRole && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: widget.onBack),
        title: const Text(
          'Drivers & Staff',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
            fontSize: 18.5,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddDriverStaffBottomSheet(context),
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Add Staff',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                boxShadow: AppShadows.soft,
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w500),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by driver name, phone, or vehicle...',
                  hintStyle: TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.0, fontWeight: FontWeight.w500),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6C4CF1), size: 19),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Role Filters (All, Drivers, Attendants, Staff)
            Row(
              children: ['All', 'Drivers', 'Attendants', 'Staff'].map((filter) {
                final bool isSelected = _selectedRoleFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRoleFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF4A4A68),
                        fontSize: 12.0,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Roster Counter Text
            Text(
              '${filtered.length} Active Staff & Crew Members',
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Staff List Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final d = filtered[index];
                final String name = d['name'] ?? 'Staff Member';
                final String role = d['role'] ?? 'Driver';
                final String phone = d['phone'] ?? '+91 98765 43210';
                final String vehicle = d['assignedVehicle'] ?? 'Unassigned';
                final String status = d['status'] ?? 'Active';

                final bool isDriver = role == 'Driver';
                final Color roleColor = isDriver
                    ? const Color(0xFF6C4CF1)
                    : (role == 'Attendant' ? const Color(0xFF3B82F6) : const Color(0xFFF59E0B));

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransportDriverDetailsScreen(driverData: d),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: roleColor.withValues(alpha: 0.12),
                          child: Icon(
                            isDriver ? LucideIcons.userCheck : LucideIcons.user,
                            color: roleColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E1E2D),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: roleColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      role,
                                      style: TextStyle(
                                        color: roleColor,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Phone: $phone',
                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF6E6E8D), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Assigned: $vehicle',
                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF4A4A68), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: status == 'Active' || status == 'On Duty'
                                    ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                    : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: status == 'Active' || status == 'On Duty' ? const Color(0xFF10B981) : const Color(0xFFD97706),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFFCDCBE0), size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ─── Native Bottom Sheet for Adding Driver / Staff (Complete Professional Fields) ──

class _AddDriverStaffBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> staff) onSave;

  const _AddDriverStaffBottomSheet({required this.onSave});

  @override
  State<_AddDriverStaffBottomSheet> createState() => _AddDriverStaffBottomSheetState();
}

class _AddDriverStaffBottomSheetState extends State<_AddDriverStaffBottomSheet> {
  final TextEditingController _firstNameController = TextEditingController(text: 'Ramesh');
  final TextEditingController _lastNameController = TextEditingController(text: 'Kumar');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  final TextEditingController _licenseNoController = TextEditingController(text: 'DL-142020008891');
  final TextEditingController _licenseExpiryController = TextEditingController(text: '12 Nov 2029');
  final TextEditingController _experienceController = TextEditingController(text: '8 Years');
  final TextEditingController _previousEmployerController = TextEditingController(text: 'BMTC Transit Metro Division');
  final TextEditingController _departmentController = TextEditingController(text: 'Transport & Fleet Logistics');
  final TextEditingController _designationController = TextEditingController(text: 'Senior Bus Driver');
  final TextEditingController _joiningDateController = TextEditingController(text: '01 Jun 2021');
  final TextEditingController _emergencyContactController = TextEditingController(text: 'Sunita Kumar (+91 98112 33445)');
  final TextEditingController _certificationsController = TextEditingController(text: 'Defensive Driving, First Aid Certified');
  final TextEditingController _skillsController = TextEditingController(text: 'Heavy Passenger Driving, CPR First Responder');

  String _selectedRole = 'Driver';
  String _selectedVehicle = 'BUS-01';
  String _selectedEmploymentType = 'Full-Time';
  String _selectedVehicleCategory = 'Heavy Passenger Vehicle (Bus)';

  final List<String> _roles = ['Driver', 'Attendant', 'Supervisor'];
  final List<String> _vehicles = ['BUS-01', 'BUS-02', 'BUS-03', 'VAN-04', 'Unassigned'];
  final List<String> _employmentTypes = ['Full-Time', 'Contract', 'Part-Time'];
  final List<String> _vehicleCategories = [
    'Heavy Passenger Vehicle (Bus)',
    'Light Commercial Vehicle (Van)',
    'Minibus Operator',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _licenseNoController.dispose();
    _licenseExpiryController.dispose();
    _experienceController.dispose();
    _previousEmployerController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _joiningDateController.dispose();
    _emergencyContactController.dispose();
    _certificationsController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final String first = _firstNameController.text.trim();
    final String last = _lastNameController.text.trim();
    if (first.isEmpty) return;

    final String fullName = '$first $last'.trim();
    final bool isDriver = _selectedRole == 'Driver';

    final newStaff = {
      'id': 'd_${DateTime.now().millisecondsSinceEpoch}',
      'name': fullName,
      'role': _selectedRole,
      'phone': _phoneController.text.trim().isEmpty ? '+91 98765 43210' : _phoneController.text.trim(),
      'assignedVehicle': _selectedVehicle,
      'status': 'Active',
      'licenseNo': isDriver ? _licenseNoController.text.trim() : 'N/A',
      'licenseExpiry': isDriver ? _licenseExpiryController.text.trim() : 'N/A',
      'experience': _experienceController.text.trim(),
      'previousEmployer': _previousEmployerController.text.trim(),
      'employmentType': _selectedEmploymentType,
      'vehicleCategory': isDriver ? _selectedVehicleCategory : 'N/A',
      'certifications': _certificationsController.text.trim(),
      'department': _departmentController.text.trim(),
      'designation': _designationController.text.trim(),
      'joiningDate': _joiningDateController.text.trim(),
      'emergencyContact': _emergencyContactController.text.trim(),
      'skills': _skillsController.text.trim(),
    };

    widget.onSave(newStaff);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bool isDriver = _selectedRole == 'Driver';

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle at top
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DDF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Title & Subtitle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.userPlus, color: Color(0xFF6C4CF1), size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Driver / Staff',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Register new crew member or driver profile',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF6E6E8D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Form Fields List (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Basic Information
                    _buildSectionTitle('Basic Information'),
                    const SizedBox(height: 8),

                    _buildFieldLabel('First Name'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _firstNameController, hintText: 'e.g. Ramesh'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Last Name'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _lastNameController, hintText: 'e.g. Kumar'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Phone Number'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _phoneController, hintText: 'e.g. +91 98765 43210', keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Role'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedRole,
                      items: _roles,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRole = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Assign Vehicle'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedVehicle,
                      items: _vehicles,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedVehicle = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Professional & Employment Details
                    _buildSectionTitle('Professional & Employment Details'),
                    const SizedBox(height: 8),

                    _buildFieldLabel('Total Working Experience'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _experienceController, hintText: 'e.g. 8 Years'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Previous Employer'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _previousEmployerController, hintText: 'e.g. BMTC Metro Division'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Employment Type'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedEmploymentType,
                      items: _employmentTypes,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedEmploymentType = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Department'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _departmentController, hintText: 'e.g. Transport & Fleet Logistics'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Designation'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _designationController, hintText: 'e.g. Senior Bus Driver'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Joining Date'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _joiningDateController, hintText: 'e.g. 01 Jun 2021'),
                    const SizedBox(height: 16),

                    // Section 3: Driver License & Vehicle Specs (If Driver)
                    if (isDriver) ...[
                      _buildSectionTitle('Licensing & Vehicle Specs'),
                      const SizedBox(height: 8),

                      _buildFieldLabel('License Number'),
                      const SizedBox(height: 6),
                      _buildTextField(controller: _licenseNoController, hintText: 'e.g. DL-142020008891'),
                      const SizedBox(height: 12),

                      _buildFieldLabel('License Expiry'),
                      const SizedBox(height: 6),
                      _buildTextField(controller: _licenseExpiryController, hintText: 'e.g. 12 Nov 2029'),
                      const SizedBox(height: 12),

                      _buildFieldLabel('Vehicle Category Authorized'),
                      const SizedBox(height: 6),
                      _buildDropdown(
                        value: _selectedVehicleCategory,
                        items: _vehicleCategories,
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedVehicleCategory = val);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Section 4: Certifications & Qualifications
                    _buildSectionTitle('Certifications & Emergency Contact'),
                    const SizedBox(height: 8),

                    _buildFieldLabel('Certifications'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _certificationsController, hintText: 'e.g. Defensive Driving, First Aid Certified'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Skills / Qualifications'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _skillsController, hintText: 'e.g. Heavy Driving License, CPR First Responder'),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Emergency Contact'),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _emergencyContactController, hintText: 'e.g. Sunita Kumar (+91 98112 33445)'),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Color(0xFF6C4CF1))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Staff Profile', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white)),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Color(0xFF6C4CF1), letterSpacing: -0.2),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: Color(0xFF1E1E2D), letterSpacing: -0.1),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14.0, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9E9AB8), fontSize: 13.5, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
        boxShadow: AppShadows.soft,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6C4CF1), size: 22),
          isExpanded: true,
          style: const TextStyle(fontSize: 14.0, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w400),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
