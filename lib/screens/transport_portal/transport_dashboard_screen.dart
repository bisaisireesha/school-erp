import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_theme.dart';

class TransportDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String screenKey) onNavigate;

  const TransportDashboardScreen({
    super.key,
    required this.data,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final stats = data['quickStats'] ?? {};
    final vehicles = data['vehicles'] as List? ?? [];
    final alerts = data['compliance'] as List? ?? [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Overall Summary KPI Cards (2x2 Grid)
          _buildKpiGrid(stats),
          const SizedBox(height: 26),

          // 2. Fleet Vehicles Section (Clean Vertical List)
          _buildFleetVehiclesSection(vehicles),
          const SizedBox(height: 26),

          // 3. Quick Actions
          _buildQuickActionsSection(),
          const SizedBox(height: 26),

          // 4. Today's Alerts
          _buildTodaysAlertsSection(alerts),
        ],
      ),
    );
  }

  // ─── 1. Overall Summary 2x2 KPI Grid ────────────────────────────────────────

  Widget _buildKpiGrid(Map<String, dynamic> stats) {
    final totalVehicles = stats['totalVehicles'] ?? 20;
    final vehiclesOnRoute = stats['vehiclesOnRoute'] ?? stats['activeFleet'] ?? 18;
    final driversOnDuty = stats['driversOnDuty'] ?? 18;
    final studentsAssigned = stats['studentsAssigned'] ?? stats['totalStudents'] ?? 640;

    final kpis = [
      {
        'title': 'Active Fleet',
        'value': '$vehiclesOnRoute / $totalVehicles',
        'chipText': '90% Operational',
        'chipColor': const Color(0xFF10B981),
        'chipBg': const Color(0xFFECFDF5),
        'icon': LucideIcons.bus,
        'iconColor': const Color(0xFF6C4CF1),
        'key': 'vehicles',
      },
      {
        'title': 'Active Routes',
        'value': '12 Routes',
        'chipText': 'On Schedule',
        'chipColor': const Color(0xFF3B82F6),
        'chipBg': const Color(0xFFEFF6FF),
        'icon': LucideIcons.mapPin,
        'iconColor': const Color(0xFF3B82F6),
        'key': 'routes',
      },
      {
        'title': 'Students Assigned',
        'value': '$studentsAssigned',
        'chipText': 'Fully Tracked',
        'chipColor': const Color(0xFFD97706),
        'chipBg': const Color(0xFFFFFBEB),
        'icon': LucideIcons.users,
        'iconColor': const Color(0xFFF59E0B),
        'key': 'assignments',
      },
      {
        'title': 'Drivers & Staff',
        'value': '$driversOnDuty / 24',
        'chipText': 'All On Duty',
        'chipColor': const Color(0xFF10B981),
        'chipBg': const Color(0xFFECFDF5),
        'icon': LucideIcons.userCheck,
        'iconColor': const Color(0xFF10B981),
        'key': 'drivers',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kpis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.30,
      ),
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        final Color iconColor = kpi['iconColor'] as Color;
        final Color chipColor = kpi['chipColor'] as Color;
        final Color chipBg = kpi['chipBg'] as Color;

        return GestureDetector(
          onTap: () => onNavigate(kpi['key'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Colored Icon on Left, Chevron on Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(kpi['icon'] as IconData, color: iconColor, size: 16),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFCDCBE0),
                      size: 18,
                    ),
                  ],
                ),

                // Middle Section: Large KPI Value & Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kpi['value'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      kpi['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6E6E8D),
                      ),
                    ),
                  ],
                ),

                // Bottom Section: Small Status Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    kpi['chipText'] as String,
                    style: TextStyle(
                      color: chipColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── 2. Fleet Vehicles (Clean Vertical List) ───────────────────────────────

  Widget _buildFleetVehiclesSection(List vehicles) {
    final topVehicles = vehicles.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fleet Vehicles',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: () => onNavigate('vehicles'),
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6C4CF1), size: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topVehicles.length,
          itemBuilder: (context, index) {
            final v = topVehicles[index];
            final String busNo = v['busNo'] ?? 'BUS-01';
            final String rawStatus = v['status'] ?? 'Idle';
            final String status = rawStatus.contains('Route')
                ? 'On Route'
                : (rawStatus.contains('Maintenance') ? 'Maintenance' : 'Idle');

            Color statusColor;
            Color statusBg;
            if (status == 'On Route') {
              statusColor = const Color(0xFF16A34A);
              statusBg = const Color(0xFFF0FDF4);
            } else if (status == 'Maintenance') {
              statusColor = const Color(0xFFEF4444);
              statusBg = const Color(0xFFFEF2F2);
            } else {
              statusColor = const Color(0xFFD97706);
              statusBg = const Color(0xFFFFFBEB);
            }

            final String driver = v['driver'] ?? 'Unassigned';
            final String route = v['route'] ?? 'No Route';

            return GestureDetector(
              onTap: () => onNavigate('vehicles'),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.bus, color: Color(0xFF6C4CF1), size: 18),
                    ),
                    const SizedBox(width: 12),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                busNo,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E2D),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$driver  •  $route',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF6E6E8D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chevron
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFB0AABF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── 3. Quick Actions ───────────────────────────────────────────────────────

  Widget _buildQuickActionsSection() {
    final actions = [
      {'title': 'Add Vehicle', 'icon': LucideIcons.bus, 'color': const Color(0xFF6C4CF1), 'key': 'vehicles'},
      {'title': 'Assign Driver', 'icon': LucideIcons.userPlus, 'color': const Color(0xFF10B981), 'key': 'drivers'},
      {'title': 'Build Route', 'icon': LucideIcons.mapPin, 'color': const Color(0xFF3B82F6), 'key': 'routes'},
      {'title': 'Collect Fee', 'icon': LucideIcons.creditCard, 'color': const Color(0xFFF59E0B), 'key': 'fees'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2D),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: actions.map((act) {
            final Color color = act['color'] as Color;
            return Expanded(
              child: GestureDetector(
                onTap: () => onNavigate(act['key'] as String),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(act['icon'] as IconData, color: color, size: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        act['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E2D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── 4. Today's Compliance Alerts ──────────────────────────────────────────

  Widget _buildTodaysAlertsSection(List alerts) {
    final topAlerts = alerts.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Alerts',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2D),
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: () => onNavigate('compliance'),
              child: const Row(
                children: [
                  Text(
                    'Compliance Hub',
                    style: TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6C4CF1), size: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Column(
          children: topAlerts.map((item) {
            final String rawStatus = item['status'] ?? 'Valid';
            final bool isWarn = rawStatus == 'Warning';
            final bool isExpired = rawStatus == 'Expired';

            Color statusColor;
            Color statusBg;
            String statusLabel;
            if (isExpired) {
              statusColor = const Color(0xFFEF4444);
              statusBg = const Color(0xFFFEF2F2);
              statusLabel = 'Expired';
            } else if (isWarn) {
              statusColor = const Color(0xFFD97706);
              statusBg = const Color(0xFFFFFBEB);
              statusLabel = 'Expiring Soon';
            } else {
              statusColor = const Color(0xFF16A34A);
              statusBg = const Color(0xFFF0FDF4);
              statusLabel = 'Compliant';
            }

            return GestureDetector(
              onTap: () => onNavigate('compliance'),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0EDF8), width: 1.0),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['busNo']} - ${item['item']}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Expires ${item['expiry']}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: isWarn || isExpired ? statusColor : const Color(0xFF6E6E8D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFB0AABF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
