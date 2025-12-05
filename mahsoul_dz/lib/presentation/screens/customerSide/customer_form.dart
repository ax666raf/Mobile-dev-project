import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';

class CustomerFormScreen extends StatelessWidget {
  const CustomerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomerFormView();
  }
}

class CustomerFormView extends StatefulWidget {
  const CustomerFormView({super.key});

  @override
  State<CustomerFormView> createState() => _CustomerFormViewState();
}

class _CustomerFormViewState extends State<CustomerFormView> {
  // TODO: Replace with Cubit
  final _formKey = GlobalKey<FormState>();
  String _selectedCity = '';
  String _postalCode = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
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

                Text(
                  l10n.completeYourProfile,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tellUsMore,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),

                _buildTextField(
                  icon: Icons.person_outline,
                  label: l10n.fullName,
                  hint: l10n.enterFullName,
                  onChanged: (v) {},
                  validator: (v) =>
                      v!.isEmpty ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  icon: Icons.phone_outlined,
                  label: l10n.phoneNumber,
                  hint: l10n.enterPhoneNumber,
                  keyboard: TextInputType.phone,
                  onChanged: (v) {},
                  validator: (v) =>
                      v!.isEmpty ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  icon: Icons.location_on_outlined,
                  label: l10n.deliveryAddress,
                  hint: l10n.enterAddress,
                  onChanged: (v) {},
                  validator: (v) =>
                      v!.isEmpty ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),

               Row(
  children: [
    Expanded(
      flex: 1, 
      child: DropdownButtonFormField<String>(
        value: _selectedCity.isEmpty ? null : _selectedCity,
        items: [
          DropdownMenuItem(value: 'Algiers', child: Text(l10n.algiers)),
          DropdownMenuItem(value: 'Oran', child: Text(l10n.oran)),
          DropdownMenuItem(value: 'Constantine', child: Text(l10n.constantine)),
        ],
        onChanged: (value) => setState(() => _selectedCity = value ?? ''),
        decoration: _inputDecoration(label: l10n.city),
        validator: (v) => v == null || v.isEmpty ? l10n.selectCity : null,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      flex: 2,
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (v) => setState(() => _postalCode = v),
        decoration: _inputDecoration(label: l10n.postalCodeOptional),
      ),
    ),
  ],
),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: MyButton(
                    text: l10n.saveContinue,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Submit with Cubit
                        Navigator.pop(context);
                      }
                    },
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
