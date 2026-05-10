import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/user_roles.dart';
import '../../../shared/widgets/bottom_navigation_bar.dart';
import '../../auth/domain/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../more/presentation/more_screen.dart';
import 'widgets/admin_dashboard.dart';
import 'widgets/manager_dashboard.dart';
import 'widgets/operator_dashboard.dart';
import 'widgets/accountant_dashboard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Show loading or redirect if not authenticated
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryRed,
                AppTheme.primaryRedLight,
                AppTheme.primaryRed.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                top: -40,
                right: -30,
                child: _HeaderBubble(
                  size: 140,
                  color: Color(0x26FFFFFF),
                ),
              ),
              Positioned(
                top: -60,
                left: -10,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    width: 180,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: -30,
                left: -20,
                child: _HeaderBubble(
                  size: 110,
                  color: Color(0x1A000000),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _HeaderTitle(
                              name: user.fullName?.isNotEmpty == true
                                  ? user.fullName!
                                  : user.username,
                              roleLabel: user.role.name.toUpperCase(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            color: Colors.white,
                            onPressed: () {
                              // TODO: Show notifications
                            },
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.person_outline),
                                    SizedBox(width: 8),
                                    Text('Profile'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    Icon(Icons.settings_outlined),
                                    SizedBox(width: 8),
                                    Text('Settings'),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout,
                                        color: AppTheme.errorRed),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Logout',
                                      style:
                                          TextStyle(color: AppTheme.errorRed),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'logout') {
                                ref.read(authProvider.notifier).logout();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else if (value == 'settings') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MoreScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _HeaderSubtitle(
                        subtitle: 'Station overview • ${_formatDate()}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          const _NeonBackdrop(),
          RefreshIndicator(
            onRefresh: () async {
              // Simulate refresh
              await Future.delayed(const Duration(seconds: 1));
            },
            child: _buildRoleBasedDashboard(context, user.role),
          ),
        ],
      ),
    );
  }

  /// Conditionally render dashboard based on user role
  Widget _buildRoleBasedDashboard(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const AdminDashboard();
      case UserRole.manager:
        return const ManagerDashboard();
      case UserRole.operator:
        return const OperatorDashboard();
      case UserRole.accountant:
        return const AccountantDashboard();
    }
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    required this.name,
    required this.roleLabel,
  });

  final String name;
  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $name',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            roleLabel,
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderSubtitle extends StatelessWidget {
  const _HeaderSubtitle({
    required this.subtitle,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(
          color: Colors.white.withOpacity(0.9),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

String _formatDate() {
  final now = DateTime.now();
  return '${_monthName(now.month)} ${now.day}, ${now.year}';
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}

class _HeaderBubble extends StatelessWidget {
  const _HeaderBubble({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NeonBackdrop extends StatelessWidget {
  const _NeonBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundGray,
            AppTheme.backgroundGrayLight,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -60,
            child: _HeaderBubble(
              size: 240,
              color: AppTheme.primaryRed.withOpacity(0.14),
            ),
          ),
          Positioned(
            bottom: -160,
            left: -50,
            child: _HeaderBubble(
              size: 260,
              color: AppTheme.infoBlue.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }
}
