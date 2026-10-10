import 'package:flutter/material.dart';
import 'package:lilac/controller/nav_controller.dart';
import 'package:lilac/model/nav_item_model.dart';
import 'package:provider/provider.dart';


import '../core/app_constants.dart';


const Color kNavInactive = Color(0xFF1F5A55);

/// Teal bottom bar: Home | History | (space for FAB) | Credit | Profile
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavController>();

    Widget item(int i) {
      final selected = nav.currentIndex == i;
      return Expanded(
        child: InkWell(
          onTap: () => context.read<NavController>().setIndex(i),
          child: Tooltip(
            message: navItems[i].label,
            child: Center(
              child: Icon(
                navItems[i].icon,
                size: selected ? 38 : 34,
                color: selected ? Colors.white : kNavInactive,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      color: kNavColor,
      child: Row(
        children: [
          item(0),
          item(1),
          const SizedBox(width: 90), // space for the floating button
          item(2),
          item(3),
        ],
      ),
    );
  }
}

/// Round "+" button with the soft light ring around it.
class CenterAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CenterAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.85),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: SizedBox(
        width: 66,
        height: 66,
        child: FloatingActionButton(
          heroTag: 'addTransactionFab',
          backgroundColor: kNavColor,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: onPressed,
          child: const Icon(Icons.add, color: Colors.white, size: 38),
        ),
      ),
    );
  }
}
