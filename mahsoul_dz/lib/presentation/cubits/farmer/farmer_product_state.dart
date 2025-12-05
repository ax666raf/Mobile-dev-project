import 'package:equatable/equatable.dart';

abstract class FarmerProductState extends Equatable {
  const FarmerProductState();

  @override
  List<Object?> get props => [];
}

class FarmerProductInitial extends FarmerProductState {}

class FarmerProductLoading extends FarmerProductState {}

class FarmerProductLoaded extends FarmerProductState {
  final List<Map<String, dynamic>> products;

  const FarmerProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class FarmerProductAdded extends FarmerProductState {
  final Map<String, dynamic> product;

  const FarmerProductAdded(this.product);

  @override
  List<Object?> get props => [product];
}

class FarmerProductUpdated extends FarmerProductState {
  final Map<String, dynamic> product;

  const FarmerProductUpdated(this.product);

  @override
  List<Object?> get props => [product];
}

class FarmerProductDeleted extends FarmerProductState {
  final String productId;

  const FarmerProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class FarmerProductError extends FarmerProductState {
  final String message;

  const FarmerProductError(this.message);

  @override
  List<Object?> get props => [message];
}



