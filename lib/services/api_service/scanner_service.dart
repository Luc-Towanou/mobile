import 'dart:convert';
import 'package:event_rush_mobile/scanners/scanner_model.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;
// import 'scanner_model.dart';

class ScannerService {
  final baseUrl = "https://eventrush.onrender.com/api";

  // ScannerService({});

  Future<List<Ticket>> fetchScannedTickets() async {
    final url = Uri.parse('$baseUrl/scanneur/mes-billets-scannes');
        final token = await AuthService.getToken();

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': "Bearer $token", // si tu utilises Sanctum/JWT
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final billets = data['billets'] as List;
      return billets.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des billets scannés');
    }
  }
}
