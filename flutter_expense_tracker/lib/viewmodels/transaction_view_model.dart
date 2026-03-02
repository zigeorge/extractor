import 'package:flutter/foundation.dart';

import '../models/transaction_entry.dart';
import '../services/transaction_repository.dart';

class TransactionViewModel extends ChangeNotifier {
  TransactionViewModel({required TransactionRepository repository})
      : _repository = repository;

  final TransactionRepository _repository;
  List<TransactionEntry> _transactions = [];

  List<TransactionEntry> get transactions => _transactions;

  double currentBalance(double initialBalance) {
    final credits = _transactions
        .where((e) => e.type == TransactionType.credit)
        .fold<double>(0, (acc, e) => acc + e.amount);
    final debits = _transactions
        .where((e) => e.type == TransactionType.debit)
        .fold<double>(0, (acc, e) => acc + e.amount);
    return initialBalance + credits - debits;
  }

  Future<void> load() async {
    _transactions = await _repository.fetchTransactions();
    notifyListeners();
  }

  Future<void> add(TransactionEntry entry) async {
    await _repository.addTransaction(entry);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.deleteTransaction(id);
    await load();
  }
}
