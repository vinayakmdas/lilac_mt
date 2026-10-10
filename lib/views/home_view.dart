import 'package:flutter/material.dart';
import 'package:lilac/controller/nav_controller.dart';
import 'package:lilac/controller/transaction_controller.dart';
import 'package:lilac/widget/balance_card.dart';
import 'package:lilac/widget/stat_box.dart';
import 'package:lilac/widget/transaction_tile.dart';
import 'package:provider/provider.dart';

import '../core/app_constants.dart';
import '../core/formatters.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TransactionController>();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: c.load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            Text(Fmt.greeting(), style: const TextStyle(fontSize: 14)),
            const Text(kUserName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            BalanceCard(
              balance: c.balance,
              income: c.totalIncome,
              expenses: c.totalExpenses,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                    child: StatBox(label: 'Daily Average', value: c.dailyAverage)),
                const SizedBox(width: 16),
                Expanded(child: StatBox(label: 'Weekly', value: c.weeklyExpenses)),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transactions History',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () => context.read<NavController>().setIndex(1),
                  child: const Text('See all',
                      style: TextStyle(fontSize: 14, color: kMutedText)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (c.isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (c.recent.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No transactions yet. Tap + to add one.',
                      style: TextStyle(color: kMutedText)),
                ),
              )
            else
              ...c.recent.map((t) => TransactionTile(item: t)),
          ],
        ),
      ),
    );
  }
}