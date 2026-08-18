import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';
import 'teacher_search_bar.dart';

class TeacherResourcesScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;

  const TeacherResourcesScreen({
    super.key,
    required this.data,
    this.onBack,
  });

  @override
  State<TeacherResourcesScreen> createState() => _TeacherResourcesScreenState();
}

class _TeacherResourcesScreenState extends State<TeacherResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = false;
  String _activeFilter = 'All'; // 'All', 'Folders', 'Files', 'PDFs', 'Media'
  final String _sortBy = 'modified'; // 'modified', 'name_asc', 'name_desc', 'size', 'type'

  // Navigation Stack for Folder Hierarchy (root is 'root')
  List<Map<String, String>> _navStack = [
    {'id': 'root', 'name': 'Resources'}
  ];

  String get _currentFolderId => _navStack.last['id']!;
  String get _currentFolderName => _navStack.last['name']!;
  bool get _isAtRoot => _navStack.length == 1;

  late List<Map<String, dynamic>> _folders;
  late List<Map<String, dynamic>> _files;

  @override
  void initState() {
    super.initState();
    _initFileSystem();
  }

  void _initFileSystem() {
    _folders = [
      {
        'id': 'f-10a',
        'name': 'Class 10-A',
        'parentId': 'root',
        'color': const Color(0xFF6C4CF1),
        'updated': '2 hours ago',
        'updatedAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': 'f-10b',
        'name': 'Class 10-B',
        'parentId': 'root',
        'color': const Color(0xFF6C4CF1),
        'updated': '1 day ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': 'f-9c',
        'name': 'Class 9-C',
        'parentId': 'root',
        'color': const Color(0xFF6C4CF1),
        'updated': '3 days ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'id': 'f-study',
        'name': 'Study Materials',
        'parentId': 'root',
        'color': const Color(0xFF06B6D4),
        'updated': 'Yesterday',
        'updatedAt': DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      },
      {
        'id': 'f-assignments',
        'name': 'Assignments',
        'parentId': 'root',
        'color': const Color(0xFFF59E0B),
        'updated': '4 days ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 4)),
      },
      {
        'id': 'f-homework',
        'name': 'Homework',
        'parentId': 'root',
        'color': const Color(0xFFEC4899),
        'updated': '5 days ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': 'f-exams',
        'name': 'Exams',
        'parentId': 'root',
        'color': const Color(0xFFEF4444),
        'updated': '1 week ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 7)),
      },
      {
        'id': 'f-worksheets',
        'name': 'Worksheets',
        'parentId': 'root',
        'color': const Color(0xFF10B981),
        'updated': '2 days ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 2)),
      },

      // Subfolders inside Class 10-A
      {
        'id': 'f-10a-math',
        'name': 'Mathematics',
        'parentId': 'f-10a',
        'color': const Color(0xFF6C4CF1),
        'updated': '2 hours ago',
        'updatedAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': 'f-10a-sci',
        'name': 'Science & Lab',
        'parentId': 'f-10a',
        'color': const Color(0xFF10B981),
        'updated': 'Yesterday',
        'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': 'f-10a-rev',
        'name': 'Revision Notes',
        'parentId': 'f-10a',
        'color': const Color(0xFFF59E0B),
        'updated': '3 days ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 3)),
      },

      // Subfolders inside Study Materials
      {
        'id': 'f-sm-calculus',
        'name': 'Calculus & Algebra',
        'parentId': 'f-study',
        'color': const Color(0xFF06B6D4),
        'updated': 'Yesterday',
        'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': 'f-sm-physics',
        'name': 'Physics Electromagnetism',
        'parentId': 'f-study',
        'color': const Color(0xFF3B82F6),
        'updated': '4 days ago',
        'updatedAt': DateTime.now().subtract(const Duration(days: 4)),
      },
    ];

    _files = [
      {
        'id': 'file-1',
        'name': 'Calculus_Derivatives_Unit4.pdf',
        'folderId': 'root',
        'type': 'PDF',
        'size': '4.2 MB',
        'sizeBytes': 4404019,
        'modified': '12 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 12),
        'sharedWith': 'Class 10-A (Sec A)',
        'description': 'Complete derivation theorems and step-by-step solved examples for Unit 4.',
      },
      {
        'id': 'file-2',
        'name': 'Physics_Electromagnetism_Notes.docx',
        'folderId': 'root',
        'type': 'DOCX',
        'size': '1.8 MB',
        'sizeBytes': 1887436,
        'modified': '11 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 11),
        'sharedWith': null,
        'description': 'Class lecture notes on magnetic flux, Faraday law, and Lenz law applications.',
      },
      {
        'id': 'file-3',
        'name': 'Chemistry_Organic_Reactions.pptx',
        'folderId': 'root',
        'type': 'PPTX',
        'size': '8.5 MB',
        'sizeBytes': 8912896,
        'modified': '10 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 10),
        'sharedWith': 'Class 10-B (Sec B)',
        'description': 'Presentation slides with full animated reaction mechanisms and IUPAC naming.',
      },
      {
        'id': 'file-4',
        'name': 'Class_10A_Term1_Marksheet.xlsx',
        'folderId': 'root',
        'type': 'XLSX',
        'size': '940 KB',
        'sizeBytes': 962560,
        'modified': '09 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 9),
        'sharedWith': null,
        'description': 'Mid-term assessment score breakdown with grades and attendance percentage.',
      },
      {
        'id': 'file-5',
        'name': 'Biology_Cell_Structure_Diagram.png',
        'folderId': 'root',
        'type': 'IMG',
        'size': '3.1 MB',
        'sizeBytes': 3250585,
        'modified': '08 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 8),
        'sharedWith': 'Class 9-C (Sec A)',
        'description': 'High-resolution labeled illustration of plant vs animal cell organelles.',
      },
      {
        'id': 'file-6',
        'name': 'Lab_Experiment_Optics_Demo.mp4',
        'folderId': 'root',
        'type': 'VID',
        'size': '24.6 MB',
        'sizeBytes': 25794969,
        'modified': '07 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 7),
        'sharedWith': 'Class 10-A (Sec A)',
        'description': 'Recorded video demonstration of convex lens focal length determination.',
      },
      {
        'id': 'file-7',
        'name': 'Linear_Algebra_Practice_Set.pdf',
        'folderId': 'f-10a-math',
        'type': 'PDF',
        'size': '2.1 MB',
        'sizeBytes': 2202009,
        'modified': '06 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 6),
        'sharedWith': 'Class 10-A (Sec A)',
        'description': 'Matrices and determinants practice problem set with solution keys.',
      },
      {
        'id': 'file-8',
        'name': 'Lab_Safety_Protocol_Guidelines.txt',
        'folderId': 'f-10a-sci',
        'type': 'TXT',
        'size': '18 KB',
        'sizeBytes': 18432,
        'modified': '05 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 5),
        'sharedWith': null,
        'description': 'Standard operating procedures for chemical storage and eye protection.',
      },
      {
        'id': 'file-9',
        'name': 'Limits_Continuity_Worksheet.pdf',
        'folderId': 'f-sm-calculus',
        'type': 'PDF',
        'size': '1.5 MB',
        'sizeBytes': 1572864,
        'modified': '04 Aug 2026',
        'modifiedAt': DateTime(2026, 8, 4),
        'sharedWith': 'Class 10-A (Sec A)',
        'description': 'Practice worksheet on limits at infinity and squeeze theorem.',
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── FOLDER NAVIGATION & STACK ───────────────────────────────────────────
  void _openFolder(String folderId, String folderName) {
    setState(() {
      _navStack.add({'id': folderId, 'name': folderName});
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _navigateToBreadcrumb(int index) {
    setState(() {
      _navStack = _navStack.sublist(0, index + 1);
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _navigateUp() {
    if (_navStack.length > 1) {
      setState(() {
        _navStack.removeLast();
        _searchQuery = '';
        _searchController.clear();
      });
    } else if (widget.onBack != null) {
      widget.onBack!();
    }
  }

  int _countFilesInFolder(String folderId) {
    return _files.where((f) => f['folderId'] == folderId).length;
  }

  // ─── SORT & FILTER ENGINE ────────────────────────────────────────────────
  List<Map<String, dynamic>> _getFilteredFolders() {
    final q = _searchQuery.toLowerCase().trim();
    List<Map<String, dynamic>> list;

    if (q.isNotEmpty) {
      list = _folders.where((f) => (f['name'] as String).toLowerCase().contains(q)).toList();
    } else {
      list = _folders.where((f) => f['parentId'] == _currentFolderId).toList();
    }

    if (_activeFilter == 'Files' || _activeFilter == 'PDFs' || _activeFilter == 'Media') {
      return [];
    }

    _sortList(list, isFolder: true);
    return list;
  }

  List<Map<String, dynamic>> _getFilteredFiles() {
    final q = _searchQuery.toLowerCase().trim();
    List<Map<String, dynamic>> list;

    if (q.isNotEmpty) {
      list = _files.where((file) {
        final name = (file['name'] as String).toLowerCase();
        final type = (file['type'] as String).toLowerCase();
        return name.contains(q) || type.contains(q);
      }).toList();
    } else {
      list = _files.where((file) => file['folderId'] == _currentFolderId).toList();
    }

    if (_activeFilter == 'Folders') return [];
    if (_activeFilter == 'PDFs') {
      list = list.where((f) => f['type'] == 'PDF').toList();
    } else if (_activeFilter == 'Media') {
      list = list.where((f) => f['type'] == 'IMG' || f['type'] == 'VID').toList();
    }

    _sortList(list, isFolder: false);
    return list;
  }

  void _sortList(List<Map<String, dynamic>> list, {required bool isFolder}) {
    switch (_sortBy) {
      case 'name_asc':
        list.sort((a, b) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
        break;
      case 'name_desc':
        list.sort((a, b) => (b['name'] as String).toLowerCase().compareTo((a['name'] as String).toLowerCase()));
        break;
      case 'size':
        if (!isFolder) {
          list.sort((a, b) => (b['sizeBytes'] as int? ?? 0).compareTo(a['sizeBytes'] as int? ?? 0));
        }
        break;
      case 'type':
        if (!isFolder) {
          list.sort((a, b) => (a['type'] as String).compareTo(b['type'] as String));
        }
        break;
      case 'modified':
      default:
        list.sort((a, b) {
          final DateTime dtA = (a['updatedAt'] ?? a['modifiedAt'] ?? DateTime(2026)) as DateTime;
          final DateTime dtB = (b['updatedAt'] ?? b['modifiedAt'] ?? DateTime(2026)) as DateTime;
          return dtB.compareTo(dtA);
        });
    }
  }

  // ─── + ADD MODAL (NEW FOLDER & UPLOAD FILE ONLY) ───────────────────────────
  void _showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  _isAtRoot ? 'Add to Resources' : 'Add to "$_currentFolderName"',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 14),

                // Option 1: New Folder
                _buildActionTile(
                  icon: LucideIcons.folderPlus,
                  iconColor: const Color(0xFF6C4CF1),
                  title: 'New Folder',
                  subtitle: 'Create a new folder in $_currentFolderName',
                  onTap: () {
                    Navigator.pop(context);
                    _showCreateFolderDialog();
                  },
                ),

                // Option 2: Upload File
                _buildActionTile(
                  icon: LucideIcons.cloudUpload,
                  iconColor: const Color(0xFF10B981),
                  title: 'Upload File',
                  subtitle: 'Drag & drop or browse Notes, Images, PPT, PDF',
                  onTap: () {
                    Navigator.pop(context);
                    _showUploadFileDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── CREATE FOLDER ────────────────────────────────────────────────────────
  void _showCreateFolderDialog() {
    final nameController = TextEditingController(text: 'Math');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('New Folder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E1E2D))),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Folder Name (e.g. Math)',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
              filled: true,
              fillColor: const Color(0xFFF8F7FC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEBE8F4))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newFolder = {
                    'id': 'f-${DateTime.now().millisecondsSinceEpoch}',
                    'name': name,
                    'parentId': _currentFolderId,
                    'color': const Color(0xFF6C4CF1),
                    'updated': 'Just now',
                    'updatedAt': DateTime.now(),
                  };

                  setState(() {
                    _folders.insert(0, newFolder);
                  });

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // ─── DRAG & DROP MULTI-FILE UPLOAD MODAL ────────────────────────────────────
  void _showUploadFileDialog() {
    List<Map<String, dynamic>> stagedFiles = [
      {
        'name': 'Calculus_Derivatives_Unit4.pdf',
        'type': 'PDF',
        'size': '2.4 MB',
        'sizeBytes': 2516582,
        'icon': LucideIcons.fileText,
        'color': const Color(0xFFEF4444),
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            void addFilePreset(String name, String type, String size, int sizeBytes, IconData icon, Color color) {
              setDlgState(() {
                stagedFiles.add({
                  'name': name,
                  'type': type,
                  'size': size,
                  'sizeBytes': sizeBytes,
                  'icon': icon,
                  'color': color,
                });
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upload Files',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F0FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Step 1: Upload',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4CF1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload into "$_currentFolderName". Supports multiple files.',
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 14),

                    // ─── DRAG & DROP UPLOAD AREA ────────────────────────────
                    GestureDetector(
                      onTap: () {
                        addFilePreset(
                          'Physics_Optics_Lecture_Slides.pptx',
                          'PPTX',
                          '4.8 MB',
                          5033164,
                          LucideIcons.presentation,
                          const Color(0xFFEA580C),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBFBFE),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFDDD6FE),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F0FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.cloudUpload, color: Color(0xFF6C4CF1), size: 24),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Drag & drop files here',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'or tap to browse files on your device',
                              style: TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF6C4CF1)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.folderOpen, size: 14, color: Color(0xFF6C4CF1)),
                                  SizedBox(width: 6),
                                  Text(
                                    'Browse Files',
                                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick Format Add Strip
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildQuickFormatPill('+ Notes / Doc', LucideIcons.fileSpreadsheet, const Color(0xFF2563EB), () {
                            addFilePreset('Chapter_Summary_Notes.docx', 'DOCX', '1.6 MB', 1677721, LucideIcons.fileSpreadsheet, const Color(0xFF2563EB));
                          }),
                          const SizedBox(width: 6),
                          _buildQuickFormatPill('+ Image', LucideIcons.image, const Color(0xFF8B5CF6), () {
                            addFilePreset('Lab_Apparatus_Diagram.png', 'IMG', '3.2 MB', 3355443, LucideIcons.image, const Color(0xFF8B5CF6));
                          }),
                          const SizedBox(width: 6),
                          _buildQuickFormatPill('+ PPT', LucideIcons.presentation, const Color(0xFFEA580C), () {
                            addFilePreset('Unit_Presentation_Slides.pptx', 'PPTX', '5.1 MB', 5347737, LucideIcons.presentation, const Color(0xFFEA580C));
                          }),
                          const SizedBox(width: 6),
                          _buildQuickFormatPill('+ PDF', LucideIcons.fileText, const Color(0xFFEF4444), () {
                            addFilePreset('Worksheet_Practice_Set.pdf', 'PDF', '1.9 MB', 1992294, LucideIcons.fileText, const Color(0xFFEF4444));
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ─── STAGED FILES LIST ──────────────────────────────────
                    if (stagedFiles.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Files (${stagedFiles.length})',
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                          ),
                          const Text(
                            'Tap ✕ to remove',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      ...stagedFiles.asMap().entries.map((entry) {
                        final index = entry.key;
                        final f = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F7FC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEBE8F4)),
                          ),
                          child: Row(
                            children: [
                              _buildFileTypeIcon(f['type'] as String, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      f['name'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E2D)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${f['type']} • ${f['size']}',
                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setDlgState(() {
                                    stagedFiles.removeAt(index);
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 14),
                    ],

                    // ─── UPLOAD BUTTON CTA ──────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: stagedFiles.isEmpty
                            ? null
                            : () {
                                Navigator.pop(context);
                                _startMultiFileUploadFlow(stagedFiles);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        icon: const Icon(LucideIcons.fileUp, size: 17, color: Colors.white),
                        label: Text(
                          stagedFiles.length > 1
                              ? 'Upload ${stagedFiles.length} Files & Continue to Share'
                              : 'Upload & Continue to Share',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickFormatPill(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEBE8F4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
            ),
          ],
        ),
      ),
    );
  }

  void _startMultiFileUploadFlow(List<Map<String, dynamic>> stagedFiles) {
    double progress = 0.0;
    final int count = stagedFiles.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dlgContext) {
        return StatefulBuilder(
          builder: (context, setProgressState) {
            Timer.periodic(const Duration(milliseconds: 60), (timer) {
              if (progress >= 1.0) {
                timer.cancel();
                if (Navigator.canPop(dlgContext)) {
                  Navigator.pop(dlgContext);
                }
              } else {
                setProgressState(() {
                  progress = (progress + 0.25).clamp(0.0, 1.0);
                });
              }
            });

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.cloudUpload, size: 36, color: Color(0xFF6C4CF1)),
                    const SizedBox(height: 12),
                    Text(
                      count > 1 ? 'Uploading $count files...' : 'Uploading "${stagedFiles.first['name']}"',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFF3F0FF),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toInt()}% • Uploading to $_currentFolderName',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 550), () {
      final List<Map<String, dynamic>> newlyAdded = [];

      for (var f in stagedFiles) {
        final newFile = {
          'id': 'file-${DateTime.now().millisecondsSinceEpoch}-${newlyAdded.length}',
          'name': f['name'] as String,
          'folderId': _currentFolderId,
          'type': f['type'] as String,
          'size': f['size'] as String,
          'sizeBytes': f['sizeBytes'] as int? ?? 2097152,
          'modified': 'Today, Just now',
          'modifiedAt': DateTime.now(),
          'sharedWith': null,
          'description': 'Uploaded by teacher on ${DateTime.now().day} Aug 2026.',
        };
        newlyAdded.add(newFile);
      }

      setState(() {
        for (var nf in newlyAdded) {
          _files.insert(0, nf);
        }
      });

      if (!mounted) return;

      _showShareDialog(newlyAdded.first, additionalCount: count - 1, isAfterUpload: true);
    });
  }

  // ─── SHARE WITH CLASS MODAL ───────────────────────────────────────────────
  void _showShareDialog(Map<String, dynamic> file, {int additionalCount = 0, bool isAfterUpload = false}) {
    String selectedClass = 'Class 10-A';
    String selectedSection = 'Section A';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final fileNameDisplay = additionalCount > 0
                ? '${file['name']} (+ $additionalCount more)'
                : file['name'] ?? '';

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Share with Class',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (isAfterUpload)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.check, size: 12, color: Color(0xFF10B981)),
                                SizedBox(width: 4),
                                Text(
                                  'Uploaded',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose which class receives immediate access to this resource.',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 14),

                    // Selected File Preview Pill
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F7FC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEBE8F4)),
                      ),
                      child: Row(
                        children: [
                          _buildFileTypeIcon(file['type'] ?? 'PDF', size: 32),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              fileNameDisplay,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E1E2D)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            file['size'] ?? '',
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Select Class Selector
                    const Text('Select Class', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: ['Class 10-A', 'Class 10-B', 'Class 9-C'].map((cls) {
                          final isSelected = cls == selectedClass;
                          return GestureDetector(
                            onTap: () => setSheetState(() => selectedClass = cls),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF8F7FC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8F4),
                                ),
                              ),
                              child: Text(
                                cls,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Select Section Selector
                    const Text('Select Section', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: ['Section A', 'Section B', 'All Sections'].map((sec) {
                          final isSelected = sec == selectedSection;
                          return GestureDetector(
                            onTap: () => setSheetState(() => selectedSection = sec),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF8F7FC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8F4),
                                ),
                              ),
                              child: Text(
                                sec,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF1E1E2D),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Share Button CTA
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final sharedTag = '$selectedClass – $selectedSection';
                          setState(() {
                            file['sharedWith'] = sharedTag;
                          });
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('✓ Shared successfully with $selectedClass – $selectedSection')),
                                ],
                              ),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        icon: const Icon(LucideIcons.share2, size: 17, color: Colors.white),
                        label: Text(
                          'Share with $selectedClass',
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    if (isAfterUpload) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Skip Sharing (Keep in Folder Only)',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─── RICH INTERACTIVE FILE PREVIEWERS ─────────────────────────────────────
  void _openFileViewer(Map<String, dynamic> file) {
    final String type = (file['type'] ?? '').toString().toUpperCase();

    switch (type) {
      case 'PDF':
        _openPdfViewer(file);
        break;
      case 'DOC':
      case 'DOCX':
        _openDocxViewer(file);
        break;
      case 'PPT':
      case 'PPTX':
        _openPptxViewer(file);
        break;
      case 'XLS':
      case 'XLSX':
        _openXlsxViewer(file);
        break;
      case 'IMG':
      case 'PNG':
      case 'JPG':
        _openImageViewer(file);
        break;
      case 'VID':
      case 'MP4':
        _openVideoViewer(file);
        break;
      case 'TXT':
        _openTxtViewer(file);
        break;
      default:
        _openUnsupportedViewer(file);
    }
  }

  // 1. Dedicated Interactive PDF Viewer
  void _openPdfViewer(Map<String, dynamic> file) {
    int currentPage = 1;
    const int totalPages = 6;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2D),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPdfState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFF13131F),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.fileText, color: Color(0xFFEF4444), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            file['name'] ?? 'Document.pdf',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.share2, color: Colors.white, size: 18),
                          onPressed: () {
                            Navigator.pop(context);
                            _showShareDialog(file);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit 4: Differential Calculus ($currentPage / $totalPages)',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                              ),
                              const SizedBox(height: 4),
                              Text('Teacher Notes • Sunrise Academy • Prof. Sharma', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
                              const Divider(height: 20),
                              const Text(
                                'Theorem 4.1 (Chain Rule Formulation):\nLet y = f(u) be a differentiable function of u and u = g(x) be a differentiable function of x. Then the composite function y = f(g(x)) is differentiable with respect to x and:\n\n   dy/dx = (dy/du) • (du/dx)\n\nExample Problem 1:\nDifferentiate y = sin(x² + 3x + 1) with respect to x.\n\nSolution Step 1: Let u = x² + 3x + 1, so y = sin(u).\nStep 2: dy/du = cos(u), and du/dx = 2x + 3.\nStep 3: dy/dx = cos(x² + 3x + 1) • (2x + 3).\n\nKey Practice Questions:\n1. Evaluate derivative of f(x) = ln(cos(x))\n2. Find critical points for g(x) = x³ - 6x² + 9x + 2\n3. Determine concavity inflection points for h(x) = e^(-x²)',
                                style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF2D3748), fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: const Color(0xFF13131F),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                          onPressed: currentPage > 1 ? () => setPdfState(() => currentPage--) : null,
                        ),
                        Text(
                          'Page $currentPage of $totalPages',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded, color: Colors.white),
                          onPressed: currentPage < totalPages ? () => setPdfState(() => currentPage++) : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 2. Dedicated Interactive DOCX Viewer
  void _openDocxViewer(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.88,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    const Icon(LucideIcons.fileSpreadsheet, color: Color(0xFF2563EB), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['name'] ?? 'Document.docx',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E2D)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${file['size']} • Word Document', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF1E1E2D)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Physics: Electromagnetism & Induction Lecture Notes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 6),
                    const Text('Prepared for Class 10 Science • Term 1 Syllabus', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.info, size: 18, color: Color(0xFF2563EB)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Students are advised to review Chapter 13 before attempting the numerical section.',
                              style: TextStyle(fontSize: 12.5, color: Color(0xFF1E40AF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '1. Magnetic Field Due to Current-Carrying Conductor\n\nWhen electric current flows through a metallic wire, a magnetic field is produced around it. The direction of the magnetic field lines can be determined using the Right-Hand Thumb Rule.\n\n2. Fleming\'s Left-Hand Rule\n\nStretch the thumb, forefinger, and middle finger of your left hand mutually perpendicular to each other. If the forefinger points in the direction of magnetic field and middle finger in direction of current, then thumb points in the direction of motion or force acting on the conductor.\n\n3. Electromagnetic Induction (Faraday\'s Law)\n\nThe phenomenon of generating electric current in a coil by relative motion between the coil and a magnet is called electromagnetic induction. Induced EMF is directly proportional to rate of change of magnetic flux linkage.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Dedicated Interactive PPTX Presentation Slide Viewer
  void _openPptxViewer(Map<String, dynamic> file) {
    int slideIndex = 1;
    const int totalSlides = 5;

    final List<Map<String, String>> slides = [
      {'title': 'Organic Chemistry: Hydrocarbons', 'content': 'Introduction to Alkanes, Alkenes & Alkynes\nClass 10 Chemistry • Unit 3'},
      {'title': '1. Nomenclature of Alkanes', 'content': '• Saturated hydrocarbons with single C-C bond\n• General formula: CnH2n+2\n• Methane (CH4), Ethane (C2H6), Propane (C3H8)'},
      {'title': '2. Functional Groups', 'content': '• Alcohols (-OH)\n• Aldehydes (-CHO)\n• Ketones (>C=O)\n• Carboxylic Acids (-COOH)'},
      {'title': '3. Homologous Series', 'content': '• Series of compounds having same functional group\n• Successive members differ by -CH2- unit\n• Uniform chemical properties across series'},
      {'title': 'Summary & Homework Assignment', 'content': '• Practice IUPAC nomenclature worksheet\n• Review questions on Page 84 of NCERT textbook'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2D),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPptState) {
            final currentSlide = slides[slideIndex - 1];

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFF13131F),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.presentation, color: Color(0xFFEA580C), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            file['name'] ?? 'Presentation.pptx',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentSlide['title']!,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                            ),
                            const Divider(height: 24, thickness: 2, color: Color(0xFFEA580C)),
                            Text(
                              currentSlide['content']!,
                              style: const TextStyle(fontSize: 14.5, height: 1.6, color: Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: const Color(0xFF13131F),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: slideIndex > 1 ? () => setPptState(() => slideIndex--) : null,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D2D42), foregroundColor: Colors.white),
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: const Text('Prev'),
                        ),
                        Text(
                          'Slide $slideIndex / $totalSlides',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        ElevatedButton.icon(
                          onPressed: slideIndex < totalSlides ? () => setPptState(() => slideIndex++) : null,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C), foregroundColor: Colors.white),
                          label: const Text('Next'),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 4. Dedicated Interactive XLSX Spreadsheet Viewer
  void _openXlsxViewer(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    const Icon(LucideIcons.sheet, color: Color(0xFF16A34A), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['name'] ?? 'Spreadsheet.xlsx',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E2D)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${file['size']} • Microsoft Excel Worksheet', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF1E1E2D)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFFF8F7FC),
                child: const Row(
                  children: [
                    Text('fx', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF16A34A), fontStyle: FontStyle.italic)),
                    SizedBox(width: 10),
                    Text('=AVERAGE(B2:E2)', style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: Color(0xFF1E1E2D))),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                      columns: const [
                        DataColumn(label: Text('Roll No', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Maths (50)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Physics (50)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Total (100)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('01')), DataCell(Text('Aarav Sharma')), DataCell(Text('48')), DataCell(Text('46')), DataCell(Text('94')), DataCell(Text('A+'))]),
                        DataRow(cells: [DataCell(Text('02')), DataCell(Text('Ananya Roy')), DataCell(Text('45')), DataCell(Text('44')), DataCell(Text('89')), DataCell(Text('A'))]),
                        DataRow(cells: [DataCell(Text('03')), DataCell(Text('Dev Patel')), DataCell(Text('42')), DataCell(Text('38')), DataCell(Text('80')), DataCell(Text('A'))]),
                        DataRow(cells: [DataCell(Text('04')), DataCell(Text('Isha Gupta')), DataCell(Text('50')), DataCell(Text('49')), DataCell(Text('99')), DataCell(Text('A+'))]),
                        DataRow(cells: [DataCell(Text('05')), DataCell(Text('Kabir Mehta')), DataCell(Text('39')), DataCell(Text('41')), DataCell(Text('80')), DataCell(Text('A'))]),
                        DataRow(cells: [DataCell(Text('06')), DataCell(Text('Neha Reddy')), DataCell(Text('47')), DataCell(Text('45')), DataCell(Text('92')), DataCell(Text('A+'))]),
                        DataRow(cells: [DataCell(Text('07')), DataCell(Text('Rohan Verma')), DataCell(Text('35')), DataCell(Text('33')), DataCell(Text('68')), DataCell(Text('B+'))]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. Dedicated Interactive Image Viewer
  void _openImageViewer(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      file['name'] ?? 'Image.png',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.image, size: 72, color: Color(0xFF8B5CF6)),
                    const SizedBox(height: 12),
                    Text(
                      file['name'] ?? 'Diagram',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    const Text('3840 x 2160 • High Resolution Scientific Diagram', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showShareDialog(file);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(LucideIcons.share2, size: 16),
                      label: const Text('Share'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 6. Dedicated Interactive Video Player Viewer
  void _openVideoViewer(Map<String, dynamic> file) {
    bool isPlaying = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setVidState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.video, color: Color(0xFFD946EF), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            file['name'] ?? 'Video.mp4',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xFF13131F),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => setVidState(() => isPlaying = !isPlaying),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C4CF1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFF6C4CF1).withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 4),
                                ],
                              ),
                              child: Icon(
                                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isPlaying ? 'Playing Lecture Demonstration...' : 'Tap to Play Video (1080p Full HD)',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFF13131F),
                    child: const Column(
                      children: [
                        LinearProgressIndicator(
                          value: 0.35,
                          backgroundColor: Color(0xFF2D2D42),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('02:45', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('08:12 (1.0x)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 7. Dedicated Interactive TXT Viewer
  void _openTxtViewer(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    const Icon(LucideIcons.fileCode, color: Color(0xFF6C4CF1), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        file['name'] ?? 'File.txt',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E2D)),
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFF8F7FC),
                  child: const SingleChildScrollView(
                    child: Text(
                      '# SCIENCE LAB SAFETY PROTOCOLS (2026-2027)\n\n1. Mandatory Personal Protective Equipment (PPE):\n   - Safety goggles must be worn during all acid/base titrations.\n   - Lab coats required for chemistry practicals.\n\n2. Emergency Response:\n   - Eyewash station located at Sector B-2.\n   - Fire extinguisher inspected on 1st of every month.\n\n3. Waste Disposal:\n   - Organic solvents must be disposed in yellow biohazard drum.\n   - Broken glassware goes into designated blue puncture-proof bins.\n\nApproved by: Department of Science & Laboratory Oversight Committee',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5, color: Color(0xFF1E1E2D)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 8. Unsupported Format Handler
  void _openUnsupportedViewer(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Cannot Preview File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E1E2D))),
          content: Text(
            'The file "${file['name']}" is in a format that cannot be previewed directly in app. You can download or share it.',
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _downloadFile(file);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(LucideIcons.download, size: 16),
              label: const Text('Download File', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // ─── FILE ACTIONS (OPEN, DOWNLOAD, SHARE, RENAME, MOVE, DELETE) ───────────

  void _showFileActionsBottomSheet(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildFileTypeIcon(file['type'] ?? 'PDF', size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${file['size']} • ${file['modified']}${file['sharedWith'] != null ? ' • Shared with ${file['sharedWith']}' : ''}',
                            style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0EDF8)),
                const SizedBox(height: 8),

                _buildSheetActionTile(
                  icon: LucideIcons.eye,
                  title: 'Open / Preview',
                  onTap: () {
                    Navigator.pop(context);
                    _openFileViewer(file);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.download,
                  title: 'Download',
                  onTap: () {
                    Navigator.pop(context);
                    _downloadFile(file);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.share2,
                  iconColor: const Color(0xFF6C4CF1),
                  title: 'Share with Class',
                  onTap: () {
                    Navigator.pop(context);
                    _showShareDialog(file);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.folderInput,
                  iconColor: const Color(0xFF06B6D4),
                  title: 'Move File',
                  onTap: () {
                    Navigator.pop(context);
                    _showMoveFileDialog(file);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.penSquare,
                  title: 'Rename',
                  onTap: () {
                    Navigator.pop(context);
                    _showRenameFileDialog(file);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.trash2,
                  iconColor: const Color(0xFFEF4444),
                  title: 'Delete',
                  textColor: const Color(0xFFEF4444),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteFile(file);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _downloadFile(Map<String, dynamic> file) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('Downloaded "${file['name']}" to device storage.')),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showMoveFileDialog(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text('Move "${file['name']}"', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                const SizedBox(height: 4),
                const Text('Select destination folder:', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                const SizedBox(height: 12),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: const Icon(LucideIcons.folder, color: Color(0xFF6C4CF1)),
                        title: const Text('Resources (Root Folder)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                        onTap: () {
                          setState(() => file['folderId'] = 'root');
                          Navigator.pop(context);
                          _showMoveSuccessSnackBar(file['name'], 'Resources');
                        },
                      ),
                      const Divider(height: 1),
                      ..._folders.map((f) {
                        final isCurrent = file['folderId'] == f['id'];
                        return ListTile(
                          leading: Icon(LucideIcons.folder, color: f['color'] as Color),
                          title: Text(f['name'], style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500, fontSize: 13.5)),
                          trailing: isCurrent ? const Text('Current', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))) : null,
                          onTap: isCurrent
                              ? null
                              : () {
                                  setState(() => file['folderId'] = f['id']);
                                  Navigator.pop(context);
                                  _showMoveSuccessSnackBar(file['name'], f['name']);
                                },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoveSuccessSnackBar(String fileName, String destinationName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "$fileName" to "$destinationName"'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showRenameFileDialog(Map<String, dynamic> file) {
    final controller = TextEditingController(text: file['name']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Rename File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E1E2D))),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F7FC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEBE8F4))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    file['name'] = newName;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Rename', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _deleteFile(Map<String, dynamic> file) {
    final deletedIndex = _files.indexOf(file);
    setState(() {
      _files.remove(file);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${file['name']}"'),
        backgroundColor: const Color(0xFF1E1E2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF6C4CF1),
          onPressed: () {
            setState(() {
              _files.insert(deletedIndex, file);
            });
          },
        ),
      ),
    );
  }

  // ─── FOLDER ACTIONS ───────────────────────────────────────────────────────
  void _showFolderActionsBottomSheet(Map<String, dynamic> folder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Row(
                  children: [
                    Icon(LucideIcons.folder, color: folder['color'] as Color, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        folder['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E1E2D)),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _buildSheetActionTile(
                  icon: LucideIcons.folderOpen,
                  title: 'Open Folder',
                  onTap: () {
                    Navigator.pop(context);
                    _openFolder(folder['id'], folder['name']);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.penSquare,
                  title: 'Rename Folder',
                  onTap: () {
                    Navigator.pop(context);
                    _showRenameFolderDialog(folder);
                  },
                ),
                _buildSheetActionTile(
                  icon: LucideIcons.trash2,
                  iconColor: const Color(0xFFEF4444),
                  title: 'Delete Folder',
                  textColor: const Color(0xFFEF4444),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _folders.remove(folder);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted "${folder['name']}"')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRenameFolderDialog(Map<String, dynamic> folder) {
    final controller = TextEditingController(text: folder['name']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Rename Folder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F7FC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  setState(() => folder['name'] = newName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  // ─── MAIN BUILD METHOD ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filteredFolders = _getFilteredFolders();
    final filteredFiles = _getFilteredFiles();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header Row (Title, Breadcrumbs, Grid/List, + Add)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  if (widget.onBack != null || !_isAtRoot) ...[
                    AppBackButton(onPressed: _navigateUp),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _isAtRoot ? 'Resources' : _currentFolderName,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Grid / List View Toggle
                  IconButton(
                    icon: Icon(
                      _isGridView ? LucideIcons.layoutList : LucideIcons.layoutGrid,
                      size: 19,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                    tooltip: 'Toggle Grid / List',
                  ),

                  // + Add / + Upload Button
                  ElevatedButton.icon(
                    onPressed: _showAddBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Icon(_isAtRoot ? LucideIcons.plus : LucideIcons.fileUp, size: 16, color: Colors.white),
                    label: Text(_isAtRoot ? 'Add' : 'Upload', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // 2. Interactive Breadcrumb Bar (when inside any subfolder)
            if (!_isAtRoot)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(_navStack.length, (index) {
                      final isLast = index == _navStack.length - 1;
                      final node = _navStack[index];

                      return Row(
                        children: [
                          GestureDetector(
                            onTap: isLast ? null : () => _navigateToBreadcrumb(index),
                            child: Text(
                              node['name']!,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                                color: isLast ? const Color(0xFF6C4CF1) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          if (!isLast)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

            // 3. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TeacherSearchBar(
                controller: _searchController,
                hintText: _isAtRoot ? 'Search files and folders...' : 'Search in $_currentFolderName...',
                onChanged: (val) => setState(() => _searchQuery = val),
                onClear: () => setState(() => _searchQuery = ''),
              ),
            ),
            const SizedBox(height: 8),

            // 4. Filter Chips (All, Folders, Files, PDFs, Media)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterPill('All', 'All (${filteredFolders.length + filteredFiles.length})'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Folders', 'Folders (${filteredFolders.length})'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Files', 'Files (${filteredFiles.length})'),
                    const SizedBox(width: 8),
                    _buildFilterPill('PDFs', 'PDFs'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Media', 'Media'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 5. Main Content: Folders & Files (with Empty States & Search handling)
            Expanded(
              child: (filteredFolders.isEmpty && filteredFiles.isEmpty)
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Folders Section
                        if (filteredFolders.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Folders', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              Text('${filteredFolders.length} folders', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                          const SizedBox(height: 8),

                          if (_isGridView)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.45,
                              ),
                              itemCount: filteredFolders.length,
                              itemBuilder: (context, index) => _buildFolderGridCard(filteredFolders[index]),
                            )
                          else
                            ...filteredFolders.map((f) => _buildFolderListRow(f)),
                          const SizedBox(height: 16),
                        ],

                        // Files Section
                        if (filteredFiles.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Files', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                              Text('${filteredFiles.length} files', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                          const SizedBox(height: 8),

                          if (_isGridView)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.22,
                              ),
                              itemCount: filteredFiles.length,
                              itemBuilder: (context, index) => _buildFileGridCard(filteredFiles[index]),
                            )
                          else
                            ...filteredFiles.map((file) => _buildFileListRow(file)),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── EMPTY STATE WIDGET ───────────────────────────────────────────────────
  Widget _buildEmptyState() {
    final bool isSearching = _searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? LucideIcons.folderSearch : LucideIcons.folderClosed,
              size: 48,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 12),
            Text(
              isSearching ? 'No results for "$_searchQuery"' : 'This folder is empty',
              style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 4),
            Text(
              isSearching
                  ? 'Check your spelling or search a different keyword.'
                  : 'Upload teaching files or create subfolders in $_currentFolderName.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 18),
            if (isSearching)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
                child: const Text('Clear Search'),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _showCreateFolderDialog,
                    icon: const Icon(LucideIcons.folderPlus, size: 16),
                    label: const Text('New Folder'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _showUploadFileDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(LucideIcons.fileUp, size: 16),
                    label: const Text('Upload File'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ─── FILTER PILL WIDGET ───────────────────────────────────────────────────
  Widget _buildFilterPill(String filterKey, String label) {
    final isSelected = _activeFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFF8F7FC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8F4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // ─── FOLDER CARDS & ROWS ──────────────────────────────────────────────────
  Widget _buildFolderListRow(Map<String, dynamic> folder) {
    final fileCount = _countFilesInFolder(folder['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDF8)),
        boxShadow: AppShadows.soft,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        onTap: () => _openFolder(folder['id'], folder['name']),
        onLongPress: () => _showFolderActionsBottomSheet(folder),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: (folder['color'] as Color).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(LucideIcons.folder, color: folder['color'] as Color, size: 20),
        ),
        title: Text(
          folder['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF1E1E2D)),
        ),
        subtitle: Text(
          '$fileCount files • ${folder['updated']}',
          style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert_rounded, size: 20, color: Color(0xFF7A7A9D)),
          onPressed: () => _showFolderActionsBottomSheet(folder),
        ),
      ),
    );
  }

  Widget _buildFolderGridCard(Map<String, dynamic> folder) {
    final fileCount = _countFilesInFolder(folder['id']);

    return GestureDetector(
      onTap: () => _openFolder(folder['id'], folder['name']),
      onLongPress: () => _showFolderActionsBottomSheet(folder),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0EDF8)),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: (folder['color'] as Color).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(LucideIcons.folder, color: folder['color'] as Color, size: 18),
                ),
                GestureDetector(
                  onTap: () => _showFolderActionsBottomSheet(folder),
                  child: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text('$fileCount files', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── FILE CARDS & ROWS ────────────────────────────────────────────────────
  Widget _buildFileListRow(Map<String, dynamic> file) {
    final bool isShared = file['sharedWith'] != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDF8)),
        boxShadow: AppShadows.soft,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () => _openFileViewer(file),
        onLongPress: () => _showFileActionsBottomSheet(file),
        leading: _buildFileTypeIcon(file['type'] ?? 'PDF', size: 38),
        title: Text(
          file['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Color(0xFF1E1E2D)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text('${file['size']} • ${file['modified']}', style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B))),
            if (isShared) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    file['sharedWith'],
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert_rounded, size: 20, color: Color(0xFF7A7A9D)),
          onPressed: () => _showFileActionsBottomSheet(file),
        ),
      ),
    );
  }

  Widget _buildFileGridCard(Map<String, dynamic> file) {
    final bool isShared = file['sharedWith'] != null;

    return GestureDetector(
      onTap: () => _openFileViewer(file),
      onLongPress: () => _showFileActionsBottomSheet(file),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0EDF8)),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFileTypeIcon(file['type'] ?? 'PDF', size: 32),
                GestureDetector(
                  onTap: () => _showFileActionsBottomSheet(file),
                  child: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF7A7A9D)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isShared ? file['sharedWith'] : '${file['size']} • ${file['modified']}',
                  style: TextStyle(
                    fontSize: 11.0,
                    color: isShared ? const Color(0xFF6C4CF1) : const Color(0xFF64748B),
                    fontWeight: isShared ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── FILE TYPE ICON HELPER ────────────────────────────────────────────────
  Widget _buildFileTypeIcon(String type, {double size = 36}) {
    Color bg;
    Color fg;
    IconData icon;

    switch (type.toUpperCase()) {
      case 'PDF':
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFEF4444);
        icon = LucideIcons.fileText;
        break;
      case 'DOC':
      case 'DOCX':
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        icon = LucideIcons.fileSpreadsheet;
        break;
      case 'PPT':
      case 'PPTX':
        bg = const Color(0xFFFFF7ED);
        fg = const Color(0xFFEA580C);
        icon = LucideIcons.presentation;
        break;
      case 'XLS':
      case 'XLSX':
        bg = const Color(0xFFF0FDF4);
        fg = const Color(0xFF16A34A);
        icon = LucideIcons.sheet;
        break;
      case 'IMG':
      case 'PNG':
      case 'JPG':
        bg = const Color(0xFFF5F3FF);
        fg = const Color(0xFF8B5CF6);
        icon = LucideIcons.image;
        break;
      case 'VID':
      case 'MP4':
        bg = const Color(0xFFFDF2F8);
        fg = const Color(0xFFD946EF);
        icon = LucideIcons.video;
        break;
      case 'TXT':
        bg = const Color(0xFFF8F7FC);
        fg = const Color(0xFF6C4CF1);
        icon = LucideIcons.fileCode;
        break;
      default:
        bg = const Color(0xFFF8F7FC);
        fg = const Color(0xFF6C4CF1);
        icon = LucideIcons.file;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icon, color: fg, size: size * 0.52),
      ),
    );
  }

  // ─── ACTION LIST TILE HELPER ──────────────────────────────────────────────
  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEBE8F4)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Color(0xFF1E1E2D))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B))),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
      ),
    );
  }

  Widget _buildSheetActionTile({
    required IconData icon,
    Color iconColor = const Color(0xFF64748B),
    required String title,
    Color textColor = const Color(0xFF1E1E2D),
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      leading: Icon(icon, color: iconColor, size: 20),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0, color: textColor)),
    );
  }
}
