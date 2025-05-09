import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/calculate_fees_usecase.dart';

abstract class FeesState {}

class FeesInitial extends FeesState {}

class FeesLoading extends FeesState {}

class FeesSuccess extends FeesState {
  final double fees;
  FeesSuccess(this.fees);
}

class FeesError extends FeesState {
  final String message;
  FeesError(this.message);
}

class FeesBloc extends Cubit<FeesState> {
  final CalculateFeesUseCase calculateFees;

  FeesBloc(this.calculateFees) : super(FeesInitial());

  void getFees(double amount) async {
    emit(FeesLoading());
    try {
      final fees = await calculateFees.execute(amount);
      emit(FeesSuccess(fees));
    } catch (e) {
      emit(FeesError("Erreur lors du calcul des frais."));
    }
  }
}
