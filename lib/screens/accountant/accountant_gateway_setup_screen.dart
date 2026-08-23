import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountantGatewaySetupScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AccountantGatewaySetupScreen({super.key, required this.onBack});

  @override
  State<AccountantGatewaySetupScreen> createState() =>
      _AccountantGatewaySetupScreenState();
}

class _AccountantGatewaySetupScreenState
    extends State<AccountantGatewaySetupScreen> {
  final List<Map<String, dynamic>> _gateways = [
    {
      'id': 'GW-001',
      'name': 'Razorpay',
      'mode': 'Live',
      'status': 'Active',
      'statusColor': const Color(0xFF16A34A),
      'statusBg': const Color(0xFFF0FDF4),
      'apiKey': 'rzp_live_**********89xy',
      'webhook': 'https://api.school.com/webhooks/rzp',
      'transactions': '4,521',
      'icon': Icons.payment,
    },
    {
      'id': 'GW-002',
      'name': 'PayU',
      'mode': 'Live',
      'status': 'Inactive',
      'statusColor': const Color(0xFF64748B),
      'statusBg': const Color(0xFFF1F5F9),
      'apiKey': 'payu_live_**********44ab',
      'webhook': 'https://api.school.com/webhooks/payu',
      'transactions': '850',
      'icon': Icons.credit_card,
    },
    {
      'id': 'GW-003',
      'name': 'Stripe',
      'mode': 'Test',
      'status': 'Sandbox',
      'statusColor': const Color(0xFFF59E0B),
      'statusBg': const Color(0xFFFFFBEB),
      'apiKey': 'sk_test_**********p01z',
      'webhook': 'https://api.school.com/webhooks/stripe',
      'transactions': '12',
      'icon': Icons.account_balance_wallet,
    },
  ];

  int get _totalGateways => _gateways.length;
  int get _activeCount =>
      _gateways.where((g) => g['status'] == 'Active').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF3EEFF),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF1E1E2D),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gateway Setup',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1E2D),
                            ),
                          ),
                          Text(
                            'Configure online payment providers',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showConfigureDialog(context, null),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CF1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              LucideIcons.plus,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // KPI grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.1,
                  children: [
                    _buildKpiCard(
                      'Total Providers',
                      _totalGateways,
                      const Color(0xFF6C4CF1),
                      const Color(0xFFF3F0FF),
                      LucideIcons.smartphone,
                    ),
                    _buildKpiCard(
                      'Active Now',
                      _activeCount,
                      const Color(0xFF16A34A),
                      const Color(0xFFF0FDF4),
                      LucideIcons.zap,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Gateways List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _gateways.map((g) => _buildGatewayCard(g)).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String label,
    int count,
    Color color,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1E2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGatewayCard(Map<String, dynamic> gateway) {
    final Color statusColor = gateway['statusColor'] as Color;
    final Color statusBg = gateway['statusBg'] as Color;
    final bool isActive = gateway['status'] == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? const Color(0xFF16A34A).withValues(alpha: 0.3)
              : const Color(0xFFF1F5F9),
          width: isActive ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8E3F8).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Icon(
                      gateway['icon'] as IconData,
                      color: const Color(0xFF6C4CF1),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    gateway['name'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  gateway['status'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildInfoRow('Mode', gateway['mode'] as String),
                const SizedBox(height: 8),
                _buildInfoRow('API Key', gateway['apiKey'] as String),
                const SizedBox(height: 8),
                _buildInfoRow('Webhook URL', gateway['webhook'] as String),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 14),

          // Footer actions
          Row(
            children: [
              Icon(
                LucideIcons.activity,
                size: 13,
                color: const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 4),
              Text(
                '${gateway['transactions']} Transactions',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showConfigureDialog(context, gateway),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Configure',
                    style: TextStyle(
                      color: Color(0xFF6C4CF1),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1E1E2D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showConfigureDialog(
    BuildContext context,
    Map<String, dynamic>? gateway,
  ) {
    final isNew = gateway == null;
    final nameController = TextEditingController(
      text: isNew ? '' : gateway['name'],
    );
    final apiController = TextEditingController(
      text: isNew ? '' : gateway['apiKey'],
    );
    final webhookController = TextEditingController(
      text: isNew ? '' : gateway['webhook'],
    );
    String selectedMode = isNew ? 'Test' : gateway['mode'];
    String selectedStatus = isNew ? 'Sandbox' : gateway['status'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isNew ? 'Add Gateway' : 'Configure Gateway',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isNew
                          ? 'Enter provider API details.'
                          : 'Update existing credentials safely.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildField('PROVIDER NAME', nameController),
                    const SizedBox(height: 16),

                    // Mode selector
                    const Text(
                      'ENVIRONMENT MODE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Live', 'Test'].map((mode) {
                        final isSelected = selectedMode == mode;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() {
                              selectedMode = mode;
                              if (mode == 'Live') {
                                selectedStatus = 'Active';
                              } else {
                                selectedStatus = 'Sandbox';
                              }
                            }),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1E1E2D)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1E1E2D)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                mode,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1E1E2D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
                    _buildField('API KEY / SECRET', apiController),
                    const SizedBox(height: 16),
                    _buildField('WEBHOOK URL', webhookController),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1E1E2D),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (isNew) {
                                _gateways.insert(0, {
                                  'id': 'GW-00${(_gateways.length + 4)}',
                                  'name': nameController.text.isEmpty
                                      ? 'Unknown Provider'
                                      : nameController.text,
                                  'mode': selectedMode,
                                  'status': selectedStatus,
                                  'statusColor': selectedStatus == 'Active'
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFFF59E0B),
                                  'statusBg': selectedStatus == 'Active'
                                      ? const Color(0xFFF0FDF4)
                                      : const Color(0xFFFFFBEB),
                                  'apiKey': apiController.text.isEmpty
                                      ? 'sk_test_*******'
                                      : apiController.text,
                                  'webhook': webhookController.text.isEmpty
                                      ? 'https://...'
                                      : webhookController.text,
                                  'transactions': '0',
                                  'icon': Icons.payment,
                                });
                              } else {
                                gateway['name'] = nameController.text;
                                gateway['mode'] = selectedMode;
                                gateway['status'] = selectedStatus;
                                gateway['statusColor'] =
                                    selectedStatus == 'Active'
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFF59E0B);
                                gateway['statusBg'] = selectedStatus == 'Active'
                                    ? const Color(0xFFF0FDF4)
                                    : const Color(0xFFFFFBEB);
                                gateway['apiKey'] = apiController.text;
                                gateway['webhook'] = webhookController.text;
                              }
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isNew
                                      ? 'Gateway added successfully!'
                                      : 'Gateway updated successfully!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4CF1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isNew ? 'Add Gateway' : 'Save Changes',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2D)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6C4CF1)),
            ),
          ),
        ),
      ],
    );
  }
}
