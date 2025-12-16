import 'dart:convert';
import 'package:event_rush_mobile/models/organizer.dart';
import 'package:http/http.dart' as http;

class OrganizersService {
  final String baseUrl = 'https://eventrush.onrender.com/api'; // 🔁 adapte

  Future<OrganizersHubResponse> fetchHub({String? search}) async {
    final uri = Uri.parse(
      '$baseUrl/organizers/hub${search != null ? '?search=$search' : ''}',
    );

    final res = await http.get(uri);
      ('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');
    if (res.statusCode != 200) {
      throw Exception('Failed to load organizers');
    }

    return OrganizersHubResponse.fromJson(json.decode(res.body));
  }

  Future<void> followOrganizer(int organizerId) async {
    await http.post(
      Uri.parse('$baseUrl/suivis/suivre/$organizerId'),
    );
  }

  Future<void> addComment(int postId,  String text) async {
    var type = 'post';
    await http.post(
      Uri.parse('$baseUrl/commentaires/$type/comment/$postId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'contenu': text}),
    );
  }
}
