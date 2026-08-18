import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

/// Reusable attachment file model
class AttachedFile {
  final String id;
  final String name;
  final String size;
  final String type; // 'pdf', 'doc', 'docx', 'jpg', 'png', 'other'

  const AttachedFile({
    required this.id,
    required this.name,
    required this.size,
    required this.type,
  });
}

/// Unified, consistent Attachment & Upload component for Teacher App
/// Used across Homework, Assignment, Sick Leave Request, and Study Materials.
class TeacherAttachmentPicker extends StatefulWidget {
  final List<AttachedFile> initialFiles;
  final Function(List<AttachedFile> files)? onChanged;
  final String label;
  final String hintText;
  final int maxFiles;

  const TeacherAttachmentPicker({
    super.key,
    this.initialFiles = const [],
    this.onChanged,
    this.label = 'Attachments & Resources',
    this.hintText = 'PDF, DOC, DOCX, JPG, PNG (Max 25MB)',
    this.maxFiles = 5,
  });

  @override
  State<TeacherAttachmentPicker> createState() => _TeacherAttachmentPickerState();
}

class _TeacherAttachmentPickerState extends State<TeacherAttachmentPicker> {
  late List<AttachedFile> _files;

  // Mock pool of sample files for realistic mobile picking
  final List<AttachedFile> _samplePool = const [
    AttachedFile(
      id: 'f1',
      name: 'Class_Worksheet_Chapter4.pdf',
      size: '2.4 MB',
      type: 'pdf',
    ),
    AttachedFile(
      id: 'f2',
      name: 'Assignment_Rubric_Guide.docx',
      size: '1.1 MB',
      type: 'doc',
    ),
    AttachedFile(
      id: 'f3',
      name: 'Medical_Certificate_Aug2026.pdf',
      size: '850 KB',
      type: 'pdf',
    ),
    AttachedFile(
      id: 'f4',
      name: 'Reference_Diagram_Figure3.png',
      size: '3.2 MB',
      type: 'png',
    ),
  ];

  int _sampleIdx = 0;

  @override
  void initState() {
    super.initState();
    _files = List.from(widget.initialFiles);
  }

  @override
  void didUpdateWidget(TeacherAttachmentPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFiles != widget.initialFiles) {
      _files = List.from(widget.initialFiles);
    }
  }

  void _addMockFile() {
    if (!mounted) return;
    if (_files.length >= widget.maxFiles) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${widget.maxFiles} files allowed.'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final sample = _samplePool[_sampleIdx % _samplePool.length];
    _sampleIdx++;

    final newFile = AttachedFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: sample.name,
      size: sample.size,
      type: sample.type,
    );

    if (mounted) {
      setState(() {
        _files.add(newFile);
      });
    }

    widget.onChanged?.call(_files);
  }

  void _removeFile(String id) {
    if (mounted) {
      setState(() {
        _files.removeWhere((f) => f.id == id);
      });
    }
    widget.onChanged?.call(_files);
  }

  Color _getFileColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('pdf')) return const Color(0xFFEF4444); // red
    if (t.contains('doc')) return const Color(0xFF2563EB); // blue
    if (t.contains('xls') || t.contains('sheet')) return const Color(0xFF10B981); // green
    if (t.contains('png') || t.contains('jpg') || t.contains('img')) return const Color(0xFF8B5CF6); // purple
    return const Color(0xFF6C4CF1);
  }

  IconData _getFileIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('pdf')) return LucideIcons.fileText;
    if (t.contains('doc')) return LucideIcons.fileText;
    if (t.contains('xls') || t.contains('sheet')) return LucideIcons.fileSpreadsheet;
    if (t.contains('png') || t.contains('jpg') || t.contains('img')) return LucideIcons.image;
    return LucideIcons.file;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              if (_files.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_files.length}/${widget.maxFiles}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Drag & Drop / Browse Upload Box
        GestureDetector(
          onTap: _addMockFile,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.uploadCloud,
                      color: Color(0xFF6C4CF1),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Drag & drop files here',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.hintText,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDDD6FF)),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.paperclip, size: 13, color: Color(0xFF6C4CF1)),
                      SizedBox(width: 5),
                      Text(
                        'Browse Files',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4CF1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Uploaded Files List Preview
        if (_files.isNotEmpty) ...[
          const SizedBox(height: 10),
          Column(
            children: _files.map((file) {
              final color = _getFileColor(file.type);
              final icon = _getFileIcon(file.type);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEEEDF5)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x051E1E2D),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 17),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E1E2D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                file.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCBD5E1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                file.size,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeFile(file.id),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          LucideIcons.trash2,
                          size: 14,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
