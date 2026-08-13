import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FrontDeskReportsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const FrontDeskReportsScreen({super.key, this.onBack});

  @override
  State<FrontDeskReportsScreen> createState() => _FrontDeskReportsScreenState();
}

class _FrontDeskReportsScreenState extends State<FrontDeskReportsScreen> {
  String _selectedCategory = 'All';
  String _timeRange = 'This Month';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Visitors',
    'Enquiries',
    'Certificates',
    'Postal',
    'Complaints',
    'Calls',
    'Lost & Found',
  ];

  final Map<String, Map<String, dynamic>> _periodData = {
    'Today': {
      'kpis': [
        {'title': 'Visitors', 'count': '28', 'icon': LucideIcons.users, 'color': const Color(0xFF6C4CF1), 'bg': const Color(0xFFF3F0FF)},
        {'title': 'Enquiries', 'count': '14', 'icon': LucideIcons.helpCircle, 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFEFF6FF)},
        {'title': 'Certificates', 'count': '8', 'icon': LucideIcons.award, 'color': const Color(0xFF10B981), 'bg': const Color(0xFFD1FAE5)},
        {'title': 'Postal Items', 'count': '11', 'icon': LucideIcons.mail, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7)},
      ],
      'reports': [
        {
          'id': 'REP-V01',
          'title': 'Daily Visitor Gate Pass & Check-In Log',
          'desc': 'Complete check-in, check-out and purpose log for visitors today.',
          'category': 'Visitors & Gate',
          'icon': LucideIcons.users,
          'records': '28 Visitors',
          'date': 'Today (Oct 25, 2023)',
          'metrics': [
            {'label': 'Total Visitors', 'val': '28'},
            {'label': 'Currently On Campus', 'val': '6'},
            {'label': 'Parent Meetings', 'val': '18'},
            {'label': 'Vendors / Official', 'val': '10'},
          ],
        },
        {
          'id': 'REP-E01',
          'title': 'Daily Admission & Walk-in Enquiries',
          'desc': 'Breakdown of walk-in inquiries for admissions and general desk.',
          'category': 'Enquiries',
          'icon': LucideIcons.helpCircle,
          'records': '14 Enquiries',
          'date': 'Today',
          'metrics': [
            {'label': 'Total Leads', 'val': '14'},
            {'label': 'Grade 1-5', 'val': '6'},
            {'label': 'Grade 6-10', 'val': '5'},
            {'label': 'High School / +2', 'val': '3'},
          ],
        },
        {
          'id': 'REP-C01',
          'title': 'Daily Certificate Issuance Log',
          'desc': 'Official certificates verified, printed, and handed over today.',
          'category': 'Certificates',
          'icon': LucideIcons.award,
          'records': '8 Issued',
          'date': 'Today',
          'metrics': [
            {'label': 'Bonafide Certificates', 'val': '5'},
            {'label': 'Transfer Certificates (TC)', 'val': '2'},
            {'label': 'Fee Clearance Cert.', 'val': '1'},
            {'label': 'Pending Signatures', 'val': '3'},
          ],
        },
        {
          'id': 'REP-P01',
          'title': 'Daily Inward & Outward Postal Dispatch',
          'desc': 'Log of all parcels, speed posts, and registered letters handled.',
          'category': 'Postal & Courier',
          'icon': LucideIcons.mail,
          'records': '11 Parcels',
          'date': 'Today',
          'metrics': [
            {'label': 'Inward Received', 'val': '7'},
            {'label': 'Outward Dispatched', 'val': '4'},
            {'label': 'Exam Board Mail', 'val': '2'},
            {'label': 'Pending Collection', 'val': '3'},
          ],
        },
        {
          'id': 'REP-CL01',
          'title': 'Front Office Telephony & Call Logs',
          'desc': 'Incoming, outgoing, and follow-up phone call summary today.',
          'category': 'Call Logs',
          'icon': LucideIcons.phoneCall,
          'records': '36 Calls',
          'date': 'Today',
          'metrics': [
            {'label': 'Incoming Received', 'val': '24'},
            {'label': 'Outgoing Follow-ups', 'val': '9'},
            {'label': 'Missed Inquiries', 'val': '3'},
            {'label': 'Avg Duration', 'val': '2.4 min'},
          ],
        },
      ]
    },
    'This Week': {
      'kpis': [
        {'title': 'Visitors', 'count': '142', 'icon': LucideIcons.users, 'color': const Color(0xFF6C4CF1), 'bg': const Color(0xFFF3F0FF)},
        {'title': 'Enquiries', 'count': '68', 'icon': LucideIcons.helpCircle, 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFEFF6FF)},
        {'title': 'Certificates', 'count': '34', 'icon': LucideIcons.award, 'color': const Color(0xFF10B981), 'bg': const Color(0xFFD1FAE5)},
        {'title': 'Postal Items', 'count': '52', 'icon': LucideIcons.mail, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7)},
      ],
      'reports': [
        {
          'id': 'REP-V02',
          'title': 'Weekly Visitor Footfall & Security Audit',
          'desc': 'Weekly gate pass analysis, peak entry times, and staff rendezvous.',
          'category': 'Visitors & Gate',
          'icon': LucideIcons.users,
          'records': '142 Visitors',
          'date': 'Oct 19 - Oct 25, 2023',
          'metrics': [
            {'label': 'Total Visitors', 'val': '142'},
            {'label': 'Peak Hour', 'val': '10:00 AM - 12:00 PM'},
            {'label': 'Avg Campus Time', 'val': '38 mins'},
            {'label': 'Overstay Alerts', 'val': '0'},
          ],
        },
        {
          'id': 'REP-E02',
          'title': 'Weekly Prospective Admission Leads & Conversions',
          'desc': 'Admissions inquiry pipeline, application form sales, and tour visits.',
          'category': 'Enquiries',
          'icon': LucideIcons.helpCircle,
          'records': '68 Leads',
          'date': 'This Week',
          'metrics': [
            {'label': 'Total Enquiries', 'val': '68'},
            {'label': 'Campus Tours Done', 'val': '22'},
            {'label': 'Forms Purchased', 'val': '19'},
            {'label': 'Conversion Rate', 'val': '28%'},
          ],
        },
        {
          'id': 'REP-C02',
          'title': 'Weekly Certificate Processing Audit',
          'desc': 'Turnaround time analysis for Bonafide, Study, and TC certificates.',
          'category': 'Certificates',
          'icon': LucideIcons.award,
          'records': '34 Records',
          'date': 'This Week',
          'metrics': [
            {'label': 'Total Requests', 'val': '34'},
            {'label': 'Issued on Time', 'val': '31 (91%)'},
            {'label': 'Avg Turnaround', 'val': '1.2 Days'},
            {'label': 'Pending Clearance', 'val': '3'},
          ],
        },
        {
          'id': 'REP-CM02',
          'title': 'Weekly Grievance & Complaint Redressal',
          'desc': 'Parent and staff complaints registered, resolved, and escalated.',
          'category': 'Complaints',
          'icon': LucideIcons.messageSquare,
          'records': '9 Complaints',
          'date': 'This Week',
          'metrics': [
            {'label': 'Registered', 'val': '9'},
            {'label': 'Resolved', 'val': '7'},
            {'label': 'Under Review', 'val': '2'},
            {'label': 'Avg Resolution', 'val': '24 Hours'},
          ],
        },
        {
          'id': 'REP-LF02',
          'title': 'Weekly Lost & Found Articles Custody Report',
          'desc': 'Articles received in custody versus items claimed and returned.',
          'category': 'Lost & Found',
          'icon': LucideIcons.package,
          'records': '12 Items',
          'date': 'This Week',
          'metrics': [
            {'label': 'Articles Found', 'val': '12'},
            {'label': 'Returned to Owner', 'val': '8'},
            {'label': 'In Custody', 'val': '4'},
            {'label': 'Claim Success', 'val': '66.7%'},
          ],
        },
      ]
    },
    'This Month': {
      'kpis': [
        {'title': 'Visitors', 'count': '540', 'icon': LucideIcons.users, 'color': const Color(0xFF6C4CF1), 'bg': const Color(0xFFF3F0FF)},
        {'title': 'Enquiries', 'count': '210', 'icon': LucideIcons.helpCircle, 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFEFF6FF)},
        {'title': 'Certificates', 'count': '128', 'icon': LucideIcons.award, 'color': const Color(0xFF10B981), 'bg': const Color(0xFFD1FAE5)},
        {'title': 'Postal Items', 'count': '184', 'icon': LucideIcons.mail, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7)},
      ],
      'reports': [
        {
          'id': 'REP-V03',
          'title': 'Monthly Comprehensive Visitor Analytics',
          'desc': 'Monthly campus footfall, visitor classification, and safety log.',
          'category': 'Visitors & Gate',
          'icon': LucideIcons.users,
          'records': '540 Visitors',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Total Visitors', 'val': '540'},
            {'label': 'Parent Consultations', 'val': '342'},
            {'label': 'Vendor & Maintenance', 'val': '118'},
            {'label': 'Official / Dignitaries', 'val': '80'},
          ],
        },
        {
          'id': 'REP-E03',
          'title': 'Monthly Admissions Pipeline & Source Analysis',
          'desc': 'Full analysis of inquiries by source, grade level, and conversion stage.',
          'category': 'Enquiries',
          'icon': LucideIcons.helpCircle,
          'records': '210 Enquiries',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Total Leads', 'val': '210'},
            {'label': 'Direct Walk-ins', 'val': '115'},
            {'label': 'Online Portal Leads', 'val': '65'},
            {'label': 'Admissions Confirmed', 'val': '54'},
          ],
        },
        {
          'id': 'REP-C03',
          'title': 'Monthly Certificate Register & Fee Audit',
          'desc': 'All student certificate requests, approvals, and fees collected.',
          'category': 'Certificates',
          'icon': LucideIcons.award,
          'records': '128 Certificates',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Bonafide Certificates', 'val': '82'},
            {'label': 'Transfer Certificates', 'val': '26'},
            {'label': 'Character & Conduct', 'val': '20'},
            {'label': 'Processing Accuracy', 'val': '99.2%'},
          ],
        },
        {
          'id': 'REP-P03',
          'title': 'Monthly Postal & Dispatch Ledger',
          'desc': 'Speed post tracking, courier expenditure, and delivery receipts.',
          'category': 'Postal & Courier',
          'icon': LucideIcons.mail,
          'records': '184 Dispatches',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Inward Mail Logged', 'val': '112'},
            {'label': 'Outward Mail Sent', 'val': '72'},
            {'label': 'Total Postal Cost', 'val': '₹ 4,820'},
            {'label': 'Delivery Confirmed', 'val': '100%'},
          ],
        },
        {
          'id': 'REP-CM03',
          'title': 'Monthly Front Desk Complaints & Resolution SLA',
          'desc': 'Service level agreements, escalation rates, and parent satisfaction score.',
          'category': 'Complaints',
          'icon': LucideIcons.messageSquare,
          'records': '24 Cases',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Total Complaints', 'val': '24'},
            {'label': 'Resolved Within SLA', 'val': '22 (91.6%)'},
            {'label': 'Pending Investigation', 'val': '2'},
            {'label': 'Satisfaction Index', 'val': '4.6 / 5.0'},
          ],
        },
        {
          'id': 'REP-CL03',
          'title': 'Monthly Front Desk Telephony Log',
          'desc': 'Total calls handled, inquiry subjects, and peak calling days.',
          'category': 'Call Logs',
          'icon': LucideIcons.phoneCall,
          'records': '860 Calls',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Incoming Calls', 'val': '610'},
            {'label': 'Outgoing Calls', 'val': '250'},
            {'label': 'Peak Day', 'val': 'Monday'},
            {'label': 'Avg Call Time', 'val': '3.1 mins'},
          ],
        },
        {
          'id': 'REP-LF03',
          'title': 'Monthly Lost & Found Inventory & Disposal',
          'desc': 'Custody audit, reclaimed belongings, and end-of-month item disposal.',
          'category': 'Lost & Found',
          'icon': LucideIcons.package,
          'records': '38 Items',
          'date': 'October 2023',
          'metrics': [
            {'label': 'Total Articles Logged', 'val': '38'},
            {'label': 'Claimed by Students', 'val': '27'},
            {'label': 'Donated / Disposed', 'val': '4'},
            {'label': 'Currently in Custody', 'val': '7'},
          ],
        },
      ]
    },
  };

  Widget _buildKpiCard(String label, String count, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: textColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6C6C80)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(report['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(
                              report['category'],
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            report['records'],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              report['desc'],
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.35),
            ),
          ),

          const SizedBox(height: 12),

          // Metrics Preview Grid
          if (report['metrics'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F1F5)),
                ),
                child: Row(
                  children: (report['metrics'] as List<Map<String, String>>).take(2).map((m) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['label']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF8F90A6))),
                          const SizedBox(height: 2),
                          Text(m['val']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

        const SizedBox(height: 12),

        // Date row info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(LucideIcons.calendar, size: 13, color: Color(0xFF8F90A6)),
              const SizedBox(width: 6),
              Text(
                report['date'] ?? _timeRange,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report['id'] ?? '',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        const Divider(color: Color(0xFFF1F1F5), height: 1),

        // Action Buttons Row (Equal width side-by-side)
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDownloadModal(report),
                  icon: const Icon(LucideIcons.download, size: 16, color: Color(0xFF6C4CF1)),
                  label: const Text(
                    'Download',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6C4CF1)),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFDDD6FE)),
                    backgroundColor: const Color(0xFFFAF8FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showReportDetails(report),
                  icon: const Icon(LucideIcons.eye, size: 16, color: Colors.white),
                  label: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CF1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  void _showDownloadModal(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _DownloadProgressSheet(report: report, timeRange: _timeRange),
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F0FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(report['icon'] as IconData, color: const Color(0xFF6C4CF1), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report['id'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C4CF1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              report['category'],
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6C4CF1), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Color(0xFF8B8B8B)),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Body Details
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F1F5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Report Title',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8F90A6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report['title'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report['desc'],
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Metrics Breakdown Table
                    const Text('Executive Metrics Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2D))),
                    const SizedBox(height: 12),

                    if (report['metrics'] != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: (report['metrics'] as List<Map<String, String>>).map((m) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(m['label']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                                  Text(m['val']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Download Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDownloadModal(report);
                        },
                        icon: const Icon(LucideIcons.download, size: 20, color: Colors.white),
                        label: const Text(
                          'Download PDF Report',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4CF1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _periodData[_timeRange] ?? _periodData['This Month']!;
    final kpiList = currentData['kpis'] as List<Map<String, dynamic>>;
    final reportsList = currentData['reports'] as List<Map<String, dynamic>>;

    final displayedReports = reportsList.where((report) {
      final title = (report['title'] as String).toLowerCase();
      final category = (report['category'] as String).toLowerCase();
      final query = _searchQuery.trim().toLowerCase();

      bool matchesQuery = query.isEmpty || title.contains(query) || category.contains(query);
      bool matchesCategory;
      if (_selectedCategory == 'All') {
        matchesCategory = true;
      } else if (_selectedCategory == 'Visitors') {
        matchesCategory = category.contains('visitor');
      } else if (_selectedCategory == 'Enquiries') {
        matchesCategory = category.contains('enquir');
      } else if (_selectedCategory == 'Certificates') {
        matchesCategory = category.contains('certif');
      } else if (_selectedCategory == 'Postal') {
        matchesCategory = category.contains('postal');
      } else if (_selectedCategory == 'Complaints') {
        matchesCategory = category.contains('complaint');
      } else if (_selectedCategory == 'Calls') {
        matchesCategory = category.contains('call');
      } else if (_selectedCategory == 'Lost & Found') {
        matchesCategory = category.contains('lost') || category.contains('found');
      } else {
        matchesCategory = category.contains(_selectedCategory.toLowerCase());
      }

      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    if (widget.onBack != null) ...[
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
                    ],
                    const Expanded(
                      child: Text('Front Desk Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Time Range Segmented Selector (Today, This Week, This Month)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: ['Today', 'This Week', 'This Month'].map((period) {
                      final isSelected = _timeRange == period;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _timeRange = period),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF6C4CF1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF6C4CF1).withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                period,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic KPI Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard(kpiList[0]['title'], kpiList[0]['count'], kpiList[0]['icon'], kpiList[0]['color'], kpiList[0]['bg'])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard(kpiList[1]['title'], kpiList[1]['count'], kpiList[1]['icon'], kpiList[1]['color'], kpiList[1]['bg'])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildKpiCard(kpiList[2]['title'], kpiList[2]['count'], kpiList[2]['icon'], kpiList[2]['color'], kpiList[2]['bg'])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildKpiCard(kpiList[3]['title'], kpiList[3]['count'], kpiList[3]['icon'], kpiList[3]['color'], kpiList[3]['bg'])),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search report title, metrics...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF6C4CF1), size: 18),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Filter Tabs (Wrapped, no horizontal scrolling)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C4CF1) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? const Color(0xFF6C4CF1) : const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Reports List
              if (displayedReports.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F0FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.fileX, size: 48, color: Color(0xFF6C4CF1)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Reports Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'There are no reports available matching your selection.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8F90A6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: displayedReports.map((r) => _buildReportCard(r)).toList(),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadProgressSheet extends StatefulWidget {
  final Map<String, dynamic> report;
  final String timeRange;

  const _DownloadProgressSheet({
    required this.report,
    required this.timeRange,
  });

  @override
  State<_DownloadProgressSheet> createState() => _DownloadProgressSheetState();
}

class _DownloadProgressSheetState extends State<_DownloadProgressSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _progressAnim;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isComplete = true;
          });
        }
      });

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final progressVal = (_progressAnim.value * 100).toInt();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Icon Status
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _isComplete ? const Color(0xFFD1FAE5) : const Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isComplete ? LucideIcons.checkCheck : LucideIcons.fileText,
              color: _isComplete ? const Color(0xFF10B981) : const Color(0xFF6C4CF1),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            _isComplete ? 'Report Downloaded!' : 'Generating PDF Report...',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: 6),
          Text(
            _isComplete
                ? 'The document has been verified and saved to your device.'
                : 'Compiling ${widget.timeRange.toLowerCase()} audit records & charts ($progressVal%)...',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),

          // Progress bar
          if (!_isComplete)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progressAnim.value,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF1F1F5),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C4CF1)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Document Card Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.fileText, size: 20, color: Color(0xFF6C4CF1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${report['id']}_${report['category'].toString().replaceAll(' ', '_')}.pdf',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'PDF Document • 342 KB • ${widget.timeRange}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF8F90A6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          if (_isComplete)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      Navigator.pop(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1E1E2D),
                          content: Row(
                            children: [
                              const Icon(LucideIcons.fileCheck, color: Color(0xFF10B981), size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Opening ${report['title']} in PDF Viewer...',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.externalLink, size: 16, color: Colors.white),
                    label: const Text(
                      'Open PDF',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CF1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel Download', style: TextStyle(color: Color(0xFF8F90A6), fontWeight: FontWeight.w600)),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
