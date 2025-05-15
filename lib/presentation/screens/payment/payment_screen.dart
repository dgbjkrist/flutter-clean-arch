import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/stellar/stellar_cubit.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Payment')),
      body: BlocConsumer<StellarCubit, StellarState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state.lastTransactionHash != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment sent successfully!')),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'Recipient Public Key',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount (XLM)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      final amount = double.tryParse(value!);
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _memoController,
                    decoration: InputDecoration(
                      labelText: 'Memo (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  if (state.isLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: _handlePayment,
                      child: Text('Send Payment'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePayment() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      context.read<StellarCubit>().sendStellarPayment(
            destinationPublicKey: _destinationController.text,
            amount: amount,
            memo: _memoController.text.isNotEmpty ? _memoController.text : null,
          );
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }
}
