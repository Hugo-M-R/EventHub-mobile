import 'package:flutter/material.dart';

abstract final class EventHubColors {
  /// Largura máxima do painel de login (mobile / card centralizado na web).
  static const loginMaxWidth = 420.0;

  static const scaffoldBg = Color(0xFFFAF7F2);
  static const purple = Color(0xFF7B2D8E);
  static const orange = Color(0xFFFF6B2C);
  static const orangeButton = Color(0xFFFF6F00);
  static const orangeButtonHover = Color(0xFFE65100);
  static const orangeButtonPressed = Color(0xFFCC4A00);
  static const linkHoverFill = Color(0xFFFFF3E8);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);
  static const inputBorder = Color(0xFFE5E7EB);
  static const inputFill = Color(0xFFF9FAFB);
  static const cardWhite = Colors.white;

  static const gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [purple, orange],
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
  );
}
