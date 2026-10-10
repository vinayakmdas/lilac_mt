import 'package:flutter/material.dart';

/// MODEL: holds the static data for the splash screen.
class SplashModel {
  final String appName;
  final Duration duration;
  final Color gradientTop;
  final Color gradientBottom;

  const SplashModel({
    this.appName = 'Expenzia',
    this.duration = const Duration(seconds: 3),
    this.gradientTop = const Color(0xFF76B3AC),
    this.gradientBottom = const Color(0xFF5C8C88),
  });
}