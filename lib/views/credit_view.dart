import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lilac/controller/credit_controller.dart';
import 'package:lilac/model/credit_model.dart';
import 'package:lilac/widget/credit_tile.dart';
import 'package:lilac/widget/form_widgets.dart';
import 'package:lilac/widget/page_header.dart';
import 'package:provider/provider.dart';

import '../core/app_constants.dart';


class CreditView extends StatefulWidget {
  const CreditView({super.key});

  @override
  State<CreditView> createState() => _CreditViewState();
}

class _CreditViewState extends State<CreditView> {
  final _toCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  String _creditType = kCreditTypes.first;
  String _planType = kPlanTypes.first;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _toCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final to = _toCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim());

    if (to.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name and a valid amount')),
      );
      return;
    }

    await context.read<CreditController>().add(CreditModel(
          creditType: _creditType,
          toName: to,
          amount: amount,
          dueDate: _date,
          planType: _planType,
        ));

    if (!mounted) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _toCtrl.clear();
      _amountCtrl.clear();
      _date = DateTime.now();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CreditController>();

    return Column(
      children: [
        const PageHeader(title: 'Credit'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
            children: [
              LabeledField(
                label: 'Credit Type',
                child: AppDropdown(
                  value: _creditType,
                  items: kCreditTypes,
                  onChanged: (v) => setState(() => _creditType = v),
                ),
              ),
              LabeledField(
                label: 'To',
                child: TextField(
                  controller: _toCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: appInputDecoration(hint: 'Netflix'),
                ),
              ),
              LabeledField(
                label: 'Amount',
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: appInputDecoration(hint: '850.00'),
                ),
              ),
              LabeledField(
                label: 'Date',
                child: AppDateField(
                  value: _date,
                  onChanged: (d) => setState(() => _date = d),
                ),
              ),
              LabeledField(
                label: 'Plan Type',
                child: AppDropdown(
                  value: _planType,
                  items: kPlanTypes,
                  onChanged: (v) => setState(() => _planType = v),
                ),
              ),
              const SizedBox(height: 4),
              PrimaryButton(label: 'Save', onPressed: _save),
              const SizedBox(height: 28),
              const Text('Your Saved Lists',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (c.isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (c.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Nothing saved yet',
                        style: TextStyle(color: kMutedText)),
                  ),
                )
              else
                ...c.items.map(
                  (item) => Dismissible(
                    key: ValueKey('credit_${item.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: kExpense,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => c.remove(item.id!),
                    child: Column(
                      children: [
                        CreditTile(item: item),
                        const Divider(height: 1, color: kBorder),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}