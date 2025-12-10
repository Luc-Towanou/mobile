class FeedItem {
  final String? id;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime? timestamp;
  final int? priority;

  FeedItem({
    this.id,
    required this.type,
    required this.payload,
    this.timestamp,
    this.priority = 0,
  });

  // factory FeedItem.fromJson(Map<String, dynamic> json) {
  //   final payload = json['payload'] as Map<String, dynamic>? ?? {};

  //  try {

  //   return FeedItem(
  //     id: json['id'] ?? payload['id']?.toString(), // 👈 récupère l'id du payload
  //     type: json['type'] ?? '',
  //     payload: json['payload'] ?? {},
  //     timestamp: DateTime.parse(json['timestamp']) != null ? DateTime.parse(json['timestamp']) : null,
  //     priority: json['priority'] ?? 0,
  //   );
  //   // return FeedItem(
  //   //   type: json['type'] ?? '',
  //   //   payload: json['payload'] ?? {},
  //   // );
  // } catch (e) {
  //   print("Erreur dans FeedItem.fromJson: $e");
  //   print("Json reçu: $json");
  //   rethrow;
  // }
  factory FeedItem.fromJson(Map<String, dynamic> json) {
    try {
      return FeedItem(
        id: json['id']?.toString(),
        type: json['type'] ?? "unknown",
        payload: json['payload'] ?? {},
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'])
            : null,
        priority: json['priority'] ?? 0,
      );
    } catch (e) {
      print("Erreur dans FeedItem.fromJson: $e");
      print("Json reçu: $json");
      rethrow;
    }
  }

    // return FeedItem(
    //   id: json['id'] ?? payload['id']?.toString(), // 👈 récupère l'id du payload
    //   type: json['type'] ?? '',
    //   payload: json['payload'],
    //   timestamp: DateTime.parse(json['timestamp']) != null ? DateTime.parse(json['timestamp']) : null,
    //   priority: json['priority'] ?? 0,
    // );
  // }
}


class FeedResponse {
  final List<FeedItem> items;
  final String? cursor;
  final bool hasMore;

  FeedResponse({
    required this.items,
    this.cursor,
    this.hasMore = false,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      items: (json['data'] as List<dynamic>?)
              ?.map((e) => FeedItem.fromJson(e))
              .toList() 
              ?? [],
      cursor: json['nextCursor'] as String?, // 👈 correspond bien au back
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}


// class FeedResponse {
//   final String? cursor;
//   final List<FeedItem> items;
//   final bool hasMore;

//   FeedResponse({
//     this.cursor,
//     required this.items,
//     required this.hasMore,
//   });

//   factory FeedResponse.fromJson(Map<String, dynamic> json) {
//     return FeedResponse(
//       cursor: json['cursor'],
//       items: (json['items'] as List)
//           .map((item) => FeedItem.fromJson(item))
//           .toList(),
//       hasMore: json['hasMore'] ?? true,
//     );
//   }
// }