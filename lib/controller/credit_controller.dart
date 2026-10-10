import 'package:flutter/foundation.dart';
import 'package:lilac/model/credit_model.dart';

import '../data/credit_repository.dart';


class CreditController extends ChangeNotifier {
  final CreditRepository _repo;

  CreditController({CreditRepository? repo})
      : _repo = repo ?? CreditRepository() {
    load();
  }

  List<CreditModel> _items = [];
  bool _loading = true;

  List<CreditModel> get items => _items;
  bool get isLoading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _items = await _repo.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(CreditModel c) async {
    await _repo.insert(c);
    await load();
  }

  Future<void> remove(int id) async {
    await _repo.delete(id);
    await load();
  }
}
