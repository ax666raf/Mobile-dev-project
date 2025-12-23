import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/common/CustomFormField.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_profile_state.dart';

class EditFarmerProfileDialog extends StatefulWidget {
  final Map<String, dynamic> currentProfile;
  final Map<String, dynamic>? farmerData;

  const EditFarmerProfileDialog({
    super.key,
    required this.currentProfile,
    this.farmerData,
  });

  @override
  State<EditFarmerProfileDialog> createState() => _EditFarmerProfileDialogState();
}

class _EditFarmerProfileDialogState extends State<EditFarmerProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _farmNameController;
  late TextEditingController _farmLocationController;
  late TextEditingController _descriptionController;
  late TextEditingController _establishedYearController;

  @override
  void initState() {
    super.initState();
    final farmerData = widget.farmerData ?? {};
    
    _nameController = TextEditingController(
      text: widget.currentProfile['full_name'] as String? ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.currentProfile['phone_number'] as String? ?? '',
    );
    _emailController = TextEditingController(
      text: widget.currentProfile['email'] as String? ?? '',
    );
    _farmNameController = TextEditingController(
      text: farmerData['farm_name'] as String? ?? '',
    );
    _farmLocationController = TextEditingController(
      text: farmerData['farm_location'] as String? ?? '',
    );
    _descriptionController = TextEditingController(
      text: farmerData['description'] as String? ?? '',
    );
    // Extract year from established_year or created_at
    // Backend stores established_year as String, so we need to handle it as String first
    final establishedYearStr = farmerData['established_year'] as String?;
    if (establishedYearStr != null && establishedYearStr.isNotEmpty) {
      _establishedYearController = TextEditingController(text: establishedYearStr);
    } else {
      final createdAt = widget.currentProfile['created_at'] as int?;
      if (createdAt != null) {
        final year = DateTime.fromMillisecondsSinceEpoch(createdAt).year;
        _establishedYearController = TextEditingController(text: year.toString());
      } else {
        _establishedYearController = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _descriptionController.dispose();
    _establishedYearController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<FarmerProfileCubit>();
      final establishedYear = int.tryParse(_establishedYearController.text.trim());
      
      cubit.updateProfile(
        farmName: _farmNameController.text.trim().isEmpty ? null : _farmNameController.text.trim(),
        farmLocation: _farmLocationController.text.trim().isEmpty ? null : _farmLocationController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        establishedYear: establishedYear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FarmerProfileCubit, FarmerProfileState>(
      listener: (context, state) {
        if (state is FarmerProfileLoaded) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is FarmerProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
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
                        'Edit Profile',
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
                  Text(
                    'Full Name',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _nameController,
                    hintText: 'Enter your full name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _phoneController,
                    hintText: 'Enter phone number',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _emailController,
                    hintText: 'Enter email address',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Farm Name
                  Text(
                    'Farm Name',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _farmNameController,
                    hintText: 'Enter farm name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Farm name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Farm Location
                  Text(
                    'Farm Location',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _farmLocationController,
                    hintText: 'Enter farm location',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Farm location is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Established Year
                  Text(
                    'Established Year',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: _establishedYearController,
                    hintText: 'Enter year (e.g., 2020)',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Established year is required';
                      }
                      final year = int.tryParse(value.trim());
                      if (year == null) {
                        return 'Please enter a valid year';
                      }
                      if (year < 1900 || year > DateTime.now().year) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter farm description',
                        hintStyle: TextStyle(
                          fontSize: 14, 
                          color: Colors.grey.shade600),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade600), 
                          borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), 
                          borderSide: BorderSide(color: Colors.grey.shade600)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  BlocBuilder<FarmerProfileCubit, FarmerProfileState>(
                    builder: (context, state) {
                      final isLoading = state is FarmerProfileLoading;
                      
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleSave,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
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

