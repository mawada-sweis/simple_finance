import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/view_models/transaction/transaction_view_model.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    
    // Load transactions when the screen is first built
    Future.microtask(() =>
        Provider.of<TransactionViewModel>(context, listen: false)
            .loadTransactions());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Consumer<TransactionViewModel>(
        builder: (context, transactionViewModel, child) {
          if (transactionViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());

          }

          if (transactionViewModel.transactions.isEmpty) {
            return const Center(child: Text("No transactions available"));
          }

          return ListView.builder(
            itemCount: transactionViewModel.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionViewModel.transactions[index];
              return Card(
                child: ListTile(
                  title: Text(transaction.statementName),
                  subtitle: Text("Amount: \$${transaction.amount}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      transactionViewModel.removeTransaction(transaction.transID);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add transaction screen (not implemented yet)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
