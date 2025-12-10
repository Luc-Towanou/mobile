// import 'package:flutter/material.dart';

// class ThemeProvider extends ChangeNotifier {
//   bool _isDark = false;

//   bool get isDark => _isDark;

//   ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

//   void toggleTheme() {
//     _isDark = !_isDark;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false = light mode par défaut

  ThemeMode get themeMode => state ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    state = !state;
  }
}

// Déclaration du provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});