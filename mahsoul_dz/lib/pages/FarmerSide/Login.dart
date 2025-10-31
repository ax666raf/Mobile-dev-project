import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';
import 'package:mahsoul_dz/utils/extensions.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/widgets/CustomFormField.dart';
import 'package:mahsoul_dz/widgets/photo_uploader.dart';

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
                  'Complete Your Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                // descritption
                Text(
                  'Tell us more so we can personalize your Mahsoul experience',
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
                          'Full Name / Farm Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _nameController,
                        hintText: 'Enter your name or farm name',
                        validator: (value) {
                          if (!value!.isValidName) {
                            return 'Invalid Name Format';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10),

                      // PHONE NUMBER
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _phoneController,
                        hintText: 'Enter your phone number',
                        obscureText: true,
                        validator: (value) {
                          if (!value!.isValidPhone) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Farm Description',
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
                            labelText: 'Farm Description',
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
                            hintText:
                                'Describe your crop from quality, harvest date, and more',
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          maxLength: 500,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 20) {
                              return 'Description must be at least 20 characters long';
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
                          'Years of Experience',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomFormField(
                        controller: _experienceController,
                        hintText: 'Enter your years of experience',
                        validator: (value) {
                          if (!value!.isValidExperience) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      // image upload
                      GalleryPickerField(),

                      const SizedBox(height: 20),

                      // login buttonr
                      MyButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/MainDashboard');
                          }
                        },
                        text: 'Save & Continue',
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
