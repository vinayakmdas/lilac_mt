import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lilac/controller/transaction_controller.dart';
import 'package:lilac/model/transaction_model.dart';
import 'package:lilac/widget/form_widgets.dart';
import 'package:lilac/widget/page_header.dart';
import 'package:provider/provider.dart';

 
import '../core/app_constants.dart';


/// One screen for both:
///  - Add  -> TransactionFormView()                (title "Transaction")
///  - Edit -> TransactionFormView(existing: item)  (title "Edit Transaction")
class TransactionFormView extends StatefulWidget {
  final TransactionModel? existing;
  const TransactionFormView({super.key, this.existing});

  bool get isEdit => existing != null;

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  static const _types = ['Income', 'Expense'];

  late final TextEditingController _nameCtrl;
  late final TextEditingController _amountCtrl;
  late String _type;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.title ?? '');
    _amountCtrl =
        TextEditingController(text: e == null ? '' : e.amount.toStringAsFixed(2));
    _type = (e?.isIncome ?? false) ? 'Income' : 'Expense';
    _date = e?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim());

    if (name.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name and a valid amount')),
      );
      return;
    }

    final model = TransactionModel(
      id: widget.existing?.id,
      title: name,
      isIncome: _type == 'Income',
      amount: amount,
      date: _date,
    );

    final controller = context.read<TransactionController>();
    if (widget.isEdit) {
      await controller.update(model);
    } else {
      await controller.add(model);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            PageHeader(
              title: widget.isEdit ? 'Edit Transaction' : 'Transaction',
              showBack: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 26, 28, 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      LabeledField(
                        label: 'Transaction Type',
                        child: AppDropdown(
                          value: _type,
                          items: _types,
                          onChanged: (v) => setState(() => _type = v),
                        ),
                      ),
                      LabeledField(
                        label: 'Name',
                        child: TextField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: appInputDecoration(hint: 'Netflix'),
                        ),
                      ),
                      LabeledField(
                        label: 'Amount',
                        child: TextField(
                          controller: _amountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: const TextStyle(color: kPrimary),
                          decoration: appInputDecoration(hint: '0.00').copyWith(
                            prefixText: '$kCurrency ',
                            prefixStyle: const TextStyle(color: kPrimary),
                            // Amount field keeps the teal border (as in design)
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: kPrimary),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: GestureDetector(
                                onTap: _amountCtrl.clear,
                                child: const Center(
                                  widthFactor: 1,
                                  child: Text('Clear',
                                      style: TextStyle(
                                          color: kPrimary, fontSize: 12)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      LabeledField(
                        label: 'Date',
                        child: AppDateField(
                          value: _date,
                          onChanged: (d) => setState(() => _date = d),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
                child: PrimaryButton(label: 'Save', onPressed: _save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
