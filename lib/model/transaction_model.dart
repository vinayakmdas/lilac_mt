class TransactionModel {
  final int? id;
  final String title;
  final bool isIncome;
  final double amount;
  final DateTime date;

  const TransactionModel({
    this.id,
    required this.title,
    required this.isIncome,
    required this.amount,
    required this.date,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'type': isIncome ? 'income' : 'expense',
        'amount': amount,
        'date': date.toIso8601String().substring(0, 10),
      };

  factory TransactionModel.fromMap(Map<String, Object?> m) => TransactionModel(
        id: m['id'] as int?,
        title: m['title'] as String,
        isIncome: m['type'] == 'income',
        amount: (m['amount'] as num).toDouble(),
        date: DateTime.parse(m['date'] as String),
      );
}
