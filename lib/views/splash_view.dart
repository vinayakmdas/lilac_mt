import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lilac/controller/auth_controller.dart';
import 'package:lilac/controller/splash_controller.dart';
import 'package:lilac/views/buttom_nav.dart';      // contains MainView
import 'package:lilac/views/login_view.dart';
import 'package:provider/provider.dart';

/// VIEW: only UI. Listens to the controller through Provider.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Start timer after first frame, then decide where to go after 3 seconds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashController>().startTimer(() {
        if (!mounted) return;

        // Logged in -> Home, otherwise -> Login
        final isLoggedIn = context.read<AuthController>().isLoggedIn;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => isLoggedIn ? const MainView() : const LoginView(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<SplashController>().model;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Teal vertical gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [model.gradientTop, model.gradientBottom],
              ),
            ),
          ),
          // Subtle grain/noise texture
          const CustomPaint(painter: _NoisePainter()),
          // App name
          Center(
            child: Text(
              model.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  const _NoisePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(7); // fixed seed = same pattern every frame
    final paint = Paint();
    final count = (size.width * size.height / 40).toInt();
    for (int i = 0; i < count; i++) {
      paint.color = (random.nextBool() ? Colors.white : Colors.black)
          .withOpacity(0.03 + random.nextDouble() * 0.03);
      canvas.drawRect(
        Rect.fromLTWH(random.nextDouble() * size.width,
            random.nextDouble() * size.height, 1.2, 1.2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}