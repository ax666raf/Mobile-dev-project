import 'package:equatable/equatable.dart';

abstract class FarmerOrderState extends Equatable {
  const FarmerOrderState();

  @override
  List<Object?> get props => [];
}

class FarmerOrderInitial extends FarmerOrderState {}

class FarmerOrderLoading extends FarmerOrderState {}

class FarmerOrderLoaded extends FarmerOrderState {
  final List<Map<String, dynamic>> orders;

  const FarmerOrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class FarmerOrderStatusUpdated extends FarmerOrderState {
  final Map<String, dynamic> order;

  const FarmerOrderStatusUpdated(this.order);

  @override
  List<Object?> get props => [order];
}

class FarmerOrderError extends FarmerOrderState {
  final String message;

  const FarmerOrderError(this.message);

  @override
  List<Object?> get props => [message];
}



