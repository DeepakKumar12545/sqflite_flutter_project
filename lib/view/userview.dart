import 'package:flutter/material.dart';
import 'package:modellearn/db/trans.dart';
import 'package:modellearn/model/tranction.dart';

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await TransactionDatabase.instance.fetchAllTransactions();
    setState(() {
      transactions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body:
          transactions.isEmpty
              ? Center(child: Text('No transactions found'))
              : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  return Dismissible(
                    key: Key(t.id.toString()), // ✅ use ID now
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      if (t.id != null) {
                        await TransactionDatabase.instance.deleteTransaction(
                          t.id!,
                        );
                        setState(() {
                          transactions.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Transaction deleted')),
                        );
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('₹${t.money.amount.toInt()}'),
                      ),
                      title: Text(t.product.name),
                      subtitle: Text(
                        '${t.category.name} | ${t.paymentMode.name}',
                      ),
                      trailing: Text(
                        '${t.date.day}/${t.date.month}/${t.date.year}',
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
