import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/user/user_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/favorite/favorite_cubit.dart';
import 'package:mahsoul_dz/presentation/screens/homescreen/intro_page.dart';
import 'package:mahsoul_dz/presentation/screens/homescreen/user_mode.dart';
import 'package:mahsoul_dz/presentation/themes/app_theme.dart';
// Centralized imports for screens
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';
import 'package:mahsoul_dz/presentation/screens/farmerSide/farmer_side_screens.dart'
    hide LoginPage;
import 'package:mahsoul_dz/core/services/local_notification_service.dart';
import 'package:mahsoul_dz/core/services/fcm_service.dart';

// Global navigator key for navigation from notifications
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Top-level function for background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase in the background isolate
  // Note: Background handlers run in a separate isolate, so Firebase must be initialized here
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
  // Background notifications are handled by the system
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('⚠️ Firebase initialization error: $e');
    print('⚠️ Make sure google-services.json (Android) and GoogleService-Info.plist (iOS) are added');
  }
  
  // Initialize FCM background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // Initialize FCM service
  try {
    final fcmService = FCMService();
    await fcmService.initialize();
    
    // Set up notification tap handler
    fcmService.onNotificationTapped = (data) {
      // Navigate to orders page when notification is tapped
      final userType = data['user_type'] ?? 'farmer';
      if (userType == 'farmer') {
        navigatorKey.currentState?.pushNamed('/OrdersPage');
      } else {
        // For customers, navigate to their orders page
        final customerId = data['customer_id'];
        if (customerId != null) {
          // Navigate to customer orders - you may need to adjust this route
          navigatorKey.currentState?.pushNamed('/main');
        }
      }
    };
    print('✅ FCM service initialized successfully');
  } catch (e) {
    print('⚠️ FCM service initialization error: $e');
  }

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
        BlocProvider(
          create: (context) =>
              FavoriteCubit(DependencyInjection.favoriteRepository),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
