import '../core/formatters.dart';

class CreditModel {
  final int? id;
  final String creditType;
  final String toName;
  final double amount;
  final DateTime dueDate;
  final String planType;

  const CreditModel({
    this.id,
    required this.creditType,
    required this.toName,
    required this.amount,
    required this.dueDate,
    required this.planType,
  });

  bool get isDueToday => dateOnly(dueDate) == dateOnly(DateTime.now());
  bool get isOverdue => dateOnly(dueDate).isBefore(dateOnly(DateTime.now()));

  Map<String, Object?> toMap() => {
        'id': id,
        'credit_type': creditType,
        'to_name': toName,
        'amount': amount,
        'due_date': dueDate.toIso8601String().substring(0, 10),
        'plan_type': planType,
      };

  factory CreditModel.fromMap(Map<String, Object?> m) => CreditModel(
        id: m['id'] as int?,
        creditType: m['credit_type'] as String,
        toName: m['to_name'] as String,
        amount: (m['amount'] as num).toDouble(),
        dueDate: DateTime.parse(m['due_date'] as String),
        planType: m['plan_type'] as String,
      );
}
