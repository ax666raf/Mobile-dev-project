import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/core/utils/extensions.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/widgets/common/CustomFormField.dart';
import 'package:mahsoul_dz/presentation/widgets/common/photo_uploader.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_profile_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

class FarmerFormScreen extends StatefulWidget {
  const FarmerFormScreen({super.key});

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _farmLocationController = TextEditingController();
  String? _selectedImagePath;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _experienceController.dispose();
    _farmLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? farmerId;
        if (authState is AuthAuthenticated && authState.userType == 'farmer') {
          farmerId = authState.userId;
        }

        if (farmerId == null) {
          return Scaffold(
            body: Center(
              child: Text(l10n.pleaseLoginAsFarmer),
            ),
          );
        }

        return BlocProvider(
          create: (context) => FarmerProfileCubit(
            DependencyInjection.profileRepository,
            farmerId!,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26.0,
                    vertical: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // LOGO
                        const Logo(),

                        const SizedBox(height: 35),

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
                        const SizedBox(height: 30),

                        //  FORM
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FARM NAME
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                l10n.farmName,
                                style: const TextStyle(
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

                            const SizedBox(height: 10),

                            // PHONE NUMBER
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                l10n.phoneNumber,
                                style: const TextStyle(
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

                            const SizedBox(height: 10),

                            // FARM LOCATION
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                l10n.farmLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            CustomFormField(
                              controller: _farmLocationController,
                              hintText: l10n.enterFarmLocation,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.requiredField;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // FARM DESCRIPTION
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                l10n.farmDescription,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: l10n.farmDescription,
                                  border: const OutlineInputBorder(),
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
                                    return l10n.descriptionMinLength;
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // YEARS OF EXPERIENCE
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                l10n.yearsExperience,
                                style: const TextStyle(
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

                            const SizedBox(height: 20),

                            // IMAGE UPLOAD
                            GalleryPickerField(
                              onImageSaved: (imagePath) {
                                setState(() {
                                  _selectedImagePath = imagePath;
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            // SAVE BUTTON
                            BlocListener<FarmerProfileCubit, FarmerProfileState>(
                              listener: (context, state) {
                                if (state is FarmerProfileLoaded) {
                                  // Profile updated successfully
                                  Navigator.pushReplacementNamed(context, '/FarmerNavigation');
                                } else if (state is FarmerProfileError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: BlocBuilder<FarmerProfileCubit, FarmerProfileState>(
                                builder: (context, state) {
                                  final isLoading = state is FarmerProfileLoading;
                                  
                                  return MyButton(
                                    onPressed: isLoading ? null : () {
                                      if (_formKey.currentState!.validate()) {
                                        final cubit = context.read<FarmerProfileCubit>();
                                        
                                        // Update profile with form data
                                        cubit.updateProfile(
                                          farmName: _nameController.text.trim(),
                                          farmLocation: _farmLocationController.text.trim(),
                                          phoneNumber: _phoneController.text.trim(),
                                          description: _descriptionController.text.trim(),
                                          establishedYear: int.tryParse(_experienceController.text.trim()) ?? DateTime.now().year,
                                        );
                                        
                                        // Update profile image if selected
                                        if (_selectedImagePath != null) {
                                          cubit.updateProfileImage(_selectedImagePath!);
                                        }
                                      }
                                    },
                                    text: isLoading ? l10n.loading : l10n.save,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

