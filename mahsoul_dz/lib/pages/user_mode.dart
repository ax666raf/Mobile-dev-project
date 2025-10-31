import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';
import 'package:mahsoul_dz/widgets/Cards/user_card.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/pages/login_page.dart';
import 'package:mahsoul_dz/pages/FarmerSide/Login.dart' as farmer_login;
import 'package:mahsoul_dz/widgets/Logo.dart';

class UserMode extends StatefulWidget {
  const UserMode({super.key});

  @override
  State<UserMode> createState() => _UserModeState();
}

class _UserModeState extends State<UserMode> {
  int? _selectedIndex; // 0: Farmer, 1: Consumer
  @override
  Widget build(BuildContext context) {
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
                  'Welcome back to Mahsoul',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                // little text
                Text(
                  'Choose the mode that best suits your needs',
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
                      title: "I'm a Farmer",
                      description:
                          'showcase your harvest and connect with buyers',
                      selected: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                    SizedBox(height: 50),
                    UserCard(
                      iconPath: 'lib/assets/consumer.png',
                      title: "I'm a Consumer",
                      description:
                          'Discover fresh local goods directly from farmers',
                      selected: _selectedIndex == 1,
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                  ],
                ),
                SizedBox(height: 75),
                // next button
                MyButton(
                  text: 'Next',
                  onPressed: () {
                    if (_selectedIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a mode')),
                      );
                      return;
                    }
                    if (_selectedIndex == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const farmer_login.LoginPage(),
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
