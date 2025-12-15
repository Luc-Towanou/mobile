import 'package:flutter/material.dart';

// --- PALETTE DE COULEURS FUN & NEON ---
class AppColors {
  static const bg = Color(0xFF121212); // Noir un peu moins dur
  static const cardBg = Color(0xFF1E1E1E);
  static const pink = Color(0xFFFA4EAB);
  static const purple = Color(0xFF7B2CBF);
  static const orange = Color(0xFFFF8C42);
  static const white = Colors.white;
  static const grey = Colors.grey;

  // Gradients pour le fun
  static const Gradient mainGradient = LinearGradient(
    colors: [pink, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient orangeGradient = LinearGradient(
    colors: [orange, Color(0xFFFF5E62)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// --- WIDGET REUTILISABLE : HEADER DE SECTION ---
class FunSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const FunSectionHeader({super.key, required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}