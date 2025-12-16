import 'dart:convert';
import 'package:event_rush_mobile/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://eventrush.onrender.com/api'; // si tu utilises l'émulateur Android
  // sur un vrai appareil, mets l'IP locale de ton PC, ex: 192.168.1.100:8000

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
      print("email : $email, password $password");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json", 
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      // final Map<String, dynamic> data = body['data'];
      await _storage.write(key: "token", value: body["access_token"]);
      await _storage.write(key: "role", value: body["role"]); // si besoin
      await _storage.write(key: "sous_statut", value: body["est_actif"].toString()); // si besoin
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur : ${response.statusCode} => ${response.body}');
    }
  }
  
  Future<Map<String, dynamic>> loginScanners(String nom, String password) async {
    final url = Uri.parse('$baseUrl/auth/login/scanneurs');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json", 
      },
      body: jsonEncode({"nom": nom, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      // final Map<String, dynamic> data = body['data'];
      await _storage.write(key: "token", value: body["access_token"]);
      // await storage.write(key: "role", value: data["role"]); // si besoin
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur : ${response.statusCode} => ${response.body}');
    }
  }

  
  Future<Map<String, dynamic>> getScannerProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // final body = jsonDecode(response.body);
    // return jsonDecode(response.body);
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['data'];
  }

  Future<List<dynamic>> getScannerEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/scanneur/event'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decoded = jsonDecode(response.body);

    // Si l'API renvoie un objet avec "data"
    if (decoded is Map && decoded.containsKey('data')) {
      return List<dynamic>.from(decoded['data']);
    }

    // Sinon si l'API renvoie déjà une Map avec des index numériques, on convertit en liste
    if (decoded is Map) {
      return decoded.values.toList();
    }

    // Si c'est déjà une liste
    if (decoded is List) return decoded;

    throw Exception("Format inattendu pour les événements");
  }
  static const _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
  static Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // static Future<void> logout() async {
  //   await _storage.delete(key: 'token');
  // }

  // static final _storage = FlutterSecureStorage();

  static Future<void> logout(BuildContext context) async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }
  static const String base = "https://eventrush.onrender.com/api";

  //  static Future<Map<String, dynamic>> register({
  //   required String nom,
  //   required String email,
  //   required String password,
  //   required String passwordConfirmation,
  // }) async {
  //   final response = await http.post(
  //     Uri.parse("$base/auth/register"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       "nom": nom,
  //       "email": email,
  //       "password": password,
  //       "password_confirmation": passwordConfirmation,
  //     }),
  //   );

  //   return {
  //     "status": response.statusCode,
  //     "body": jsonDecode(response.body),
  //   };
  // }
  static Future<Map<String, dynamic>> register({
    required String nom,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$base/auth/register"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "nom": nom,
              "email": email,
              "password": password,
              "password_confirmation": passwordConfirmation,
            }),
          )
          .timeout(const Duration(seconds: 15)); // ⏱️ timeout

      return {
        "status": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      return {
        "status": 500,
        "body": {"message": "Erreur réseau ou serveur inaccessible - $e"},
      };
    }
  }


  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse("$base/auth/verifymailByOtp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    return {
      "status": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }
  Future<Map<String, dynamic>> getScannreEvents(String token) async {
    final url = Uri.parse("$baseUrl/scanneur/event");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // ✅ Succès : on parse le JSON
      final data = json.decode(response.body);
      return {
        "success": true,
        "events": data["evenement"] ?? [],
        "total": data["total_event"] ?? 0,
      };
    } else {
      // ❌ Erreur : on renvoie le message
      final errorData = json.decode(response.body);
      return {
        "success": false,
        "message": errorData["error"] ?? "Erreur inconnue",
        "status": response.statusCode,
      };
    }
  }
}
