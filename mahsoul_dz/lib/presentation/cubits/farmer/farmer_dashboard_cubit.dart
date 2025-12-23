import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/farmer_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'farmer_dashboard_state.dart';

class FarmerDashboardCubit extends Cubit<FarmerDashboardState> {
  final FarmerRepository _farmerRepository;
  final String farmerId;

  FarmerDashboardCubit(this._farmerRepository, this.farmerId) : super(FarmerDashboardInitial());

  // Load dashboard data
  Future<void> loadDashboardData() async {
    emit(FarmerDashboardLoading());

    try {
      final response = await _farmerRepository.getDashboard(farmerId);
      emit(FarmerDashboardLoaded(response));
    } on ApiException catch (e) {
      emit(FarmerDashboardError(e.message));
    } catch (e) {
      emit(FarmerDashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }
}



