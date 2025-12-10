//services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed_item.dart';

class ApiService {
  static const String baseUrl = 'https://node-eventrush-docker.onrender.com';
  final String authToken;

  ApiService(this.authToken);

  Future<FeedResponse> fetchFeed(String pageType, {String? cursor, int limit = 20}) async {
  final Map<String, String> queryParams = {
    'limit': limit.toString(),
    'pageType': pageType,
  };
  
  if (cursor != null) {
    queryParams['cursor'] = cursor;
  }

  final uri = Uri.parse('$baseUrl/feed').replace(queryParameters: queryParams);
  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    try {
      final body = jsonDecode(response.body);
      print("Réponse brute: ${response.body}");

      final data = body['data'];
      print("Data length: ${data.length}");

      for (var item in data) {
        print("Feed item type: ${item['type']}, payload: ${item['payload']}");
      }
      return FeedResponse.fromJson(json.decode(response.body));
      // ensuite ton parsing normal...
    } catch (e, stack) {
        print("Erreur de parsing: $e");
        print("Stack trace: $stack");
        throw Exception("Erreur de parsing feed: $e");
      }

  } else {
    throw Exception('Failed to load feed: ${response.statusCode}\n ${response.body}');
  }
}

  // Future<FeedResponse> fetchFeed(String pageType, {String? cursor, int limit = 20}) async {
  //   final Map<String, String> queryParams = {
  //     'limit': limit.toString(),
  //     'pageType': pageType,
  //   };
    
  //   if (cursor != null) {
  //     queryParams['cursor'] = cursor;
  //   }

  //   final uri = Uri.parse('$baseUrl/feed').replace(queryParameters: queryParams);
  //   final response = await http.get(
  //     uri,
  //     headers: {
  //       'Authorization': 'Bearer $authToken',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return FeedResponse.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load feed: ${response.statusCode}');
  //   } 
  // }

  // Autres méthodes pour interactions (like, achat, etc.)
}