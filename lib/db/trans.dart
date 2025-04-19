import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/tranction.dart';

class TransactionDatabase {
  static final TransactionDatabase instance = TransactionDatabase();
  static Database? _database;

  //Database agar bana hai to use karo, nahi to banao
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDB('transactions.db'); // file ka naam
    return _database!;
  }

  //Database open
  Future<Database> _openDB(String fileName) async {
    final dbFolder =
        await getDatabasesPath(); // mobile me database folder ka path
    final fullPath = join(dbFolder, fileName); // full path banaya

    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: _createTable, // jab first time banega
    );
  }

  // Table banane
  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        product TEXT,
        category TEXT,
        paymentMode TEXT,
        date TEXT
      )
    ''');
  }

  Future<void> insertTransaction(TransactionModel t) async {
    final db = await instance.database;

    await db.insert('transactions', {
      'amount': t.money.amount,
      'product': t.product.name,
      'category': t.category.name,
      'paymentMode': t.paymentMode.name,
      'date': t.date.toIso8601String(),
    });
  }

  Future<List<TransactionModel>> fetchAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions');

    return result.map((json) {
      return TransactionModel(
        id: json['id'] as int?, // NEW
        money: Money(json['amount'] as double),
        product: Product(json['product'] as String),
        category: Category(json['category'] as String),
        paymentMode: PaymentMode(json['paymentMode'] as String),
        date: DateTime.parse(json['date'] as String),
      );
    }).toList();
  }

  Future<void> deleteTransaction(int id) async {
    final db = await instance.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
