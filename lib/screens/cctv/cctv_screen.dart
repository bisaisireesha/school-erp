import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CCTVScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CCTVScreen({super.key, required this.onBack});

  @override
  State<CCTVScreen> createState() => _CCTVScreenState();
}

class _CCTVScreenState extends State<CCTVScreen> {
  final List<Map<String, dynamic>> _mockCCTVData = [
    {
      'id': 'cam1',
      'name': 'Main Entrance Gate',
      'status': 'Online',
      'location': 'Front Gate',
      'imageUrl': 'https://picsum.photos/seed/gate/800/600',
    },
    {
      'id': 'cam2',
      'name': 'Playground North',
      'status': 'Online',
      'location': 'Playground',
      'imageUrl': 'https://picsum.photos/seed/play/800/600',
    },
    {
      'id': 'cam3',
      'name': 'Cafeteria Seating',
      'status': 'Online',
      'location': 'Cafeteria',
      'imageUrl': 'https://picsum.photos/seed/cafe/800/600',
    },
    {
      'id': 'cam4',
      'name': 'Library Corridor',
      'status': 'Offline',
      'location': 'Library',
      'imageUrl': 'https://picsum.photos/seed/lib/800/600',
    }
  ];

  void _showLiveFeed(BuildContext context, Map<String, dynamic> camData) {
    if (camData['status'] == 'Offline') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${camData['name']} is currently offline.'),
          backgroundColor: const Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return _LiveFeedDialog(camData: camData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1E2D), size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Campus CCTV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.video, size: 20, color: Color(0xFF6C4CF1)),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mockCCTVData.length,
                  itemBuilder: (context, index) {
                    final cam = _mockCCTVData[index];
                    final isOnline = cam['status'] == 'Online';

                    return GestureDetector(
                    onTap: () => _showLiveFeed(context, cam),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Camera Feed Thumbnail
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                            child: Stack(
                              children: [
                                // Thumbnail Image
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    cam['imageUrl'],
                                    fit: BoxFit.cover,
                                    color: isOnline ? null : Colors.grey,
                                    colorBlendMode: isOnline ? null : BlendMode.saturation,
                                  ),
                                ),
                                // Gradient Overlay for text readability
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                                        begin: Alignment.topCenter,
                                        end: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                                // Status Badge
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isOnline ? const Color(0xFFE11D48) : const Color(0xFF4B5563),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isOnline) ...[
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2)),
                                        ] else ...[
                                          const Icon(LucideIcons.wifiOff, size: 10, color: Colors.white),
                                          const SizedBox(width: 6),
                                          const Text('OFFLINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2)),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                                // Play Icon Overlay (if online)
                                if (isOnline)
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                                        ),
                                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Camera Details
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cam['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D))),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(LucideIcons.mapPin, size: 12, color: Color(0xFF9E9E9E)),
                                        const SizedBox(width: 4),
                                        Text(cam['location'], style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
                                  ),
                                  child: const Icon(LucideIcons.maximize, size: 18, color: Color(0xFF1E1E2D)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// Widget for the Full Screen Live Feed Dialog
class _LiveFeedDialog extends StatefulWidget {
  final Map<String, dynamic> camData;

  const _LiveFeedDialog({required this.camData});

  @override
  State<_LiveFeedDialog> createState() => _LiveFeedDialogState();
}

class _LiveFeedDialogState extends State<_LiveFeedDialog> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated Video Feed
          Image.network(
            widget.camData['imageUrl'],
            fit: BoxFit.contain,
          ),
          
          // Camera HUD Overlays
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: Row(
              children: [
                FadeTransition(
                  opacity: _pulseAnimation,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(color: Color(0xFFE11D48), shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('REC', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Text(
                  _getCurrentTime(),
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
                );
              }
            ),
          ),

          Positioned(
            bottom: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.camData['name'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                const SizedBox(height: 4),
                Text('CAM ID: ${widget.camData['id'].toString().toUpperCase()}', style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'monospace')),
              ],
            ),
          ),

          // Close Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: MediaQuery.of(context).size.width / 2 - 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                ),
                child: const Icon(LucideIcons.x, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
