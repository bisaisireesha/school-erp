import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class CctvCamerasScreen extends StatefulWidget {
  final VoidCallback onBack;

  const CctvCamerasScreen({super.key, required this.onBack});

  @override
  State<CctvCamerasScreen> createState() => _CctvCamerasScreenState();
}

class _CctvCamerasScreenState extends State<CctvCamerasScreen> {
  Map<String, dynamic>? _cctvData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCctvData();
  }

  Future<void> _loadCctvData() async {
    final String response = await rootBundle.loadString('assets/mock/cctv_cameras.json');
    final data = json.decode(response);
    setState(() {
      _cctvData = data;
      _isLoading = false;
    });
  }

  void _openLiveStreamView(Map<String, dynamic> camera) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenLiveStreamView(camera: camera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final banner = _cctvData!['infoBanner'];
    final cameras = _cctvData!['cameras'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Back Row
          Row(
            children: [
              AppBackButton(onPressed: widget.onBack),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text(
                  'CCTV Cameras',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // School Hours Info Banner
          _buildInfoBanner(banner),
          const SizedBox(height: AppSpacing.sectionSpacing),

          // Camera List Header
          const Text(
            'Available Live Feeds',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
          ),
          const SizedBox(height: AppSpacing.md),

          // Vertically Scrollable Camera Cards
          ...cameras.map((cam) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.cardSpacing),
                child: _buildCameraCard(cam),
              )),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(Map<String, dynamic> banner) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingHorizontal),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFE8E3F8), width: 1.5),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF6C4CF1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.clock, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'School Hours Stream ',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4CF1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        banner['hours'],
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  banner['notice'],
                  style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A68), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraCard(Map<String, dynamic> camera) {
    final bool isLive = camera['status'] == 'LIVE';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Preview Header Area
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2D),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl - 1)),
            ),
            child: Stack(
              children: [
                // Simulated Camera Video Stream Graphics
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLive ? LucideIcons.video : LucideIcons.videoOff,
                        color: isLive ? Colors.white.withValues(alpha: 0.8) : Colors.grey.shade500,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLive ? 'Tap View Live to connect stream' : 'Camera Feed Offline',
                        style: TextStyle(
                          color: isLive ? Colors.white.withValues(alpha: 0.9) : Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Top Left Live/Offline Badge
                Positioned(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLive ? const Color(0xFFEF4444) : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLive) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          isLive ? 'LIVE' : 'OFFLINE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Right Resolution Pill
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      camera['resolution'],
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Camera Details & Action
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPaddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  camera['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2D)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF7A7A9D)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        camera['location'],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A9D), fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Full-width View Live Button
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.minTouchTarget,
                  child: ElevatedButton.icon(
                    onPressed: isLive ? () => _openLiveStreamView(camera) : null,
                    icon: const Icon(LucideIcons.play, size: 16, color: Colors.white),
                    label: Text(
                      isLive ? 'View Live Stream' : 'Stream Unavailable',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLive ? const Color(0xFF6C4CF1) : Colors.grey.shade400,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Full Screen Live Stream View
class FullScreenLiveStreamView extends StatelessWidget {
  final Map<String, dynamic> camera;

  const FullScreenLiveStreamView({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Standard AppBackButton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.md),
              child: Row(
                children: [
                  AppBackButton(onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          camera['name'],
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          camera['location'],
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),

            // Live Player Container
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C4CF1).withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.video, color: Color(0xFF6C4CF1), size: 48),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Streaming ${camera['name']}',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${camera['resolution']} · ${camera['fps']} · Low Latency HD',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Controls Overlay
                    Positioned(
                      bottom: AppSpacing.lg,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.wifi, color: Color(0xFF22C55E), size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Signal Excellent',
                                  style: TextStyle(color: Colors.grey.shade300, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.maximize, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Switched to landscape view'), duration: Duration(seconds: 1)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
