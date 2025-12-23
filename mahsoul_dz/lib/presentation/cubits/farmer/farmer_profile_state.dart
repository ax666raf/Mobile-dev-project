import 'package:equatable/equatable.dart';

abstract class FarmerProfileState extends Equatable {
  const FarmerProfileState();

  @override
  List<Object?> get props => [];
}

class FarmerProfileInitial extends FarmerProfileState {}

class FarmerProfileLoading extends FarmerProfileState {}

class FarmerProfileLoaded extends FarmerProfileState {
  final Map<String, dynamic> profile;

  const FarmerProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class FarmerProfileError extends FarmerProfileState {
  final String message;

  const FarmerProfileError(this.message);

  @override
  List<Object?> get props => [message];
}



