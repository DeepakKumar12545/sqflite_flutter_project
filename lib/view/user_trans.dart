import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modellearn/db/trans.dart';
import 'package:modellearn/model/tranction.dart';
import 'package:modellearn/view/userview.dart' show TransactionListPage;

class TransactionFormPage extends StatefulWidget {
  @override
  _TransactionFormPageState createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  String? selectedProduct;
  String? selectedCategory;
  String? selectedPaymentMode;

  final List<String> products = ['Milk', 'Bread', 'Shoes', 'Phone'];
  final List<String> categories = ['Grocery', 'Electronics', 'Clothing'];
  final List<String> paymentModes = ['Cash', 'Card', 'UPI'];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final money = Money(double.parse(_amountController.text));
      final product = Product(selectedProduct!);
      final category = Category(selectedCategory!);
      final paymentMode = PaymentMode(selectedPaymentMode!);

      TransactionModel transaction = TransactionModel(
        money: money,
        product: product,
        category: category,
        paymentMode: paymentMode,
        date: DateTime.now(),
      );

      await TransactionDatabase.instance.insertTransaction(transaction);

      Get.to(TransactionListPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter amount' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedProduct,
                items:
                    products
                        .map(
                          (item) =>
                              DropdownMenuItem(child: Text(item), value: item),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedProduct = value),
                decoration: InputDecoration(labelText: 'Select Product'),
                validator: (value) => value == null ? 'Select a product' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items:
                    categories
                        .map(
                          (item) =>
                              DropdownMenuItem(child: Text(item), value: item),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                decoration: InputDecoration(labelText: 'Select Category'),
                validator:
                    (value) => value == null ? 'Select a category' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPaymentMode,
                items:
                    paymentModes
                        .map(
                          (item) =>
                              DropdownMenuItem(child: Text(item), value: item),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => selectedPaymentMode = value),
                decoration: InputDecoration(labelText: 'Select Payment Mode'),
                validator:
                    (value) => value == null ? 'Select a payment mode' : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Transaction'),
              ),
              ElevatedButton(
                onPressed: () => Get.to(TransactionListPage()),
                child: Text('Submit Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
