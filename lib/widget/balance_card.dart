import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/formatters.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  const BalanceCard(
      {super.key,
      required this.balance,
      required this.income,
      required this.expenses});

  Widget _stat(String label, double value, IconData icon,
      {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white24,
              child: Icon(icon, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Text(Fmt.money(value, symbol: kCurrency),
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: kPrimary.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Balance',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(Fmt.money(balance, symbol: kCurrency),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat('Income', income, Icons.arrow_downward),
              _stat('Expenses', expenses, Icons.arrow_upward,
                  align: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }
}
