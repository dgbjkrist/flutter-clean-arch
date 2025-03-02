import 'package:flutter/material.dart';

import 'amount_screen.dart';

class OperationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Opérations")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AmountScreen()),
            );
          },
          child: Text("Effectuer un transfert"),
        ),
      ),
    );
  }
}
