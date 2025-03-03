import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_recipients_usecase.dart';

abstract class RecipientsState {}

class RecipientsInitial extends RecipientsState {}

class RecipientsLoading extends RecipientsState {}

class RecipientsSuccess extends RecipientsState {
  final List<User> recipients;
  RecipientsSuccess(this.recipients);
}

class RecipientsError extends RecipientsState {
  final String message;
  RecipientsError(this.message);
}

class RecipientsBloc extends Cubit<RecipientsState> {
  final GetRecipientsUseCase getRecipients;
  List<User> _allRecipients = [];

  RecipientsBloc(this.getRecipients) : super(RecipientsInitial());

  void searchRecipients(String query) {
    if (query.isEmpty) {
      emit(RecipientsSuccess(_allRecipients));
    } else {
      List<User> filteredList = _allRecipients
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(RecipientsSuccess(filteredList));
    }
  }

  void fetchRecipients() async {
    emit(RecipientsLoading());
    try {
      _allRecipients = await getRecipients.execute();
      emit(RecipientsSuccess(_allRecipients));
    } catch (e) {
      emit(RecipientsError("Impossible de récupérer les destinataires."));
    }
  }
}
