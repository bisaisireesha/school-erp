import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SubjectResourcesScreen extends StatefulWidget {
  final Map<String, dynamic> subjectData;
  final VoidCallback onBack;

  const SubjectResourcesScreen({
    super.key,
    required this.subjectData,
    required this.onBack,
  });

  @override
  State<SubjectResourcesScreen> createState() => _SubjectResourcesScreenState();
}

class _SubjectResourcesScreenState extends State<SubjectResourcesScreen> {
  final List<Map<String, dynamic>> _mockFiles = [
    {
      'title': 'Notes 01',
      'type': 'PDF',
      'size': '0.3 MB',
      'date': '01 Jan 2026',
      'uploader': 'Anita Rao',
      'color': const Color(0xFFE11D48),
    },
    {
      'title': 'Question Bank 02',
      'type': 'DOC',
      'size': '0.7 MB',
      'date': '02 Feb 2026',
      'uploader': 'R. Khan',
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Worksheets 03',
      'type': 'Link',
      'size': '1.1 MB',
      'date': '03 Mar 2026',
      'uploader': 'P. Iyer',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Assignments 04',
      'type': 'Video',
      'size': '1.5 MB',
      'date': '04 Apr 2026',
      'uploader': 'V. Gupta',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'Practice Papers 05',
      'type': 'PDF',
      'size': '1.9 MB',
      'date': '05 May 2026',
      'uploader': 'Anita Rao',
      'color': const Color(0xFFE11D48),
    },
    {
      'title': 'Notes 06',
      'type': 'DOC',
      'size': '2.3 MB',
      'date': '06 Jun 2026',
      'uploader': 'R. Khan',
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Question Bank 07',
      'type': 'Link',
      'size': '2.7 MB',
      'date': '07 Jul 2026',
      'uploader': 'P. Iyer',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Worksheets 08',
      'type': 'PDF',
      'size': '1.2 MB',
      'date': '08 Aug 2026',
      'uploader': 'Anita Rao',
      'color': const Color(0xFFE11D48),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
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
                  Text(
                    widget.subjectData['subject'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Row(
                        children: [
                          const Text('Study Material', style: TextStyle(fontSize: 12, color: Color(0xFF6C4CF1), fontWeight: FontWeight.w600)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFFD1D5DB)),
                          ),
                          Text(widget.subjectData['subject'], style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                        ],
                      ),
                    ),
                    
                    // Subject Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(LucideIcons.folder, color: Color(0xFF6C4CF1), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.subjectData['subject'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                const SizedBox(height: 6),
                                Text('Primary • Grade 5 • ${widget.subjectData['resources']} resources', style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.search, color: Color(0xFF9E9E9E), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: const TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search resources...',
                                  hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(LucideIcons.slidersHorizontal, color: const Color(0xFF9E9E9E).withValues(alpha: 0.8), size: 20),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // List Header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TITLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9E9E9E), letterSpacing: 0.5)),
                          Row(
                            children: [
                              Text('LAST UPDATED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9E9E9E), letterSpacing: 0.5)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_downward, size: 12, color: Color(0xFF6C4CF1)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1),
                    
                    // Files List
                    Builder(
                      builder: (context) {
                        if (_mockFiles.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text('No resources found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mockFiles.length,
                          separatorBuilder: (context, index) => const Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1),
                          itemBuilder: (context, index) {
                            return _buildFileItem(_mockFiles[index]);
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file) {
    IconData getFileIcon(String type) {
      switch (type) {
        case 'PDF': return LucideIcons.fileText;
        case 'DOC': return LucideIcons.file;
        case 'Link': return LucideIcons.link;
        case 'Video': return LucideIcons.playSquare;
        default: return LucideIcons.file;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // File Type Icon
          Container(
            width: 44,
            height: 48,
            decoration: BoxDecoration(
              color: file['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(getFileIcon(file['type']), color: file['color'], size: 22),
            ),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: file['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(file['type'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: file['color'])),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('•', style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                    ),
                    Text(file['size'], style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Uploaded by ${file['uploader']}', style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
              ],
            ),
          ),
          
          // Date
          Text(file['date'], style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
          
          const SizedBox(width: 16),
          
          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => _showFilePreview(context, file),
                child: const Icon(LucideIcons.eye, color: Color(0xFF6C6C80), size: 20),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Downloading ${file['title']}...'), 
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                child: const Icon(LucideIcons.downloadCloud, color: Color(0xFF6C6C80), size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilePreview(BuildContext context, Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: file['color'].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(file['type'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: file['color'])),
                        ),
                        const SizedBox(width: 12),
                        Text('File Preview', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF9E9E9E))),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.x, size: 16, color: Color(0xFF1E1E2D)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.fileText, size: 48, color: const Color(0xFFD1D5DB)),
                      const SizedBox(height: 16),
                      const Text('Document Preview', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(file['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Uploaded by ${file['uploader']} • ${file['date']}', style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80))),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading ${file['title']}...'), backgroundColor: const Color(0xFF10B981), behavior: SnackBarBehavior.floating),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(LucideIcons.download, size: 18),
                    label: const Text('Download File', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
