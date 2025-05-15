import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/recipients/recipients_bloc.dart';
import '../../cubits/transfer_cubit.dart';
import 'summary_screen.dart';

class RecipientScreen extends StatefulWidget {
  @override
  State<RecipientScreen> createState() => _RecipientScreenState();
}

class _RecipientScreenState extends State<RecipientScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecipientsBloc>().fetchRecipients();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choisir Destinataire")),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Rechercher un utilisateur",
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (value) {
                  context.read<RecipientsBloc>().searchRecipients(value);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<RecipientsBloc, RecipientsState>(
                  builder: (context, state) {
                    if (state is RecipientsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RecipientsError) {
                      return Center(
                          child: Text("Erreur : ${state.message}",
                              style: TextStyle(color: Colors.red)));
                    } else if (state is RecipientsSuccess) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          itemCount: state.recipients.length,
                          itemBuilder: (context, index) {
                            final user = state.recipients[index];
                            return ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              onTap: () {
                                context
                                    .read<TransferCubit>()
                                    .setRecipient(user);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SummaryScreen()),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const Center(
                        child: Text("Aucun destinataire trouvé."));
                  },
                ),
              )
            ],
          )),
    );
  }
}
