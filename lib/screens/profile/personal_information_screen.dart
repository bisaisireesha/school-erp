import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final role = authProvider.currentUser?.role ?? 'parent';
    final isStudent = role == 'student';
    final isWarden = role == 'warden';
    final isFrontDesk = role == 'front_desk';
    final isAccountant = role == 'accountant';

    String fullName = 'Suresh Patel';
    String initials = 'SP';
    String email = 'suresh.patel@email.com';
    String phone = '+91 98765 43210';
    String address = '123 Meadow Lane, Springfield, IL 62704';

    if (isStudent) {
      fullName = 'Akshara';
      initials = 'AK';
      email = 'akshara.s@school.edu';
      phone = '+91 98765 11223';
    } else if (isWarden) {
      fullName = 'Ramesh Verma';
      initials = 'RV';
      email = 'warden.verma@school.edu';
      phone = '+91 98765 55443';
    } else if (isFrontDesk) {
      fullName = 'Aditi Tiwari';
      initials = 'AT';
      email = 'frontdesk@school.edu';
      phone = '+91 98765 99887';
    } else if (isAccountant) {
      fullName = 'Arun Kumar';
      initials = 'AK';
      email = 'accountant@school.edu';
      phone = '+91 98765 12345';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF3EEFF), width: 2),
                    ),
                    child: Center(
                      child: Text(initials, style: const TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.w800, fontSize: 36)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C4CF1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.camera, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Basic Details'),
            const SizedBox(height: 16),
            _buildTextField('Full Name', fullName, LucideIcons.user),
            const SizedBox(height: 16),
            if (isStudent) ...[
              _buildTextField('Class & Grade', 'Class 10-A', LucideIcons.graduationCap),
              const SizedBox(height: 16),
              _buildTextField('Roll Number', '1042', LucideIcons.hash),
              const SizedBox(height: 16),
            ] else if (isWarden) ...[
              _buildTextField('Role / Designation', 'Hostel Warden', LucideIcons.shield),
              const SizedBox(height: 16),
              _buildTextField('Warden Staff ID', 'WDN-402', LucideIcons.badgeCheck),
              const SizedBox(height: 16),
              _buildTextField('Assigned Blocks', 'Boys Hostel Block A & Block B', LucideIcons.building2),
              const SizedBox(height: 16),
            ] else if (isFrontDesk) ...[
              _buildTextField('Role / Designation', 'Front Desk Executive', LucideIcons.briefcase),
              const SizedBox(height: 16),
              _buildTextField('Staff ID', 'FD-108', LucideIcons.badgeCheck),
              const SizedBox(height: 16),
              _buildTextField('Desk Location', 'Main Reception Counter 1', LucideIcons.mapPin),
              const SizedBox(height: 16),
              _buildTextField('Shift Timings', 'Morning Shift (08:00 AM – 04:30 PM)', LucideIcons.clock),
              const SizedBox(height: 16),
            ] else if (isAccountant) ...[
              _buildTextField('Role / Designation', 'Accountant', LucideIcons.briefcase),
              const SizedBox(height: 16),
              _buildTextField('Staff ID', 'EMP-FIN-001', LucideIcons.badgeCheck),
              const SizedBox(height: 16),
              _buildTextField('Department', 'Finance Department', LucideIcons.building2),
              const SizedBox(height: 16),
            ] else ...[
              _buildTextField('Role', 'Parent / Guardian', LucideIcons.users),
              const SizedBox(height: 16),
              _buildTextField('Enrolled Children', 'Akshara (Class 10-A), Aryan (Class 7-B)', LucideIcons.baby),
              const SizedBox(height: 16),
            ],
            _buildSectionTitle('Contact Information'),
            const SizedBox(height: 16),
            _buildTextField('Email Address', email, LucideIcons.mail, TextInputType.emailAddress),
            if (!isStudent && !isFrontDesk) ...[
              const SizedBox(height: 16),
              _buildTextField('Phone Number', phone, LucideIcons.phone, TextInputType.phone),
            ],
            if (isFrontDesk) ...[
              const SizedBox(height: 16),
              _buildTextField('Phone Number', phone, LucideIcons.phone, TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Extension', 'Ext 205', LucideIcons.phoneCall, TextInputType.phone),
            ],
            const SizedBox(height: 24),
            _buildSectionTitle('Address'),
            const SizedBox(height: 16),
            _buildTextField('Home Address', address, LucideIcons.mapPin, TextInputType.streetAddress, 2),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Information saved successfully!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E2D),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon, [TextInputType keyboardType = TextInputType.text, int maxLines = 1]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A68),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, color: const Color(0xFF9090A7), size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFFAFAFF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFF3EEFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFF3EEFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
