import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/views/themes/colors.dart';
import 'package:mahsoul_dz/views/screens/FarmerSide/MainDahboard.dart';
import 'package:mahsoul_dz/views/screens/FarmerSide/Products.dart';
import 'package:mahsoul_dz/views/screens/FarmerSide/orders_page.dart';
import 'package:mahsoul_dz/views/screens/FarmerSide/profile_page.dart';


class Farmernavigation extends StatefulWidget {
  const Farmernavigation({super.key});

  @override
  State<Farmernavigation> createState() => _FarmernavigationState();
}

class _FarmernavigationState extends State<Farmernavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainDashboard(),
    const ProductsPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
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
            label: l10n.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: l10n.products,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag),
            label: l10n.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
