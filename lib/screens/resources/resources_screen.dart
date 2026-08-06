import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'subject_resources_screen.dart';
import '../main_layout.dart';

class ResourcesScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ResourcesScreen({super.key, required this.onBack});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final List<Map<String, dynamic>> _mockFolders = [
    {'subject': 'Mathematics', 'folders': 5, 'resources': 248},
    {'subject': 'English', 'folders': 5, 'resources': 210},
    {'subject': 'Science', 'folders': 5, 'resources': 218},
    {'subject': 'Social Studies', 'folders': 5, 'resources': 195},
    {'subject': 'Computer', 'folders': 4, 'resources': 146},
    {'subject': 'Telugu', 'folders': 4, 'resources': 138},
    {'subject': 'Hindi', 'folders': 4, 'resources': 126},
    {'subject': 'General Knowledge', 'folders': 3, 'resources': 98},
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: MainLayout.globalSearchQuery,
      builder: (context, searchQuery, child) {
        final query = searchQuery.toLowerCase();

        final filteredFolders = _mockFolders.where((folder) {
          if (query.isEmpty) return true;
          return folder['subject'].toString().toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                              ],
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Study Material',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Row
                        Row(
                          children: [
                            Expanded(child: _buildStatCard('Total Folders', '11', LucideIcons.folder)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStatCard('Total Resources', '1,567', LucideIcons.fileText)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Folders Grid
                        if (filteredFolders.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text(
                                'No folders found',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredFolders.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              final folder = filteredFolders[index];
                              return GestureDetector(
                                onTap: () {
                                  MainLayout.pushSubScreen(
                                    context,
                                    SubjectResourcesScreen(
                                      subjectData: folder,
                                      onBack: () => MainLayout.popSubScreen(context),
                                    ),
                                  );
                                },
                                child: _buildSubjectFolderCard(folder),
                              );
                            },
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
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF6C6C80), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFolderCard(Map<String, dynamic> folder) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE8E3F8).withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Folder Icon
          Container(
            width: 48,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 20,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB4A6F8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            folder['subject'],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(LucideIcons.folder, size: 12, color: Color(0xFF6C6C80)),
              const SizedBox(width: 4),
              Text('${folder['folders']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('•', style: TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
              ),
              Text('${folder['resources']} resources', style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Notes • Question Bank • Worksheets • Assignments • Practice Papers',
            style: TextStyle(fontSize: 10, color: Color(0xFF9E9E9E), height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
