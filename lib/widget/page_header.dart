import 'package:flutter/material.dart';
import '../core/app_constants.dart';

/// Teal header with centered white title.
class PageHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack; // default: Navigator.pop
  const PageHeader(
      {super.key, required this.title, this.showBack = false, this.onBack});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity, // full width (was shrinking to the title width)
      color: kPrimary,
      height: top + 90,
      padding: EdgeInsets.only(top: top),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Positioned(
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              ),
            ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}