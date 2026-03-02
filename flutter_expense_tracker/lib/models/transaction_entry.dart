enum TransactionType { credit, debit }

class TransactionEntry {
  TransactionEntry({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.comment,
    this.personName,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? comment;
  final String? personName;
}
