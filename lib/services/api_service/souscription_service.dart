import 'dart:convert';
import 'package:event_rush_mobile/auth/login_page.dart';
import 'package:event_rush_mobile/outils/sous_web_view.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> launchPayment(BuildContext context, int planId) async {
  // Afficher un loader
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: Color.fromARGB(255, 243, 152, 33)),
    ),
  );
  try {
    final url = Uri.parse("https://eventrush.onrender.com/api/souscriptions");
    final token = await AuthService.getToken();
    if (token == null) {
      // throw Exception("Pas de token");
        print("token non trouvé : null");
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
      return; 
    }
    print("in launshPayment $planId");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer $token', // ⚠️ remplace par ton vrai token
      },
      body: jsonEncode({
        "plans_souscription_id": planId,
      }),
    );
    print("reponse api : ${response.body}, statut : ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final checkoutUrl = data["payment_url"];

      if (checkoutUrl != null) {
        // ✅ Fermer le loader AVANT d'ouvrir la WebView
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(checkoutUrl: checkoutUrl),
          ),
        );
      } else {
        throw Exception("Pas d'URL de paiement dans la réponse");
      }
    } else {
      throw Exception("Erreur backend : ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    Navigator.pop(context); // Fermer le loader en cas d'erreur
    rethrow;
  }
  
}
