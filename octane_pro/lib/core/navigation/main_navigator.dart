import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/shifts/presentation/shifts_screen.dart';
import '../../features/entries/presentation/entries_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../shared/widgets/bottom_navigation_bar.dart';
import '../../core/theme/app_theme.dart';

class MainNavigator extends ConsumerStatefulWidget {
  const MainNavigator({super.key});

  @override
  ConsumerState<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends ConsumerState<MainNavigator> {
  int _currentIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> _screens = const [
    DashboardScreen(),
    ShiftsScreen(),
    EntriesScreen(),
    ReportsScreen(),
    MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Check auth state on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  void _checkAuth() {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    if (!isAuthenticated) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
              case '/splash':
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginScreen());
              default:
                return MaterialPageRoute(builder: (_) => const SplashScreen());
            }
          },
          initialRoute: '/splash',
        ),
      );
    }

    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
