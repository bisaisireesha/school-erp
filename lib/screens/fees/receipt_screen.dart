import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> receiptData;

  const ReceiptScreen({
    super.key,
    required this.onBack,
    required this.receiptData,
  });

  Future<File> _generatePdf() async {
    final amount = receiptData['amount'] ?? receiptData['total'] ?? '0';
    final date = receiptData['date'] ?? '12 Aug 2026';
    final receiptNo = receiptData['receiptNo'] ?? 'REC-00123';
    final title = receiptData['title'] ?? receiptData['month'] ?? 'Fee Payment';
    final method = receiptData['method'] ?? 'Online';

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
                pw.Center(
                  child: pw.Text(
                    'GLOBAL INTERNATIONAL SCHOOL',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                    '123 Education Lane, Knowledge City',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Center(
                  child: pw.Text(
                    'FEE RECEIPT',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                pw.SizedBox(height: 32),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Receipt No: $receiptNo'),
                    pw.Text('Date: $date'),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text('Transaction ID: TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                pw.SizedBox(height: 24),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Text('Student Name: Arjun Kumar', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text('Class: Class X - Section A'),
                pw.SizedBox(height: 8),
                pw.Text('Roll No: 24'),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Fee Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(title),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Payment Mode', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(method),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL PAID', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rs. $amount', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 60),
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.green, width: 2),
                    ),
                    child: pw.Text(
                      'PAID SUCCESSFULLY',
                      style: pw.TextStyle(
                        color: PdfColors.green,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/receipt_$receiptNo.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    final amount = receiptData['amount'] ?? receiptData['total'] ?? '0';
    final date = receiptData['date'] ?? '12 Aug 2026';
    final receiptNo = receiptData['receiptNo'] ?? 'REC-00123';
    final title = receiptData['title'] ?? receiptData['month'] ?? 'Fee Payment';
    final method = receiptData['method'] ?? 'Online';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1E1E2D)),
          onPressed: onBack,
        ),
        title: const Text(
          'Payment Receipt',
          style: TextStyle(
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C4CF1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.graduationCap, color: Color(0xFF6C4CF1), size: 32),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'GLOBAL INTERNATIONAL SCHOOL',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '123 Education Lane, Knowledge City',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'FEE RECEIPT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildReceiptRow('Receipt No', receiptNo),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Date', date),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Transaction ID', 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: _DashedDivider(),
                        ),
                        _buildReceiptRow('Student Name', 'Arjun Kumar'),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Class', 'Class X - Section A'),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Roll No', '24'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: _DashedDivider(),
                        ),
                        _buildReceiptRow('Fee Category', title),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Payment Mode', method),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: _DashedDivider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL PAID',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2D),
                              ),
                            ),
                            Text(
                              '₹$amount',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF4DBB7E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF4DBB7E), width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PAID SUCCESSFULLY',
                            style: TextStyle(
                              color: Color(0xFF4DBB7E),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: LucideIcons.download,
                    label: 'Download PDF',
                    color: Colors.white,
                    textColor: const Color(0xFF6C4CF1),
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating PDF...')),
                      );
                      try {
                        final file = await _generatePdf();
                        if (!context.mounted) return;
                        await OpenFile.open(file.path);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to open PDF: $e')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    icon: LucideIcons.share2,
                    label: 'Share PDF',
                    color: const Color(0xFF6C4CF1),
                    textColor: Colors.white,
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preparing to share...')),
                      );
                      try {
                        final file = await _generatePdf();
                        if (!context.mounted) return;
                        await Share.shareXFiles([XFile(file.path)], text: 'Fee Receipt');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to share PDF: $e')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF7A7A9D),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E1E2D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6C4CF1).withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFE8E3F8)),
              ),
            );
          }),
        );
      },
    );
  }
}
