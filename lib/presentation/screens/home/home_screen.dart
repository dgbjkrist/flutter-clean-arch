import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = User(
        id: "123", email: "test@test.com", name: "Christian", balance: 1000.0);

    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: Column(
        children: [
          Text("Solde : \$${user.balance}"),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Simule 5 transactions
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Transaction ${index + 1}"),
                  subtitle: Text("Montant: \$${(index + 1) * 50}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
