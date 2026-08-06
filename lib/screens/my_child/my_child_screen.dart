import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:parent_app/screens/main_layout.dart';

const String _mockChildrenDataJson = '''
[
  {
    "studentId": "STU20230014",
    "firstName": "Akshara",
    "lastName": "Sharma",
    "grade": "Grade 5",
    "section": "C",
    "rollNumber": "14",
    "dateOfBirth": "15-May-2012",
    "bloodGroup": "O+",
    "gender": "Female",
    "address": "402, Sunshine Apartments, MG Road, Bangalore - 560001",
    "classTeacher": "Mrs. Kavita Menon",
    "parents": {
      "fatherName": "Ravi Sharma",
      "motherName": "Priya Sharma",
      "primaryContact": "+91 98765 43210"
    },
    "healthInfo": {
      "allergies": "Peanuts",
      "medicalConditions": "None",
      "emergencyContact": "+91 98765 43211"
    }
  },
  {
    "studentId": "STU20230089",
    "firstName": "Aryan",
    "lastName": "Sharma",
    "grade": "Grade 7",
    "section": "B",
    "rollNumber": "22",
    "dateOfBirth": "22-Aug-2012",
    "bloodGroup": "B+",
    "gender": "Female",
    "address": "402, Sunshine Apartments, MG Road, Bangalore - 560001",
    "classTeacher": "John Smith",
    "parents": {
      "fatherName": "Ravi Sharma",
      "motherName": "Priya Sharma",
      "primaryContact": "+91 98765 43210"
    },
    "healthInfo": {
      "allergies": "None",
      "medicalConditions": "Asthma",
      "emergencyContact": "+91 98765 43211"
    }
  }
]
''';

class MyChildScreen extends StatefulWidget {
  final VoidCallback onBack;

  static final List<dynamic> childrenData = jsonDecode(_mockChildrenDataJson);
  static final ValueNotifier<int> selectedChildIndex = ValueNotifier(0);

  const MyChildScreen({super.key, required this.onBack});

  @override
  State<MyChildScreen> createState() => _MyChildScreenState();
}

class _MyChildScreenState extends State<MyChildScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showSwitchChildModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Switch Child', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(LucideIcons.x, size: 20, color: Color(0xFF1E1E2D)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...List.generate(MyChildScreen.childrenData.length, (index) {
              final child = MyChildScreen.childrenData[index];
              final isSelected = index == MyChildScreen.selectedChildIndex.value;
              final Color color = index == 0 ? const Color(0xFF6C4CF1) : const Color(0xFF0EA5E9);
              final Color bgColor = index == 0 ? const Color(0xFFF3F0FF) : const Color(0xFFE0F2FE);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildChildSelectOption(
                  name: '${child["firstName"]} ${child["lastName"]}', 
                  grade: '${child["grade"]} - ${child["section"]}', 
                  initials: '${child["firstName"][0]}${child["lastName"][0]}', 
                  color: color, 
                  bgColor: bgColor, 
                  isSelected: isSelected,
                  onTap: () {
                    MyChildScreen.selectedChildIndex.value = index;
                    Navigator.pop(context);
                  }
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildChildSelectOption({required String name, required String grade, required String initials, required Color color, required Color bgColor, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF3EEFF), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Center(
                child: Text(initials, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFF1E1E2D))),
                  const SizedBox(height: 4),
                  Text(grade, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFF6C4CF1).withValues(alpha: 0.7) : const Color(0xFF6C6C80))),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFF6C4CF1), shape: BoxShape.circle),
                child: const Icon(LucideIcons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6C4CF1)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF6C4CF1), size: 22),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MyChildScreen.selectedChildIndex,
      builder: (context, selectedChildIndex, child) {
        final currentChild = MyChildScreen.childrenData[selectedChildIndex];
        String fullName = '${currentChild["firstName"]} ${currentChild["lastName"]}';
        
        return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Custom Header matching HomeworkScreen
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        MainLayout.popSubScreen(context);
                      },
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
                    const Text('My Child Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const Spacer(),
                    GestureDetector(
                      onTap: _showSwitchChildModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                        ),
                        child: Row(
                          children: const [
                            Icon(LucideIcons.users, size: 16, color: Color(0xFF6C4CF1)),
                            SizedBox(width: 6),
                            Text('Switch', style: TextStyle(color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Profile Overview Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C4CF1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${currentChild["firstName"][0]}${currentChild["lastName"][0]}',
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${currentChild["grade"]} - ${currentChild["section"]} | Roll: ${currentChild["rollNumber"]}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final sections = [
                          _buildSectionCard('Personal Information', LucideIcons.user, [
                            _buildInfoTile('Student ID', currentChild["studentId"], LucideIcons.hash),
                            _buildInfoTile('Date of Birth', currentChild["dateOfBirth"], LucideIcons.calendar),
                            _buildInfoTile('Gender', currentChild["gender"], LucideIcons.user),
                            _buildInfoTile('Blood Group', currentChild["bloodGroup"], LucideIcons.activity),
                            _buildInfoTile('Address', currentChild["address"], LucideIcons.mapPin),
                          ]),
                          _buildSectionCard('Academic Details', LucideIcons.graduationCap, [
                            _buildInfoTile('Grade & Section', '${currentChild["grade"]} - ${currentChild["section"]}', LucideIcons.graduationCap),
                            _buildInfoTile('Roll Number', currentChild["rollNumber"], LucideIcons.fileDigit),
                            _buildInfoTile('Class Teacher', currentChild["classTeacher"], LucideIcons.bookOpen),
                          ]),
                          _buildSectionCard('Health & Emergency', LucideIcons.heartPulse, [
                            _buildInfoTile('Allergies', currentChild["healthInfo"]["allergies"], LucideIcons.alertTriangle),
                            _buildInfoTile('Medical Conditions', currentChild["healthInfo"]["medicalConditions"], LucideIcons.stethoscope),
                            _buildInfoTile('Emergency Contact', currentChild["healthInfo"]["emergencyContact"], LucideIcons.phoneCall),
                          ]),
                          _buildSectionCard('Parents & Guardians', LucideIcons.users, [
                            _buildInfoTile('Father\'s Name', currentChild["parents"]["fatherName"], LucideIcons.user),
                            _buildInfoTile('Mother\'s Name', currentChild["parents"]["motherName"], LucideIcons.user),
                            _buildInfoTile('Primary Contact', currentChild["parents"]["primaryContact"], LucideIcons.phone),
                          ]),
                        ];

                        if (constraints.maxWidth > 900) {
                          return Wrap(
                            spacing: 24,
                            runSpacing: 0,
                            children: sections.map((section) {
                              return SizedBox(
                                width: (constraints.maxWidth - 24) / 2,
                                child: section,
                              );
                            }).toList(),
                          );
                        } else {
                          return Column(
                            children: sections,
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
