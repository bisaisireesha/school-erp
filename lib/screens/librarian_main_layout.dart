import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

import 'librarian_portal/librarian_dashboard_screen.dart';
import 'librarian_portal/librarian_issue_return_screen.dart';
import 'librarian_portal/librarian_books_screen.dart';
import 'librarian_portal/librarian_members_screen.dart';
import 'librarian_portal/librarian_more_screen.dart';
import 'librarian_portal/librarian_categories_screen.dart';
import 'librarian_portal/librarian_racks_screen.dart';
import 'librarian_portal/librarian_lost_damaged_screen.dart';
import 'librarian_portal/librarian_profile_screen.dart';

class LibrarianMainLayout extends StatefulWidget {
  const LibrarianMainLayout({super.key});

  static void pushSubScreen(BuildContext context, Widget screen) {
    context.findAncestorStateOfType<_LibrarianMainLayoutState>()?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    context.findAncestorStateOfType<_LibrarianMainLayoutState>()?.popSubScreen();
  }

  @override
  State<LibrarianMainLayout> createState() => _LibrarianMainLayoutState();
}

class _LibrarianMainLayoutState extends State<LibrarianMainLayout> {
  int _currentIndex = 0;
  Widget? _subScreen;
  Map<String, dynamic> _librarianData = {};
  bool _isLoading = true;

  int _issueReturnInitialTab = 0;
  String? _prefilledReturnMember;

  @override
  void initState() {
    super.initState();
    _loadLibrarianData();
  }

  Future<void> _loadLibrarianData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock/librarian_portal_data.json');
      setState(() {
        _librarianData = json.decode(jsonString);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void pushSubScreen(Widget screen) {
    setState(() {
      _subScreen = screen;
    });
  }

  void popSubScreen() {
    setState(() {
      _subScreen = null;
    });
  }

  void _navigateToScreen(String screenKey, {int initialTab = 0, String? prefilledMember}) {
    setState(() {
      if (screenKey == 'issue_return') {
        _subScreen = null;
        _currentIndex = 1;
        _issueReturnInitialTab = initialTab;
        _prefilledReturnMember = prefilledMember;
      } else if (screenKey == 'books') {
        _subScreen = null;
        _currentIndex = 2;
      } else if (screenKey == 'more') {
        _subScreen = null;
        _currentIndex = 3;
      } else if (screenKey == 'fines_overdue' || screenKey == 'overdue' || screenKey == 'due_today') {
        _subScreen = null;
        _currentIndex = 1;
        _issueReturnInitialTab = 1; // Return tab
        _prefilledReturnMember = prefilledMember;
      } else if (screenKey == 'members') {
        _subScreen = LibrarianMembersScreen(
          data: _librarianData,
          onBack: popSubScreen,
          onAddStaff: _showAddStaffModal,
        );
      } else if (screenKey == 'staff_members') {
        _subScreen = LibrarianMembersScreen(
          data: _librarianData,
          initialRole: 'Staff',
          onBack: popSubScreen,
          onAddStaff: _showAddStaffModal,
        );
      } else if (screenKey == 'categories') {
        _subScreen = LibrarianCategoriesScreen(
          data: _librarianData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'shelves') {
        _subScreen = LibrarianRacksScreen(
          data: _librarianData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'lost_damaged') {
        _subScreen = LibrarianLostDamagedScreen(
          data: _librarianData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'profile') {
        _subScreen = LibrarianProfileScreen(
          data: _librarianData,
          onBack: popSubScreen,
        );
      } else {
        _subScreen = null;
        _currentIndex = 0;
      }
    });
  }

  // ─── STATE MUTATIONS (Syncs changes live across all screens & dashboard) ───

  void _issueBook({
    required String studentName,
    required String bookTitle,
    required String isbn,
    required DateTime dueDate,
  }) {
    setState(() {
      final dateStr = '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}';
      final dueStr = '${dueDate.day} ${_monthName(dueDate.month)} ${dueDate.year}';

      // 1. Add to Recently Issued List
      final List recentlyIssued = _librarianData['recentlyIssuedBooks'] as List? ?? [];
      recentlyIssued.insert(0, {
        'id': 'ISS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'studentName': studentName,
        'memberId': 'STU-${(1000 + recentlyIssued.length * 17).toString()}',
        'bookName': bookTitle,
        'isbn': isbn,
        'issueDate': dateStr,
        'dueDate': dueStr,
        'status': 'Issued',
      });
      _librarianData['recentlyIssuedBooks'] = recentlyIssued;

      // 2. Add to Recent Activity
      final List recentAct = _librarianData['recentActivity'] as List? ?? [];
      recentAct.insert(0, {
        'id': 'ACT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'type': 'Issued',
        'bookTitle': bookTitle,
        'memberName': studentName,
        'memberId': 'STU-9921',
        'timestamp': 'Just now',
        'statusBadge': 'Issued',
        'statusColor': '0xFF6C4CF1',
      });
      _librarianData['recentActivity'] = recentAct;

      // 3. Update Quick Stats
      final stats = Map<String, dynamic>.from(_librarianData['quickStats'] ?? {});
      stats['issuedToday'] = (stats['issuedToday'] as int? ?? 48) + 1;
      int avail = (stats['availableBooks'] as int? ?? 9820) - 1;
      stats['availableBooks'] = avail < 0 ? 0 : avail;
      _librarianData['quickStats'] = stats;

      // 4. Update Catalog available copies
      final List books = _librarianData['books'] as List? ?? [];
      for (var b in books) {
        if (b['title'].toString().toLowerCase().contains(bookTitle.toLowerCase()) ||
            b['isbn'].toString().contains(isbn)) {
          int curAvail = b['availableCopies'] as int? ?? 1;
          if (curAvail > 0) {
            b['availableCopies'] = curAvail - 1;
          }
        }
      }

      // 5. Update Member active issues
      final List members = _librarianData['members'] as List? ?? [];
      for (var m in members) {
        if (m['name'].toString().toLowerCase().contains(studentName.toLowerCase())) {
          m['activeIssued'] = (m['activeIssued'] as int? ?? 0) + 1;
        }
      }
    });
  }

  void _returnBook({
    required String studentName,
    required String bookTitle,
    required String isbn,
    required String condition,
    required double finePaid,
    required bool isOverdue,
  }) {
    setState(() {
      final dateStr = '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}';

      // 1. Add to Recently Returned List
      final List recentlyReturned = _librarianData['recentlyReturnedBooks'] as List? ?? [];
      recentlyReturned.insert(0, {
        'id': 'RET-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'studentName': studentName,
        'memberId': 'STU-8842',
        'bookName': bookTitle,
        'isbn': isbn,
        'returnDate': dateStr,
        'finePaid': finePaid > 0 ? '₹${finePaid.toStringAsFixed(0)}' : '₹0',
        'status': isOverdue ? 'Late Return' : 'Returned On Time',
        'condition': condition,
      });
      _librarianData['recentlyReturnedBooks'] = recentlyReturned;

      // 2. Add to Recent Activity
      final List recentAct = _librarianData['recentActivity'] as List? ?? [];
      recentAct.insert(0, {
        'id': 'ACT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'type': 'Returned',
        'bookTitle': bookTitle,
        'memberName': studentName,
        'memberId': 'STU-8842',
        'timestamp': 'Just now',
        'statusBadge': isOverdue ? 'Late Return (₹${finePaid.toStringAsFixed(0)} Fine)' : 'Returned On Time',
        'statusColor': isOverdue ? '0xFFF59E0B' : '0xFF10B981',
      });
      _librarianData['recentActivity'] = recentAct;

      // 3. Remove from Overdue books list if present
      final List overdueList = _librarianData['overdueBooks'] as List? ?? [];
      overdueList.removeWhere((item) =>
          item['memberName'].toString().toLowerCase().contains(studentName.toLowerCase()) ||
          item['bookTitle'].toString().toLowerCase().contains(bookTitle.toLowerCase()));
      _librarianData['overdueBooks'] = overdueList;

      // 4. Remove from Today's due returns list if present
      final List dueReturnsList = _librarianData['todaysDueReturns'] as List? ?? [];
      dueReturnsList.removeWhere((item) =>
          item['memberName'].toString().toLowerCase().contains(studentName.toLowerCase()) ||
          item['bookTitle'].toString().toLowerCase().contains(bookTitle.toLowerCase()));
      _librarianData['todaysDueReturns'] = dueReturnsList;

      // 5. Update Quick Stats
      final stats = Map<String, dynamic>.from(_librarianData['quickStats'] ?? {});
      stats['availableBooks'] = (stats['availableBooks'] as int? ?? 9820) + 1;
      if (isOverdue) {
        int ov = (stats['overdueBooks'] as int? ?? 14) - 1;
        stats['overdueBooks'] = ov < 0 ? 0 : ov;
      }

      if (finePaid > 0) {
        String curFines = stats['totalFinesCollected'] ?? '₹420.00';
        double currentVal = double.tryParse(curFines.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 420.0;
        stats['totalFinesCollected'] = '₹${(currentVal + finePaid).toStringAsFixed(0)}';
      }
      _librarianData['quickStats'] = stats;

      // 6. Update Catalog available copies
      final List books = _librarianData['books'] as List? ?? [];
      for (var b in books) {
        if (b['title'].toString().toLowerCase().contains(bookTitle.toLowerCase()) ||
            b['isbn'].toString().contains(isbn)) {
          b['availableCopies'] = (b['availableCopies'] as int? ?? 0) + 1;
        }
      }

      // 7. Update Member active issues
      final List members = _librarianData['members'] as List? ?? [];
      for (var m in members) {
        if (m['name'].toString().toLowerCase().contains(studentName.toLowerCase())) {
          int curActive = m['activeIssued'] as int? ?? 1;
          m['activeIssued'] = curActive > 0 ? curActive - 1 : 0;
        }
      }

      // 8. Flag stock alerts if damaged or lost
      if (condition == 'Damaged' || condition == 'Lost') {
        final List stockAlerts = _librarianData['stockAlerts'] as List? ?? [];
        stockAlerts.insert(0, {
          'id': 'ALT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'type': condition == 'Damaged' ? 'Damaged Books' : 'Lost Books',
          'count': 1,
          'label': '$bookTitle ($condition)',
          'description': 'Reported during return by $studentName. Fine collected: ₹${finePaid.toStringAsFixed(0)}',
          'severity': condition == 'Damaged' ? 'Alert' : 'Critical',
          'color': condition == 'Damaged' ? '0xFFF59E0B' : '0xFFEF4444',
          'bgColor': condition == 'Damaged' ? '0xFFFFFBEB' : '0xFFFEF2F2',
        });
        _librarianData['stockAlerts'] = stockAlerts;
      }
    });
  }

  void _addBook(Map<String, dynamic> newBook) {
    setState(() {
      final List books = _librarianData['books'] as List? ?? [];
      books.insert(0, newBook);
      _librarianData['books'] = books;

      final stats = Map<String, dynamic>.from(_librarianData['quickStats'] ?? {});
      int addedCount = newBook['totalCopies'] as int? ?? 1;
      stats['totalBooks'] = (stats['totalBooks'] as int? ?? 12450) + addedCount;
      stats['availableBooks'] = (stats['availableBooks'] as int? ?? 9820) + addedCount;
      _librarianData['quickStats'] = stats;
    });
  }

  void _addMember(Map<String, dynamic> newMember) {
    setState(() {
      final List members = _librarianData['members'] as List? ?? [];
      members.insert(0, newMember);
      _librarianData['members'] = members;

      final stats = Map<String, dynamic>.from(_librarianData['quickStats'] ?? {});
      stats['totalMembers'] = (stats['totalMembers'] as int? ?? 1280) + 1;
      _librarianData['quickStats'] = stats;
    });
  }

  // ─── QUICK ACTION HANDLER ──────────────────────────────────────────────────

  void _handleQuickAction(String actionKey) {
    if (actionKey == 'issue_book') {
      _showAddIssueModal();
    } else if (actionKey == 'return_book') {
      _navigateToScreen('issue_return', initialTab: 1);
    } else if (actionKey == 'add_book') {
      _showAddBookModal();
    } else if (actionKey == 'add_staff') {
      _showAddStaffModal();
    } else {
      _navigateToScreen(actionKey);
    }
  }

  void _showAddIssueModal() {
    final nameCtrl = TextEditingController(text: 'Ethan Vance (STU-9921)');
    final bookCtrl = TextEditingController(text: 'To Kill a Mockingbird (ISBN: 978-0446310789)');
    DateTime dueDate = DateTime.now().add(const Duration(days: 14));

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
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(LucideIcons.bookUp, color: Color(0xFF6C4CF1), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Issue Book to Member',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Member Name / ID',
                      prefixIcon: const Icon(LucideIcons.user, size: 18, color: Color(0xFF6C4CF1)),
                      filled: true,
                      fillColor: const Color(0xFFF9F8FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bookCtrl,
                    decoration: InputDecoration(
                      labelText: 'Book Title / ISBN',
                      prefixIcon: const Icon(LucideIcons.bookOpen, size: 18, color: Color(0xFF6C4CF1)),
                      filled: true,
                      fillColor: const Color(0xFFF9F8FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (picked != null) {
                        setModalState(() => dueDate = picked);
                      }
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEBE8FF)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF6C4CF1)),
                          const SizedBox(width: 10),
                          Text('Due Date: ${dueDate.day}/${dueDate.month}/${dueDate.year}', style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final student = nameCtrl.text.split(' (')[0];
                        final book = bookCtrl.text.split(' (')[0];
                        _issueBook(
                          studentName: student.isEmpty ? 'Ethan Vance' : student,
                          bookTitle: book.isEmpty ? 'To Kill a Mockingbird' : book,
                          isbn: '978-0446310789',
                          dueDate: dueDate,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Book issued successfully & catalog updated!'),
                            backgroundColor: Color(0xFF6C4CF1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4CF1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Confirm Book Issue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
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

  void _showAddBookModal() {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final isbnCtrl = TextEditingController();
    final rackCtrl = TextEditingController();
    final copiesCtrl = TextEditingController(text: '5');
    String selectedCategory = 'Fiction';

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
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(LucideIcons.bookPlus, color: Color(0xFF3B82F6), size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Add New Book to Catalog',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Book Title',
                        filled: true,
                        fillColor: const Color(0xFFF9F8FF),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: authorCtrl,
                      decoration: InputDecoration(
                        labelText: 'Author Name',
                        filled: true,
                        fillColor: const Color(0xFFF9F8FF),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: isbnCtrl,
                            decoration: InputDecoration(
                              labelText: 'ISBN',
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: rackCtrl,
                            decoration: InputDecoration(
                              labelText: 'Rack No. (e.g. B-04)',
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                            ),
                            items: ['Fiction', 'Science', 'Technology', 'History', 'Social Science']
                                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedCategory = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: copiesCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Copies',
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleCtrl.text.trim();
                          if (title.isEmpty) return;
                          final author = authorCtrl.text.trim().isEmpty ? 'Unknown Author' : authorCtrl.text.trim();
                          final isbn = isbnCtrl.text.trim().isEmpty ? '978-0000000000' : isbnCtrl.text.trim();
                          final rack = rackCtrl.text.trim().isEmpty ? 'R-01' : rackCtrl.text.trim();
                          final int copies = int.tryParse(copiesCtrl.text.trim()) ?? 5;

                          _addBook({
                            'id': 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                            'title': title,
                            'author': author,
                            'isbn': isbn,
                            'category': selectedCategory,
                            'totalCopies': copies,
                            'availableCopies': copies,
                            'rackNumber': rack,
                            'status': 'Available',
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added "$title" ($copies copies) to library catalog!'),
                              backgroundColor: const Color(0xFF3B82F6),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Add Book to Catalog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
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

  void _showAddStaffModal() {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final deptCtrl = TextEditingController(text: 'Library Administration');
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.userPlus, color: Color(0xFFF59E0B), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add Staff / Library Member',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Staff Full Name',
                  filled: true,
                  fillColor: const Color(0xFFF9F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: idCtrl,
                decoration: InputDecoration(
                  labelText: 'Employee ID (e.g. STF-5099)',
                  filled: true,
                  fillColor: const Color(0xFFF9F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: deptCtrl,
                decoration: InputDecoration(
                  labelText: 'Department / Role',
                  filled: true,
                  fillColor: const Color(0xFFF9F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  filled: true,
                  fillColor: const Color(0xFFF9F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEBE8FF))),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;
                    final id = idCtrl.text.trim().isEmpty ? 'STF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}' : idCtrl.text.trim();

                    _addMember({
                      'id': 'MEM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      'name': name,
                      'memberId': id,
                      'role': 'Staff',
                      'department': deptCtrl.text.trim().isEmpty ? 'Library Administration' : deptCtrl.text.trim(),
                      'activeIssued': 0,
                      'pendingFine': '₹0.00',
                      'email': emailCtrl.text.trim().isEmpty ? '${name.toLowerCase().replaceAll(' ', '.')}@school.edu' : emailCtrl.text.trim(),
                      'phone': '+1 (555) 000-0000',
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Staff member "$name" ($id) added to library system!'),
                        backgroundColor: const Color(0xFFF59E0B),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Staff Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── BUILD 4 TOP-LEVEL SCREENS (Home, Issue & Return, Books, More) ──────

  List<Widget> get _screens => [
        LibrarianDashboardScreen(
          data: _librarianData,
          onNavigate: _navigateToScreen,
          onQuickAction: _handleQuickAction,
        ),
        LibrarianIssueReturnScreen(
          data: _librarianData,
          initialTabIndex: _issueReturnInitialTab,
          prefilledMember: _prefilledReturnMember,
          onBack: () => setState(() => _currentIndex = 0),
          onIssueBook: _issueBook,
          onReturnBook: _returnBook,
        ),
        LibrarianBooksScreen(
          data: _librarianData,
          onBack: () => setState(() => _currentIndex = 0),
          onAddBook: _showAddBookModal,
        ),
        LibrarianMoreScreen(
          data: _librarianData,
          onNavigate: (key) => _navigateToScreen(key),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6C4CF1))),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 0.84, 1.0],
                  colors: [
                    const Color(0xFF995EFF).withValues(alpha: 0.35),
                    const Color(0xFFCCAEFF).withValues(alpha: 0.25),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          // Main Content Area
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                SizedBox(
                  height: AppSpacing.headerHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildShieldLogo(),
                        const SizedBox(width: AppSpacing.logoTextGap),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sunrise Academy',
                                style: AppTypography.schoolName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Librarian Portal',
                                style: AppTypography.portalSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildIconButton(
                              icon: LucideIcons.messageSquare,
                              badgeCount: 2,
                              badgeColor: const Color(0xFF5B5CEB),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Librarian Messages & Notices')),
                                );
                              },
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildIconButton(
                              icon: Icons.notifications_none_rounded,
                              badgeCount: (_librarianData['overdueBooks'] as List? ?? []).length,
                              badgeColor: const Color(0xFFFF4B4B),
                              onTap: () {
                                _navigateToScreen('issue_return', initialTab: 1);
                              },
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildProfileAvatar(initials: 'SJ'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Dynamic Scrollable Screen Body
                Expanded(
                  child: _subScreen ?? _screens[(_currentIndex >= 0 && _currentIndex < _screens.length) ? _currentIndex : 0],
                ),
              ],
            ),
          ),

          // Floating 4-Tab Bottom Navigation Bar (Home, Issue & Return, Books, More)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildShieldLogo() {
    return Container(
      width: AppSpacing.logoSize,
      height: AppSpacing.logoSize,
      alignment: Alignment.center,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            child: Icon(Icons.shield, color: Color(0x336C4CF1), size: 38),
          ),
          Icon(Icons.shield, color: Color(0xFF6C4CF1), size: 38),
          Icon(Icons.shield, color: Colors.white, size: 32),
          Icon(Icons.shield, color: Color(0xFFFFB300), size: 26),
          Icon(LucideIcons.bookOpen, color: Color(0xFF6C4CF1), size: 14),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar({required String initials}) {
    return GestureDetector(
      onTap: () => _navigateToScreen('profile'),
      child: Container(
        width: AppSpacing.actionContainerSize,
        height: AppSpacing.actionContainerSize,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFECE8F8), width: 2),
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF6C4CF1),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required int badgeCount,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: AppSpacing.actionContainerSize,
            height: AppSpacing.actionContainerSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child: Icon(icon, color: const Color(0xFF1E1E2D), size: AppSpacing.headerIconSize),
          ),
          if (badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: AppSpacing.badgeSize,
                height: AppSpacing.badgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF7F5FF), width: 1.5),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        height: AppSpacing.bottomNavHeight,
        margin: const EdgeInsets.only(
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          bottom: AppSpacing.lg,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E1E2D).withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavItem(
              activeIcon: Icons.home_rounded,
              inactiveIcon: Icons.home_outlined,
              label: 'Home',
              isActive: _currentIndex == 0 && _subScreen == null,
              index: 0,
              size: 26.5,
            ),
            _buildNavItem(
              activeIcon: LucideIcons.arrowLeftRight,
              inactiveIcon: LucideIcons.arrowLeftRight,
              label: 'Issue & Return',
              isActive: _currentIndex == 1 && _subScreen == null,
              index: 1,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.menu_book_rounded,
              inactiveIcon: Icons.menu_book_outlined,
              label: 'Books',
              isActive: _currentIndex == 2 && _subScreen == null,
              index: 2,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.grid_view_rounded,
              inactiveIcon: Icons.grid_view_outlined,
              label: 'More',
              isActive: _currentIndex == 3 && _subScreen == null,
              index: 3,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required bool isActive,
    required int index,
    double size = 24.0,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _subScreen = null;
            if (index == 1) {
              _issueReturnInitialTab = 0;
              _prefilledReturnMember = null;
            }
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Center(
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                    size: size,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
