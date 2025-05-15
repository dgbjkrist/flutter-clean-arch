import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fetch_user_balance.dart';

class BalanceCubit extends Cubit<double> {
  final FetchUserBalance fetchUserBalance;
  final String userId;

  BalanceCubit(this.fetchUserBalance, this.userId) : super(0);

  void loadBalance() async {
    final user = await fetchUserBalance.execute(userId);
    emit(user.balance);
  }

  void updateBalance(double newBalance) {
    emit(newBalance);
  }
}
