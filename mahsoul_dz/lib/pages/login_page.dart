import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/pages/main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LOGO
                Text(
                  'Mahsoul',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 35),

                // TITLE
                Text(
                  'Mahsoul Portal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                // descritption
                Text(
                  'Connect with local farmers and discover fresh produce',
                  style: TextStyle(fontSize: 12, color: Colors.grey[900]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // image
                Image.asset('lib/assets/login.png', width: 210, height: 210),
                SizedBox(height: 25),

                // email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // password
                    Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ],
                ),

                // remember me and forgot password
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: [
                      // remember me
                      Checkbox(value: false, onChanged: (value) {}),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // login buttonr
                MyButton(
                  text: 'Login',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // sign up
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
