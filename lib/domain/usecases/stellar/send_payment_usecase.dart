import '../../repositories/stellar_repository.dart';

class SendStellarPaymentUseCase {
  final StellarRepository repository;

  SendStellarPaymentUseCase(this.repository);

  Future<String> execute({
    required String sourceSecretKey,
    required String destinationPublicKey,
    required double amount,
    String? memo,
  }) async {
    return repository.sendPayment(
      sourceSecretKey: sourceSecretKey,
      destinationPublicKey: destinationPublicKey,
      amount: amount,
      memo: memo,
    );
  }
}
