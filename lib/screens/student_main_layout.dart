import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';

import '../theme/app_theme.dart';
import 'student_dashboard/student_dashboard_screen.dart';
import 'student_subjects/student_subjects_screen.dart';
import 'student_attendance/student_attendance_screen.dart';
import 'student_homework/student_homework_screen.dart';
import 'student_exams/student_exams_screen.dart';
import 'student_timetable/student_timetable_screen.dart';
import 'student_school/student_school_screen.dart';
import 'student_fees/student_fees_screen.dart';
import 'student_messages/student_messages_screen.dart';
import 'student_events/student_events_screen.dart';
import 'student_library/student_library_screen.dart';
import 'student_leave/student_leave_screen.dart';
import 'student_transport/student_transport_screen.dart';
import 'student_hostel/student_hostel_screen.dart';
import 'student_services/student_services_screen.dart';
import 'student_study_material/student_study_material_screen.dart';
import 'student_more/student_more_screen.dart';

class StudentMainLayout extends StatefulWidget {
  const StudentMainLayout({super.key});

  static void pushSubScreen(BuildContext context, Widget screen) {
    context.findAncestorStateOfType<_StudentMainLayoutState>()?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    context.findAncestorStateOfType<_StudentMainLayoutState>()?.popSubScreen();
  }

  @override
  State<StudentMainLayout> createState() => _StudentMainLayoutState();
}

class _StudentMainLayoutState extends State<StudentMainLayout> {
  int _currentIndex = 0;
  Widget? _subScreen;
  Map<String, dynamic> _studentData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock/student_data.json');
      setState(() {
        _studentData = json.decode(jsonString);
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

  void _navigateToScreen(String screenKey) {
    setState(() {
      _subScreen = _buildSubScreenWidget(screenKey);
    });
  }

  Widget _buildSubScreenWidget(String key) {
    switch (key) {
      case 'subjects':
        return StudentSubjectsScreen(data: _studentData, onBack: popSubScreen);
      case 'attendance':
        return StudentAttendanceScreen(data: _studentData, onBack: popSubScreen);
      case 'homework':
        return StudentHomeworkScreen(data: _studentData, onBack: popSubScreen);
      case 'exams':
        return StudentExamsScreen(data: _studentData, onBack: popSubScreen);
      case 'timetable':
        return StudentTimetableScreen(data: _studentData, onBack: popSubScreen);
      case 'school':
        return StudentSchoolScreen(data: _studentData, onBack: popSubScreen);
      case 'fees':
        return StudentFeesScreen(data: _studentData, onBack: popSubScreen);
      case 'messages':
        return StudentMessagesScreen(data: _studentData, onBack: popSubScreen);
      case 'events':
        return StudentEventsScreen(data: _studentData, onBack: popSubScreen);
      case 'library':
        return StudentLibraryScreen(data: _studentData, onBack: popSubScreen);
      case 'leave':
        return StudentLeaveScreen(data: _studentData, onBack: popSubScreen);
      case 'transport':
        return StudentTransportScreen(data: _studentData, onBack: popSubScreen);
      case 'hostel':
        return StudentHostelScreen(data: _studentData, onBack: popSubScreen);
      case 'services':
        return StudentServicesScreen(data: _studentData, onBack: popSubScreen);
      case 'study_material':
        return StudentStudyMaterialScreen(data: _studentData, onBack: popSubScreen);
      default:
        return StudentDashboardScreen(data: _studentData, onNavigate: _navigateToScreen);
    }
  }

  List<Widget> get _screens => [
    StudentDashboardScreen(data: _studentData, onNavigate: _navigateToScreen),
    StudentSubjectsScreen(data: _studentData, onBack: () => setState(() => _currentIndex = 0)),
    StudentFeesScreen(data: _studentData, onBack: () => setState(() => _currentIndex = 0)),
    StudentMoreScreen(data: _studentData, onNavigate: _navigateToScreen),
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
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 0.84, 1.0],
                  colors: [
                    const Color(0xFF995EFF).withValues(alpha: 0.40),
                    const Color(0xFFCCAEFF).withValues(alpha: 0.30),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.20),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row (Exact Parent App Copy: 72px Height, 20px side padding, 16px bottom spacing)
                SizedBox(
                  height: AppSpacing.headerHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // School Logo (44 x 44px Shield Logo)
                        _buildShieldLogo(),
                        const SizedBox(width: AppSpacing.logoTextGap),
                        // Title & Subtitle (Sunrise Academy / Student Portal)
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
                                'Student Portal',
                                style: AppTypography.portalSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Action Buttons (Exact Parent App Copy: 44 x 44px containers, badges, student initials AV)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildIconButton(
                              icon: Icons.chat_bubble_outline_rounded,
                              badgeCount: 2,
                              badgeColor: const Color(0xFF6C4CF1),
                              onTap: () => _navigateToScreen('messages'),
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildIconButton(
                              icon: Icons.notifications_none_rounded,
                              badgeCount: 3,
                              badgeColor: const Color(0xFFFF4B4B),
                              onTap: () => _navigateToScreen('school'),
                            ),
                            const SizedBox(width: AppSpacing.actionIconGap),
                            _buildProfileAvatar(initials: 'AV'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.headerBottomSpacing),

                // Search Bar (Exact Parent App Copy: Height: 48px, Radius: 24px, Padding: 16px)
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.screenPadding,
                    right: AppSpacing.screenPadding,
                    top: AppSpacing.searchBarMarginTop,
                    bottom: AppSpacing.searchBarMarginBottom,
                  ),
                  child: _buildSearchBar(),
                ),

                // Dynamic Scrollable Content Area
                Expanded(
                  child: _subScreen ?? _screens[_currentIndex],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  // --- Shell UI Methods (Exact Clone of Parent App Layout) ---
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
            child: Icon(Icons.shield, color: Color(0x336C4CF1), size: 44),
          ),
          Icon(Icons.shield, color: Color(0xFF6C4CF1), size: 44),
          Icon(Icons.shield, color: Colors.white, size: 38),
          Icon(Icons.shield, color: Color(0xFFFFB300), size: 32),
          Icon(Icons.menu_book_rounded, color: Color(0xFF6C4CF1), size: 16),
        ],
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
                    fontSize: 10,
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

  Widget _buildProfileAvatar({required String initials}) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Signed in as', style: TextStyle(fontSize: 11, color: Color(0xFF6E6E8D))),
              Text('Student Portal', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ],
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
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: AppSpacing.searchBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.searchBarRadius),
        boxShadow: AppShadows.soft,
      ),
      child: TextField(
        style: AppTypography.bodyText,
        decoration: InputDecoration(
          hintText: 'Search subjects, exams, material...',
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1E1E2D), size: AppSpacing.searchIconSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.searchBarRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.searchBarPaddingHorizontal,
            vertical: 12,
          ),
          isDense: true,
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
              activeIcon: Icons.menu_book_rounded,
              inactiveIcon: Icons.menu_book_outlined,
              label: 'Academics',
              isActive: _currentIndex == 1 && _subScreen == null,
              index: 1,
              size: 24.0,
            ),
            _buildNavItem(
              activeIcon: Icons.account_balance_wallet_rounded,
              inactiveIcon: Icons.account_balance_wallet_outlined,
              label: 'Fees',
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
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
