import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/main_navigator.dart';

void main() {
  runApp(
    const ProviderScope(
      child: OctaneProApp(),
    ),
  );
}

class OctaneProApp extends ConsumerWidget {
  const OctaneProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'OctanePro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: const MainNavigator(),
    );
  }
}
