import 'package:flutter/material.dart';
import 'transport_portal/transport_routes_screen.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
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
import 'transport_portal/transport_dashboard_screen.dart';
import 'transport_portal/transport_vehicles_screen.dart';
import 'transport_portal/transport_more_screen.dart';

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
  int _unreadNotificationsCount = 3;
  final List<Widget> _subScreens = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final PageController _pageController = PageController();

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
    _pageController.dispose();
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
    if (_currentIndex != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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

    if (role == 'transport') {
      return [
        const TransportDashboardScreen(),
        TransportVehiclesScreen(onBack: () => switchTab(0)),
        TransportRoutesScreen(onBack: () => switchTab(0)),
        const TransportMoreScreen(),
      ];
    }

    final isStudent = role == 'student';
    return [
      isStudent
          ? const StudentDashboardScreen()
          : const ParentDashboardScreen(),
      const AcademicsScreen(),
      isStudent
          ? HomeworkScreen(onBack: () => switchTab(0), isStudentPortal: true)
          : const FeesScreen(),
      isStudent ? const StudentMoreScreen() : const MoreScreen(),
    ];
  }

  bool get _hideGlobalHeader {
    return _subScreens.isNotEmpty && _subScreens.last is MessagesScreen;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

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
              bottom: false, // Let content flow under the bottom navigation bar for glass effect
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_hideGlobalHeader) ...[
                    // Fixed Top Header Row
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Shield Logo
                          _buildShieldLogo(),
                          const SizedBox(
                            width: 14,
                          ), // Perfect spacing between logo and text
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
                                    } else if (role == 'transport') {
                                      subtitle = 'Transport Portal';
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
                                badgeColor: const Color(
                                  0xFF6C4CF1,
                                ), // Primary Purple
                                onTap: () {
                                  MainLayout.pushSubScreen(
                                    context,
                                    MessagesScreen(
                                      onBack: () =>
                                          MainLayout.popSubScreen(context),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ), // Reduced spacing slightly
                              _buildIconButton(
                                icon: Icons.notifications_none_rounded,
                                badgeCount: _unreadNotificationsCount,
                                badgeColor: const Color(0xFFFF4B4B),
                                onTap: () {
                                  final role = Provider.of<AuthProvider>(context, listen: false).currentUser?.role ?? 'teacher';
                                  NotificationsScreen.show(
                                    context,
                                    role,
                                    () {
                                      setState(() {
                                        _unreadNotificationsCount = 0;
                                      });
                                    },
                                  );
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
                                  } else if (role == 'transport') {
                                    initials = 'TR';
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
                                        MaterialPageRoute(
                                          builder: (context) => const ProfileScreen(),
                                        ),
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
                            return PageView(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(), // Edge to edge fluid swipe
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                  _subScreens.clear();
                                });
                              },
                              children: _getScreens(
                                authProvider.currentUser?.role,
                              ),
                            );
                          },
                        ),
                        ..._subScreens.map(
                          (screen) => Positioned.fill(
                            child: Container(
                              color: Colors.white,
                              child: screen,
                            ),
                          ),
                        ),
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
                  border: Border.all(
                    color: const Color(0xFFF7F5FF),
                    width: 1.5,
                  ),
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
          border: Border.all(
            color: textColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
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
            color: const Color(
              0xFFE8E3F8,
            ).withValues(alpha: 0.25), // Soft shadow
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
              hintStyle: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF1E1E2D),
              ), // Dark search icon
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final role = Provider.of<AuthProvider>(context).currentUser?.role ?? 'parent';
    List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.menu_book_outlined, 'activeIcon': Icons.menu_book_rounded, 'label': 'Academics'},
      {'icon': Icons.account_balance_wallet_outlined, 'activeIcon': Icons.account_balance_wallet_rounded, 'label': 'Fees'},
      {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
    ];

    if (role == 'student') {
      navItems = [
        {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.menu_book_outlined, 'activeIcon': Icons.menu_book_rounded, 'label': 'Academics'},
        {'icon': Icons.assignment_outlined, 'activeIcon': Icons.assignment_rounded, 'label': 'Exams'},
        {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
      ];
    } else if (role == 'warden') {
      navItems = [
        {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.badge_outlined, 'activeIcon': Icons.badge_rounded, 'label': 'Staff'},
        {'icon': Icons.bed_outlined, 'activeIcon': Icons.bed_rounded, 'label': 'Hostel'},
        {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
      ];
    } else if (role == 'front_desk') {
      navItems = [
        {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.how_to_reg_outlined, 'activeIcon': Icons.how_to_reg_rounded, 'label': 'Register'},
        {'icon': Icons.support_agent_outlined, 'activeIcon': Icons.support_agent_rounded, 'label': 'Support'},
        {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
      ];
    } else if (role == 'accountant') {
      navItems = [
        {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.payments_outlined, 'activeIcon': Icons.payments_rounded, 'label': 'Payments'},
        {'icon': Icons.bar_chart_outlined, 'activeIcon': Icons.bar_chart_rounded, 'label': 'Reports'},
        {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
      ];
    } else if (role == 'transport') {
      navItems = [
        {'icon': Icons.home_outlined, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
        {'icon': Icons.directions_bus_outlined, 'activeIcon': Icons.directions_bus_rounded, 'label': 'Buses'},
        {'icon': Icons.map_outlined, 'activeIcon': Icons.map_rounded, 'label': 'Routes'},
        {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded, 'label': 'More'},
      ];
    }

    final safeIndex = _currentIndex >= navItems.length ? navItems.length - 1 : _currentIndex;

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final totalHeight = 72.0 + bottomPadding;

    return Container(
      margin: EdgeInsets.zero,
      child: Stack(
        children: [
          // 1. Shadow layer (clipped in the center so it doesn't ruin the glass effect)
          ClipPath(
            clipper: _HoleClipper(radius: 8),
            child: Container(
              height: totalHeight,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8E3F8).withValues(alpha: 0.8), // Shadow color
                    blurRadius: 20,
                    offset: const Offset(0, 0), // 4-sided shadow
                  ),
                ],
              ),
            ),
          ),
          // 2. Glassmorphism layer
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5), // Brighter, crisp border
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), // Strong frosted glass blur
                child: Container(
                  height: totalHeight,
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  color: Colors.white.withValues(alpha: 0.05), // Ultra transparent 5% tint
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final tabWidth = constraints.maxWidth / navItems.length;
                      final leftOffset = (tabWidth * safeIndex) + (tabWidth / 2) - 38; // Center pill (76 / 2 = 38)

                      return Stack(
                        children: [
                          // Sliding Pill Animation
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 100), // Ultra-fast snappy transmission
                            curve: Curves.easeOut,
                            left: leftOffset,
                            top: 12, // (72 total height - 48 pill height) / 2
                            child: Container(
                              width: 76,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: const Color(0xFF6C4CF1).withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                          // Icons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(navItems.length, (index) {
                              return _buildNavItem(
                                icon: navItems[index]['icon'] as IconData,
                                activeIcon: navItems[index]['activeIcon'] as IconData,
                                label: navItems[index]['label'] as String,
                                isActive: safeIndex == index,
                                index: index,
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required int index,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex != index) {
            // Instantly update the active tab highlight
            setState(() {
              _currentIndex = index;
              _subScreens.clear();
            });
            // Instantly switch the screen without waiting for an animation
            _pageController.jumpToPage(index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 72, // Full height of navbar for huge tap target area
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100), // Fast icon switch
                  child: Icon(
                    isActive ? activeIcon : icon,
                    key: ValueKey(isActive), // Animates color change
                    color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF757575), // Bold grey when inactive
                    size: 24, // Keep icon size perfectly identical for both states
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600, // Bold for inactive too
                    color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoleClipper extends CustomClipper<Path> {
  final double radius;
  _HoleClipper({required this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTRB(-100, -100, size.width + 100, size.height + 100)) // Outer bounds for shadow
      ..addRRect(RRect.fromRectAndCorners(
        Offset.zero & size,
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      )) // Inner bounds to cut out
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(_HoleClipper oldClipper) => radius != oldClipper.radius;
}
