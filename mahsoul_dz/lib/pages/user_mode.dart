import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';
import 'package:mahsoul_dz/widgets/Cards/user_card.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/pages/login_page.dart';

class UserMode extends StatefulWidget {
  const UserMode({super.key});

  @override
  State<UserMode> createState() => _UserModeState();
}

class _UserModeState extends State<UserMode> {
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
                Text(
                  'Mahsoul',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

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
                      onTap: () {},
                    ),
                    SizedBox(height: 50),
                    UserCard(
                      iconPath: 'lib/assets/consumer.png',
                      title: "I'm a Consumer",
                      description:
                          'Discover fresh local goods directly from farmers',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 75),
                // next button
                MyButton(
                  text: 'Next',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
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
