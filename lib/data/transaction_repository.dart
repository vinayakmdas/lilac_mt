import 'package:lilac/model/transaction_model.dart';

import 'database_helper.dart';

class TransactionRepository {
  final DatabaseHelper _helper = DatabaseHelper.instance;

  Future<List<TransactionModel>> getAll() async {
    final db = await _helper.database;
    final rows = await db.query(
      DatabaseHelper.tableTransactions,
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<int> insert(TransactionModel t) async {
    final db = await _helper.database;
    return db.insert(DatabaseHelper.tableTransactions, t.toMap());
  }

  Future<int> update(TransactionModel t) async {
    final db = await _helper.database;
    return db.update(DatabaseHelper.tableTransactions, t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }

  Future<int> delete(int id) async {
    final db = await _helper.database;
    return db.delete(DatabaseHelper.tableTransactions,
        where: 'id = ?', whereArgs: [id]);
  }
}
