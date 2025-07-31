import '../../repositories/stellar_repository.dart';

class GetXLMToUSDCRateUseCase {
  final StellarRepository _repository;

  GetXLMToUSDCRateUseCase(this._repository);

  Future<double> execute(double xlmAmount) async {
    return await _repository.getXLMToUSDCRate(xlmAmount);
  }
}
