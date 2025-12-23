import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/delivery_address_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/delivery_address_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

/// Delivery Address Dialog - Modal for managing delivery addresses
class DeliveryAddressDialog extends StatefulWidget {
  const DeliveryAddressDialog({super.key});

  static void show(BuildContext context) {
    // Get customerId from AuthCubit
    final authState = context.read<AuthCubit>().state;
    String? customerId;
    if (authState is AuthAuthenticated && authState.userType == 'customer') {
      customerId = authState.userId;
    }
    
    if (customerId == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseLoginToManageAddresses),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => DeliveryAddressCubit(
            DependencyInjection.deliveryAddressRepository,
            customerId!,
          )..loadAddresses(),
          child: const DeliveryAddressDialog(),
        );
      },
    );
  }

  @override
  State<DeliveryAddressDialog> createState() => _DeliveryAddressDialogState();
}

class _DeliveryAddressDialogState extends State<DeliveryAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  bool _isAddingNew = false;
  String? _lastAction; // Track last action: 'add', 'setDefault', 'delete'

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() => _lastAction = 'add');
      final cubit = context.read<DeliveryAddressCubit>();
      cubit.addAddress(
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim().isEmpty 
            ? null 
            : _postalCodeController.text.trim(),
      );
      _clearForm();
    }
  }

  void _clearForm() {
    _addressController.clear();
    _cityController.clear();
    _postalCodeController.clear();
    setState(() => _isAddingNew = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<DeliveryAddressCubit, DeliveryAddressState>(
      listener: (context, state) {
        if (state is DeliveryAddressLoaded) {
          // Show success message based on last action
          if (_lastAction == 'add' && _isAddingNew) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.addressSavedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
            _clearForm();
            _lastAction = null;
          } else if (_lastAction == 'setDefault') {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.defaultAddressUpdated),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            _lastAction = null;
          } else if (_lastAction == 'delete') {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.addressDeletedSuccessfully),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            _lastAction = null;
          }
        } else if (state is DeliveryAddressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          _lastAction = null;
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.deliveryAddress,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Existing Addresses List
              Expanded(
                child: BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
                  builder: (context, state) {
                    if (state is DeliveryAddressLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is DeliveryAddressError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is DeliveryAddressLoaded) {
                      final addresses = state.addresses;
                      
                      if (addresses.isEmpty && !_isAddingNew) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noAddressesSaved,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: addresses.length + (_isAddingNew ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isAddingNew && index == addresses.length) {
                            return _buildAddAddressForm(l10n);
                          }
                          
                          final address = addresses[index];
                          return _buildAddressCard(address, l10n);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Add New Address Button
              if (!_isAddingNew)
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isAddingNew = true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.addNewAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, AppLocalizations l10n) {
    final addressCubit = context.read<DeliveryAddressCubit>();
    final isDefault = address['is_default'] == true;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: isDefault ? primaryColor : Colors.grey,
        ),
        title: Text(
          address['address'] as String? ?? '',
          style: TextStyle(
            fontWeight: isDefault ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${address['city'] ?? ''}${address['postal_code'] != null ? ', ${address['postal_code']}' : ''}'),
            if (isDefault)
              Text(
                l10n.defaultAddress,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'setDefault') {
              setState(() => _lastAction = 'setDefault');
              print('🔵 Setting address as default: ${address['id']}');
              await addressCubit.setDefaultAddress(address['id'] as String);
            } else if (value == 'delete') {
              // Show confirmation dialog before deleting
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.deleteAddress),
                  content: Text(l10n.areYouSureDeleteAddress),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text(l10n.delete),
                    ),
                  ],
                ),
              );
              
              if (shouldDelete == true) {
                setState(() => _lastAction = 'delete');
                print('🔵 Deleting address: ${address['id']}');
                addressCubit.deleteAddress(address['id'] as String);
              }
            }
          },
          itemBuilder: (context) => [
            if (!isDefault)
              PopupMenuItem<String>(
                value: 'setDefault',
                child: Row(
                  children: [
                    const Icon(Icons.star_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.setAsDefault),
                  ],
                ),
              ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressForm(AppLocalizations l10n) {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.addNewAddress,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: l10n.address,
                  hintText: l10n.enterStreetAddress,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.addressIsRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: l10n.city,
                  hintText: l10n.enterCity,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.cityIsRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(
                  labelText: l10n.postalCodeOptional,
                  hintText: l10n.enterPostalCode,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearForm,
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
