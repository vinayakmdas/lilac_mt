import 'package:flutter/material.dart';
import 'package:lilac/controller/auth_controller.dart';
import 'package:lilac/controller/credit_controller.dart';
import 'package:lilac/controller/nav_controller.dart';
import 'package:lilac/controller/splash_controller.dart';
import 'package:lilac/controller/transaction_controller.dart';
import 'package:lilac/core/app_constants.dart';
import 'package:lilac/views/splash_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load SharedPreferences (login state, name, photo) before the app starts
  final auth = AuthController();
  await auth.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: auth),
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => NavController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
        ChangeNotifierProvider(create: (_) => CreditController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenzia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashView(),
    );
  }
}