import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/views/widgets/common/CustomFormField.dart';
import 'package:mahsoul_dz/utils/FarmerExtensions/validators.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  String? selectedCategory;

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

              // product weight
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  l10n.productWeight,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 5),
              CustomFormField(
                controller: _weightController,
                hintText: l10n.enterProductWeight,
                validator: ProductValidators().validateWeight,
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
                hintText: l10n.enterProductWeight,
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

              // product availability
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(hintText: l10n.availability),
                  items: [
                    DropdownMenuItem(
                      value: 'Available',
                      child: Text(l10n.available),
                    ),
                    DropdownMenuItem(
                      value: 'Out of stock',
                      child: Text(l10n.outOfStock),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 30),

              // cancel and add product buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF45A049),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
