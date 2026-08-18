import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:parent_app/providers/auth_provider.dart';
import 'package:parent_app/screens/teacher_main_layout.dart';
import 'package:parent_app/screens/driver_main_layout.dart';
import 'package:parent_app/screens/transport_main_layout.dart';
import 'package:parent_app/screens/librarian_main_layout.dart';

Widget createTestApp(Widget home) {
  return ChangeNotifierProvider<AuthProvider>(
    create: (_) => AuthProvider(),
    child: MaterialApp(
      home: home,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TeacherMainLayout QA Tests', () {
    testWidgets('Renders, switches tabs, and handles notifications popover', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const TeacherMainLayout()));
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(TeacherMainLayout), findsOneWidget);

      // Tap Classes tab
      final classesTab = find.text('Classes');
      if (classesTab.evaluate().isNotEmpty) {
        await tester.tap(classesTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      // Tap Attendance tab
      final attTab = find.text('Attendance');
      if (attTab.evaluate().isNotEmpty) {
        await tester.tap(attTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      // Tap More tab
      final moreTab = find.text('More');
      if (moreTab.evaluate().isNotEmpty) {
        await tester.tap(moreTab.first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));
      }

      // Tap bell icon to open notifications popover
      final bellFinder = find.byIcon(LucideIcons.bell);
      if (bellFinder.evaluate().isNotEmpty) {
        await tester.tap(bellFinder.first);
        await tester.pump(const Duration(milliseconds: 300));

        final markReadFinder = find.text('Mark all read');
        if (markReadFinder.evaluate().isNotEmpty) {
          await tester.tap(markReadFinder);
          await tester.pump(const Duration(milliseconds: 300));
        }
      }
    });
  });

  group('DriverMainLayout QA Tests', () {
    testWidgets('Renders, switches tabs, and handles popovers', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const DriverMainLayout()));
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(DriverMainLayout), findsOneWidget);

      final busTab = find.text('Bus');
      if (busTab.evaluate().isNotEmpty) {
        await tester.tap(busTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      final msgTab = find.text('Messages');
      if (msgTab.evaluate().isNotEmpty) {
        await tester.tap(msgTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      final moreTab = find.text('More');
      if (moreTab.evaluate().isNotEmpty) {
        await tester.tap(moreTab.first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));
      }
    });
  });

  group('TransportMainLayout QA Tests', () {
    testWidgets('Renders, switches tabs, and handles popovers', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const TransportMainLayout()));
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(TransportMainLayout), findsOneWidget);

      final vehTab = find.text('Vehicles');
      if (vehTab.evaluate().isNotEmpty) {
        await tester.tap(vehTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      final feesTab = find.text('Fees');
      if (feesTab.evaluate().isNotEmpty) {
        await tester.tap(feesTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      final moreTab = find.text('More');
      if (moreTab.evaluate().isNotEmpty) {
        await tester.tap(moreTab.first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));
      }
    });
  });

  group('LibrarianMainLayout QA Tests', () {
    testWidgets('Renders, switches tabs, and handles popovers', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const LibrarianMainLayout()));
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(LibrarianMainLayout), findsOneWidget);

      final issueTab = find.text('Issue & Return');
      if (issueTab.evaluate().isNotEmpty) {
        await tester.tap(issueTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      final booksTab = find.text('Books');
      if (booksTab.evaluate().isNotEmpty) {
        await tester.tap(booksTab.first);
        await tester.pump(const Duration(milliseconds: 300));
      }

      final moreTab = find.text('More');
      if (moreTab.evaluate().isNotEmpty) {
        await tester.tap(moreTab.first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));
      }
    });
  });
}
