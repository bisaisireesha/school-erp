import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'parent_dashboard/parent_dashboard_screen.dart';
import 'academics/academics_screen.dart';
import 'fees/fees_screen.dart';
import 'more/more_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static void pushSubScreen(BuildContext context, Widget screen) {
    context.findAncestorStateOfType<_MainLayoutState>()?.pushSubScreen(screen);
  }

  static void popSubScreen(BuildContext context) {
    context.findAncestorStateOfType<_MainLayoutState>()?.popSubScreen();
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  Widget? _subScreen;

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

  final List<Widget> _screens = [
    const ParentDashboardScreen(),
    const AcademicsScreen(),
    const FeesScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Gradient Background (App Bar Area)
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
                            const Text(
                              'Parent Portal',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A4A68), // Darker gray
                              ),
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
                            onTap: () {},
                          ),
                          const SizedBox(width: 10), // Reduced spacing slightly
                          _buildIconButton(
                            icon: Icons.notifications_none_rounded,
                            badgeCount: 5,
                            badgeColor: const Color(0xFFFF4B4B),
                            onTap: () {},
                          ),
                          const SizedBox(width: 10),
                          _buildProfileAvatar(initials: 'RS'),
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
                // Dynamic Scrollable Content
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

  Widget _buildProfileAvatar({required String initials}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFECE8F8), width: 2), // Border
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Color(0xFF6C4CF1), // Primary Purple
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search anything...',
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1E1E2D)), // Dark search icon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        height: 86,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(43),
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
              icon: Icons.home_rounded,
              label: 'Dashboard',
              isActive: _currentIndex == 0,
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.menu_book_rounded,
              label: 'Academics',
              isActive: _currentIndex == 1,
              index: 1,
            ),
            _buildNavItem(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Fees',
              isActive: _currentIndex == 2,
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.grid_view_rounded,
              label: 'More',
              isActive: _currentIndex == 3,
              index: 3,
            ),
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
            _subScreen = null;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFF6C4CF1) : const Color(0xFF7A7A9D),
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 6),
              Container(
                width: 18,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4CF1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ] else
              const SizedBox(height: 9),
          ],
        ),
      ),
    );
  }
}
