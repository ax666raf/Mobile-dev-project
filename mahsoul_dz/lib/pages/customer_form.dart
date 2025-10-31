import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahsoul_dz/controllers/customer_form.dart';
import 'package:mahsoul_dz/widgets/button.dart';

class CustomerFormScreen extends StatelessWidget {
  const CustomerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerFormController(),
      child: const CustomerFormView(),
    );
  }
}

class CustomerFormView extends StatelessWidget {
  const CustomerFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CustomerFormController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'lib/assets/logoo.png',
                    width: 120,
                    height: 30,
                    errorBuilder: (_, __, ___) => const Text(
                      '🌱',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Complete Your Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell us a bit more so we can personalize your Mahsoul experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),

                _buildTextField(
                  icon: Icons.person_outline,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  onChanged: controller.setFullName,
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  keyboard: TextInputType.phone,
                  onChanged: controller.setPhoneNumber,
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  icon: Icons.location_on_outlined,
                  label: 'Delivery Address',
                  hint: 'Enter your address',
                  onChanged: controller.setAddress,
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter your address' : null,
                ),
                const SizedBox(height: 16),

               Row(
  children: [
    Expanded(
      flex: 1, 
      child: DropdownButtonFormField<String>(
        value: controller.city,
        items: const [
          DropdownMenuItem(value: 'Algiers', child: Text('Algiers')),
          DropdownMenuItem(value: 'Oran', child: Text('Oran')),
          DropdownMenuItem(value: 'Constantine', child: Text('Constantine')),
        ],
        onChanged: (value) => controller.setCity(value ?? ''),
        decoration: _inputDecoration(label: 'City'),
        validator: (v) => v == null || v.isEmpty ? 'Select a city' : null,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      flex: 2,
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: controller.setPostalCode,
        decoration: _inputDecoration(label: 'Postal Code (Optional)'),
      ),
    ),
  ],
),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: MyButton(
                    text: "Save & Continue",
                    onPressed: () => controller.submitForm(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4CAF50)),
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required String hint,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            )),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboard,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50)),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
