import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class LibrarianIssueReturnScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final int initialTabIndex;
  final String? prefilledMember;
  final Function({
    required String studentName,
    required String bookTitle,
    required String isbn,
    required DateTime dueDate,
  })? onIssueBook;

  final Function({
    required String studentName,
    required String bookTitle,
    required String isbn,
    required String condition,
    required double finePaid,
    required bool isOverdue,
  })? onReturnBook;

  const LibrarianIssueReturnScreen({
    super.key,
    required this.data,
    this.onBack,
    this.initialTabIndex = 0,
    this.prefilledMember,
    this.onIssueBook,
    this.onReturnBook,
  });

  @override
  State<LibrarianIssueReturnScreen> createState() => _LibrarianIssueReturnScreenState();
}

class _LibrarianIssueReturnScreenState extends State<LibrarianIssueReturnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- ISSUE BOOKS FORM STATE ---
  final TextEditingController _studentInputController = TextEditingController(text: 'Ethan Vance (STU-9921)');
  final TextEditingController _bookInputController = TextEditingController(text: 'To Kill a Mockingbird (ISBN: 978-0446310789)');
  DateTime _currentDueDate = DateTime.now().add(const Duration(days: 14));
  final DateTime _internalIssueDate = DateTime.now();

  // Additional Books added via "Add Another Book"
  final List<Map<String, dynamic>> _additionalBooksList = [];

  // --- RETURN BOOKS FORM STATE ---
  final TextEditingController _returnStudentInputController = TextEditingController();
  String? _selectedReturnStudent;
  Map<String, dynamic>? _selectedMemberData;
  List<Map<String, dynamic>> _studentIssuedBooks = [];

  final Map<int, bool> _selectedReturnBookIndexes = {};
  final Map<int, String> _bookConditions = {}; // 'Good', 'Damaged', 'Lost'
  final Map<int, TextEditingController> _penaltyControllers = {};
  final Map<int, TextEditingController> _remarksControllers = {};

  List<String> get _memberOptions {
    final members = (widget.data['members'] as List? ?? []);
    if (members.isNotEmpty) {
      return members.map((m) => '${m['name']} (${m['memberId'] ?? 'STU-0000'})').toList();
    }
    return [
      'Ethan Vance (STU-9921)',
      'Michael Scott (STU-8842)',
      'Emily Watson (STU-9104)',
      'Prof. David Miller (FAC-2041)',
      'Alexander Wright (STU-9430)',
      'Sophia Martinez (STU-7751)',
    ];
  }

  List<String> get _bookOptions {
    final books = (widget.data['books'] as List? ?? []);
    if (books.isNotEmpty) {
      return books.map((b) => '${b['title']} (ISBN: ${b['isbn'] ?? 'N/A'})').toList();
    }
    return [
      'To Kill a Mockingbird (ISBN: 978-0446310789)',
      'Principles of Physics Vol. 2 (ISBN: 978-0134988559)',
      'Data Structures & Algorithms (ISBN: 978-0672324536)',
      'Sapiens: Brief History (ISBN: 978-0062316097)',
      'Modern Microeconomics (ISBN: 978-0333778081)',
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);

    if (widget.prefilledMember != null && widget.prefilledMember!.isNotEmpty) {
      _returnStudentInputController.text = widget.prefilledMember!;
      _onSelectReturnStudent(widget.prefilledMember!);
    } else {
      // Default initial return selection
      _onSelectReturnStudent('Michael Scott (STU-8842)');
    }
  }

  @override
  void didUpdateWidget(LibrarianIssueReturnScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTabIndex != oldWidget.initialTabIndex) {
      _tabController.animateTo(widget.initialTabIndex);
    }
    if (widget.prefilledMember != null && widget.prefilledMember != oldWidget.prefilledMember) {
      _returnStudentInputController.text = widget.prefilledMember!;
      _onSelectReturnStudent(widget.prefilledMember!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentInputController.dispose();
    _bookInputController.dispose();
    _returnStudentInputController.dispose();
    for (var c in _penaltyControllers.values) {
      c.dispose();
    }
    for (var c in _remarksControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // --- ISSUE BOOKS LOGIC ---
  void _addBookToAdditionalList() {
    setState(() {
      _additionalBooksList.add({
        'controller': TextEditingController(text: 'Data Structures & Algorithms (ISBN: 978-0672324536)'),
        'dueDate': DateTime.now().add(const Duration(days: 14)),
      });
    });
  }

  void _removeBookFromAdditionalList(int index) {
    setState(() {
      final item = _additionalBooksList.removeAt(index);
      (item['controller'] as TextEditingController).dispose();
    });
  }

  void _handleIssueSubmit() {
    final student = _studentInputController.text.trim();
    if (student.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or select a student name/ID.')),
      );
      return;
    }

    final totalCount = 1 + _additionalBooksList.length;
    final dateStr = '${_internalIssueDate.day}/${_internalIssueDate.month}/${_internalIssueDate.year}';
    final studentCleanName = student.split(' (')[0];
    final bookCleanTitle = _bookInputController.text.split(' (ISBN:')[0];
    final isbn = RegExp(r'ISBN:\s*([0-9\-]+)').firstMatch(_bookInputController.text)?.group(1) ?? '978-0446310789';

    // Trigger state mutation in main layout
    if (widget.onIssueBook != null) {
      widget.onIssueBook!(
        studentName: studentCleanName,
        bookTitle: bookCleanTitle,
        isbn: isbn,
        dueDate: _currentDueDate,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Issued $totalCount book(s) on $dateStr to $studentCleanName successfully!'),
        backgroundColor: const Color(0xFF5B5CEB),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- RETURN BOOKS LOGIC ---
  void _onSelectReturnStudent(String studentString) {
    final members = (widget.data['members'] as List? ?? []);
    final memberIdMatch = RegExp(r'\((.*?)\)').firstMatch(studentString)?.group(1) ?? 'STU-8842';
    final member = members.firstWhere(
      (m) => m['memberId'] == memberIdMatch || m['name'].toString().toLowerCase() == studentString.split(' (')[0].toLowerCase(),
      orElse: () => {
        'name': studentString.split(' (')[0],
        'memberId': memberIdMatch,
        'activeIssued': 2,
      },
    );

    // Pull student issued books dynamically from overdue list or defaults
    final overdueBooks = (widget.data['overdueBooks'] as List? ?? []);
    final todaysDue = (widget.data['todaysDueReturns'] as List? ?? []);

    final List<Map<String, dynamic>> studentBooks = [];

    for (var ov in overdueBooks) {
      if (ov['memberName'].toString().toLowerCase().contains(studentString.split(' (')[0].toLowerCase())) {
        studentBooks.add({
          'id': ov['id'] ?? 'BK-101',
          'title': ov['bookTitle'] ?? 'To Kill a Mockingbird',
          'isbn': ov['isbn'] ?? '978-0446310789',
          'dueDate': ov['dueDate'] ?? '28 Jul 2026',
          'isOverdue': true,
          'daysOverdue': ov['daysOverdue'] ?? 6,
          'suggestedFine': double.tryParse((ov['fineAmount'] ?? '150').replaceAll(RegExp(r'[^0-9.]'), '')) ?? 150.0,
        });
      }
    }

    for (var td in todaysDue) {
      if (td['memberName'].toString().toLowerCase().contains(studentString.split(' (')[0].toLowerCase())) {
        studentBooks.add({
          'id': td['id'] ?? 'BK-102',
          'title': td['bookTitle'] ?? 'Principles of Physics Vol. 2',
          'isbn': td['isbn'] ?? '978-0134988559',
          'dueDate': 'Today',
          'isOverdue': false,
          'daysOverdue': 0,
          'suggestedFine': 0.0,
        });
      }
    }

    if (studentBooks.isEmpty) {
      studentBooks.addAll([
        {
          'id': 'BK-101',
          'title': 'To Kill a Mockingbird',
          'isbn': '978-0446310789',
          'dueDate': '28 Jul 2026',
          'isOverdue': true,
          'daysOverdue': 6,
          'suggestedFine': 150.0,
        },
        {
          'id': 'BK-102',
          'title': 'Principles of Physics Vol. 2',
          'isbn': '978-0134988559',
          'dueDate': '10 Aug 2026',
          'isOverdue': false,
          'daysOverdue': 0,
          'suggestedFine': 0.0,
        },
      ]);
    }

    setState(() {
      _selectedReturnStudent = studentString;
      _selectedMemberData = member;
      _studentIssuedBooks = studentBooks;
      _selectedReturnBookIndexes.clear();
      _bookConditions.clear();
      _penaltyControllers.clear();
      _remarksControllers.clear();

      for (int i = 0; i < studentBooks.length; i++) {
        _selectedReturnBookIndexes[i] = i == 0; // Pre-select first book for quick return
        _bookConditions[i] = 'Good';
        _penaltyControllers[i] = TextEditingController(
          text: (studentBooks[i]['suggestedFine'] as double).toStringAsFixed(0),
        );
        _remarksControllers[i] = TextEditingController();
      }
    });
  }

  bool _hasDamagedOrLostSelection() {
    bool hasDamagedOrLost = false;
    _selectedReturnBookIndexes.forEach((index, isSelected) {
      if (isSelected) {
        final cond = _bookConditions[index] ?? 'Good';
        if (cond == 'Damaged' || cond == 'Lost') {
          hasDamagedOrLost = true;
        }
      }
    });
    return hasDamagedOrLost;
  }

  double _calculateTotalPenalty() {
    double total = 0.0;
    _selectedReturnBookIndexes.forEach((index, isSelected) {
      if (isSelected) {
        final fineStr = _penaltyControllers[index]?.text ?? '0';
        total += double.tryParse(fineStr) ?? 0.0;
      }
    });
    return total;
  }

  void _handleReturnSubmit() {
    final isPaymentRequired = _hasDamagedOrLostSelection() || _calculateTotalPenalty() > 0;
    final totalPenalty = _calculateTotalPenalty();

    if (isPaymentRequired && totalPenalty > 0) {
      _showPaymentBottomSheet(totalPenalty);
    } else {
      _completeReturnProcess(paid: false);
    }
  }

  void _completeReturnProcess({required bool paid}) {
    final selectedCount = _selectedReturnBookIndexes.values.where((v) => v).length;

    _selectedReturnBookIndexes.forEach((index, isSelected) {
      if (isSelected && index < _studentIssuedBooks.length) {
        final book = _studentIssuedBooks[index];
        final cond = _bookConditions[index] ?? 'Good';
        final fineVal = double.tryParse(_penaltyControllers[index]?.text ?? '0') ?? 0.0;
        final bool isOverdue = book['isOverdue'] ?? false;

        if (widget.onReturnBook != null) {
          widget.onReturnBook!(
            studentName: _selectedMemberData?['name'] ?? 'Student',
            bookTitle: book['title'],
            isbn: book['isbn'] ?? '978-0446310789',
            condition: cond,
            finePaid: fineVal,
            isOverdue: isOverdue,
          );
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Returned $selectedCount book(s) successfully!${paid ? ' Payment collected.' : ''}'),
        backgroundColor: const Color(0xFF22C55E),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _selectedReturnStudent = null;
      _selectedMemberData = null;
      _studentIssuedBooks.clear();
      _selectedReturnBookIndexes.clear();
      _returnStudentInputController.clear();
    });
  }

  void _showPaymentBottomSheet(double totalAmount) {
    String selectedPaymentMethod = 'UPI';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Collect Penalty & Fine Payment', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Payable Fine', style: TextStyle(fontSize: 12.0, color: Color(0xFF64748B))),
                            Text('Includes damage/lost book penalties', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                          ],
                        ),
                        Text('₹${totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Select Payment Method', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPaymentOptionChip(
                        label: 'UPI',
                        icon: LucideIcons.qrCode,
                        isSelected: selectedPaymentMethod == 'UPI',
                        onTap: () => setModalState(() => selectedPaymentMethod = 'UPI'),
                      ),
                      const SizedBox(width: 8),
                      _buildPaymentOptionChip(
                        label: 'Cash',
                        icon: LucideIcons.banknote,
                        isSelected: selectedPaymentMethod == 'Cash',
                        onTap: () => setModalState(() => selectedPaymentMethod = 'Cash'),
                      ),
                      const SizedBox(width: 8),
                      _buildPaymentOptionChip(
                        label: 'Card',
                        icon: LucideIcons.creditCard,
                        isSelected: selectedPaymentMethod == 'Card',
                        onTap: () => setModalState(() => selectedPaymentMethod = 'Card'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _completeReturnProcess(paid: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B5CEB),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'Confirm Payment of ₹${totalAmount.toStringAsFixed(0)} ($selectedPaymentMethod)',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
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

  Widget _buildPaymentOptionChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F1FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF5B5CEB) : const Color(0xFFE8ECF5),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF5B5CEB) : const Color(0xFF64748B), size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: isSelected ? const Color(0xFF5B5CEB) : const Color(0xFF0F172A))),
            ],
          ),
        ),
      ),
    );
  }

  // ─── MAIN BUILD ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final recentlyIssued = (widget.data['recentlyIssuedBooks'] as List? ?? []);
    final recentlyReturned = (widget.data['recentlyReturnedBooks'] as List? ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeaderRow(),
            const SizedBox(height: 14),

            _buildSegmentedControl(),
            const SizedBox(height: 14),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIssueBookTab(recentlyIssued),
                  _buildReturnBookTab(recentlyReturned),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 1. PAGE HEADER ROW ───────────────────────────────────────────────────
  Widget _buildPageHeaderRow() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Text(
        'Issue & Return',
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E1E2D),
          letterSpacing: -0.4,
        ),
      ),
    );
  }

  // ─── 2. SEGMENTED CONTROL ──────────────────────────────────────────────────
  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: const Color(0xFF6C4CF1),
          borderRadius: BorderRadius.circular(9),
          boxShadow: AppShadows.soft,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF7A7A9D),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        tabs: const [
          Tab(text: 'Issue Book'),
          Tab(text: 'Return Book'),
        ],
      ),
    );
  }

  // ─── ISSUE BOOK TAB ────────────────────────────────────────────────────────
  Widget _buildIssueBookTab(List recentlyIssued) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NEW ISSUE TRANSACTION CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8ECF5), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F0F172A),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Issue Transaction',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),

                // Student Name / Member ID Input
                _buildFieldLabel('Student Name / Member ID'),
                const SizedBox(height: 6),
                _buildAutocompleteInput(
                  controller: _studentInputController,
                  options: _memberOptions,
                  icon: LucideIcons.user,
                  hint: 'Type student name or ID...',
                ),
                const SizedBox(height: 16),

                // Book ID / ISBN / Book Name Input
                _buildFieldLabel('Book ID / ISBN / Book Name'),
                const SizedBox(height: 6),
                _buildAutocompleteInput(
                  controller: _bookInputController,
                  options: _bookOptions,
                  icon: LucideIcons.bookOpen,
                  hint: 'Type book title or ISBN...',
                ),
                const SizedBox(height: 16),

                // Due Date Picker
                _buildFieldLabel('Due Date Picker'),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _currentDueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      setState(() => _currentDueDate = picked);
                    }
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8ECF5), width: 1.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF5B5CEB)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Due: ${_currentDueDate.day.toString().padLeft(2, '0')} ${_monthName(_currentDueDate.month)} ${_currentDueDate.year}',
                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Color(0xFF0F172A)),
                          ),
                        ),
                        const Icon(LucideIcons.calendarDays, size: 18, color: Color(0xFF5B5CEB)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Additional Dynamic Book Inputs
                if (_additionalBooksList.isNotEmpty) ...[
                  const Divider(height: 24, color: Color(0xFFE8ECF5)),
                  ...List.generate(_additionalBooksList.length, (index) {
                    final bookItem = _additionalBooksList[index];
                    final TextEditingController controller = bookItem['controller'];
                    final DateTime dueVal = bookItem['dueDate'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE8ECF5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Additional Book #${index + 2}',
                                style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Color(0xFF5B5CEB)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18, color: Color(0xFFEF4444)),
                                onPressed: () => _removeBookFromAdditionalList(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _buildAutocompleteInput(
                            controller: controller,
                            options: _bookOptions,
                            icon: LucideIcons.bookOpen,
                            hint: 'Type book title or ISBN...',
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: dueVal,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 90)),
                              );
                              if (picked != null) {
                                setState(() => _additionalBooksList[index]['dueDate'] = picked);
                              }
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE8ECF5)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF5B5CEB)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Due: ${dueVal.day}/${dueVal.month}/${dueVal.year}',
                                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: _addBookToAdditionalList,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF5B5CEB), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Add Another Book',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5B5CEB),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleIssueSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B5CEB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Issue ${1 + _additionalBooksList.length > 1 ? '${1 + _additionalBooksList.length} Books' : 'Books'}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // RECENTLY ISSUED BOOKS SECTION BELOW FORM
          _buildRecentlyIssuedSection(recentlyIssued),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return 'MB';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return clean[0].toUpperCase();
  }

  // ─── RECENTLY ISSUED BOOKS SECTION ────────────────────────────────────────
  Widget _buildRecentlyIssuedSection(List recentlyIssued) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Issued Books',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8ECF5), width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F0F172A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(recentlyIssued.length, (index) {
              final item = recentlyIssued[index];
              final String studentName = item['studentName'] ?? 'Ethan Vance';
              final String initials = _getInitials(studentName);
              final bool isLast = index == recentlyIssued.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFF0F1FF),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Color(0xFF5B5CEB),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    studentName,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F1FF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['memberId'] ?? 'STU-9921',
                                      style: const TextStyle(
                                        color: Color(0xFF5B5CEB),
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['bookName'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Due ${item['dueDate'] ?? '17 Aug'}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF5B5CEB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, color: Color(0xFFE8ECF5)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ─── TAB 2: RETURN BOOK ────────────────────────────────────────────────────
  Widget _buildReturnBookTab(List recentlyReturned) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Searchable Text Input for Student Selection
          _buildFieldLabel('Search Student Name / Member ID'),
          const SizedBox(height: 6),
          _buildAutocompleteInput(
            controller: _returnStudentInputController,
            options: _memberOptions,
            icon: LucideIcons.userCheck,
            hint: 'Type student name or ID...',
            onSelected: (val) {
              _returnStudentInputController.text = val;
              _onSelectReturnStudent(val);
            },
          ),
          const SizedBox(height: 14),

          // Member Info Summary Header
          if (_selectedReturnStudent != null && _selectedMemberData != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8ECF5)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFF0F1FF),
                    child: Text(
                      _getInitials(_selectedMemberData?['name'] ?? 'MB'),
                      style: const TextStyle(color: Color(0xFF5B5CEB), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMemberData!['name'] ?? '',
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          'ID: ${_selectedMemberData!['memberId'] ?? 'STU-8842'}',
                          style: const TextStyle(fontSize: 11.0, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F1FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_studentIssuedBooks.length} Active Issued',
                      style: const TextStyle(color: Color(0xFF5B5CEB), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Issued Books List with Checkboxes
          _buildFieldLabel('Currently Issued Books'),
          const SizedBox(height: 6),

          if (_studentIssuedBooks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0EDF8)),
                boxShadow: AppShadows.soft,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.userCheck, size: 28, color: Color(0xFF6C4CF1)),
                  SizedBox(height: 6),
                  Text(
                    'Select Student or Member',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Type student name or ID above to view currently issued books.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF7A7A9D)),
                  ),
                ],
              ),
            )
          else
            Column(
              children: List.generate(_studentIssuedBooks.length, (index) {
                final book = _studentIssuedBooks[index];
                final bool isChecked = _selectedReturnBookIndexes[index] ?? false;
                final bool isOverdue = book['isOverdue'] ?? false;
                final String condition = _bookConditions[index] ?? 'Good';

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isChecked ? const Color(0xFF5B5CEB) : const Color(0xFFE8ECF5),
                      width: isChecked ? 1.5 : 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x0F0F172A), blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            _selectedReturnBookIndexes[index] = val ?? false;
                          });
                        },
                        activeColor: const Color(0xFF5B5CEB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: Text(book['title'] ?? '', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        subtitle: Row(
                          children: [
                            Text('Due: ${book['dueDate']}', style: const TextStyle(fontSize: 11.0, color: Color(0xFF64748B))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isOverdue ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isOverdue ? 'Overdue (${book['daysOverdue']}d)' : 'On Time',
                                style: TextStyle(color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF22C55E), fontSize: 9.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (isChecked) ...[
                        const Divider(height: 1, color: Color(0xFFE8ECF5)),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Book Condition:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              const SizedBox(height: 6),

                              // Condition Chips (Good, Damaged, Lost)
                              Row(
                                children: ['Good', 'Damaged', 'Lost'].map((cond) {
                                  final isSelected = condition == cond;
                                  Color condColor = cond == 'Good'
                                      ? const Color(0xFF22C55E)
                                      : (cond == 'Damaged' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));
                                  Color condBg = cond == 'Good'
                                      ? const Color(0xFFECFDF5)
                                      : (cond == 'Damaged' ? const Color(0xFFFFFBEB) : const Color(0xFFFEF2F2));

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _bookConditions[index] = cond;
                                          if (cond == 'Damaged') {
                                            _penaltyControllers[index]?.text = '250';
                                          } else if (cond == 'Lost') {
                                            _penaltyControllers[index]?.text = '600';
                                          } else {
                                            _penaltyControllers[index]?.text = isOverdue ? '150' : '0';
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? condBg : Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected ? condColor : const Color(0xFFE8ECF5),
                                            width: isSelected ? 1.5 : 1.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cond,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? condColor : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),

                              if (condition != 'Good' || isOverdue) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F8FC),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFE8ECF5)),
                                        ),
                                        child: TextField(
                                          controller: _penaltyControllers[index],
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) => setState(() {}),
                                          decoration: const InputDecoration(
                                            prefixText: '₹ ',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Remarks Textarea
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE8ECF5)),
                                ),
                                child: TextField(
                                  controller: _remarksControllers[index],
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    hintText: 'Remarks (Optional)...',
                                    hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          const SizedBox(height: 16),

          // Action Button
          if (_selectedReturnBookIndexes.values.any((v) => v)) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handleReturnSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_hasDamagedOrLostSelection() || _calculateTotalPenalty() > 0) ? const Color(0xFF5B5CEB) : const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  (_hasDamagedOrLostSelection() || _calculateTotalPenalty() > 0)
                      ? 'Return Books & Collect Payment'
                      : 'Return Books',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Recently Returned Section
          _buildRecentlyReturnedSection(recentlyReturned),
        ],
      ),
    );
  }

  // ─── RECENTLY RETURNED SECTION ─────────────────────────────────────────────
  Widget _buildRecentlyReturnedSection(List recentlyReturned) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Returned Books',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: -0.2),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8ECF5), width: 1.0),
            boxShadow: const [
              BoxShadow(color: Color(0x0F0F172A), blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            children: List.generate(recentlyReturned.length, (index) {
              final item = recentlyReturned[index];
              final String fine = item['finePaid'] ?? '₹0';
              final bool hasFine = fine != '\$0.00' && fine != '\$0' && fine != '₹0' && fine != '₹0.00';
              final Color badgeColor = hasFine ? const Color(0xFFF59E0B) : const Color(0xFF22C55E);
              final Color badgeBg = hasFine ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5);
              final bool isLast = index == recentlyReturned.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(LucideIcons.bookCheck, color: Color(0xFF22C55E), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['studentName'] ?? '',
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['bookName'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                              ),
                              const SizedBox(height: 3),
                              Text('Returned: ${item['returnDate']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['condition'] ?? 'Good',
                            style: TextStyle(color: badgeColor, fontSize: 10.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, color: Color(0xFFE8ECF5)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ─── HELPER WIDGETS ────────────────────────────────────────────────────────
  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildAutocompleteInput({
    required TextEditingController controller,
    required List<String> options,
    required IconData icon,
    required String hint,
    ValueChanged<String>? onSelected,
  }) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
        if (onSelected != null) {
          onSelected(selection);
        }
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8ECF5), width: 1.0),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF5B5CEB)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: textController,
                  focusNode: focusNode,
                  style: const TextStyle(fontSize: 16.0, color: Color(0xFF0F172A), fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 14.0, color: Color(0xFF64748B)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      optionsViewBuilder: (context, onSelectedOption, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(context).size.width - 64,
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8ECF5)),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option, style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A))),
                    onTap: () => onSelectedOption(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
