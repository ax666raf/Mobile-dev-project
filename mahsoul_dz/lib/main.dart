import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahsoul_dz/pages/intro_page.dart';
import 'package:mahsoul_dz/pages/login_page.dart';
import 'package:mahsoul_dz/pages/user_mode.dart';
import 'package:mahsoul_dz/themes/app_theme.dart';
import 'package:mahsoul_dz/pages/menu_page.dart';
import 'package:mahsoul_dz/pages/main_navigation.dart';
import 'package:mahsoul_dz/pages/FarmerSide/MainDahboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mahsoul',
      theme: AppTheme.lightTheme,
      home: const SystemUIOverlayWrapper(child: IntroPage()),
      routes: {
        '/intro': (context) => const IntroPage(),
        '/home': (context) => const UserMode(),
        '/login': (context) => const LoginPage(),
        '/menu': (context) => const MenuPage(),
        '/main': (context) => const MainNavigation(),
        '/MainDashboard': (context) => MainDashboard(),

      },
    );
  }
}

class SystemUIOverlayWrapper extends StatelessWidget {
  final Widget child;

  const SystemUIOverlayWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
      child: child,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mahsoul'),
      ),
      body: const Center(child: Text('Welcome to Mahsoul')),
    );
  }
}
