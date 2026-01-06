import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/widgets/common/CustomFormField.dart';
import 'package:mahsoul_dz/core/utils/farmer_extensions/validators.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_state.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/widgets/common/multiple_image_picker.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _harvestDateController = TextEditingController();
  final _storageController = TextEditingController();
  String? selectedCategory;
  String? selectedAvailability;
  bool isOrganic = false;
  List<String> _productImages = []; // List of uploaded image paths

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _harvestDateController.dispose();
    _storageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.addProduct,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // product name
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.productName,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              CustomFormField(
                controller: _nameController,
                hintText: l10n.enterProductName,
                validator: ProductValidators().validateName,
              ),

              SizedBox(height: 15),

              // product category
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: l10n.selectProductCategory,
                  ),
                  items: [
                    DropdownMenuItem(value: 'Fruits', child: Text(l10n.fruits)),
                    DropdownMenuItem(
                      value: 'Vegetables',
                      child: Text(l10n.vegetables),
                    ),
                    DropdownMenuItem(value: 'Grains', child: Text(l10n.grains)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),

              // product weights (multiple options)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.availableWeights,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    hintText: l10n.enterWeightsExample,
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
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                child: Text(
                  l10n.weightsHint,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: 15),

              // product price
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.productPrice,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              CustomFormField(
                controller: _priceController,
                hintText: l10n.enterPriceExample,
                validator: ProductValidators().validatePrice,
              ),
              SizedBox(height: 15),

              // product location
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.productLocation,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              CustomFormField(
                controller: _locationController,
                hintText: l10n.enterProductLocation,
                validator: ProductValidators().validateLocation,
              ),
              SizedBox(height: 15),

              // product description
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.enterProductDescription,
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
              SizedBox(height: 15),

              // harvest date
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.harvestDate,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _harvestDateController,
                  decoration: InputDecoration(
                    hintText: l10n.harvestDateExample,
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
              SizedBox(height: 15),

              // storage instructions
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.storageInstructions,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _storageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.storageExample,
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
              SizedBox(height: 15),

              // Product Images (Multiple)
              MultipleImagePicker(
                onImagesChanged: (images) {
                  setState(() {
                    _productImages = images;
                  });
                },
                maxImages: 10,
              ),
              SizedBox(height: 15),

              // product availability
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(hintText: l10n.availability),
                  value: selectedAvailability,
                  items: [
                    DropdownMenuItem(
                      value: 'available',
                      child: Text(l10n.available),
                    ),
                    DropdownMenuItem(
                      value: 'out_of_stock',
                      child: Text(l10n.outOfStock),
                    ),
                    DropdownMenuItem(
                      value: 'unavailable',
                      child: Text(l10n.unavailable),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedAvailability = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),

              // Organic certification
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Organic Certification',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Switch(
                      value: isOrganic,
                      onChanged: (value) {
                        setState(() {
                          isOrganic = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // cancel and add product buttons
              BlocConsumer<FarmerProductCubit, FarmerProductState>(
                listener: (context, state) {
                  if (state is FarmerProductAdded) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is FarmerProductError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is FarmerProductLoading;
                  
                  return Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),

                      // Add Product button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () {
                            if (_formKey.currentState!.validate()) {
                              final authState = context.read<AuthCubit>().state;
                              if (authState is AuthAuthenticated && authState.userType == 'farmer') {
                                final cubit = context.read<FarmerProductCubit>();
                                
                                // Parse weights from controller (comma-separated, e.g., "500g, 1kg, 2kg" -> ["500g", "1kg", "2kg"])
                                final weightText = _weightController.text.trim();
                                List<String> weights = [];
                                if (weightText.isNotEmpty) {
                                  // Split by comma and clean up each weight
                                  weights = weightText
                                      .split(',')
                                      .map((w) => w.trim())
                                      .where((w) => w.isNotEmpty)
                                      .toList();
                                }
                                // Default to 1kg if no weights provided
                                if (weights.isEmpty) {
                                  weights = ['1kg'];
                                }
                                
                                // Parse price
                                final priceText = _priceController.text.trim().replaceAll('DA', '').trim();
                                final price = double.tryParse(priceText) ?? 0.0;
                                
                                cubit.addProduct(
                                  name: _nameController.text.trim(),
                                  description: _descriptionController.text.trim().isEmpty 
                                      ? 'No description' 
                                      : _descriptionController.text.trim(),
                                  category: selectedCategory ?? 'Vegetables',
                                  price: price,
                                  origin: _locationController.text.trim().isEmpty 
                                      ? null 
                                      : _locationController.text.trim(),
                                  harvestSeason: _harvestDateController.text.trim().isEmpty 
                                      ? null 
                                      : _harvestDateController.text.trim(),
                                  storageInstructions: _storageController.text.trim().isEmpty 
                                      ? null 
                                      : _storageController.text.trim(),
                                  isOrganic: isOrganic,
                                  imagePaths: _productImages.isNotEmpty ? _productImages : null,
                                  status: selectedAvailability ?? 'available',
                                  weights: weights,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF45A049),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                              : Text(
                                  l10n.addProduct,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
    );
  }
}
