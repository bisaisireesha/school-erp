import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class MyChildScreen extends StatefulWidget {
  final VoidCallback onBack;

  const MyChildScreen({super.key, required this.onBack});

  @override
  State<MyChildScreen> createState() => _MyChildScreenState();
}

class _MyChildScreenState extends State<MyChildScreen> {
  Map<String, dynamic>? _childData;
  bool _isLoading = true;

  // Editable fields state
  late TextEditingController _addressController;
  late TextEditingController _fatherPhoneController;
  late TextEditingController _fatherEmailController;
  late TextEditingController _motherPhoneController;
  late TextEditingController _motherEmailController;
  late TextEditingController _allergiesController;
  late TextEditingController _doctorPhoneController;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    final String response = await rootBundle.loadString('assets/mock/child_profile.json');
    final data = json.decode(response);
    setState(() {
      _childData = data;
      _isLoading = false;
      _initControllers();
    });
  }

  void _initControllers() {
    final pInfo = _childData!['personalInformation'];
    final pgInfo = _childData!['parentGuardianDetails'];
    final mInfo = _childData!['medicalInformation'];

    _addressController = TextEditingController(text: pInfo['address']);
    _fatherPhoneController = TextEditingController(text: pgInfo['fatherPhone']);
    _fatherEmailController = TextEditingController(text: pgInfo['fatherEmail']);
    _motherPhoneController = TextEditingController(text: pgInfo['motherPhone']);
    _motherEmailController = TextEditingController(text: pgInfo['motherEmail']);
    _allergiesController = TextEditingController(text: mInfo['allergies']);
    _doctorPhoneController = TextEditingController(text: mInfo['doctorPhone']);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _fatherPhoneController.dispose();
    _fatherEmailController.dispose();
    _motherPhoneController.dispose();
    _motherEmailController.dispose();
    _allergiesController.dispose();
    _doctorPhoneController.dispose();
    super.dispose();
  }

  void _openEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          padding: EdgeInsets.only(
            top: AppSpacing.screenPadding,
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.screenPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Allowed Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF7A7A9D)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7F0),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: const Color(0xFFFFE4CC)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline_rounded, color: Color(0xFFF97316), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Read-only fields like Admission No, Roll No, and Name are managed by school administration.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF9A4C00), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFormField('Residential Address', _addressController, maxLines: 2),
                _buildFormField('Father Contact Number', _fatherPhoneController),
                _buildFormField('Father Email', _fatherEmailController),
                _buildFormField('Mother Contact Number', _motherPhoneController),
                _buildFormField('Mother Email', _motherEmailController),
                _buildFormField('Allergies & Medical Notes', _allergiesController),
                _buildFormField('Family Doctor Phone', _doctorPhoneController),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.minTouchTarget,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        _childData!['personalInformation']['address'] = _addressController.text;
                        _childData!['parentGuardianDetails']['fatherPhone'] = _fatherPhoneController.text;
                        _childData!['parentGuardianDetails']['fatherEmail'] = _fatherEmailController.text;
                        _childData!['parentGuardianDetails']['motherPhone'] = _motherPhoneController.text;
                        _childData!['parentGuardianDetails']['motherEmail'] = _motherEmailController.text;
                        _childData!['medicalInformation']['allergies'] = _allergiesController.text;
                        _childData!['medicalInformation']['doctorPhone'] = _doctorPhoneController.text;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile details updated successfully!'),
                          backgroundColor: Color(0xFF22C55E),
                        ),
                      );
                    },
                    child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9F8FF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: Color(0xFFE8E3F8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: Color(0xFFE8E3F8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final header = _childData!['header'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Back Navigation Row
          Row(
            children: [
              AppBackButton(onPressed: widget.onBack),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text(
                  'My Child Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Child Profile Header Card
          _buildProfileHeaderCard(header),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Personal Information Section
          _buildPersonalInformationSection(_childData!['personalInformation']),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Parent & Guardian Details Section
          _buildParentGuardianDetailsSection(_childData!['parentGuardianDetails']),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Emergency Contacts Section
          _buildEmergencyContactsSection(_childData!['emergencyContacts']),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Medical Information Section
          _buildMedicalInformationSection(_childData!['medicalInformation']),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Authorized Pickup Section
          _buildAuthorizedPickupSection(_childData!['authorizedPickup']),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Documents Section
          _buildDocumentsSection(_childData!['documents']),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderCard(Map<String, dynamic> header) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingHorizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Active Badge
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF6C4CF1), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        header['initials'],
                        style: const TextStyle(
                          color: Color(0xFF6C4CF1),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        header['status'],
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              // Student Main Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${header['studentId']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${header['classSection']} · Roll No: ${header['rollNo']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A7A9D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: Color(0xFFF3EEFF)),
          const SizedBox(height: AppSpacing.md),
          // Academic Year & Secondary Edit Profile Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF7A7A9D)),
                  const SizedBox(width: 6),
                  Text(
                    'Academic Year: ${header['academicYear']}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4A4A68)),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _openEditProfileModal,
                icon: const Icon(LucideIcons.pencil, size: 14, color: Color(0xFF6C4CF1)),
                label: const Text('Edit Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 36),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingHorizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: const Color(0xFF6C4CF1), size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: Color(0xFFF3EEFF)),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isReadOnly = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A7A9D)),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2D)),
                  ),
                ),
                if (!isReadOnly)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(LucideIcons.pencil, size: 12, color: Color(0xFF6C4CF1)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationSection(Map<String, dynamic> info) {
    return _buildSectionCard(
      title: 'Personal Information',
      icon: LucideIcons.user,
      children: [
        _buildInfoRow('Date of Birth', info['dob']),
        _buildInfoRow('Gender', info['gender']),
        _buildInfoRow('Blood Group', info['bloodGroup']),
        _buildInfoRow('Nationality', info['nationality']),
        _buildInfoRow('Mother Tongue', info['motherTongue']),
        _buildInfoRow('Address', info['address'], isReadOnly: false),
      ],
    );
  }

  Widget _buildParentGuardianDetailsSection(Map<String, dynamic> info) {
    return _buildSectionCard(
      title: 'Parent & Guardian Details',
      icon: LucideIcons.users,
      children: [
        _buildInfoRow('Father\'s Name', info['fatherName']),
        _buildInfoRow('Occupation', info['fatherOccupation']),
        _buildInfoRow('Father Phone', info['fatherPhone'], isReadOnly: false),
        _buildInfoRow('Father Email', info['fatherEmail'], isReadOnly: false),
        const SizedBox(height: 8),
        const Divider(height: 1, color: Color(0xFFF3EEFF)),
        const SizedBox(height: 8),
        _buildInfoRow('Mother\'s Name', info['motherName']),
        _buildInfoRow('Occupation', info['motherOccupation']),
        _buildInfoRow('Mother Phone', info['motherPhone'], isReadOnly: false),
        _buildInfoRow('Mother Email', info['motherEmail'], isReadOnly: false),
      ],
    );
  }

  Widget _buildEmergencyContactsSection(List contacts) {
    return _buildSectionCard(
      title: 'Emergency Contacts',
      icon: LucideIcons.phoneCall,
      children: contacts.map<Widget>((c) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F8FF),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                  const SizedBox(height: 2),
                  Text(c['phone'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C4CF1))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(c['relation'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicalInformationSection(Map<String, dynamic> info) {
    return _buildSectionCard(
      title: 'Medical Information',
      icon: LucideIcons.stethoscope,
      children: [
        _buildInfoRow('Allergies', info['allergies'], isReadOnly: false),
        _buildInfoRow('Chronic Conditions', info['chronicConditions']),
        _buildInfoRow('Blood Group', info['bloodGroup']),
        _buildInfoRow('Family Doctor', info['doctorName']),
        _buildInfoRow('Doctor Phone', info['doctorPhone'], isReadOnly: false),
      ],
    );
  }

  Widget _buildAuthorizedPickupSection(List pickupList) {
    return _buildSectionCard(
      title: 'Authorized Pickup Persons',
      icon: LucideIcons.shieldCheck,
      children: pickupList.map<Widget>((p) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFFF3FDF7),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: const Color(0xFFDCFCE7)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.userCheck, color: Color(0xFF22C55E), size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    Text('${p['relation']} · ${p['phone']}', style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A68))),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDocumentsSection(List docs) {
    return _buildSectionCard(
      title: 'Documents & Verification',
      icon: LucideIcons.fileText,
      children: docs.map<Widget>((doc) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F8FF),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.file, color: Color(0xFF6C4CF1), size: 18),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    Text(doc['size'], style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A9D))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(doc['status'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
