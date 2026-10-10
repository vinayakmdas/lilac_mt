import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lilac/controller/transaction_controller.dart';
import 'package:lilac/model/transaction_model.dart';
import 'package:lilac/views/transaction_form_view.dart';
import 'package:lilac/widget/confirm_dialog.dart';
import 'package:lilac/widget/page_header.dart';
import 'package:lilac/widget/transaction_tile.dart';
import 'package:provider/provider.dart';

import '../core/app_constants.dart';

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  Future<void> _edit(BuildContext context, TransactionModel t) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TransactionFormView(existing: t)),
    );
  }

  Future<void> _delete(BuildContext context, TransactionModel t) async {
    final controller = context.read<TransactionController>();
    final ok = await confirmDelete(
      context,
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete "${t.title}"? '
          'This action cannot be undone.',
    );
    if (ok) await controller.remove(t.id!);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TransactionController>();

    return Column(
      children: [
        const PageHeader(title: 'Transaction History'),
        Expanded(
          child: c.isLoading
              ? const Center(child: CircularProgressIndicator())
              : c.items.isEmpty
                  ? const Center(
                      child: Text('No transactions yet',
                          style: TextStyle(color: kMutedText)))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 120),
                      itemCount: c.items.length,
                      itemBuilder: (_, i) {
                        final t = c.items[i];
                        return Slidable(
                          key: ValueKey('tx_${t.id}'),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.3,
                            children: [
                              CustomSlidableAction(
                                backgroundColor: const Color(0xFFE6E6E6),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.zero,
                                onPressed: (ctx) => _edit(context, t),
                                child: const Icon(Icons.edit, size: 20),
                              ),
                              CustomSlidableAction(
                                backgroundColor: const Color(0xFFFF4040),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                onPressed: (ctx) => _delete(context, t),
                                child: const Icon(Icons.delete, size: 20),
                              ),
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22),
                            child: TransactionTile(item: t),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
