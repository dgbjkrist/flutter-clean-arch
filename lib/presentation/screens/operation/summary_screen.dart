import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/transfer/transfer_bloc.dart';
import '../../cubits/transfer_cubit.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transferState = context.watch<TransferCubit>().state;
    final transferBloc = context.read<TransferBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text("Résumé du Transfert")),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is TransferSuccess) {
            context.read<TransferCubit>().reset();
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is TransferError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is TransferLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Montant : ${transferState.amount} USD"),
              Text("Frais : ${transferState.fees} USD"),
              Text(
                  "Destinataire : ${transferState.recipient?.name ?? "Non défini"}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  transferBloc.transfer(
                    "senderId",
                    transferState.recipient!.id,
                    transferState.amount,
                  );
                },
                child: const Text("Transferer"),
              ),
            ],
          );
        },
      ),
    );
  }
}
