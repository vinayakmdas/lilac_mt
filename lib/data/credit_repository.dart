import 'package:lilac/model/credit_model.dart';

import 'database_helper.dart';

class CreditRepository {
  final DatabaseHelper _helper = DatabaseHelper.instance;

  Future<List<CreditModel>> getAll() async {
    final db = await _helper.database;
    final rows = await db.query(
      DatabaseHelper.tableCredits,
      orderBy: 'due_date ASC, id DESC',
    );
    return rows.map(CreditModel.fromMap).toList();
  }

  Future<int> insert(CreditModel c) async {
    final db = await _helper.database;
    return db.insert(DatabaseHelper.tableCredits, c.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _helper.database;
    return db.delete(DatabaseHelper.tableCredits,
        where: 'id = ?', whereArgs: [id]);
  }
}
