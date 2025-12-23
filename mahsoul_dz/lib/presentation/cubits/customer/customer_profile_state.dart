import 'package:equatable/equatable.dart';

abstract class CustomerProfileState extends Equatable {
  const CustomerProfileState();

  @override
  List<Object?> get props => [];
}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileLoaded extends CustomerProfileState {
  final Map<String, dynamic> profile;

  const CustomerProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class CustomerProfileError extends CustomerProfileState {
  final String message;

  const CustomerProfileError(this.message);

  @override
  List<Object?> get props => [message];
}



