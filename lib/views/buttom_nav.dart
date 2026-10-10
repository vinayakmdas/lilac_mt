import 'package:flutter/material.dart';
import 'package:lilac/controller/nav_controller.dart';
import 'package:lilac/views/add_transaction.dart';
import 'package:lilac/views/transaction_form_view.dart';
import 'package:lilac/views/transaction_history.dart';
import 'package:lilac/widget/customBottomNav.dart';
import 'package:provider/provider.dart';


import 'credit_view.dart';
import 'home_view.dart';
import 'profile_view.dart';


/// Shell screen that holds the 4 tabs + bottom bar + floating button.
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final index = context.watch<NavController>().currentIndex;

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: index,
        children: const [
          HomeView(),
          TransactionHistoryView(),
          
          CreditView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: CenterAddButton(
          // Tapping "+" opens the Transaction (add) page
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TransactionFormView()),
          ),
        ),
      ),
    );
  }
}