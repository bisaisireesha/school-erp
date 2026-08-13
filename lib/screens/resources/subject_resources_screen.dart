import 'dart:convert';
import 'package:flutter/services.dart';
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
  List<Map<String, dynamic>> _mockFiles = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/student_subject_resources.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          _mockFiles = List<Map<String, dynamic>>.from(data['files']);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading files: $e');
    }
  }

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search resources...',
                                  hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                                ),
                              ),
                            ),
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
                        if (_isLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
                          );
                        }
                        final filteredFiles = _mockFiles.where((file) {
                          return file['title'].toString().toLowerCase().contains(_searchQuery);
                        }).toList();

                        if (filteredFiles.isEmpty) {
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
                          itemCount: filteredFiles.length,
                          separatorBuilder: (context, index) => const Divider(color: Color(0xFFF3EEFF), height: 1, thickness: 1),
                          itemBuilder: (context, index) {
                            return _buildFileItem(filteredFiles[index]);
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

    return GestureDetector(
      onTap: () => _showFilePreview(context, file),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // File Type Icon
            Container(
              width: 44,
              height: 48,
              decoration: BoxDecoration(
                color: _getColor(file['color']).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(getFileIcon(file['type']), color: _getColor(file['color']), size: 22),
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
                          color: _getColor(file['color']).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(file['type'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getColor(file['color']))),
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
            
            // Actions (Three dots)
            PopupMenuButton<String>(
              icon: const Icon(LucideIcons.moreVertical, color: Color(0xFF6C6C80), size: 20),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              onSelected: (value) async {
                if (value == 'view') {
                  _showFilePreview(context, file);
                } else if (value == 'share') {
                  _showShareModal(context, file);
                } else if (value == 'download') {
                  _showDownloadModal(context, file);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: const [
                      Icon(LucideIcons.eye, color: Color(0xFF1E1E2D), size: 18),
                      SizedBox(width: 12),
                      Text('View Details', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: const [
                      Icon(LucideIcons.share2, color: Color(0xFF1E1E2D), size: 18),
                      SizedBox(width: 12),
                      Text('Share', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'download',
                  child: Row(
                    children: const [
                      Icon(LucideIcons.downloadCloud, color: Color(0xFF1E1E2D), size: 18),
                      SizedBox(width: 12),
                      Text('Download', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilePreview(BuildContext context, Map<String, dynamic> file) {

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(file['type'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                            ),
                            const SizedBox(width: 12),
                            const Text('File Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF9E9E9E))),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3EEFF),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showShareModal(context, file);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3EEFF),
                              foregroundColor: const Color(0xFF6C4CF1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            icon: const Icon(LucideIcons.share2, size: 18),
                            label: const Text('Share', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDownloadModal(context, file);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4CF1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            icon: const Icon(LucideIcons.download, size: 18),
                            label: const Text('Download', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _showDownloadModal(BuildContext context, Map<String, dynamic> file) {
    bool isDownloading = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // Start the mock download delay when the sheet opens
            if (isDownloading) {
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  setSheetState(() {
                    isDownloading = false;
                  });
                }
              });
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: isDownloading
                    ? _buildDownloadingState(file['title'])
                    : _buildDownloadedState(context),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadingState(String name) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
          const SizedBox(height: 24),
          const Text('Downloading File...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Text('Preparing $name', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildDownloadedState(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
            child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 48),
          ),
          const SizedBox(height: 24),
          const Text('Download Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          const Text('Saved to your device', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('View File', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareModal(BuildContext context, Map<String, dynamic> file) {
    bool isSharing = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // Start the mock sharing delay when the sheet opens
            if (isSharing) {
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  setSheetState(() {
                    isSharing = false;
                  });
                }
              });
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: isSharing
                    ? _buildSharingState(file['title'])
                    : _buildSharedState(context),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSharingState(String name) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
          const SizedBox(height: 24),
          const Text('Generating Link...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Preparing shareable link for $name', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildSharedState(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
            child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 48),
          ),
          const SizedBox(height: 24),
          const Text('Link Copied to Clipboard!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
          const SizedBox(height: 8),
          const Text('Anyone with the link can view this file', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4CF1),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Done', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
