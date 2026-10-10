import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/formatters.dart';

class StatBox extends StatelessWidget {
  final String label;
  final double value;
  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 12, letterSpacing: 1, color: kMutedText)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(Fmt.money(value, symbol: kCurrency),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
