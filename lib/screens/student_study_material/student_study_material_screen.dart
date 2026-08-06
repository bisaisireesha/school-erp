import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class StudentStudyMaterialScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const StudentStudyMaterialScreen({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final materials = data['studyMaterial'] as List? ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(onPressed: onBack),
        title: const Text('Study Material & Notes', style: TextStyle(color: Color(0xFF1E1E2D), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final item = materials[index];
          final isVideo = item['type'] == 'Video';

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isVideo ? const Color(0xFFF43F5E).withValues(alpha: 0.12) : const Color(0xFFA855F7).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isVideo ? LucideIcons.video : LucideIcons.fileText,
                    color: isVideo ? const Color(0xFFF43F5E) : const Color(0xFFA855F7),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E2D))),
                      const SizedBox(height: 1),
                      Text('${item['subject']} • ${item['type']} (${isVideo ? item['duration'] : item['size']})', style: const TextStyle(fontSize: 10, color: Color(0xFF7A7A9D))),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isVideo ? LucideIcons.playCircle : LucideIcons.download,
                    color: isVideo ? const Color(0xFFF43F5E) : const Color(0xFFA855F7),
                    size: 20,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isVideo ? 'Playing video tutorial... 🎥' : 'Downloading notes PDF... 📥')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
