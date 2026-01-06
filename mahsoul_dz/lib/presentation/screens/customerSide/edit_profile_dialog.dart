import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_state.dart';

class EditProfileDialog extends StatefulWidget {
  final Map<String, dynamic> currentProfile;

  const EditProfileDialog({
    super.key,
    required this.currentProfile,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();

  static void show(BuildContext context, Map<String, dynamic> currentProfile) {
    try {
      // Get the CustomerProfileCubit from the parent context
      final profileCubit = context.read<CustomerProfileCubit>();
      
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => BlocProvider.value(
          value: profileCubit,
          child: EditProfileDialog(currentProfile: currentProfile),
        ),
      );
    } catch (e) {
      print('❌ Error showing edit profile dialog: $e');
      // Show error to user
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorOpeningEditProfile}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentProfile['full_name'] as String? ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.currentProfile['phone_number'] as String? ?? '',
    );
    _cityController = TextEditingController(
      text: widget.currentProfile['city'] as String? ?? '',
    );
    _postalCodeController = TextEditingController(
      text: widget.currentProfile['postal_code'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<CustomerProfileCubit>();
      cubit.updateProfile({
        'full_name': _nameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'city': _cityController.text.trim(),
        'postal_code': _postalCodeController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CustomerProfileCubit, CustomerProfileState>(
      listener: (context, state) {
        if (state is CustomerProfileLoaded) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileUpdatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CustomerProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.editProfile,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.fullName,
                      hintText: l10n.enterFullName,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      hintText: l10n.enterPhoneNumber,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // City
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: l10n.city,
                      hintText: l10n.selectCity,
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Postal Code
                  TextFormField(
                    controller: _postalCodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.postalCodeOptional,
                      hintText: 'Enter postal code',
                      prefixIcon: const Icon(Icons.markunread_mailbox_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
                    builder: (context, state) {
                      final isLoading = state is CustomerProfileLoading;
                      return MyButton(
                        text: isLoading ? l10n.saving : l10n.save,
                        onPressed: isLoading ? null : _handleSave,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

