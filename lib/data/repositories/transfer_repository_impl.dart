import '../../domain/entities/transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/remote/transfer_api_service.dart';

class TransferRepositoryImpl implements TransferRepository {
  final TransferApiService apiService;

  TransferRepositoryImpl(this.apiService);

  @override
  Future<void> makeTransfer(Transfer transfer) async {
    await apiService.makeTransfer(transfer.toJson());
  }
}
