import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _postalCodeController = TextEditingController();
  String _selectedCity = '';

  @override
  void dispose() {
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? customerId;
        if (authState is AuthAuthenticated && authState.userType == 'customer') {
          customerId = authState.userId;
        }

        if (customerId == null) {
          return Scaffold(
            body: Center(child: Text(l10n.pleaseLoginToViewProfile)),
          );
        }

        return BlocProvider(
          create: (context) => CustomerProfileCubit(
            DependencyInjection.profileRepository,
            customerId!,
          ),
          child: Scaffold(
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

                // Note: Full Name and Phone Number are already collected during signup
                // Only collecting additional profile information here (City and Postal Code)

               Row(
  children: [
    Expanded(
      flex: 1, 
      child: DropdownButtonFormField<String>(
        value: _selectedCity.isEmpty ? null : _selectedCity,
        items: _buildWilayaItems(l10n),
        onChanged: (value) => setState(() => _selectedCity = value ?? ''),
        decoration: _inputDecoration(label: l10n.city),
        validator: (v) => v == null || v.isEmpty ? l10n.selectCity : null,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      flex: 2,
      child: TextFormField(
        controller: _postalCodeController,
        keyboardType: TextInputType.number,
        decoration: _inputDecoration(label: l10n.postalCodeOptional),
      ),
    ),
  ],
),

                const SizedBox(height: 32),

                BlocConsumer<CustomerProfileCubit, CustomerProfileState>(
                  listener: (context, state) {
                    if (state is CustomerProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is CustomerProfileLoading;
                    
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: MyButton(
                        text: isLoading ? l10n.loading : l10n.saveContinue,
                        onPressed: isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            final cubit = context.read<CustomerProfileCubit>();
                            try {
                              // Update profile - this will reload profile on success
                              await cubit.updateProfile({
                                'city': _selectedCity,
                                'postal_code': _postalCodeController.text.trim(),
                              });
                              // Wait a bit for state to update, then navigate
                              await Future.delayed(const Duration(milliseconds: 300));
                              // Navigate after successful update
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainNavigation(),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Error will be shown via BlocConsumer listener
                              print('Error updating profile: $e');
                            }
                          }
                        },
                      ),
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
      },
    );
  }

  List<DropdownMenuItem<String>> _buildWilayaItems(AppLocalizations l10n) {
    // Map of wilaya values to their localization keys
    final wilayaMap = {
      'Algiers': l10n.algiers,
      'Oran': l10n.oran,
      'Constantine': l10n.constantine,
      'Blida': l10n.blida,
      'Annaba': l10n.annaba,
      'Batna': l10n.batna,
      'Béjaïa': l10n.bejaia,
      'Biskra': l10n.biskra,
      'Boumerdès': l10n.boumerdes,
      'Chlef': l10n.chlef,
      'Djelfa': l10n.djelfa,
      'Guelma': l10n.guelma,
      'Jijel': l10n.jijel,
      'Khenchela': l10n.khenchela,
      'Laghouat': l10n.laghouat,
      'Mascara': l10n.mascara,
      'Médéa': l10n.medea,
      'Mostaganem': l10n.mostaganem,
      'M\'Sila': l10n.msila,
      'Mila': l10n.mila,
      'Ouargla': l10n.ouargla,
      'Oued': l10n.oued,
      'Relizane': l10n.relizane,
      'Saïda': l10n.saida,
      'Sétif': l10n.setif,
      'Sidi Bel Abbès': l10n.sidiBelAbbes,
      'Skikda': l10n.skikda,
      'Souk Ahras': l10n.soukAhras,
      'Tamanrasset': l10n.tamanrasset,
      'Tébessa': l10n.tebessa,
      'Tiaret': l10n.tiaret,
      'Tindouf': l10n.tindouf,
      'Tipaza': l10n.tipaza,
      'Tissemsilt': l10n.tissemsilt,
      'Tizi Ouzou': l10n.tiziOuzou,
      'Tlemcen': l10n.tlemcen,
      'Adrar': l10n.adrar,
      'Aïn Defla': l10n.ainDefla,
      'Aïn Témouchent': l10n.ainTemouchent,
      'Bordj Bou Arréridj': l10n.bordjBouArreridj,
      'Bouira': l10n.bouira,
      'El Bayadh': l10n.elBayadh,
      'El Oued': l10n.elOued,
      'El Tarf': l10n.elTarf,
      'Ghardaïa': l10n.ghardaia,
      'Illizi': l10n.illizi,
      'Naâma': l10n.naama,
    };
    
    return wilayaMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList()..sort((a, b) => a.value!.compareTo(b.value!));
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

}
