import 'package:flutter/material.dart';
import 'package:lilac/model/transaction_model.dart';
import '../core/app_constants.dart';
import '../core/formatters.dart';


class TransactionTile extends StatelessWidget {
  final TransactionModel item;
  const TransactionTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isIncome ? kIncome : kExpense;
    final sign = item.isIncome ? '+' : '-';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(Fmt.relativeDate(item.date),
                    style: const TextStyle(fontSize: 13, color: kMutedText)),
              ],
            ),
          ),
          Text(
            '$sign ${Fmt.money(item.amount, symbol: kCurrency)}',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
