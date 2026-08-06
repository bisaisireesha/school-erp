import 'package:flutter/material.dart';

enum LibrarianCreateType {
  book,
  staff,
  category,
  rack,
  shelf,
}

class LibrarianCreateBottomSheet extends StatefulWidget {
  final LibrarianCreateType type;
  final Function(Map<String, dynamic> data) onSubmit;

  const LibrarianCreateBottomSheet({
    super.key,
    required this.type,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required LibrarianCreateType type,
    required Function(Map<String, dynamic> data) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LibrarianCreateBottomSheet(
        type: type,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<LibrarianCreateBottomSheet> createState() => _LibrarianCreateBottomSheetState();
}

class _LibrarianCreateBottomSheetState extends State<LibrarianCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Book controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  String _selectedCategory = 'Fiction';
  final _rackController = TextEditingController();
  final _shelfController = TextEditingController();
  final _copiesController = TextEditingController(text: '5');

  // Staff controllers
  final _fullNameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'Library Administration';

  // Category controllers
  final _categoryNameController = TextEditingController();
  final _categoryDescController = TextEditingController();

  // Rack controllers
  final _rackNameController = TextEditingController();
  final _floorController = TextEditingController(text: 'Floor 2 - Main Wing');
  final _rackDescController = TextEditingController();

  // Shelf controllers
  String _selectedParentRack = 'Rack A-04';
  final _shelfNameController = TextEditingController();
  final _capacityController = TextEditingController(text: '150');

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _rackController.dispose();
    _shelfController.dispose();
    _copiesController.dispose();
    _fullNameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _categoryNameController.dispose();
    _categoryDescController.dispose();
    _rackNameController.dispose();
    _floorController.dispose();
    _rackDescController.dispose();
    _shelfNameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.type) {
      case LibrarianCreateType.book:
        return 'Add New Book';
      case LibrarianCreateType.staff:
        return 'Add Staff Member';
      case LibrarianCreateType.category:
        return 'Add Category';
      case LibrarianCreateType.rack:
        return 'Add Rack';
      case LibrarianCreateType.shelf:
        return 'Add Shelf';
    }
  }

  String get _helperText {
    switch (widget.type) {
      case LibrarianCreateType.book:
        return 'Enter the book details below.';
      case LibrarianCreateType.staff:
        return 'Enter staff member information below.';
      case LibrarianCreateType.category:
        return 'Create a new book category or subject below.';
      case LibrarianCreateType.rack:
        return 'Enter rack location details below.';
      case LibrarianCreateType.shelf:
        return 'Enter shelf details under a rack below.';
    }
  }

  String get _ctaLabel {
    switch (widget.type) {
      case LibrarianCreateType.book:
        return 'Add Book';
      case LibrarianCreateType.staff:
        return 'Add Staff';
      case LibrarianCreateType.category:
        return 'Add Category';
      case LibrarianCreateType.rack:
        return 'Add Rack';
      case LibrarianCreateType.shelf:
        return 'Add Shelf';
    }
  }

  void _handleSubmit() {
    final Map<String, dynamic> result = {};

    switch (widget.type) {
      case LibrarianCreateType.book:
        final title = _titleController.text.trim();
        if (title.isEmpty) return;
        result['title'] = title;
        result['author'] = _authorController.text.trim().isEmpty ? 'Unknown Author' : _authorController.text.trim();
        result['isbn'] = _isbnController.text.trim().isEmpty ? '978-0000000000' : _isbnController.text.trim();
        result['category'] = _selectedCategory;
        result['rackNumber'] = _rackController.text.trim().isEmpty ? 'R-01' : _rackController.text.trim();
        result['shelfNumber'] = _shelfController.text.trim().isEmpty ? 'Shelf 1' : _shelfController.text.trim();
        result['totalCopies'] = int.tryParse(_copiesController.text.trim()) ?? 5;
        result['availableCopies'] = result['totalCopies'];
        break;

      case LibrarianCreateType.staff:
        final name = _fullNameController.text.trim();
        if (name.isEmpty) return;
        result['name'] = name;
        result['memberId'] = _employeeIdController.text.trim().isEmpty
            ? 'STF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'
            : _employeeIdController.text.trim();
        result['email'] = _emailController.text.trim().isEmpty
            ? '${name.toLowerCase().replaceAll(' ', '.')}@school.edu'
            : _emailController.text.trim();
        result['phone'] = _phoneController.text.trim().isEmpty ? '+1 (555) 000-0000' : _phoneController.text.trim();
        result['role'] = 'Staff';
        result['department'] = _selectedRole;
        break;

      case LibrarianCreateType.category:
        final name = _categoryNameController.text.trim();
        if (name.isEmpty) return;
        result['name'] = name;
        result['code'] = name.length >= 3 ? name.substring(0, 3).toUpperCase() : 'GEN';
        result['description'] = _categoryDescController.text.trim().isEmpty ? 'General catalog section' : _categoryDescController.text.trim();
        break;

      case LibrarianCreateType.rack:
        final rack = _rackNameController.text.trim();
        if (rack.isEmpty) return;
        result['rackNo'] = rack;
        result['floor'] = _floorController.text.trim();
        result['description'] = _rackDescController.text.trim();
        break;

      case LibrarianCreateType.shelf:
        final shelf = _shelfNameController.text.trim();
        if (shelf.isEmpty) return;
        result['rackNo'] = _selectedParentRack;
        result['shelfNo'] = shelf;
        result['capacity'] = int.tryParse(_capacityController.text.trim()) ?? 150;
        break;
    }

    widget.onSubmit(result);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Header Row: Title, Helper Text & Close Icon (No blue icon, no borders)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _helperText,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7A7A9D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF7A7A9D),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0EDF8)),

          // Scrollable Form Fields Area
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
              child: Form(
                key: _formKey,
                child: _buildFormFields(),
              ),
            ),
          ),

          // Fixed Primary CTA Button at Bottom
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + (bottomInset > 0 ? 0 : MediaQuery.of(context).padding.bottom)),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0EDF8), width: 1.0)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _ctaLabel,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    switch (widget.type) {
      case LibrarianCreateType.book:
        return _buildBookFields();
      case LibrarianCreateType.staff:
        return _buildStaffFields();
      case LibrarianCreateType.category:
        return _buildCategoryFields();
      case LibrarianCreateType.rack:
        return _buildRackFields();
      case LibrarianCreateType.shelf:
        return _buildShelfFields();
    }
  }

  // 1. Add Book Form Fields
  Widget _buildBookFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMinimalField(
          label: 'Book Title',
          controller: _titleController,
          hint: 'e.g. To Kill a Mockingbird',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Author',
          controller: _authorController,
          hint: 'e.g. Harper Lee',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'ISBN',
          controller: _isbnController,
          hint: 'e.g. 978-0446310789',
        ),
        const SizedBox(height: 14),
        _buildDropdownField(
          label: 'Category',
          value: _selectedCategory,
          items: ['Fiction', 'Science', 'Technology', 'History', 'Social Science', 'Reference'],
          onChanged: (val) {
            if (val != null) setState(() => _selectedCategory = val);
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildMinimalField(
                label: 'Rack',
                controller: _rackController,
                hint: 'e.g. Rack A-04',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMinimalField(
                label: 'Shelf',
                controller: _shelfController,
                hint: 'e.g. Shelf 2',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Number of Copies',
          controller: _copiesController,
          hint: 'e.g. 5',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // 2. Add Staff Form Fields
  Widget _buildStaffFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMinimalField(
          label: 'Full Name',
          controller: _fullNameController,
          hint: 'e.g. Eleanor Vance',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Employee ID',
          controller: _employeeIdController,
          hint: 'e.g. STF-5099',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Email',
          controller: _emailController,
          hint: 'e.g. eleanor.vance@school.edu',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Phone',
          controller: _phoneController,
          hint: 'e.g. +1 (555) 345-6789',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _buildDropdownField(
          label: 'Role / Department',
          value: _selectedRole,
          items: ['Library Administration', 'Head Librarian', 'Assistant Librarian', 'Cataloger', 'Archivist'],
          onChanged: (val) {
            if (val != null) setState(() => _selectedRole = val);
          },
        ),
      ],
    );
  }

  // 3. Add Category Form Fields
  Widget _buildCategoryFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMinimalField(
          label: 'Category Name',
          controller: _categoryNameController,
          hint: 'e.g. Computer Science & AI',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Description (optional)',
          controller: _categoryDescController,
          hint: 'Enter brief category description...',
          maxLines: 3,
        ),
      ],
    );
  }

  // 4. Add Rack Form Fields
  Widget _buildRackFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMinimalField(
          label: 'Rack Name / Number',
          controller: _rackNameController,
          hint: 'e.g. Rack B-06',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Floor / Section (optional)',
          controller: _floorController,
          hint: 'e.g. Floor 2 - East Wing',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Description (optional)',
          controller: _rackDescController,
          hint: 'Enter location description...',
          maxLines: 2,
        ),
      ],
    );
  }

  // 5. Add Shelf Form Fields
  Widget _buildShelfFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Select Rack',
          value: _selectedParentRack,
          items: ['Rack A-04', 'Rack S-12', 'Rack T-02', 'Rack H-08', 'Rack E-05', 'Rack R-01'],
          onChanged: (val) {
            if (val != null) setState(() => _selectedParentRack = val);
          },
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Shelf Name / Number',
          controller: _shelfNameController,
          hint: 'e.g. Shelf 3',
        ),
        const SizedBox(height: 14),
        _buildMinimalField(
          label: 'Capacity (optional)',
          controller: _capacityController,
          hint: 'e.g. 150',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // Minimal Input Field Helper Matching Transport App System
  Widget _buildMinimalField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14.0, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
            filled: true,
            fillColor: const Color(0xFFF9F8FF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEBE8FF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEBE8FF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Minimal Dropdown Field Helper Matching Transport App System
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E2D),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A7A9D)),
          style: const TextStyle(fontSize: 14.0, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9F8FF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEBE8FF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEBE8FF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
