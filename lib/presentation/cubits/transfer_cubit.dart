import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';

class TransferData {
  final double amount;
  final double fees;
  final User? recipient;

  TransferData({required this.amount, required this.fees, this.recipient});

  TransferData copyWith({double? amount, double? fees, User? recipient}) {
    return TransferData(
      amount: amount ?? this.amount,
      fees: fees ?? this.fees,
      recipient: recipient ?? this.recipient,
    );
  }
}

class TransferCubit extends Cubit<TransferData> {
  TransferCubit() : super(TransferData(amount: 0, fees: 0));

  void setAmount(double amount, double fees) {
    emit(state.copyWith(amount: amount, fees: fees));
  }

  void setRecipient(User recipient) {
    emit(state.copyWith(recipient: recipient));
  }

  void reset() {
    emit(TransferData(amount: 0, fees: 0, recipient: null));
  }
}
