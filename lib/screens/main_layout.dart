import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'parent_dashboard/parent_dashboard_screen.dart';
import 'student_dashboard/student_dashboard_screen.dart';
import 'academics/academics_screen.dart';
import 'fees/fees_screen.dart';
import 'more/more_screen.dart';
import 'more/student_more_screen.dart';
import 'more/warden_more_screen.dart';
import 'homework/homework_screen.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';
import 'messages/messages_screen.dart';
import 'hostel/hostel_rooms_screen.dart';
import 'hostel/outing_pass_screen.dart';
import 'hostel_warden/hostel_warden_dashboard_screen.dart';
import 'front_desk/front_desk_dashboard_screen.dart';
import 'front_desk/visitors_screen.dart';
import 'front_desk/enquiries_screen.dart';
import 'front_desk/front_desk_more_screen.dart';
import 'accountant/accountant_dashboard_screen.dart';
import 'accountant/accountant_reports_screen.dart';
import 'accountant/accountant_invoices_screen.dart';
import 'accountant/accountant_more_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  // ignore: library_private_types_in_public_api
  static _MainLayoutState? currentState;

  static void pushSubScreen(BuildContext context, Widget screen) {
    currentState?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    currentState?.popSubScreen();
  }

  static void switchTab(int index) {
    currentState?.switchTab(index);
  }

  static final ValueNotifier<String> globalSearchQuery = ValueNotifier('');

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final List<Widget> _subScreens = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    MainLayout.currentState = this;
  }

  @override
  void dispose() {
    if (MainLayout.currentState == this) {
      MainLayout.currentState = null;
    }
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void pushSubScreen(Widget screen) {
    setState(() {
      _subScreens.add(screen);
      MainLayout.globalSearchQuery.value = '';
      _searchController.clear();
    });
  }

  void popSubScreen() {
    setState(() {
      if (_subScreens.isNotEmpty) {
        _subScreens.removeLast();
      }
      MainLayout.globalSearchQuery.value = '';
      _searchController.clear();
    });
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
      _subScreens.clear();
      MainLayout.globalSearchQuery.value = '';
      _searchController.clear();
    });
  }

  List<Widget> _getScreens(String? role) {
    if (role == 'warden') {
      return [
        const HostelWardenDashboardScreen(),
        OutingPassScreen(onBack: () => switchTab(0)),
        const HostelRoomsScreen(),
        const WardenMoreScreen(),
      ];
    }

    if (role == 'front_desk') {
      return [
        const FrontDeskDashboardScreen(),
        VisitorsScreen(onBack: () => switchTab(0)),
        EnquiriesScreen(onBack: () => switchTab(0)),
        const FrontDeskMoreScreen(),
      ];
    }

    if (role == 'accountant') {
      return [
        const AccountantDashboardScreen(),
        AccountantInvoicesScreen(onBack: () => switchTab(0)),
        AccountantReportsScreen(onBack: () => switchTab(0)),
        const AccountantMoreScreen(),
      ];
    }

    final isStudent = role == 'student';
    return [
      isStudent ? const StudentDashboardScreen() : const ParentDashboardScreen(),
      const AcademicsScreen(),
      isStudent ? HomeworkScreen(onBack: () => switchTab(0), isStudentPortal: true) : const FeesScreen(),
      isStudent ? const StudentMoreScreen() : const MoreScreen(),
    ];
  }

  bool get _hideGlobalHeader {
    return _subScreens.isNotEmpty && _subScreens.last is MessagesScreen;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return PopScope(
      canPop: _subScreens.isEmpty && _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_subScreens.isNotEmpty) {
            popSubScreen();
          } else if (_currentIndex != 0) {
            switchTab(0);
          }
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Background (App Bar Area)
          if (!_hideGlobalHeader)
            Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
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
                if (!_hideGlobalHeader) ...[
                  // Fixed Top Header Row
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Shield Logo
                      _buildShieldLogo(),
                      const SizedBox(width: 14), // Perfect spacing between logo and text
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sunrise Academy',
                              style: TextStyle(
                                fontSize: 24, // Updated to 24px
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1E2D),
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                final role = authProvider.currentUser?.role;
                                String subtitle = 'Parent Portal';
                                if (role == 'student') {
                                  subtitle = 'Student Portal';
                                } else if (role == 'warden') {
                                  subtitle = 'Warden Portal';
                                } else if (role == 'front_desk') {
                                  subtitle = 'Front Desk Portal';
                                } else if (role == 'accountant') {
                                  subtitle = 'Accountant Portal';
                                }
                                
                                return Text(
                                  subtitle,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A4A68), // Darker gray
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Action Buttons (Chat, Bell, Profile)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIconButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            badgeCount: 2,
                            badgeColor: const Color(0xFF6C4CF1), // Primary Purple
                            onTap: () {
                              MainLayout.pushSubScreen(context, MessagesScreen(onBack: () => MainLayout.popSubScreen(context)));
                            },
                          ),
                          const SizedBox(width: 10), // Reduced spacing slightly
                          _buildIconButton(
                            icon: Icons.notifications_none_rounded,
                            badgeCount: 5,
                            badgeColor: const Color(0xFFFF4B4B),
                            onTap: () {
                              MainLayout.pushSubScreen(context, NotificationsScreen(onBack: () => MainLayout.popSubScreen(context)));
                            },
                          ),
                          const SizedBox(width: 10),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              final role = authProvider.currentUser?.role;
                              String initials = 'SP';
                              Color bgColor = const Color(0xFFF3F0FF);
                              Color textColor = const Color(0xFF6C4CF1);

                              if (role == 'student') {
                                initials = 'AK';
                                bgColor = const Color(0xFFF3F0FF);
                                textColor = const Color(0xFF6C4CF1);
                              } else if (role == 'warden') {
                                initials = 'RV';
                                bgColor = const Color(0xFFF3F0FF);
                                textColor = const Color(0xFF6C4CF1);
                              } else if (role == 'front_desk') {
                                initials = 'AT';
                                bgColor = const Color(0xFFF3F0FF);
                                textColor = const Color(0xFF6C4CF1);
                              } else if (role == 'accountant') {
                                initials = 'AC';
                                bgColor = const Color(0xFFF3F0FF);
                                textColor = const Color(0xFF6C4CF1);
                              }

                              return _buildProfileAvatar(
                                initials: initials,
                                bgColor: bgColor,
                                textColor: textColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Fixed Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildSearchBar(),
                ),
                const SizedBox(height: 16),
                ],
                // Dynamic Scrollable Content
                Expanded(
                  child: Stack(
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return IndexedStack(
                            index: _currentIndex,
                            children: _getScreens(authProvider.currentUser?.role),
                          );
                        },
                      ),
                      ..._subScreens.map((screen) => Positioned.fill(
                        child: Container(
                          color: Colors.white,
                          child: screen,
                        ),
                      )),
                    ],
                  ),
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
      ),
    );
  }

  // --- Shell UI Methods ---
  Widget _buildShieldLogo() {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            child: Icon(Icons.shield, color: Color(0x336C4CF1), size: 52),
          ),
          Icon(Icons.shield, color: Color(0xFF6C4CF1), size: 52),
          Icon(Icons.shield, color: Colors.white, size: 46),
          Icon(Icons.shield, color: Color(0xFFFFB300), size: 40),
          Icon(Icons.menu_book_rounded, color: Color(0xFF6C4CF1), size: 20),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF1E1E2D), size: 22),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
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

  Widget _buildProfileAvatar({
    required String initials,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: textColor.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: textColor,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // 24px radius
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.25), // Soft shadow
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ValueListenableBuilder<String>(
        valueListenable: MainLayout.globalSearchQuery,
        builder: (context, query, child) {
          return TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) {
              MainLayout.globalSearchQuery.value = value;
            },
            decoration: InputDecoration(
              hintText: 'Search anything...',
              hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontWeight: FontWeight.w500),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1E1E2D)), // Dark search icon
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF9E9E9E)),
                      onPressed: () {
                        _searchController.clear();
                        MainLayout.globalSearchQuery.value = '';
                        _searchFocusNode.unfocus();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final role = authProvider.currentUser?.role;
    final isWarden = role == 'warden';
    final isStudent = role == 'student';

    return SafeArea(
      child: Container(
        height: 86,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C4CF1).withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
            BoxShadow(
              color: const Color(0xFF1E1E2D).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: isWarden
              ? [
                  _buildNavItem(icon: LucideIcons.home, label: 'Dashboard', isActive: _currentIndex == 0, index: 0),
                  _buildNavItem(icon: LucideIcons.calendarClock, label: 'Outings', isActive: _currentIndex == 1, index: 1),
                  _buildNavItem(icon: LucideIcons.bedDouble, label: 'Rooms', isActive: _currentIndex == 2, index: 2),
                  _buildNavItem(icon: LucideIcons.layoutGrid, label: 'More', isActive: _currentIndex == 3, index: 3),
                ]
              : role == 'front_desk'
                   ? [
                      _buildNavItem(icon: LucideIcons.home, label: 'Dashboard', isActive: _currentIndex == 0, index: 0),
                      _buildNavItem(icon: LucideIcons.userCheck, label: 'Visitors', isActive: _currentIndex == 1, index: 1),
                      _buildNavItem(icon: LucideIcons.clipboardList, label: 'Enquiries', isActive: _currentIndex == 2, index: 2),
                      _buildNavItem(icon: LucideIcons.layoutGrid, label: 'More', isActive: _currentIndex == 3, index: 3),
                    ]
                   : role == 'accountant'
                   ? [
                      _buildNavItem(icon: LucideIcons.home, label: 'Dashboard', isActive: _currentIndex == 0, index: 0),
                      _buildNavItem(icon: LucideIcons.fileCheck, label: 'Invoices', isActive: _currentIndex == 1, index: 1),
                      _buildNavItem(icon: LucideIcons.chartNoAxesCombined, label: 'Reports', isActive: _currentIndex == 2, index: 2),
                      _buildNavItem(icon: LucideIcons.layoutGrid, label: 'More', isActive: _currentIndex == 3, index: 3),
                    ]
                  : isStudent
                  ? [
                      _buildNavItem(icon: LucideIcons.home, label: 'Dashboard', isActive: _currentIndex == 0, index: 0),
                      _buildNavItem(icon: LucideIcons.bookOpen, label: 'Academics', isActive: _currentIndex == 1, index: 1),
                      _buildNavItem(icon: LucideIcons.fileText, label: 'Homework', isActive: _currentIndex == 2, index: 2),
                      _buildNavItem(icon: LucideIcons.layoutGrid, label: 'More', isActive: _currentIndex == 3, index: 3),
                    ]
                  : [
                      _buildNavItem(icon: LucideIcons.home, label: 'Dashboard', isActive: _currentIndex == 0, index: 0),
                      _buildNavItem(icon: LucideIcons.bookOpen, label: 'Academics', isActive: _currentIndex == 1, index: 1),
                      _buildNavItem(icon: LucideIcons.wallet, label: 'Fees', isActive: _currentIndex == 2, index: 2),
                      _buildNavItem(icon: LucideIcons.layoutGrid, label: 'More', isActive: _currentIndex == 3, index: 3),
                    ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required bool isActive, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _subScreens.clear();
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF94A3B8),
                size: isActive ? 24 : 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 14 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6C4CF1).withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
