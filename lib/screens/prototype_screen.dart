import 'package:flutter/material.dart';

class PrototypeScreen extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const PrototypeScreen({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E1E2D), size: 20),
          onPressed: onBack,
        ),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.construction_rounded, size: 60, color: Color(0xFF3B82F6)),
            ),
            const SizedBox(height: 24),
            Text(
              '$title coming soon!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'This screen is currently a prototype. Real functionality will be added here in the future.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF7A7A9D), height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
