import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

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
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        // Force text scale to 1.0 globally to prevent text from hiding or wrapping unpredictably
        final mediaQueryData = MediaQuery.of(context);
        final scaledChild = MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child,
        );

        return ResponsiveBreakpoints.builder(
          child: Builder(
            builder: (context) {
              return ResponsiveScaledBox(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: 450,
                  conditionalValues: [
                    Condition.equals(name: MOBILE, value: 450),
                    Condition.between(start: 450, end: 800, value: 600),
                  ],
                ).value,
                child: BouncingScrollWrapper.builder(context, scaledChild),
              );
            },
          ),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
        );
      },
      navigatorKey: globalNavigatorKey,
      title: 'Smart School Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        textTheme: TextTheme(
          // Screen Title: Inter Bold (24 px)
          headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ), // Fallback
          // Section Title: Inter SemiBold (18 px)
          titleMedium: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          // Card Title: Inter SemiBold (16 px)
          titleSmall: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),

          // Body Text: Roboto Regular (14 px)
          bodyLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),

          // Button Text: Inter Medium (16 px)
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),

          // Labels: Roboto Regular (12-13 px)
          labelMedium: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          labelSmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
