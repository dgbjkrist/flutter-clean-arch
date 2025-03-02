import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/transfer/transfer_bloc.dart';

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is TransferSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Transfert réussi !")),
          );
          Navigator.pop(context);
        } else if (state is TransferError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Text("Montant : \$${amount.toStringAsFixed(2)}"),
            Text("Destinataire : $recipientId"),
            if (state is TransferLoading) CircularProgressIndicator(), // Loader
            ElevatedButton(
              onPressed: state is TransferLoading
                  ? null
                  : () {
                      context
                          .read<TransferBloc>()
                          .transfer("currentUserId", recipientId, amount);
                    },
              child: Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }
}
