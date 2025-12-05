import 'package:equatable/equatable.dart';

abstract class FarmerDashboardState extends Equatable {
  const FarmerDashboardState();

  @override
  List<Object?> get props => [];
}

class FarmerDashboardInitial extends FarmerDashboardState {}

class FarmerDashboardLoading extends FarmerDashboardState {}

class FarmerDashboardLoaded extends FarmerDashboardState {
  final Map<String, dynamic> data;

  const FarmerDashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class FarmerDashboardError extends FarmerDashboardState {
  final String message;

  const FarmerDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}



