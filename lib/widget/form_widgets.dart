import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/formatters.dart';

InputDecoration appInputDecoration({String? hint, Widget? suffix}) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c),
      );
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: border(kBorder),
    enabledBorder: border(kBorder),
    focusedBorder: border(kPrimary),
  );
}

/// Small grey uppercase label above a field.
class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const LabeledField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
                fontSize: 12, letterSpacing: 1, color: kMutedText),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class AppDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const AppDropdown(
      {super.key,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down, color: kMutedText),
      decoration: appInputDecoration(),
      borderRadius: BorderRadius.circular(10),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class AppDateField extends StatelessWidget {
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  const AppDateField({super.key, required this.value, required this.onChanged});

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: appInputDecoration(
          suffix: const Icon(Icons.calendar_month, color: kMutedText),
        ),
        child: Text(Fmt.fieldDate(value)),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}
