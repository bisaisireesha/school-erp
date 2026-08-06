import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void reassemble() {
    super.reassemble();
    // Forcefully reset the app to fix the red screen on hot reload
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalNavigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Smart School Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          // Screen Title: Inter Bold (24 px)
          headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold), // Fallback
          
          // Section Title: Inter SemiBold (18 px)
          titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          
          // Card Title: Inter SemiBold (16 px)
          titleSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          
          // Body Text: Roboto Regular (14 px)
          bodyLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
          bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
          
          // Button Text: Inter Medium (16 px)
          labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          
          // Labels: Roboto Regular (12-13 px)
          labelMedium: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.normal),
          labelSmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
