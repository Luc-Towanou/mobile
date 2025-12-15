class MyEventsResponse {
  final List<MyEvent> favoris;
  final List<MyEvent> participations;
  final List<MyEvent> organisateur;

  MyEventsResponse({
    required this.favoris,
    required this.participations,
    required this.organisateur,
  });

  factory MyEventsResponse.fromJson(Map<String, dynamic> json) {
    return MyEventsResponse(
      favoris: (json['participant']['favoris'] as List)
          .map((e) => MyEvent.fromJson(e))
          .toList(),

      participations: (json['participant']['participations'] as List)
          .map((e) => MyEvent.fromJson(e))
          .toList(),

      organisateur: (json['organisateur'] as List)
          .map((e) => MyEvent.fromJson(e))
          .toList(),
    );
  }
}


class MyEvent {
  final int id;
  final String title;
  final String date;
  final String location;
  final String image;

  MyEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
  });

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    return MyEvent(
      id: json['id'],
      title: json['titre'],
      date: json['date_event'] ?? json['date'],
      location: json['lieu'],
      image: json['image_url'] ?? "https://picsum.photos/400/200",
    );
  }
}
