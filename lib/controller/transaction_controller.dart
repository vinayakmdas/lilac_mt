import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:lilac/model/transaction_model.dart';

import '../core/formatters.dart';
import '../data/transaction_repository.dart';


class TransactionController extends ChangeNotifier {
  final TransactionRepository _repo;

  TransactionController({TransactionRepository? repo})
      : _repo = repo ?? TransactionRepository() {
    load();
  }

  List<TransactionModel> _items = [];
  bool _loading = true;

  List<TransactionModel> get items => _items;
  List<TransactionModel> get recent => _items.take(3).toList();
  bool get isLoading => _loading;

  double get totalIncome =>
      _items.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get totalExpenses =>
      _items.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpenses;

  /// Expenses of the last 7 days (including today).
  double get weeklyExpenses {
    final start = dateOnly(DateTime.now()).subtract(const Duration(days: 6));
    return _items
        .where((t) => !t.isIncome && !dateOnly(t.date).isBefore(start))
        .fold(0.0, (s, t) => s + t.amount);
  }

  /// Total expenses / number of days since the first transaction.
  double get dailyAverage {
    if (_items.isEmpty) return 0;
    final first = _items.map((t) => dateOnly(t.date)).reduce(
        (a, b) => a.isBefore(b) ? a : b);
    final days = max(1, dateOnly(DateTime.now()).difference(first).inDays + 1);
    return totalExpenses / days;
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _items = await _repo.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(TransactionModel t) async {
    await _repo.insert(t);
    await load();
  }

  Future<void> update(TransactionModel t) async {
    await _repo.update(t);
    await load();
  }

  Future<void> remove(int id) async {
    await _repo.delete(id);
    await load();
  }
}
