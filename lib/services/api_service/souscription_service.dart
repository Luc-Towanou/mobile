import 'dart:convert';
import 'package:event_rush_mobile/outils/sous_web_view.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> launchPayment(BuildContext context, int planId) async {
  final url = Uri.parse("https://eventrush.onrender.com/api/souscriptions");
  final token = await AuthService.getToken();
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
      Navigator.push(
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
}
