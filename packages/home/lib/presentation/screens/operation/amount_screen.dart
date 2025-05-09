import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/transfer/fees_bloc.dart';
import '../../blocs/transfer_cubit.dart';
import 'recipient_screen.dart';

class AmountScreen extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saisir Montant")),
      body: Column(
        children: [
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: "Montant"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              double amount = double.tryParse(value) ?? 0.0;
              context.read<FeesBloc>().getFees(amount);
            },
          ),
          BlocBuilder<FeesBloc, FeesState>(
            builder: (context, state) {
              if (state is FeesLoading) {
                return CircularProgressIndicator();
              } else if (state is FeesSuccess) {
                return Text("Frais estimés : ${state.fees} USD");
              } else if (state is FeesError) {
                return Text("Erreur : ${state.message}",
                    style: TextStyle(color: Colors.red));
              }
              return SizedBox.shrink();
            },
          ),
          ElevatedButton(
            onPressed: () {
              double amount = double.parse(amountController.text);
              double fees =
                  (context.read<FeesBloc>().state as FeesSuccess).fees;
              context.read<TransferCubit>().setAmount(amount, fees);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipientScreen()),
              );
            },
            child: Text("Suivant"),
          ),
        ],
      ),
    );
  }
}
