
// class Organizer {
//   final int id;
//   final String name;
//   final String image;
//   final String description;
//   final double rating;
//   final int eventsCount;
//   final int followers;
//   final int points;
//   final List<Post> posts;

//   Organizer.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['title'],
//         subtitle = json['subtitle'],
//         content = json['content'],
//         image = json['image'],
//         date = DateTime.parse(json['date']),
//         likes = json['likes'],
//         comments = (json['comments'] as List)
//             .map((c) => CommentModel.fromJson(c))
//             .toList();
  // Organizer({
  //   required this.id,
  //   required this.name,
  //   required this.image,
  //   required this.description,
  //   required this.rating,
  //   required this.eventsCount,
  //   required this.followers,
  //   required this.points,
  //   required this.posts,
  // });
// }

class Post {
  final int id;
  final String title;
  final String subtitle;
  final String content;
  final String image;
  final DateTime date;
  final int likes;
  final List<Comment> comments;

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        subtitle = json['subtitle'],
        content = json['content'],
        image = json['image'],
        date = DateTime.parse(json['date']),
        likes = json['likes'],
        comments = (json['comments'] as List)
            .map((c) => Comment.fromJson(c))
            .toList();
}
class Organizer {
  final int id;
  final String name;
  final String image;
  final String description;
  final double rating;
  final int eventsCount;
  final int followers;
  final int points;
  final List<Post> posts;

  Organizer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        description = json['description'],
        rating = (json['rating'] as num).toDouble(),
        eventsCount = json['events_count'],
        followers = json['followers'],
        points = json['points'],
        posts = (json['posts'] as List)
            .map((p) => Post.fromJson(p))
            .toList();
}


// c

class Comment {
  final String user;
  final String text;
  final DateTime date;

  Comment.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        text = json['text'],
        date = DateTime.parse(json['date']);

  // Comment({
  //   required this.user,
  //   required this.text,
  //   required this.date,
  // });
}

class OrganizersHubResponse {
  final Organizer featured;
  final List<Organizer> organizers;
  final Map<String, dynamic> stats;
  final Map<String, dynamic> quote;

  OrganizersHubResponse.fromJson(Map<String, dynamic> json)
      : featured = Organizer.fromJson(json['featured']),
        organizers = (json['organizers'] as List)
            .map((o) => Organizer.fromJson(o))
            .toList(),
        stats = json['statistics'],
        quote = json['quote'];
}
