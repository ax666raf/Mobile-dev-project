import 'package:equatable/equatable.dart';

abstract class DeliveryAddressState extends Equatable {
  const DeliveryAddressState();

  @override
  List<Object?> get props => [];
}

class DeliveryAddressInitial extends DeliveryAddressState {}

class DeliveryAddressLoading extends DeliveryAddressState {}

class DeliveryAddressLoaded extends DeliveryAddressState {
  final List<Map<String, dynamic>> addresses;

  const DeliveryAddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class DeliveryAddressError extends DeliveryAddressState {
  final String message;

  const DeliveryAddressError(this.message);

  @override
  List<Object?> get props => [message];
}



