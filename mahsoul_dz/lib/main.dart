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
import 'package:mahsoul_dz/presentation/screens/customerSide/login_page.dart';
import 'package:mahsoul_dz/presentation/screens/homescreen/user_mode.dart';
import 'package:mahsoul_dz/presentation/themes/app_theme.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/menu_page.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/main_navigation.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/MainDahboard.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/FarmerNavigation.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/signup.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/product_detail.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_form.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/FarmerForm.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/market.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/cart_page.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/cart-proceed.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/Products.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/orders_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
        BlocProvider(create: (context) => AuthCubit(DependencyInjection.authRepository)),
        BlocProvider(create: (context) => UserCubit(DependencyInjection.authRepository)),
        BlocProvider(create: (context) => ProductCubit(DependencyInjection.productRepository)),
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
            data: baseTheme.copyWith(
              textTheme: textTheme,
            ),
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
          Locale('en'),      // English
          Locale('ar'),      // Arabic
          Locale('fr'),      // French
        ],
        
        home: SystemUIOverlayWrapper(child: IntroPage()),
        routes: {
          '/intro': (context) => const IntroPage(),
          '/home': (context) => const UserMode(),
          '/login': (context) => const LoginPage(),
          '/menu': (context) => const MenuPage(),
          '/main': (context) => const MainNavigation(),
          '/MainDashboard': (context) => MainDashboard(),
          '/FarmerNavigation': (context) => Farmernavigation(),
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
