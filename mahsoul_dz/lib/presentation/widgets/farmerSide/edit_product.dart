import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/farmerSide/product.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_state.dart';
import 'package:mahsoul_dz/presentation/widgets/common/multiple_image_picker.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

class EditProductWidget extends StatefulWidget {
  final Product product;
  final Map<String, dynamic>? productData; // Full product data from backend
  
  const EditProductWidget({
    super.key,
    required this.product,
    this.productData,
  });

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController weightController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  late TextEditingController harvestDateController;
  late TextEditingController storageController;
  
  String selectedCategory = 'Vegetables';
  String selectedAvailability = 'available';
  bool isOrganic = false;
  List<String> _productImages = []; // List of uploaded image paths

  @override
  void initState() {
    super.initState();
    // Load data from product and productData
    nameController = TextEditingController(text: widget.product.name);
    descriptionController = TextEditingController(
      text: widget.productData?['description'] as String? ?? ''
    );
    // Load weights from productData
    final weights = widget.productData?['weights'] as List<dynamic>? ?? [];
    final weightStrings = weights
        .map((w) => (w as Map<String, dynamic>?)?['weight_value'] as String? ?? '')
        .where((w) => w.isNotEmpty)
        .join(', ');
    weightController = TextEditingController(text: weightStrings.isNotEmpty ? weightStrings : '1kg');
    priceController = TextEditingController(text: '${widget.product.price.toInt()}');
    locationController = TextEditingController(
      text: widget.productData?['origin'] as String? ?? 'Blida , Algeria'
    );
    harvestDateController = TextEditingController(
      text: widget.productData?['harvest_season'] as String? ?? ''
    );
    storageController = TextEditingController(
      text: widget.productData?['storage_instructions'] as String? ?? ''
    );
    selectedCategory = widget.product.category;
    // Map backend status to frontend dropdown value
    final status = widget.product.status;
    if (status == 'available') {
      selectedAvailability = 'available';
    } else if (status == 'out_of_stock') {
      selectedAvailability = 'out_of_stock';
    } else {
      selectedAvailability = 'unavailable';
    }
    // Load is_organic from backend data
    isOrganic = widget.productData?['is_organic'] as bool? ?? false;
    // Load product images from backend
    final images = widget.productData?['images'] as List<dynamic>? ?? [];
    _productImages = images
        .map((img) => (img as Map<String, dynamic>?)?['image_path'] as String? ?? '')
        .where((path) => path.isNotEmpty)
        .toList();
    // If no images array, fall back to single image_path
    if (_productImages.isEmpty && widget.productData?['image_path'] != null) {
      _productImages = [widget.productData!['image_path'] as String];
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    priceController.dispose();
    locationController.dispose();
    harvestDateController.dispose();
    storageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.editProduct,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Product Name
            _buildLabel(l10n.productName),
            const SizedBox(height: 8),
            _buildTextField(
              controller: nameController,
              hintText: l10n.enterProductName,
            ),
            const SizedBox(height: 20),

            // Category
            _buildLabel(l10n.category),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedCategory,
              items: ['Vegetables', 'Fruits', 'Grains'], // Keep English for backend
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              backgroundColor: const Color(0xFFD1F4E0),
            ),
            const SizedBox(height: 20),

            // Description
            _buildLabel(l10n.description),
            const SizedBox(height: 8),
            _buildTextField(
              controller: descriptionController,
              hintText: l10n.enterProductDescription,
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Weights (multiple options)
            _buildLabel(l10n.availableWeights),
            const SizedBox(height: 8),
            _buildTextField(
              controller: weightController,
              hintText: l10n.enterWeightsExample,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.weightsHint,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),

            // Price
            _buildLabel(l10n.productPrice),
            const SizedBox(height: 8),
            _buildTextField(
              controller: priceController,
              hintText: l10n.enterPriceExample,
            ),
            const SizedBox(height: 20),

            // Location
            _buildLabel(l10n.productLocation),
            const SizedBox(height: 8),
            _buildTextField(
              controller: locationController,
              hintText: l10n.enterProductLocation,
            ),
            const SizedBox(height: 20),

            // Harvest Date
            _buildLabel(l10n.harvestDate),
            const SizedBox(height: 8),
            _buildTextField(
              controller: harvestDateController,
              hintText: l10n.harvestDateExample,
            ),
            const SizedBox(height: 20),

            // Storage Instructions
            _buildLabel(l10n.storageInstructions),
            const SizedBox(height: 8),
            _buildTextField(
              controller: storageController,
              hintText: l10n.storageExample,
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Organic Certification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.organicCertification,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: isOrganic,
                  onChanged: (value) {
                    setState(() {
                      isOrganic = value;
                    });
                  },
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Availability
            _buildLabel(l10n.availability),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedAvailability,
              items: ['available', 'out_of_stock', 'unavailable'],
              onChanged: (value) {
                setState(() {
                  selectedAvailability = value!;
                });
              },
              backgroundColor: const Color(0xFFBAE6FD),
              icon: Icons.check_circle,
            ),
            const SizedBox(height: 20),

            // Product Images (Multiple)
            MultipleImagePicker(
              initialImages: _productImages,
              onImagesChanged: (images) {
                setState(() {
                  _productImages = images;
                });
              },
              maxImages: 10,
            ),
            const SizedBox(height: 20),

            // Buttons
            BlocConsumer<FarmerProductCubit, FarmerProductState>(
              listener: (context, state) {
                if (state is FarmerProductUpdated) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product updated successfully'),
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
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : () => Navigator.pop(context),
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
                        onPressed: isLoading ? null : () {
                          final cubit = context.read<FarmerProductCubit>();
                          
                          // Parse price
                          final priceText = priceController.text.trim().replaceAll('DA', '').trim();
                          final price = double.tryParse(priceText) ?? widget.product.price;
                          
                          // Parse weights from controller (comma-separated, e.g., "500g, 1kg, 2kg" -> ["500g", "1kg", "2kg"])
                          final weightText = weightController.text.trim();
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
                          
                          cubit.updateProduct(
                            widget.product.id,
                            {
                              'name': nameController.text.trim(),
                              'description': descriptionController.text.trim().isEmpty 
                                  ? null 
                                  : descriptionController.text.trim(),
                              'category': selectedCategory,
                              'price': price,
                              'origin': locationController.text.trim().isEmpty 
                                  ? null 
                                  : locationController.text.trim(),
                              'harvest_season': harvestDateController.text.trim().isEmpty 
                                  ? null 
                                  : harvestDateController.text.trim(),
                              'storage_instructions': storageController.text.trim().isEmpty 
                                  ? null 
                                  : storageController.text.trim(),
                              'is_organic': isOrganic,
                              'image_paths': _productImages.isNotEmpty ? _productImages : null,
                              'status': selectedAvailability,
                              'weights': weights, // Include weights in update
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
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
                                'Save Changes',
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    Color? backgroundColor,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: backgroundColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required Color backgroundColor,
    IconData? icon,
  }) {
    final l10n = AppLocalizations.of(context)!;
    // Map English category values to translated labels
    String getCategoryLabel(String category) {
      switch (category) {
        case 'Vegetables':
          return l10n.vegetables;
        case 'Fruits':
          return l10n.fruits;
        case 'Grains':
          return l10n.grains;
        case 'available':
          return l10n.available;
        case 'out_of_stock':
          return l10n.outOfStock;
        case 'unavailable':
          return l10n.unavailable;
        default:
          return category;
      }
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(getCategoryLabel(item)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
