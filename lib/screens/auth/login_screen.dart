import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../main_layout.dart';
import '../student_main_layout.dart';
import '../transport_main_layout.dart';
import '../driver_main_layout.dart';
import '../librarian_main_layout.dart';
import '../teacher_main_layout.dart';

class LoginScreen extends StatefulWidget {
  final String? initialRole; // 'teacher', 'librarian', 'driver', 'transport', 'student', 'parent'

  const LoginScreen({super.key, this.initialRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Immediate default users so cards appear instantly
  List<dynamic> _demoUsers = [
    {
      "id": "4",
      "name": "Teacher Portal (Sarah Williams)",
      "email": "teacher@school.edu",
      "password": "Teacher@123",
      "role": "teacher"
    },
    {
      "id": "7",
      "name": "Librarian Portal (Sarah Jenkins)",
      "email": "librarian@school.edu",
      "password": "Librarian@123",
      "role": "librarian"
    },
    {
      "id": "6",
      "name": "Bus Driver (Rajesh Kumar)",
      "email": "driver@school.edu",
      "password": "Driver@123",
      "role": "driver"
    },
    {
      "id": "3",
      "name": "Transport Manager",
      "email": "transport@school.edu",
      "password": "Transport@123",
      "role": "transport"
    },
    {
      "id": "2",
      "name": "Student Portal (Alex Vance)",
      "email": "student@school.edu",
      "password": "Student@123",
      "role": "student"
    },
    {
      "id": "1",
      "name": "Parent Portal",
      "email": "parent@school.edu",
      "password": "Parent@123",
      "role": "parent"
    },
  ];

  @override
  void initState() {
    super.initState();
    _prefillInitialCredentials();
    _loadDemoCredentials();
  }

  void _prefillInitialCredentials() {
    if (widget.initialRole == 'teacher') {
      _emailController.text = 'teacher@school.edu';
      _passwordController.text = 'Teacher@123';
    } else if (widget.initialRole == 'librarian') {
      _emailController.text = 'librarian@school.edu';
      _passwordController.text = 'Librarian@123';
    } else if (widget.initialRole == 'driver') {
      _emailController.text = 'driver@school.edu';
      _passwordController.text = 'Driver@123';
    } else if (widget.initialRole == 'transport') {
      _emailController.text = 'transport@school.edu';
      _passwordController.text = 'Transport@123';
    } else if (widget.initialRole == 'student') {
      _emailController.text = 'student@school.edu';
      _passwordController.text = 'Student@123';
    } else if (widget.initialRole == 'parent') {
      _emailController.text = 'parent@school.edu';
      _passwordController.text = 'Parent@123';
    } else if (widget.initialRole == 'principal' || widget.initialRole == 'admin') {
      _emailController.text = 'principal@gmail.com';
      _passwordController.text = 'Principal@123';
    }
  }

  Future<void> _loadDemoCredentials() async {
    try {
      final String response = await rootBundle.loadString('assets/mock/auth.json');
      final data = json.decode(response);
      if (data['users'] != null && (data['users'] as List).isNotEmpty) {
        setState(() {
          _demoUsers = data['users'];
        });
      }
    } catch (e) {
      debugPrint("Error loading demo credentials: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _portalTitle {
    if (widget.initialRole == 'teacher') return 'Sunrise Teacher Portal';
    if (widget.initialRole == 'librarian') return 'Sunrise Librarian Portal';
    if (widget.initialRole == 'driver') return 'Sunrise Driver Portal';
    if (widget.initialRole == 'transport') return 'Sunrise Transport Portal';
    if (widget.initialRole == 'student') return 'Sunrise Student Portal';
    if (widget.initialRole == 'parent') return 'Sunrise Parent Portal';
    if (widget.initialRole == 'principal' || widget.initialRole == 'admin') return 'Sunrise Admin Portal';
    return 'Smart School Portal';
  }

  String get _portalSubtitle {
    if (widget.initialRole != null && widget.initialRole!.isNotEmpty) {
      final roleCapitalized = widget.initialRole![0].toUpperCase() + widget.initialRole!.substring(1);
      return 'Sign in to access your $roleCapitalized portal features and tools';
    }
    return 'Sign in to access your teacher, librarian, driver, transport, student, or parent portal';
  }

  String get _emailHint {
    if (widget.initialRole == 'teacher') return 'teacher@school.edu';
    if (widget.initialRole == 'librarian') return 'librarian@school.edu';
    if (widget.initialRole == 'driver') return 'driver@school.edu';
    if (widget.initialRole == 'transport') return 'transport@school.edu';
    if (widget.initialRole == 'student') return 'student@school.edu';
    if (widget.initialRole == 'parent') return 'parent@school.edu';
    if (widget.initialRole == 'principal' || widget.initialRole == 'admin') return 'principal@gmail.com';
    return 'teacher@school.edu';
  }

  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty) {
      email = _emailHint;
    }
    if (password.isEmpty) {
      password = '123456';
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(email, password);

    if (success) {
      if (!mounted) return;
      final role = authProvider.currentUser?.role ?? widget.initialRole;
      if (role == 'student') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentMainLayout()),
        );
      } else if (role == 'transport') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransportMainLayout()),
        );
      } else if (role == 'driver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverMainLayout()),
        );
      } else if (role == 'librarian') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LibrarianMainLayout()),
        );
      } else if (role == 'teacher') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeacherMainLayout()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Login failed')),
        );
      }
    }
  }

  void _autoLoginDemoUser(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFEDE9FA),
      body: Stack(
        children: [
          // Background Gradient and Icon
          Container(
            height: size.height * 0.35,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEDE9FA),
                  Color(0xFFE8E4F8),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Icon Card
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C8DDB).withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'lib/assets/graduation logo.png',
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.school,
                        size: 38,
                        color: Color(0xFF9C8DDB),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.74,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _portalTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1035),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _portalSubtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1035),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: _emailHint,
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.5),
                          prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey, size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1035),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.5),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF6C4CF1), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF6C4CF1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Color(0xFF1A1035),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password reset link sent to registered email')),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF6C4CF1),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              if (auth.isLoading) {
                                return const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                );
                              }
                              return const Text(
                                'Sign In to Portal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Demo Logins Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEBE8FF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFF6C4CF1)),
                                SizedBox(width: 6),
                                Text(
                                  'Quick Demo Credentials',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C4CF1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...(() {
                              final Map<String, dynamic> uniqueRoleUsers = {};
                              // If initialRole is specified, prioritize it at the top
                              if (widget.initialRole != null) {
                                for (var user in _demoUsers) {
                                  if (user['role'] == widget.initialRole) {
                                    uniqueRoleUsers[user['role']] = user;
                                    break;
                                  }
                                }
                              }
                              for (var user in _demoUsers) {
                                final r = user['role'];
                                if (!uniqueRoleUsers.containsKey(r)) {
                                  uniqueRoleUsers[r] = user;
                                }
                              }
                              return uniqueRoleUsers.values;
                            })().map((user) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _buildDemoCard(
                                    icon: user['role'] == 'teacher'
                                        ? Icons.assignment_ind_rounded
                                        : user['role'] == 'librarian'
                                            ? Icons.menu_book_rounded
                                            : user['role'] == 'student'
                                                ? Icons.school
                                                : user['role'] == 'parent'
                                                    ? Icons.family_restroom
                                                    : user['role'] == 'driver'
                                                        ? Icons.directions_bus_rounded
                                                        : user['role'] == 'principal' || user['role'] == 'admin'
                                                            ? Icons.admin_panel_settings_rounded
                                                            : Icons.directions_bus_rounded,
                                    title: user['name'] ?? 'Portal User',
                                    email: user['email'] ?? '',
                                    password: user['password'] ?? 'Teacher@123',
                                    roleLabel: user['role'] == 'teacher'
                                        ? '👩‍🏫 Teacher'
                                        : user['role'] == 'librarian'
                                            ? '📚 Librarian'
                                            : user['role'] == 'student'
                                                ? '🎓 Student'
                                                : user['role'] == 'parent'
                                                    ? '👨‍👩‍👧 Parent'
                                                    : user['role'] == 'driver'
                                                        ? '🛞 Driver'
                                                        : user['role'] == 'principal' || user['role'] == 'admin'
                                                            ? '🏫 Admin / Principal'
                                                            : '🚌 Transport',
                                    isHighlighted: widget.initialRole != null
                                        ? user['role'] == widget.initialRole
                                        : user['role'] == 'teacher',
                                    onTap: () => _autoLoginDemoUser(
                                      user['email'],
                                      user['password'] ?? 'Teacher@123',
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard({
    required IconData icon,
    required String title,
    required String email,
    required String password,
    required String roleLabel,
    required bool isHighlighted,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFF3EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? const Color(0xFF6C4CF1) : const Color(0xFFEBE8FF),
            width: isHighlighted ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isHighlighted ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isHighlighted ? Colors.white : const Color(0xFF6C4CF1),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E2D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Email: $email  •  Pass: $password',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isHighlighted ? const Color(0xFF6C4CF1) : const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                roleLabel,
                style: TextStyle(
                  color: isHighlighted ? Colors.white : const Color(0xFF6C4CF1),
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
