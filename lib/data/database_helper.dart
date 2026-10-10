import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Single SQLite connection for the whole app.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _dbName = 'expenzia.db';
  static const int _dbVersion = 1;

  static const String tableTransactions = 'transactions';
  static const String tableCredits = 'credits';

  static Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  /// Deletes every row (used by "Clear Storage").
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableTransactions);
    await db.delete(tableCredits);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id     INTEGER PRIMARY KEY AUTOINCREMENT,
        title  TEXT    NOT NULL,
        type   TEXT    NOT NULL,   -- 'income' | 'expense'
        amount REAL    NOT NULL,
        date   TEXT    NOT NULL    -- yyyy-MM-dd
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCredits (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        credit_type TEXT NOT NULL,
        to_name     TEXT NOT NULL,
        amount      REAL NOT NULL,
        due_date    TEXT NOT NULL,  -- yyyy-MM-dd
        plan_type   TEXT NOT NULL
      )
    ''');
  }
}
