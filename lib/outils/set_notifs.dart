import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(true) {
    _load(); // au démarrage, on charge la valeur stockée
  }

  static const String _key = "notifications_enabled";

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true; // valeur par défaut = true
  }

  Future<void> toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    state = value; // met à jour l’état
  }
}

// Déclaration du provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});
