import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';
import 'package:mahsoul_dz/utils/extensions.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/widgets/CustomFormField.dart';
import 'package:mahsoul_dz/widgets/Logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;

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
                Logo(),

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

                //  FORM
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // email field
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _emailController,
                        hintText: 'Enter you email address',
                        validator: (value) {
                          if (!value!.isValidEmail) {
                            return 'Invalid email adress';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscureText: true,
                        validator: (value) {
                          if (!value!.isValidPassword) {
                            return 'Invalid password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // remember me and forgot password
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) =>
                                setState(() => rememberMe = value ?? false),
                          ),
                          const Text('Remember me'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 14,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // login buttonr
                      MyButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/main');
                          }
                        },
                        text: 'Login',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(height: 20),

                // dont have account & sign up
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
