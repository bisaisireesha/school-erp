import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class ReportCardScreen extends StatefulWidget {
  final String title;
  final VoidCallback onBack;

  const ReportCardScreen({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  State<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen> {
  List<Map<String, dynamic>> subjectMarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReportCard();
  }

  Future<void> _loadReportCard() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/student_report_card.json');
      final data = await json.decode(response);
      if (mounted) {
        setState(() {
          subjectMarks = List<Map<String, dynamic>>.from(data['subjectMarks']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getColor(String colorStr) {
    return Color(int.parse(colorStr));
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
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);

        scaffoldMessenger.showSnackBar(
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
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Downloaded ${widget.title} Report Card PDF'),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Custom App Bar
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
                    Expanded(
                      child: Text('Report Card', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                    GestureDetector(
                      onTap: () => _downloadReport(context, widget.title),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LucideIcons.download, size: 20, color: Color(0xFF6C4CF1)),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C4CF1), Color(0xFF8B73F5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C4CF1).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('2025 - 2026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              const Icon(LucideIcons.award, color: Colors.white, size: 28),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHeaderStat('Percentage', '91.8%'),
                              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.2)),
                              _buildHeaderStat('Grade', 'A+'),
                              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.2)),
                              _buildHeaderStat('Rank', '4th'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text('Subject Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 16),

                    // Subjects List
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
                      )
                    else if (subjectMarks.isEmpty)
                      const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Text("No report card data available.")))
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                        if (constraints.maxWidth > 900) {
                          return Wrap(
                            spacing: 16,
                            runSpacing: 0,
                            children: subjectMarks.map((subject) {
                              return SizedBox(
                                width: (constraints.maxWidth - 16) / 2,
                                child: _buildSubjectCard(subject),
                              );
                            }).toList(),
                          );
                        } else {
                          return Column(
                            children: subjectMarks.map((subject) => _buildSubjectCard(subject)).toList(),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 32),
                    const Text('Teacher\'s Remarks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(LucideIcons.quote, color: Color(0xFF16A34A), size: 20),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Aarav is an excellent student who consistently demonstrates a deep understanding of the material. He actively participates in class discussions and shows great leadership skills during group projects. Keep up the fantastic work!',
                              style: TextStyle(fontSize: 14, color: Color(0xFF4A4A68), height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    double percentage = subject['marks'] / subject['total'];
    Color subjectColor = _getColor(subject['color']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: subjectColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(LucideIcons.bookOpen, color: subjectColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['subject'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject['marks']} / ${subject['total']}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6C6C80), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: subjectColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subject['grade'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: subjectColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
