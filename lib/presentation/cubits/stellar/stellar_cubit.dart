import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/stellar_account.dart';
import '../../../domain/entities/transaction_history.dart';
import '../../../domain/repositories/stellar_repository.dart';
import '../../../domain/usecases/stellar/create_account_usecase.dart';
import '../../../domain/usecases/stellar/add_trustline_usecase.dart';
import '../../../domain/usecases/stellar/get_transaction_history_usecase.dart';
import '../../../domain/usecases/stellar/swap_xlm_to_usdc_usecase.dart';
import '../../../domain/usecases/stellar/send_payment_usecase.dart';

// State
class StellarState {
  final StellarAccount? account;
  final bool isLoading;
  final String? error;
  final bool hasTrustline;
  final double? usdcBalance;
  final List<TransactionHistory>? transactions;
  final String? lastTransactionHash;

  StellarState({
    this.account,
    this.isLoading = false,
    this.error,
    this.hasTrustline = false,
    this.usdcBalance,
    this.transactions,
    this.lastTransactionHash,
  });

  StellarState copyWith({
    StellarAccount? account,
    bool? isLoading,
    String? error,
    bool? hasTrustline,
    double? usdcBalance,
    List<TransactionHistory>? transactions,
    String? lastTransactionHash,
  }) {
    return StellarState(
      account: account ?? this.account,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasTrustline: hasTrustline ?? this.hasTrustline,
      usdcBalance: usdcBalance ?? this.usdcBalance,
      transactions: transactions ?? this.transactions,
      lastTransactionHash: lastTransactionHash ?? this.lastTransactionHash,
    );
  }
}

class StellarCubit extends Cubit<StellarState> {
  final CreateStellarAccountUseCase createAccount;
  final AddUSDCTrustlineUseCase addTrustline;
  final SwapXLMToUSDCUseCase swapToUSDC;
  final GetTransactionHistoryUseCase getTransactionHistory;
  final SendStellarPaymentUseCase sendPayment;
  final StellarRepository repository;

  StellarCubit(this.createAccount, this.addTrustline, this.swapToUSDC,
      this.getTransactionHistory, this.repository, this.sendPayment)
      : super(StellarState());

  Future<void> createStellarAccount() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final account = await createAccount.execute();
      emit(state.copyWith(
        account: account,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> addUSDCTrustline() async {
    if (state.account == null || state.account!.secretKey == null) return;

    emit(state.copyWith(isLoading: true, error: null));
    try {
      await addTrustline.execute(state.account!.secretKey!);
      emit(state.copyWith(
        isLoading: false,
        hasTrustline: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> swapXLMToUSDC(double xlmAmount) async {
    if (state.account == null || state.account!.secretKey == null) return;

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final newUsdcBalance = await swapToUSDC.execute(
        secretKey: state.account!.secretKey!,
        xlmAmount: xlmAmount,
      );
      emit(state.copyWith(
        isLoading: false,
        usdcBalance: newUsdcBalance,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadAccountDetails() async {
    if (state.account == null) return;

    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Get transactions
      final transactions = await getTransactionHistory.execute(
        state.account!.publicKey,
      );

      // Get balances
      final balances = await repository.getAssetBalances(
        state.account!.publicKey,
      );

      emit(state.copyWith(
        isLoading: false,
        transactions: transactions,
        usdcBalance: balances['USDC'],
        hasTrustline: balances.containsKey('USDC'),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Refresh transaction history only
  Future<void> refreshTransactions() async {
    if (state.account == null) return;

    try {
      final transactions = await getTransactionHistory.execute(
        state.account!.publicKey,
      );
      emit(state.copyWith(transactions: transactions));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> sendStellarPayment({
    required String destinationPublicKey,
    required double amount,
    String? memo,
  }) async {
    if (state.account == null || state.account!.secretKey == null) {
      emit(state.copyWith(error: 'No account available'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final hash = await sendPayment.execute(
        sourceSecretKey: state.account!.secretKey!,
        destinationPublicKey: destinationPublicKey,
        amount: amount,
        memo: memo,
      );

      // Refresh account details after payment
      await loadAccountDetails();

      emit(state.copyWith(
        isLoading: false,
        lastTransactionHash: hash,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
