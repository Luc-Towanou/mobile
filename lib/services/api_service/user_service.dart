import 'dart:convert';
import 'package:event_rush_mobile/models/notification.dart';
import 'package:event_rush_mobile/models/souscription.dart';
import 'package:event_rush_mobile/models/user.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'https://eventrush.onrender.com/api'; // si tu utilises l'émulateur Android
  // sur un vrai appareil, mets l'IP locale de ton PC, ex: 192.168.1.100:8000

  Future<User> getMe() async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/me');
    print("fetching user ...");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        // "Accept": "application/json", 
        'Authorization': 'Bearer $token',
      },
      // body: jsonEncode({"email": email, "password": password}),
    );
    print("statut code :${response.statusCode}");
    if (response.statusCode == 200) {
      // await storage.write(key: "token", value: data["access_token"]);
      // await storage.write(key: "role", value: data["role"]); // si besoin
      // final List data = jsonDecode(response.body);
      print("body :${response.body}");
      // return jsonDecode(response.body);
      // return data.map((e) => User.fromJson(e)).toList();
      final Map<String, dynamic> body = jsonDecode(response.body);
      final Map<String, dynamic> data = body['data'];
      return User.fromJson(data);
    } else {
      print("Erreur :${response.body}");
      throw Exception('Erreur : ${response.statusCode} => ${response.body}');
    }
  }

    static const base = "https://eventrush.onrender.com/api";

  
   static Future<Map<String, dynamic>> getSubscriptions() async {
    final token = await AuthService.getToken();

    final res = await http.get(
      Uri.parse('$base/my-subscriptions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );

    return jsonDecode(res.body);
  }

  static Future<List> getNotifications() async {
    final token = await AuthService.getToken();

    final res = await http.get(
      Uri.parse('$base/my-notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );

    return jsonDecode(res.body);
  }
  
  // Future<Map<String, dynamic>> loginScanners(String nom, String password) async {
  //   final url = Uri.parse('$baseUrl/auth/login/scanneurs');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json", 
  //     },
  //     body: jsonEncode({"nom": nom, "password": password}),
  //   );

  //   if (response.statusCode == 200) {
  //     // await storage.write(key: "token", value: data["access_token"]);
  //     // await storage.write(key: "role", value: data["role"]); // si besoin
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Erreur : ${response.statusCode} => ${response.body}');
  //   }
  // }

  
  // Future<Map<String, dynamic>> getScannerProfile(String token) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/me'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //   return jsonDecode(response.body);
  // }

  // Future<List<dynamic>> getScannerEvents(String token) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/scanneur/event'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   final decoded = jsonDecode(response.body);

  //   // Si l'API renvoie un objet avec "data"
  //   if (decoded is Map && decoded.containsKey('data')) {
  //     return List<dynamic>.from(decoded['data']);
  //   }

  //   // Sinon si l'API renvoie déjà une Map avec des index numériques, on convertit en liste
  //   if (decoded is Map) {
  //     return decoded.values.toList();
  //   }

  //   // Si c'est déjà une liste
  //   if (decoded is List) return decoded;

  //   throw Exception("Format inattendu pour les événements");
  // }
  // static const _storage = FlutterSecureStorage();

  // static Future<String?> getToken() async {
  //   return await _storage.read(key: 'token');
  // }

  // static Future<void> saveToken(String token) async {
  //   await _storage.write(key: 'token', value: token);
  // }

  // static Future<void> logout() async {
  //   await _storage.delete(key: 'token');
  // }
}



class ProfileService {
  final String baseUrl = "https://eventrush.onrender.com/api";
  
  // Fonction utilitaire pour les headers avec le Token
  Future<Map<String, String>> _getHeaders() async {
    // TODO: Récupère ton vrai token ici (ex: via SharedPreferences)
    String? token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 1. Récupérer le profil (/me)
  Future<User?> getUserProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/me'), headers: headers);

      if (response.statusCode == 200) {
        // final body = jsonDecode(response.body);
        final Map<String, dynamic> body = jsonDecode(response.body);
        final Map<String, dynamic> data = body['data'];
        return User.fromJson(data);
      } else {
        print("Erreur profil: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception profil: $e");
      return null;
    }
  }

  // 2. Récupérer l'historique des souscriptions
  Future<List<Subscription>> getSubscriptions() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/souscriptions/history'), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((e) => Subscription.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Exception souscriptions: $e");
      return [];
    }
  }

  // 3. Récupérer les notifications
  Future<List<AppNotification>> getNotifications() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/notifications'), headers: headers);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['notifications'];
        return list.map((e) => AppNotification.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Exception notifs: $e");
      return [];
    }
  }
}