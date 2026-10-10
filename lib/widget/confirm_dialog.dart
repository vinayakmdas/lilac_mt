import 'package:flutter/material.dart';
import '../core/app_constants.dart';

/// Confirmation alert. Returns true if the user confirms.
Future<bool> confirmDelete(
  BuildContext context, {
  String title = 'Delete Transaction',
  String message = 'Are you sure you want to delete this item? '
      'This action cannot be undone.',
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      content: Text(message, style: const TextStyle(color: kMutedText)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel', style: TextStyle(color: kMutedText)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel,
              style: const TextStyle(
                  color: kExpense, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
  return result ?? false;
}
