import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/views/themes/colors.dart';
import 'package:mahsoul_dz/utils/extensions.dart';
import 'package:mahsoul_dz/views/widgets/common/button.dart';
import 'package:mahsoul_dz/views/widgets/common/CustomFormField.dart';
import 'package:mahsoul_dz/views/widgets/common/Logo.dart';
import 'package:mahsoul_dz/views/screens/customerSide/signup.dart';

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
    final l10n = AppLocalizations.of(context)!;
    
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
                  l10n.mahsoulPortal,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                // description
                Text(
                  l10n.connectWithFarmers,
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
                          l10n.emailAddress,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _emailController,
                        hintText: l10n.enterEmail,
                        validator: (value) {
                          if (!value!.isValidEmail) {
                            return l10n.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          l10n.password,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _passwordController,
                        hintText: l10n.enterPassword,
                        obscureText: true,
                        validator: (value) {
                          if (!value!.isValidPassword) {
                            return l10n.invalidPassword;
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
                          Text(l10n.rememberMe),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password
                            },
                            child: Text(
                              l10n.forgotPassword,
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

                      // login button
                      MyButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/main');
                          }
                        },
                        text: l10n.login,
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
                        l10n.dontHaveAccount,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 5),
                      StatefulBuilder(
                        builder: (context, setState) {
                          bool isHovered = false;
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isHovered = true),
                            onExit: (_) => setState(() => isHovered = false),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to sign up page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                l10n.signUp,
                                style: TextStyle(
                                  color: isHovered
                                      ? primaryColor.withOpacity(0.8)
                                      : primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  decoration: isHovered
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          );
                        },
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
