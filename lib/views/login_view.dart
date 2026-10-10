import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lilac/controller/auth_controller.dart';
import 'package:lilac/core/app_constants.dart'; // kAdminEmail, kAdminPassword, colors
import 'package:lilac/views/buttom_nav.dart';
import 'package:lilac/widget/form_widgets.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _loginError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Fills the fixed admin credentials into both fields.
  void _autoFill() {
    FocusScope.of(context).unfocus();
    setState(() {
      _emailCtrl.text = "admin@gmail.com";
      _passCtrl.text = "admin123";
      _loginError = null;
    });
    _formKey.currentState?.validate(); // clears red field messages
  }

  Future<void> _login() async {
    setState(() => _loginError = null);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim().toLowerCase();
    final password = _passCtrl.text;

    // Fixed credentials (see kAdminEmail / kAdminPassword in app_constants.dart)
    if (email != "admin@gmail.com" || password != "admin123") {
      setState(() => _loginError = 'Invalid email or password');
      return;
    }

    setState(() => _busy = true);
    final auth = context.read<AuthController>();
    await auth.login(name: auth.userName, email: email); // saved in SharedPreferences

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kPrimary,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 190,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Expenzia',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1)),
                    SizedBox(height: 6),
                    Text('Track every expense',
                        style: TextStyle(color: Colors.white70, fontSize: 15)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Welcome',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        const Text('Login to continue',
                            style: TextStyle(color: kMutedText)),
                        const SizedBox(height: 28),
                        LabeledField(
                          label: 'Email',
                          child: TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                appInputDecoration(hint: 'admin@gmail.com'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter your email'
                                : null,
                          ),
                        ),
                        LabeledField(
                          label: 'Password',
                          child: TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            decoration: appInputDecoration(hint: '••••••').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kMutedText,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Enter your password'
                                : null,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _autoFill,
                            icon: const Icon(Icons.auto_fix_high,
                                size: 18, color: kPrimary),
                            label: const Text('Auto fill',
                                style: TextStyle(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        if (_loginError != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(_loginError!,
                                style: const TextStyle(
                                    color: kExpense, fontSize: 13)),
                          ),
                        const SizedBox(height: 4),
                        _busy
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(label: 'Login', onPressed: _login),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}