import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';
import 'teacher_create_bottom_sheet.dart';

class TeacherStudyMaterialScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherStudyMaterialScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherStudyMaterialScreen> createState() => _TeacherStudyMaterialScreenState();
}

class _TeacherStudyMaterialScreenState extends State<TeacherStudyMaterialScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedClass = 'All Classes';
  String _selectedSubject = 'All Subjects';

  late List<Map<String, dynamic>> _materials;

  List<String> get _classes {
    final classes = widget.data['classes'] as List? ?? [];
    final set = <String>{'All Classes'};
    for (var c in classes) {
      final name = c['className']?.toString();
      if (name != null && name.isNotEmpty) {
        set.add(name);
      }
    }
    return set.toList();
  }

  List<String> get _subjects {
    final profile = widget.data['teacherProfile'] as Map<String, dynamic>? ?? {};
    final list = (profile['assignedSubjects'] as List?)?.map((e) => e.toString()).toList();
    if (list != null && list.isNotEmpty) {
      return ['All Subjects', ...list];
    }
    final classes = widget.data['classes'] as List? ?? [];
    final set = <String>{'All Subjects'};
    for (var c in classes) {
      final subj = c['subject']?.toString();
      if (subj != null && subj.isNotEmpty) {
        set.add(subj);
      }
    }
    return set.toList();
  }

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  void _loadMaterials() {
    final raw = widget.data['studyMaterials'] as List? ?? [];
    final list = raw.map((item) => Map<String, dynamic>.from(item)).toList();
    if (mounted) {
      setState(() {
        _materials = list;
      });
    } else {
      _materials = list;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUploadMaterialModal() {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.studyMaterial,
      classList: _classes.where((c) => c != 'All Classes').toList(),
      subjectList: _subjects.where((s) => s != 'All Subjects').toList(),
      onSubmit: (data) {
        final newMat = {
          'id': 'MAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'title': data['title'] ?? 'Uploaded Study Material',
          'subject': data['subject'] ?? 'Mathematics',
          'className': data['className'] ?? 'Class 10',
          'fileType': data['fileType'] ?? 'PDF',
          'fileSize': data['fileSize'] ?? '3.5 MB',
          'uploadDate': data['uploadDate'] ?? '10 Aug 2026',
          'downloads': 0,
        };

        setState(() {
          _materials.insert(0, newMat);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uploaded "${newMat['title']}" to ${newMat['className']}!'),
            backgroundColor: const Color(0xFF6C4CF1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  void _downloadFile(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.fileDown, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('Downloaded "$title" to local device!')),
          ],
        ),
        backgroundColor: const Color(0xFF6C4CF1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _materials.where((m) {
      if (_selectedClass != 'All Classes' && m['className'] != _selectedClass) return false;
      if (_selectedSubject != 'All Subjects' && m['subject'] != _selectedSubject) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (m['title'] ?? '').toString().toLowerCase().contains(q) ||
          (m['subject'] ?? '').toString().toLowerCase().contains(q) ||
          (m['className'] ?? '').toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  if (widget.onBack != null) ...[
                    AppBackButton(onPressed: widget.onBack!),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Study Material',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_materials.length} Files',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              TeacherSearchBar(
                controller: _searchController,
                hintText: 'Search study notes, slides, formula sheets...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
              const SizedBox(height: 12),

              // Class Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _classes.map((cls) {
                    final isSelected = cls == _selectedClass;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedClass = cls),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF9F8FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
                          ),
                          boxShadow: isSelected ? AppShadows.soft : null,
                        ),
                        child: Text(
                          cls,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // Subject Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _subjects.map((subj) {
                    final isSelected = subj == _selectedSubject;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSubject = subj),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF9F8FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFEBE8FF),
                          ),
                        ),
                        child: Text(
                          subj,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // Materials List
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF0EDF8)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.folderSearch, size: 36, color: Color(0xFF64748B)),
                      SizedBox(height: 10),
                      Text(
                        'No study resources found for this filter',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                    ],
                  ),
                )
              else
                ...filtered.map((mat) => _buildMaterialCard(mat)),
            ],
          ),
        ),
      ),

      // Floating Upload Action
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: _showUploadMaterialModal,
          backgroundColor: const Color(0xFF6C4CF1),
          icon: const Icon(LucideIcons.upload, color: Colors.white, size: 20),
          label: const Text('Upload Resource', style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> mat) {
    final String type = mat['fileType'] ?? 'PDF';
    final isPdf = type == 'PDF';
    final isVideo = type.contains('MP4') || type.contains('Video');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EDF8)),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          // File Type Icon Container
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isPdf
                  ? const Color(0xFFFEF2F2)
                  : isVideo
                      ? const Color(0xFFFFFBEB)
                      : const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPdf
                  ? LucideIcons.fileText
                  : isVideo
                      ? LucideIcons.video
                      : LucideIcons.presentation,
              color: isPdf
                  ? const Color(0xFFEF4444)
                  : isVideo
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF6C4CF1),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mat['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${mat['subject']} • ${mat['className']} • ${mat['fileSize']} • ${mat['uploadDate']}',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Download Action Icon
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () => _downloadFile(mat['title']),
              icon: const Icon(LucideIcons.download, color: Color(0xFF6C4CF1), size: 18),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              tooltip: 'Download Material',
            ),
          ),
        ],
      ),
    );
  }
}
