import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/farmerSide/product.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_state.dart';

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
  
  String selectedCategory = 'Vegetables';
  String selectedAvailability = 'available';
  bool isOrganic = false;

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
    selectedCategory = widget.product.category;
    selectedAvailability = widget.product.status == 'available' ? 'available' : 'out of stock';
    // Load is_organic from backend data
    isOrganic = widget.productData?['is_organic'] as bool? ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Edit Product',
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
            _buildLabel('Product Name'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: nameController,
              hintText: 'Organic Tomatoes',
            ),
            const SizedBox(height: 20),

            // Category
            _buildLabel('Category'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedCategory,
              items: ['Vegetables', 'Fruits', 'Grains'],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              backgroundColor: const Color(0xFFD1F4E0),
            ),
            const SizedBox(height: 20),

            // Description
            _buildLabel('Description'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: descriptionController,
              hintText: 'Product description',
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Weights (multiple options)
            _buildLabel('Available Weights (comma-separated)'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: weightController,
              hintText: 'e.g., 500g, 1kg, 2kg',
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 4),
            Text(
              'Enter multiple weight options separated by commas',
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),

            // Price
            _buildLabel('Price (DA/kg)'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: priceController,
              hintText: '1200 DA',
            ),
            const SizedBox(height: 20),

            // Location
            _buildLabel('Location'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: locationController,
              hintText: 'Blida , Algeria',
            ),
            const SizedBox(height: 20),

            // Organic Certification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Organic Certification',
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
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Availability
            _buildLabel('Availability'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedAvailability,
              items: ['available', 'out of stock'],
              onChanged: (value) {
                setState(() {
                  selectedAvailability = value!;
                });
              },
              backgroundColor: const Color(0xFFBAE6FD),
              icon: Icons.check_circle,
            ),
            const SizedBox(height: 20),

            // Product Image
            _buildLabel('Product Image'),
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('lib/assets/IMAGE.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),

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
                            widget.product.id!,
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
                              'is_organic': isOrganic,
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
                    child: Text(item),
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
