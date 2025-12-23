import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

/// Wrapper widget that adds bottom navigation to any page
class PageWithNav extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const PageWithNav({
    super.key,
    required this.child,
    this.currentIndex = 1, // Default to Cart
  });

  @override
  State<PageWithNav> createState() => _PageWithNavState();
}

class _PageWithNavState extends State<PageWithNav> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 0) {
                  // Navigate to Home (MainNavigation with index 0)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                    (route) => false,
                  );
                } else if (index == 1) {
                  // Navigate to Cart
                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthAuthenticated &&
                      authState.userType == 'customer') {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CartCubit(
                            DependencyInjection.cartRepository,
                            authState.userId,
                          )..loadCart(),
                          child: MahsoulOrderScreen(
                            customerId: authState.userId,
                          ),
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    // Navigate to MainNavigation which will show login message
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(),
                      ),
                      (route) => false,
                    );
                  }
                } else if (index == 2) {
                  // Navigate to Profile (MainNavigation with index 2)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                    (route) => false,
                  );
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart),
                  label: l10n.cart ?? 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: l10n.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
