import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/user/user_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/product_cubit.dart';
import 'package:mahsoul_dz/presentation/screens/homescreen/intro_page.dart';
import 'package:mahsoul_dz/presentation/screens/homescreen/user_mode.dart';
import 'package:mahsoul_dz/presentation/themes/app_theme.dart';
// Centralized imports for screens
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';
import 'package:mahsoul_dz/presentation/screens/farmerSide/farmer_side_screens.dart'
    hide LoginPage;
import 'package:mahsoul_dz/core/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Firebase (requires google-services.json configuration)
  // Uncomment when Firebase is properly configured:
  /*
  await Firebase.initializeApp();
  
  // Initialize FCM
  FirebaseMessaging.onBackgroundMessage(fcm.firebaseMessagingBackgroundHandler);
  final fcmService = FCMService();
  await fcmService.initialize();
  
  // Set up notification tap handler
  fcmService.onNotificationTapped = (data) {
    // Navigate to orders page
    // This will be handled by a navigator key
  };
  */

  // Initialize local notifications
  await LocalNotificationService().initialize();

  runApp(MyApp());
}

class LocaleManager extends ChangeNotifier {
  static final LocaleManager _instance = LocaleManager._internal();
  factory LocaleManager() => _instance;
  LocaleManager._internal();

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global cubits
        BlocProvider(
          create: (context) => AuthCubit(DependencyInjection.authRepository),
        ),
        BlocProvider(
          create: (context) => UserCubit(DependencyInjection.authRepository),
        ),
        BlocProvider(
          create: (context) =>
              ProductCubit(DependencyInjection.productRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mahsoul',
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          // Update theme based on locale
          final locale = _locale;
          final isArabic = locale.languageCode == 'ar';
          final baseTheme = Theme.of(context);
          final textTheme = isArabic
              ? GoogleFonts.cairoTextTheme(baseTheme.textTheme)
              : GoogleFonts.leagueSpartanTextTheme(baseTheme.textTheme);

          return Theme(
            data: baseTheme.copyWith(textTheme: textTheme),
            child: child!,
          );
        },

        // Current locale
        locale: _locale,

        // Localization Configuration
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
          Locale('fr'), // French
        ],

        home: SystemUIOverlayWrapper(child: IntroPage()),
        routes: {
          '/intro': (context) => const IntroPage(),
          '/home': (context) => const UserMode(),
          '/login': (context) => const LoginPage(),
          '/menu': (context) => const MenuPage(),
          '/main': (context) => const MainNavigation(),
          '/MainDashboard': (context) => MainDashboard(),
          '/FarmerNavigation': (context) =>
              Farmernavigation(key: Farmernavigation.navigationKey),
          '/signup': (context) => SignUpScreen(),
          '/customer': (context) => CustomerFormScreen(),
          '/farmer-form': (context) => FarmerFormScreen(),
          '/ProductsPage': (context) => const ProductsPage(),
          '/OrdersPage': (context) => const OrdersPage(),
          '/market': (context) => Market(),
        },
      ),
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
