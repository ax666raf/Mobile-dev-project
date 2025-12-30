import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/farmerSide/product.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/edit_product.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_state.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';

class ProductTile extends StatelessWidget {
  // require the image to be displayed
  final String imagePath;
  final Product product;
  final List<String> availableWeights;
  final Map<String, dynamic>? productData; // Full product data from backend
  const ProductTile({
    super.key,
    required this.product,
    required this.imagePath,
    this.availableWeights = const [],
    this.productData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image of the product
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageStorageHelper.getImageWidget(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // name of product
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),

                        // weights and category
                        Text(
                          availableWeights.isNotEmpty
                              ? '${availableWeights.join(', ')} . ${product.category}'
                              : '${product.quantity}Kg . ${product.category}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),

                        // price
                        Text(
                          '${product.price} DA/Kg',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // edit and delete buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Show edit product modal
                            final cubit = context.read<FarmerProductCubit>();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (sheetContext) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: BlocProvider.value(
                                  value: cubit,
                                  child: EditProductWidget(
                                    product: product,
                                    productData: productData,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () {
                            // Get cubit before showing dialog
                            final cubit = context.read<FarmerProductCubit>();
                            final productId = product.id;

                            if (productId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Product ID is missing'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Show a confirmation dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => BlocProvider.value(
                                value: cubit,
                                child:
                                    BlocConsumer<
                                      FarmerProductCubit,
                                      FarmerProductState
                                    >(
                                      listener: (context, state) {
                                        if (state is FarmerProductDeleted) {
                                          Navigator.pop(dialogContext);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Product deleted successfully',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else if (state
                                            is FarmerProductError) {
                                          Navigator.pop(dialogContext);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(state.message),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state is FarmerProductLoading;

                                        return AlertDialog(
                                          title: Text(
                                            'Delete Product',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this product?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () {
                                                      Navigator.pop(
                                                        dialogContext,
                                                      );
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[400],
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () {
                                                      cubit.deleteProduct(
                                                        productId,
                                                      );
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: isLoading
                                                  ? SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.white),
                                                      ),
                                                    )
                                                  : Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                          elevation: 24,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // status
                    Container(
                      margin: EdgeInsets.only(bottom: 4),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: product.status == 'available'
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        product.status,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
