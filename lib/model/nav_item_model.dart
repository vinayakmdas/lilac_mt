import 'package:flutter/material.dart';

/// MODEL: one item of the bottom navigation bar.
class NavItemModel {
  final String label;
  final IconData icon;
  const NavItemModel({required this.label, required this.icon});
}

const List<NavItemModel> navItems = [
  NavItemModel(label: 'Home', icon: Icons.home_outlined),
  NavItemModel(label: 'Transaction History', icon: Icons.history),
  NavItemModel(label: 'Credit', icon: Icons.account_balance_wallet_outlined),
  NavItemModel(label: 'Profile', icon: Icons.person_outline),
];