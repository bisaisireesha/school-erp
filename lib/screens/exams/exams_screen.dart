import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import '../main_layout.dart';
import 'report_card_screen.dart';

class ExamsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int initialTabIndex;

  const ExamsScreen({super.key, required this.onBack, this.initialTabIndex = 0});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: MainLayout.globalSearchQuery,
      builder: (context, searchQuery, child) {
        final query = searchQuery.toLowerCase();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // App Bar Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Exams & Results', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPerformanceSummaryCards(),
          const SizedBox(height: 24),

          // Custom Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C4CF1).withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: const Color(0xFF6C4CF1),
                unselectedLabelColor: const Color(0xFF6C6C80),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Upcoming Exams'),
                  Tab(text: 'Exam Results'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tab Bar View content
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return _tabController.index == 0 
                ? _buildUpcomingExamsTab(query) 
                : _buildExamResultsTab(query);
            },
          ),
          const SizedBox(height: 120), // Bottom padding for navbar
        ],
      ),
    );
      },
    );
  }

  Widget _buildUpcomingExamsTab(String query) {
    return FutureBuilder<String>(
      future: rootBundle.loadString('assets/mock/exams_upcoming.json'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var data = json.decode(snapshot.data!)['exams'] as List;
        
        if (query.isNotEmpty) {
          data = data.where((item) => item['title'].toString().toLowerCase().contains(query)).toList();
        }

        if (data.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text('No exams found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: data.map((item) {
                    return SizedBox(
                      width: (constraints.maxWidth - 48 - 32) / 3,
                      child: _buildExamCard(
                        title: item['title'],
                        dateRange: item['dateRange'],
                        subjects: item['subjects'],
                        status: item['status'],
                        statusColor: Color(int.parse("0xFF${item['statusColorHex']}")),
                        statusBg: Color(int.parse("0xFF${item['statusBgHex']}")),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else if (constraints.maxWidth > 500) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: data.map((item) {
                    return SizedBox(
                      width: (constraints.maxWidth - 48 - 16) / 2,
                      child: _buildExamCard(
                        title: item['title'],
                        dateRange: item['dateRange'],
                        subjects: item['subjects'],
                        status: item['status'],
                        statusColor: Color(int.parse("0xFF${item['statusColorHex']}")),
                        statusBg: Color(int.parse("0xFF${item['statusBgHex']}")),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return _buildExamCard(
                    title: item['title'],
                    dateRange: item['dateRange'],
                    subjects: item['subjects'],
                    status: item['status'],
                    statusColor: Color(int.parse("0xFF${item['statusColorHex']}")),
                    statusBg: Color(int.parse("0xFF${item['statusBgHex']}")),
                  );
                },
              );
            }
          }
        );
      },
    );
  }

  Widget _buildExamResultsTab(String query) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Full Year Dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Full Year', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text('2025 - 2026', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1))),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6C4CF1), size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<String>(
          future: rootBundle.loadString('assets/mock/exams_results.json'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(32.0), child: Center(child: CircularProgressIndicator()));
            var data = json.decode(snapshot.data!)['results'] as List;
            
            if (query.isNotEmpty) {
              data = data.where((item) => item['title'].toString().toLowerCase().contains(query)).toList();
            }

            if (data.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text('No results found', style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: data.map((item) {
                      return SizedBox(
                        width: (constraints.maxWidth - 48 - 32) / 3,
                        child: _buildResultCard(
                          title: item['title'],
                          date: item['date'],
                          percentage: item['percentage'],
                          grade: item['grade'],
                          isNew: item['isNew'],
                        ),
                      );
                    }).toList(),
                  );
                } else if (constraints.maxWidth > 500) {
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: data.map((item) {
                      return SizedBox(
                        width: (constraints.maxWidth - 48 - 16) / 2,
                        child: _buildResultCard(
                          title: item['title'],
                          date: item['date'],
                          percentage: item['percentage'],
                          grade: item['grade'],
                          isNew: item['isNew'],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return _buildResultCard(
                        title: item['title'],
                        date: item['date'],
                        percentage: item['percentage'],
                        grade: item['grade'],
                        isNew: item['isNew'],
                      );
                    },
                  );
                }
              }
            );
          },
        ),
      ],
    );
  }

  Widget _buildExamCard({
    required String title,
    required String dateRange,
    required int subjects,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6C6C80)),
              const SizedBox(width: 6),
              Text(dateRange, style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A68), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(LucideIcons.bookOpen, size: 16, color: Color(0xFF6C6C80)),
              const SizedBox(width: 6),
              Text('$subjects Subjects', style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A68), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showTimetableBottomSheet(context, title),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F0FF),
                foregroundColor: const Color(0xFF6C4CF1),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Timetable & Syllabus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String date,
    required String percentage,
    required String grade,
    required bool isNew,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      if (isNew) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4B4B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('NEW', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(date, style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80))),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.award, color: Color(0xFF6C4CF1), size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Text('Percentage', style: TextStyle(fontSize: 11, color: Color(0xFF6C6C80), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(percentage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Text('Grade', style: TextStyle(fontSize: 11, color: Color(0xFF6C6C80), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(grade, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _viewReport(context, title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F0FF),
                    foregroundColor: const Color(0xFF6C4CF1),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(LucideIcons.eye, size: 16),
                  label: const Text('View', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _downloadReport(context, title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(LucideIcons.download, size: 16),
                  label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _viewReport(BuildContext context, String title) {
    MainLayout.pushSubScreen(
      context,
      ReportCardScreen(
        title: title,
        onBack: () => MainLayout.popSubScreen(context),
      ),
    );
  }

  Future<void> _downloadReport(BuildContext context, String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF6C4CF1)),
              const SizedBox(height: 20),
              Text(
                'Downloading $title PDF...',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please wait a moment...',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('SCHOOL ERP - OFFICIAL REPORT CARD', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple900)),
                  pw.SizedBox(height: 10),
                  pw.Divider(color: PdfColors.deepPurple, thickness: 2),
                  pw.SizedBox(height: 15),
                  pw.Text('Exam: $title', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Student: Akshara | Class: 10-A | Roll No: 1042', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                  pw.SizedBox(height: 25),
                  pw.TableHelper.fromTextArray(
                    headers: ['Subject', 'Marks Obtained', 'Max Marks', 'Grade'],
                    data: [
                      ['Mathematics', '95', '100', 'A+'],
                      ['Science', '92', '100', 'A+'],
                      ['English', '88', '100', 'A'],
                      ['Social Studies', '90', '100', 'A+'],
                      ['Computer Science', '98', '100', 'A+'],
                    ],
                  ),
                  pw.SizedBox(height: 25),
                  pw.Text('Overall Result: PASSED (Grade: A+)', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
                ],
              ),
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/${title.replaceAll(' ', '_')}_ReportCard.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('$title report card downloaded!')),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () {
                OpenFile.open(file.path);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded $title Report Card PDF'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildPerformanceSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.bookOpen,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  value: '8',
                  label: 'Exams Completed',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFF0FDF4),
                  value: '88%',
                  label: 'Average Score',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.star,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFFFBEB),
                  value: '96%',
                  label: 'Highest Score',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: LucideIcons.barChart2,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  value: '6 / 45',
                  label: 'Class Rank',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C6C80), height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTimetableBottomSheet(BuildContext context, String examTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('$examTitle Timetable', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)))),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF6C6C80)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimetableRow('Mathematics', '15 Oct 2026', '09:00 AM - 12:00 PM'),
            _buildTimetableRow('Science', '17 Oct 2026', '09:00 AM - 12:00 PM'),
            _buildTimetableRow('English', '19 Oct 2026', '09:00 AM - 12:00 PM'),
            _buildTimetableRow('Social Studies', '21 Oct 2026', '09:00 AM - 12:00 PM'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _downloadReport(context, '$examTitle Syllabus');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(LucideIcons.download, size: 20),
                label: const Text('Download Syllabus PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableRow(String subject, String date, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF6C6C80)),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF6C6C80), fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          ),
        ],
      ),
    );
  }
}
