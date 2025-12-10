import 'dart:convert';
import 'package:event_rush_mobile/pages/dashboard/events_page.dart';
import 'package:event_rush_mobile/pages/event_detail_page.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
// import 'package:event_rush_mobile/pages/event_page.dart';
import 'package:http/http.dart' as http;

class EventsService {
  final String baseUrl = 'https://eventrush.onrender.com/api'; // si tu utilises l'émulateur Android
  // final token = await AuthService.getToken();
  final Future<String?> token = AuthService.getToken();
  // final String token = "531|D5x0ChCwv7hpFYw0skQ8OxdTKOcnJAJV19mc2voU891baf93"; // à remplacer par ton vrai Bearer token

  Future<List<Event>> index() async {
  final response = await http.get(Uri.parse('$baseUrl/events'));

  if (response.statusCode != 200) {
    throw Exception("Erreur serveur : ${response.statusCode}");
  }

  final decoded = jsonDecode(response.body);

  List<dynamic> rawEvents;

  if (decoded is Map && decoded.containsKey('data')) {
    rawEvents = List<dynamic>.from(decoded['data']);
  } else if (decoded is Map) {
    rawEvents = decoded.values.toList();
  } else if (decoded is List) {
    rawEvents = decoded;
  } else {
    throw Exception("Format inattendu pour les événements");
  }

  // ✅ Conversion en List<Event>
  return rawEvents.map((e) => Event.fromJson(e)).toList();
}

//  Future<List<dynamic>> getUpcoming() async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/home/upcoming"),
//       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body)["data"]; // adapte si structure différente
//     } else {
//       throw Exception("Erreur upcoming : ${response.body}");
//     }
//   }

//   Future<List<Event>> fetchUpcoming() async {
//   try {
//     final response = await http.get(
//       Uri.parse("$baseUrl/home/upcoming"),
//       headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);

//       final List<dynamic> dataJson = body["data"];
//       final List<Event> data =
//           dataJson.map((e) => Event.fromJson(e)).toList();

//       print("Upcoming taille: ${data.length} ✅");
//       return data; // 🔥 on retourne la liste
//     } else {
//       print("Erreur serveur: ${response.statusCode}");
//       return []; // retourne liste vide en cas d’erreur
//     }
//   } catch (e) {
//     print("Erreur fetchUpcoming: $e");
//     return [];
//   }
// }



//   Future<List<dynamic>> getPopular({int min = 90}) async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/home/popular?min=$min"),
//       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body)["data"];
//     } else {
//       throw Exception("Erreur popular : ${response.body}");
//     }
//   }
  
//   Future<List<Event>> fetchPopularNear({required double lat, required double lng}) async {
//   final url = Uri.parse("$baseUrl/home/nearEvents?latitude=$lat&longitude=$lng");
//   final response = await http.get(url, headers: {
//     "Accept": "application/json",
//     "Authorization": "Bearer $token",
//   });

//   if (response.statusCode == 200) {
//     final body = jsonDecode(response.body);
//     final List<dynamic> dataJson = body["data"];
//     return dataJson.map((e) => Event.fromJson(e)).toList();
//   } else {
//     throw Exception("Failed to load near events : ${response.body}, $token");
//   }
// }


//   Future<List<dynamic>> getNearEvents(double latitude, double longitude) async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/home/nearEvents?latitude=$latitude&longitude=$longitude"),
//       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body)["data"];
//     } else {
//       throw Exception("Erreur nearEvents : ${response.body}");
//     }
    
//   }

//     // Popular (with min param)
//     Future<List<Event>> fetchPopular({int min = 90}) async {
//       final url = Uri.parse("$baseUrl/home/popular?min=$min");
//       final response = await http.get(url, headers: {"Accept": "application/json", "Authorization": "Bearer $token"},);
//       if (response.statusCode == 200) {
//         final List data = jsonDecode(response.body);
//         return data.map((e) => Event.fromJson(e)).toList();
//       } else {
//         throw Exception("Failed to load popular events");
//       }
//     }

  
//   Future<Map<String, dynamic>> loginScanners(String nom, String password) async {
//     final url = Uri.parse('$baseUrl/auth/login/scanneurs');
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json", 
//       },
//       body: jsonEncode({"nom": nom, "password": password}),
//     );

//     if (response.statusCode == 200) {
//       // await storage.write(key: "token", value: data["access_token"]);
//       // await storage.write(key: "role", value: data["role"]); // si besoin
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Erreur : ${response.statusCode} => ${response.body}');
//     }
//   }

  Future<EventShow> fetchEventById(int eventId) async {
    final response = await http.get(Uri.parse("$baseUrl/events/$eventId"));
    print("fetchEventById réussi : $eventId, statut code :${response.statusCode}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'];
      print ("organisateur : nom : ${data['organisateur']['utilisateur']['nom']}");
      print ("note moyenne : ${data['commentaires']},");
      // print ("ticketsnom : ${data['organisateur']['utilisateur']['nom']}");
      return EventShow(
        id: data['id'],
        titre: data['titre'],
        description: data['description'],
        affiche: data['affiche_url'] ?? '',
        dateDebutIso: data['date_debut'],
        dateFinIso: data['date_fin'],
        lieu: data['lieu'],
        latitude: double.tryParse(data['latitude'] ?? '0') ?? 0,
        longitude: double.tryParse(data['longitude'] ?? '0') ?? 0,
        organizer: data['organisateur'] != null
            ? Organizer(
                id: data['organisateur']['id'],
                nom: data['organisateur']['utilisateur']['nom'],
                avatarUrl: data['organisateur']['logo'],
              )
            : Organizer(id: 0, nom: "Inconnu"),
        stats: Stats(
          vues: data['stats']['vues'],
          partages: data['stats']['partages'],
          likes: data['stats']['favoris'],
        ),
        commentsSummary: CommentsSummary(
          total: data['nombre_commentaires'],
          positifs: 0, // tu peux calculer selon ton API
          negatifs: 0,
          moyenneEtoiles: (data['moyenne_notes'] ?? 0).toDouble(),
        ),
        comments: (data['commentaires'] as List)
            .map((c) => Comment(
                  auteur: c['auteur'] ?? 'Anonyme',
                  contenu: c['contenu'] ?? '',
                  etoiles: c['etoiles'] ?? 0,
                  date: DateTime.parse(c['created_at']),
                ))
            .toList(),
        tickets: (data['tickets'] as List)
            .map((t) => Ticket(
                  id: t['id'].toString(),
                  nom: t['type'],
                  description: t['description'] ?? '',
                  prix: (t['prix'] ?? 0).toDouble(),
                  devise: t['devise'] ?? 'XOF',
                  stock: t['quantite_restante'] ?? 0,
                ))
            .toList(),
      );
    } else {
      throw Exception("Erreur lors du chargement de l'événement");
    }
  }

  static const base = "https://eventrush.onrender.com/api";

  static Future<void> react(String reactableType, int eventId, String type) async {
    final token = await AuthService.getToken();
    await http.post(
      Uri.parse('$base/reactions/toggle'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "reactable_type": "event",
        "reactable_id": eventId,
        'type': type

        }),
    );
  }

  static Future<void> share(String shareableType, int shareableId) async {
    final token = await AuthService.getToken();
    await http.post(
      Uri.parse('$base/shares'),
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode({
        "shareable_type": shareableType,
        "shareable_id": shareableId,

      }),
    );
    
  }

  static Future<void> commentEvent(int eventId, String content, int stars) async {
    final token = await AuthService.getToken();
    await http.post(
      Uri.parse('$base/evenements/$eventId/commentaires'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'contenu': content,
        'note': stars
      }),
    );
  }


}