import '../models/transaction_entry.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntry>> fetchTransactions();

  Future<void> addTransaction(TransactionEntry entry);

  Future<void> deleteTransaction(String id);
}

class InMemoryTransactionRepository implements TransactionRepository {
  final List<TransactionEntry> _store = [];

  @override
  Future<List<TransactionEntry>> fetchTransactions() async {
    _store.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(_store);
  }

  @override
  Future<void> addTransaction(TransactionEntry entry) async {
    _store.add(entry);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _store.removeWhere((item) => item.id == id);
  }
}
