import 'package:flutter/material.dart';

import 'recipient_screen.dart';

class AmountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Montant")),
      body: Column(
        children: [
          TextField(
              decoration: InputDecoration(labelText: "Montant à transférer")),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipientScreen()));
            },
            child: Text("Suivant"),
          ),
        ],
      ),
    );
  }
}
