import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

import 'teacher_portal/teacher_dashboard_screen.dart';
import 'teacher_portal/teacher_classes_screen.dart';
import 'teacher_portal/teacher_class_details_screen.dart';
import 'teacher_portal/teacher_attendance_screen.dart';
import 'teacher_portal/teacher_homework_screen.dart';
import 'teacher_portal/teacher_assignments_screen.dart';
import 'teacher_portal/teacher_exams_screen.dart';
import 'teacher_portal/teacher_timetable_screen.dart';
import 'teacher_portal/teacher_messages_screen.dart';
import 'teacher_portal/teacher_resources_screen.dart';
import 'teacher_portal/teacher_transport_screen.dart';
import 'teacher_portal/teacher_payroll_screen.dart';
import 'teacher_portal/teacher_calendar_screen.dart';
import 'teacher_portal/teacher_profile_screen.dart';
import 'teacher_portal/teacher_settings_screen.dart';
import 'teacher_portal/teacher_more_screen.dart';
import 'teacher_portal/teacher_create_bottom_sheet.dart';
import 'teacher_portal/teacher_my_attendance_screen.dart';

class TeacherMainLayout extends StatefulWidget {
  const TeacherMainLayout({super.key});

  static void pushSubScreen(BuildContext context, Widget screen) {
    context.findAncestorStateOfType<_TeacherMainLayoutState>()?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    context.findAncestorStateOfType<_TeacherMainLayoutState>()?.popSubScreen();
  }

  @override
  State<TeacherMainLayout> createState() => _TeacherMainLayoutState();
}

class _TeacherMainLayoutState extends State<TeacherMainLayout> {
  int _currentIndex = 0;
  Widget? _subScreen;
  String? _activeModuleKey;
  Map<String, dynamic> _teacherData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  @override
  void dispose() {
    _notificationOverlayEntry?.remove();
    _notificationOverlayEntry = null;
    super.dispose();
  }

  Future<void> _loadTeacherData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock/teacher_portal_data.json');
      if (mounted) {
        setState(() {
          _teacherData = json.decode(jsonString);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      _activeModuleKey = null;
      if (_currentIndex == -1) {
        _currentIndex = 0;
      }
    });
  }

  void _navigateToScreen(String screenKey, {Map<String, dynamic>? arguments}) {
    setState(() {
      if (screenKey == 'dashboard') {
        _subScreen = null;
        _currentIndex = 0;
        _activeModuleKey = null;
      } else if (screenKey == 'classes') {
        _subScreen = null;
        _currentIndex = 1;
        _activeModuleKey = null;
      } else if (screenKey == 'attendance') {
        _subScreen = null;
        _currentIndex = 2;
        _activeModuleKey = null;
      } else if (screenKey == 'more') {
        _subScreen = null;
        _currentIndex = 3;
        _activeModuleKey = null;
      } else if (screenKey == 'messages') {
        _currentIndex = -1;
        _activeModuleKey = 'messages';
        _subScreen = TeacherMessagesScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'class_details') {
        _currentIndex = 1;
        _activeModuleKey = 'classes';
        _subScreen = TeacherClassDetailsScreen(
          classData: arguments ?? (_teacherData['classes']?[0] ?? {}),
          globalData: _teacherData,
          onBack: popSubScreen,
          onNavigate: _navigateToScreen,
        );
      } else if (screenKey == 'homework') {
        _currentIndex = 3;
        _activeModuleKey = 'homework';
        _subScreen = TeacherHomeworkScreen(
          data: _teacherData,
          onBack: popSubScreen,
          onAddHomework: _addHomework,
        );
      } else if (screenKey == 'assignments') {
        _currentIndex = 3;
        _activeModuleKey = 'assignments';
        _subScreen = TeacherAssignmentsScreen(
          data: _teacherData,
          onBack: popSubScreen,
          onAddAssignment: _addAssignment,
        );
      } else if (screenKey == 'exams') {
        _currentIndex = 3;
        _activeModuleKey = 'exams';
        _subScreen = TeacherExamsScreen(
          data: _teacherData,
          onBack: popSubScreen,
          onUpdateExam: _updateExam,
        );
      } else if (screenKey == 'timetable') {
        _currentIndex = 3;
        _activeModuleKey = 'timetable';
        _subScreen = TeacherTimetableScreen(
          data: _teacherData,
          onBack: popSubScreen,
          onNavigate: _navigateToScreen,
        );
      } else if (screenKey == 'resources' || screenKey == 'study_material') {
        _currentIndex = 3;
        _activeModuleKey = 'resources';
        _subScreen = TeacherResourcesScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'transport') {
        _currentIndex = 3;
        _activeModuleKey = 'transport';
        _subScreen = TeacherTransportScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'my_attendance') {
        _currentIndex = 3;
        _activeModuleKey = 'my_attendance';
        _subScreen = TeacherMyAttendanceScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'payroll') {
        _currentIndex = 3;
        _activeModuleKey = 'payroll';
        _subScreen = TeacherPayrollScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'calendar') {
        _currentIndex = 3;
        _activeModuleKey = 'calendar';
        _subScreen = TeacherCalendarScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'profile') {
        _currentIndex = -1;
        _activeModuleKey = 'profile';
        _subScreen = TeacherProfileScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else if (screenKey == 'settings') {
        _currentIndex = 3;
        _subScreen = TeacherSettingsScreen(
          data: _teacherData,
          onBack: popSubScreen,
        );
      } else {
        _subScreen = null;
        _currentIndex = 0;
      }
    });
  }

  // ─── STATE MUTATIONS (Syncs changes live across all screens & dashboard) ───

  void _submitAttendance(String classId, List<Map<String, dynamic>> attendanceRecords) {
    setState(() {
      final stats = Map<String, dynamic>.from(_teacherData['quickStats'] ?? {});
      int pending = stats['pendingAttendance'] ?? 1;
      if (pending > 0) {
        stats['pendingAttendance'] = pending - 1;
      }
      _teacherData['quickStats'] = stats;

      // Update class attendance status
      final List classes = _teacherData['classes'] as List? ?? [];
      for (var c in classes) {
        if (c['className'].toString().contains(classId) || classId.contains(c['className'].toString())) {
          c['isAttendancePending'] = false;
          c['attendanceStatus'] = 'Marked Today';
        }
      }

      // Clear related Need Attention item
      final List needAtt = _teacherData['needAttention'] as List? ?? [];
      needAtt.removeWhere((item) => item['targetScreen'] == 'attendance');
      _teacherData['needAttention'] = needAtt;
    });
  }

  void _addHomework(Map<String, dynamic> newHomework) {
    setState(() {
      final List hw = _teacherData['homeworkList'] as List? ?? [];
      hw.insert(0, newHomework);
      _teacherData['homeworkList'] = hw;
    });
  }

  void _addAssignment(Map<String, dynamic> newAssignment) {
    setState(() {
      final List asg = _teacherData['assignmentsList'] as List? ?? [];
      asg.insert(0, newAssignment);
      _teacherData['assignmentsList'] = asg;
    });
  }

  void _updateExam(Map<String, dynamic> updatedExam) {
    setState(() {
      final List exams = _teacherData['examsList'] as List? ?? [];
      final idx = exams.indexWhere((e) => e['id'] == updatedExam['id']);
      if (idx != -1) {
        exams[idx] = updatedExam;
      }
      _teacherData['examsList'] = exams;
    });
  }

  // ─── QUICK ACTION HANDLERS ───

  void _handleQuickAction(String actionKey) {
    if (actionKey == 'take_attendance') {
      _navigateToScreen('attendance');
    } else if (actionKey == 'create_homework') {
      _showCreateHomeworkModal();
    } else if (actionKey == 'create_assignment') {
      _showCreateAssignmentModal();
    } else if (actionKey == 'view_timetable') {
      _navigateToScreen('timetable');
    } else {
      _navigateToScreen(actionKey);
    }
  }

  void _showCreateHomeworkModal() {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.homework,
      onSubmit: (data) {
        final newHw = {
          'id': 'HW-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'title': data['title'] ?? 'Homework Task',
          'subject': data['subject'] ?? 'Mathematics',
          'className': data['className'] ?? 'Class 10-A',
          'dueDate': data['dueDate'] ?? '15 Aug 2026',
          'status': 'Active',
          'submittedCount': 0,
          'totalCount': 34,
          'description': data['description'] ?? '',
          'attachments': data['attachments'] ?? 'Worksheet.pdf',
        };
        _addHomework(newHw);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created Homework "${newHw['title']}" for ${newHw['className']}!'),
            backgroundColor: const Color(0xFF6C4CF1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  void _showCreateAssignmentModal() {
    TeacherCreateBottomSheet.show(
      context: context,
      type: TeacherCreateType.assignment,
      onSubmit: (data) {
        final newAsg = {
          'id': 'ASG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'title': data['title'] ?? 'Assignment Project',
          'subject': data['subject'] ?? 'Mathematics',
          'className': data['className'] ?? 'Class 10-A',
          'dueDate': data['dueDate'] ?? '20 Aug 2026',
          'totalMarks': data['totalMarks'] ?? 50,
          'submissionCount': '0 / 34 Submitted',
          'status': 'Open',
          'description': data['description'] ?? '',
        };
        _addAssignment(newAsg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created Assignment "${newAsg['title']}" for ${newAsg['className']}!'),
            backgroundColor: const Color(0xFF6C4CF1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  // ─── NOTIFICATION POPOVER TOOLTIP NOTCH (Identical to Librarian) ───

  bool _isNotificationPopoverOpen = false;
  OverlayEntry? _notificationOverlayEntry;

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Attendance Reminder',
      'message': 'Period 4 Calculus attendance needs to be submitted.',
      'time': '10m ago',
      'isUnread': true,
      'targetScreen': 'attendance',
      'icon': LucideIcons.calendarClock,
      'iconColor': const Color(0xFFFF4B4B),
    },
    {
      'id': '2',
      'title': 'New Homework Submissions',
      'message': '5 students turned in Math Quadratic exercises.',
      'time': '35m ago',
      'isUnread': true,
      'targetScreen': 'homework',
      'icon': LucideIcons.bookOpen,
      'iconColor': const Color(0xFF6C4CF1),
    },
    {
      'id': '3',
      'title': 'Curriculum Review Passed',
      'message': 'Term 1 Mathematics blueprint approved by Dept Chair.',
      'time': '2h ago',
      'isUnread': false,
      'targetScreen': 'exams',
      'icon': LucideIcons.circleCheck,
      'iconColor': const Color(0xFF10B981),
    },
  ];

  int get _unreadNotificationCount =>
      _notifications.where((n) => n['isUnread'] == true).length;

  void _hideNotificationPopover() {
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry?.remove();
      _notificationOverlayEntry = null;
      if (mounted) {
        setState(() {
          _isNotificationPopoverOpen = false;
        });
      }
    }
  }

  void _toggleNotificationPopover() {
    if (_isNotificationPopoverOpen) {
      _hideNotificationPopover();
    } else {
      _showNotificationPopover();
    }
  }

  void _showNotificationPopover() {
    _notificationOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Modal Barrier to dismiss popover when tapping outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideNotificationPopover,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Floating Popover Card anchored right below top header bell icon
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.headerHeight + 4,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Top Pointer Arrow Notch
                    Positioned(
                      top: -5,
                      right: 48,
                      child: Transform.rotate(
                        angle: 0.785398, // 45 degrees
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1A1E1E2D),
                                blurRadius: 4,
                                offset: Offset(-2, -2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Popover Card
                    Container(
                      width: 320,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0EDF8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E1E2D).withValues(alpha: 0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Popover Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(LucideIcons.bell, size: 16, color: Color(0xFF6C4CF1)),
                                  SizedBox(width: 6),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (var n in _notifications) {
                                      n['isUnread'] = false;
                                    }
                                  });
                                  _hideNotificationPopover();
                                },
                                child: const Text(
                                  'Mark all read',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C4CF1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1, color: Color(0xFFF0EDF8)),
                          const SizedBox(height: 6),

                          // Notification Items List
                          ..._notifications.map((notif) {
                            final String title = notif['title'];
                            final String message = notif['message'];
                            final String time = notif['time'];
                            final bool isUnread = notif['isUnread'];
                            final IconData icon = notif['icon'];
                            final Color iconColor = notif['iconColor'];
                            final String targetScreen = notif['targetScreen'];

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  notif['isUnread'] = false;
                                });
                                _hideNotificationPopover();
                                _navigateToScreen(targetScreen);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: iconColor.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(icon, size: 16, color: iconColor),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                                    color: const Color(0xFF1E1E2D),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                time,
                                                style: const TextStyle(fontSize: 12.0, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            message,
                                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.35),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isUnread) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        width: 7,
                                        height: 7,
                                        margin: const EdgeInsets.only(top: 4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF4B4B),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_notificationOverlayEntry!);
    setState(() {
      _isNotificationPopoverOpen = true;
    });
  }

  // ─── BUILD 4 TOP-LEVEL SCREENS (Home, Classes, Attendance, More) ──────

  List<Widget> get _screens => [
        TeacherDashboardScreen(
          data: _teacherData,
          onNavigate: _navigateToScreen,
          onQuickAction: _handleQuickAction,
        ),
        TeacherClassesScreen(
          data: _teacherData,
          onBack: () => setState(() => _currentIndex = 0),
          onNavigate: _navigateToScreen,
        ),
        TeacherAttendanceScreen(
          data: _teacherData,
          onBack: () => setState(() => _currentIndex = 0),
          onSubmitAttendance: _submitAttendance,
        ),
        TeacherMoreScreen(
          data: _teacherData,
          activeModuleKey: _activeModuleKey,
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

    final bool isInsideMessages = _subScreen is TeacherMessagesScreen || _activeModuleKey == 'messages';
    final bool isFullScreenSubScreen = _subScreen is TeacherTransportScreen;

    if (isFullScreenSubScreen && _subScreen != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            popSubScreen();
          }
        },
        child: _subScreen!,
      );
    }

    return PopScope(
      canPop: _subScreen == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _subScreen != null) {
          popSubScreen();
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Background (Identical to Librarian)
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
                                'Teacher Portal',
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
                              badgeCount: isInsideMessages ? 0 : 2,
                              badgeColor: const Color(0xFF5B5CEB),
                              isActive: isInsideMessages,
                              onTap: () {
                                _navigateToScreen('messages');
                              },
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildIconButton(
                              icon: Icons.notifications_none_rounded,
                              badgeCount: _unreadNotificationCount,
                              badgeColor: const Color(0xFFFF4B4B),
                              onTap: _toggleNotificationPopover,
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildProfileAvatar(initials: 'SW'),
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

          // Floating 4-Tab Bottom Navigation Bar (Home, Classes, Attendance, More)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
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
          Icon(LucideIcons.graduationCap, color: Color(0xFF6C4CF1), size: 14),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar({required String initials}) {
    final bool isInsideProfile = _activeModuleKey == 'profile' || _subScreen is TeacherProfileScreen;
    return GestureDetector(
      onTap: () => _navigateToScreen('profile'),
      child: Container(
        width: AppSpacing.actionContainerSize,
        height: AppSpacing.actionContainerSize,
        decoration: BoxDecoration(
          color: isInsideProfile ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
          shape: BoxShape.circle,
          border: Border.all(
            color: isInsideProfile ? const Color(0xFF6C4CF1) : const Color(0xFFECE8F8),
            width: 2,
          ),
          boxShadow: isInsideProfile
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C4CF1).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: isInsideProfile ? Colors.white : const Color(0xFF6C4CF1),
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
    bool isActive = false,
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
              color: isActive ? const Color(0xFF6C4CF1) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6C4CF1).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : AppShadows.soft,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF1E1E2D),
              size: AppSpacing.headerIconSize,
            ),
          ),
          if (badgeCount > 0 && !isActive)
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
                  style: AppTypography.badgeText.copyWith(
                    color: Colors.white,
                    fontSize: 11.0,
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      return const SizedBox.shrink();
    }

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
              isActive: _currentIndex == 0,
              index: 0,
              size: 26.5,
            ),
            _buildNavItem(
              activeIcon: Icons.school_rounded,
              inactiveIcon: Icons.school_outlined,
              label: 'Classes',
              isActive: _currentIndex == 1,
              index: 1,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.how_to_reg_rounded,
              inactiveIcon: Icons.how_to_reg_outlined,
              label: 'Attendance',
              isActive: _currentIndex == 2,
              index: 2,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.grid_view_rounded,
              inactiveIcon: Icons.grid_view_outlined,
              label: 'More',
              isActive: _currentIndex == 3,
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
                    color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF64748B),
                    size: size,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  fontSize: 12.0,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF64748B),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
