import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/make_transfer_usecase.dart';

abstract class TransferState {}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferSuccess extends TransferState {}

class TransferError extends TransferState {
  final String message;
  TransferError(this.message);
}

class TransferBloc extends Cubit<TransferState> {
  final MakeTransferUseCase makeTransfer;

  TransferBloc(this.makeTransfer) : super(TransferInitial());

  void transfer(String senderId, String recipientId, double amount) async {
    emit(TransferLoading()); // 🔄 Affiche le loader
    try {
      await makeTransfer.execute(senderId, recipientId, amount);
      emit(TransferSuccess()); // ✅ Succès
    } catch (e) {
      emit(TransferError(e.toString())); // ❌ Erreur avec message
    }
  }
}
