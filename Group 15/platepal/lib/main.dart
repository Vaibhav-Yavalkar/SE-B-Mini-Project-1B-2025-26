     // lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'app_provider.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/admin_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const PlatePalApp());
}

class PlatePalApp extends StatelessWidget {
  const PlatePalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'PlatePal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        // Always start with SplashScreen to ensure opening animation plays
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainShell(),
          '/admin': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
