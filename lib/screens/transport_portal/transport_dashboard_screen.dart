import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TransportDashboardScreen extends StatefulWidget {
  const TransportDashboardScreen({super.key});

  @override
  State<TransportDashboardScreen> createState() => _TransportDashboardScreenState();
}

class _TransportDashboardScreenState extends State<TransportDashboardScreen> {
  bool _isLoading = true;
  List<dynamic> _kpis = [];
  List<dynamic> _fleetVehicles = [];
  List<dynamic> _todayAlerts = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mock/transport_dashboard.json',
      );
      final data = json.decode(response);

      if (mounted) {
        setState(() {
          _kpis = data['kpis'] ?? [];
          _fleetVehicles = data['fleetVehicles'] ?? [];
          _todayAlerts = data['todayAlerts'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading transport mock data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6C4CF1)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKpiGrid(),
          const SizedBox(height: 32),
          _buildSectionHeader('Fleet Vehicles', 'View All >'),
          const SizedBox(height: 16),
          _buildFleetVehiclesList(),
          const SizedBox(height: 32),
          _buildSectionHeader('Today\'s Alerts', 'View All >'),
          const SizedBox(height: 16),
          _buildAlertsList(),
          const SizedBox(height: 32),
          _buildQuickActions(),
          const SizedBox(height: 100), // spacing for bottom nav
        ],
      ),
    );
  }

  Widget _buildKpiGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth > 600 ? 1.3 : 1.15,
          ),
          itemCount: _kpis.length,
          itemBuilder: (context, index) {
            final kpi = _kpis[index];
            return _buildKpiCard(kpi);
          },
        );
      },
    );
  }

  Widget _buildKpiCard(Map<String, dynamic> kpi) {
    IconData icon;
    Color iconColor;
    Color iconBgColor;

    switch (kpi['iconType']) {
      case 'bus':
        icon = LucideIcons.bus;
        iconColor = const Color(0xFF6C4CF1); // Purple
        iconBgColor = const Color(0xFFF3F0FF);
        break;
      case 'map':
        icon = LucideIcons.mapPin;
        iconColor = const Color(0xFF3B82F6); // Blue
        iconBgColor = const Color(0xFFEFF6FF);
        break;
      case 'users':
        icon = LucideIcons.users;
        iconColor = const Color(0xFFF59E0B); // Orange
        iconBgColor = const Color(0xFFFEF3C7);
        break;
      case 'userCheck':
        icon = LucideIcons.userCheck;
        iconColor = const Color(0xFF10B981); // Green
        iconBgColor = const Color(0xFFF0FDF4);
        break;
      default:
        icon = LucideIcons.box;
        iconColor = const Color(0xFF6C4CF1);
        iconBgColor = const Color(0xFFF3F0FF);
    }

    Color statusColor;

    switch (kpi['statusColor']) {
      case 'green':
        statusColor = const Color(0xFF10B981);
        break;
      case 'blue':
        statusColor = const Color(0xFF3B82F6);
        break;
      case 'orange':
        statusColor = const Color(0xFFF59E0B);
        break;
      default:
        statusColor = const Color(0xFF6C4CF1);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFFFF),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF9CA3AF),
                  size: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            kpi['title'],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            kpi['value'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter',
              color: Color(0xFF111827),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              kpi['status'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E1E2D),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4CF1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFleetVehiclesList() {
    if (_fleetVehicles.isEmpty) {
      return const Text('No vehicles available.');
    }

    return Column(
      children: _fleetVehicles.map((vehicle) {
        Color statusColor;
        Color statusBgColor;

        if (vehicle['statusColor'] == 'green') {
          statusColor = const Color(0xFF10B981);
          statusBgColor = const Color(0xFFF0FDF4);
        } else if (vehicle['statusColor'] == 'orange') {
          statusColor = const Color(0xFFF59E0B);
          statusBgColor = const Color(0xFFFEF3C7);
        } else {
          statusColor = const Color(0xFF6C4CF1);
          statusBgColor = const Color(0xFFF3F0FF);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.bus,
                  color: Color(0xFF6C4CF1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          vehicle['id'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            vehicle['status'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle['driver']} • ${vehicle['route']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6C6C80),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                LucideIcons.chevronRight,
                color: Color(0xFF9E9E9E),
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
            children: [
              _buildActionItem('Assign\nDriver', LucideIcons.userPlus),
              _buildActionItem('Add\nRoute', LucideIcons.map),
              _buildActionItem('New\nVehicle', LucideIcons.bus),
              _buildActionItem('Broadcast\nMsg', LucideIcons.megaphone),
              _buildActionItem('Reports', LucideIcons.fileText),
              _buildActionItem('Map View', LucideIcons.mapPin),
              _buildActionItem('Attendance', LucideIcons.clipboardCheck),
              _buildActionItem('Staff', LucideIcons.users),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF6C4CF1).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6C4CF1), size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2D),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    if (_todayAlerts.isEmpty) {
      return const Text('No recent alerts.');
    }

    return Column(
      children: _todayAlerts.map((alert) {
        Color iconColor = alert['type'] == 'warning'
            ? const Color(0xFFF59E0B)
            : const Color(0xFF3B82F6);
        Color bgColor = alert['type'] == 'warning'
            ? const Color(0xFFFEF3C7)
            : const Color(0xFFEFF6FF);
        IconData icon = alert['type'] == 'warning'
            ? LucideIcons.alertTriangle
            : LucideIcons.info;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3EEFF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8E3F8).withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert['message'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert['time'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
