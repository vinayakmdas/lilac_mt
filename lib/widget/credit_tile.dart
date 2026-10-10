import 'package:flutter/material.dart';
import 'package:lilac/model/credit_model.dart';
import '../core/app_constants.dart';
import '../core/formatters.dart';


class CreditTile extends StatelessWidget {
  final CreditModel item;
  const CreditTile({super.key, required this.item});

  Widget _dueText() {
    const grey = TextStyle(fontSize: 13, color: kMutedText);
    const red = TextStyle(fontSize: 13, color: Colors.red);
    if (item.isDueToday) {
      return Text.rich(const TextSpan(children: [
        TextSpan(text: 'Due ', style: grey),
        TextSpan(text: 'Today', style: red),
      ]));
    }
    return Text.rich(TextSpan(children: [
      TextSpan(text: 'Due On ', style: item.isOverdue ? red : grey),
      TextSpan(
          text: Fmt.shortDate(item.dueDate),
          style: item.isOverdue ? red : grey),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.toName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                _dueText(),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.planType,
                  style: const TextStyle(fontSize: 13, color: kMutedText)),
              const SizedBox(height: 2),
              Text(
                Fmt.money(item.amount, symbol: kCreditCurrency),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
