class TransactionModel {
  final int? id; // NEW
  final Money money;
  final Product product;
  final Category category;
  final PaymentMode paymentMode;
  final DateTime date;

  TransactionModel({
    this.id, // NEW
    required this.money,
    required this.product,
    required this.category,
    required this.paymentMode,
    required this.date,
  });
}

class Money {
  final double amount;
  Money(this.amount);
}

class Product {
  final String name;
  Product(this.name);
}

class Category {
  final String name;
  Category(this.name);
}

class PaymentMode {
  final String name;
  PaymentMode(this.name);
}
