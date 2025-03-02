import 'package:flutter/material.dart';

import 'summary_screen.dart';

class RecipientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choix du bénéficiaire")),
      body: Column(
        children: [
          Text("Sélectionnez un destinataire"),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SummaryScreen()));
            },
            child: Text("Suivant"),
          ),
        ],
      ),
    );
  }
}
