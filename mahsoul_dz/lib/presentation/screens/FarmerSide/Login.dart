import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/core/utils/extensions.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/widgets/common/CustomFormField.dart';
import 'package:mahsoul_dz/presentation/widgets/common/photo_uploader.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();

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
                  l10n.setupFarmProfile,
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

                //  FORM
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FULL NAME / FARM NAME
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          l10n.farmName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _nameController,
                        hintText: l10n.enterFullName,
                        validator: (value) {
                          if (!value!.isValidName) {
                            return l10n.requiredField;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10),

                      // PHONE NUMBER
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          l10n.phoneNumber,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _phoneController,
                        hintText: l10n.enterPhoneNumber,
                        validator: (value) {
                          if (!value!.isValidPhone) {
                            return l10n.invalidPhoneNumber;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          l10n.farmDescription,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // FARM DESCRIPTION
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: l10n.farmDescription,
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            hintText: l10n.description,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          maxLength: 500,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.requiredField;
                            }
                            if (value.length < 20) {
                              return l10n.requiredField;
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      // years of experience
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          l10n.yearsExperience,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _experienceController,
                        hintText: l10n.yearsExperience,
                        validator: (value) {
                          if (!value!.isValidExperience) {
                            return l10n.requiredField;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      // image upload
                      GalleryPickerField(),

                      const SizedBox(height: 20),

                      // login button
                      MyButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/FarmerNavigation');
                          }
                        },
                        text: l10n.save,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
