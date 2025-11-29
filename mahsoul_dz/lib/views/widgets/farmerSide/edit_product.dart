import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/models/farmerSide/product.dart';

class EditProductWidget extends StatefulWidget {
  final Product product;
  
  const EditProductWidget({
    super.key,
    required this.product,
  });

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  late TextEditingController nameController;
  late TextEditingController weightController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  
  String selectedCategory = 'Vegetables';
  String selectedAvailability = 'Available';
  bool isOrganic = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    weightController = TextEditingController(text: '${widget.product.quantity.toInt()} kg');
    priceController = TextEditingController(text: '${widget.product.price.toInt()} DA');
    locationController = TextEditingController(text: 'Blida , Algeria');
    selectedCategory = widget.product.category;
    selectedAvailability = widget.product.status == 'available' ? 'Available' : 'Out of Stock';
  }

  @override
  void dispose() {
    nameController.dispose();
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

            // Weight
            _buildLabel('Weight'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: weightController,
              hintText: '10 kg',
              backgroundColor: Colors.grey.shade200,
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
              items: ['Available', 'Out of Stock'],
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: () {
                      // Handle save changes
                      // TODO: Implement save logic
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
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
  }) {
    return TextField(
      controller: controller,
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
