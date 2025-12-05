import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/common/user_card.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/login_page.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/FarmerLogin.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';

class UserMode extends StatefulWidget {
  const UserMode({super.key});

  @override
  State<UserMode> createState() => _UserModeState();
}

class _UserModeState extends State<UserMode> {
  int? _selectedIndex; // 0: Farmer, 1: Consumer
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35.0,
              vertical: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // logo mn fo9
                Logo(),

                SizedBox(height: 60),

                // title
                Text(
                  l10n.welcomeBack,  // 🌍 Localized!
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                // little text
                Text(
                  l10n.selectMode,  // 🌍 Localized!
                  style: TextStyle(fontSize: 13, color: Colors.grey[900]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),

                // choice of user mode
                // two cards
                Column(
                  children: [
                    UserCard(
                      iconPath: 'lib/assets/farmer.png',
                      title: l10n.imFarmer,  // 🌍 Localized!
                      description: l10n.farmerDescription,  // 🌍 Localized!
                      selected: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                    SizedBox(height: 50),
                    UserCard(
                      iconPath: 'lib/assets/consumer.png',
                      title: l10n.imConsumer,  // 🌍 Localized!
                      description: l10n.consumerDescription,  // 🌍 Localized!
                      selected: _selectedIndex == 1,
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                  ],
                ),
                SizedBox(height: 75),
                // next button
                MyButton(
                  text: l10n.next,  // 🌍 Localized!
                  onPressed: () {
                    if (_selectedIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.pleaseSelectMode)),  // 🌍 Localized!
                      );
                      return;
                    }
                    if (_selectedIndex == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FarmerLoginPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
