

class UserModel {
  final String id;
  final String nom;
  final String email;
  final String? avatar;
  final String role;
  final int points;
  final String statutCompte;

  UserModel({
    required this.id,
    required this.nom,
    required this.email,
    this.avatar,
    required this.role,
    required this.points,
    required this.statutCompte,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      nom: json['nom'],
      email: json['email'],
      avatar: json['avatar'],
      role: json['role'],
      points: json['points'] ?? 0,
      statutCompte: json['statut_compte'],
    );
  }
}

class StoryModel {
  final String id;
  final String mediaPath;
  final DateTime expiresAt;
  final UserModel user;

  StoryModel({
    required this.id,
    required this.mediaPath,
    required this.expiresAt,
    required this.user,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'].toString(),
      mediaPath: json['media_path'],
      expiresAt: DateTime.parse(json['expires_at']),
      user: UserModel.fromJson(json['utilisateurs']),
    );
  }
}


class ClipModel {
  final String id;
  final String description;
  final String type;
  final String mediaPath;
  final String eventId;
  final UserModel user;

  ClipModel({
    required this.id,
    required this.description,
    required this.type,
    required this.mediaPath,
    required this.eventId,
    required this.user,
  });

  factory ClipModel.fromJson(Map<String, dynamic> json) {
    return ClipModel(
      id: json['id'].toString(),
      description: json['description'] ?? '',
      type: json['type'],
      mediaPath: json['media_path'],
      eventId: json['event_id'].toString(),
      user: UserModel.fromJson(json['utilisateurs']),
    );
  }
}



class ArticleModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String cover;
  final String readTime;
  final UserModel user;

  ArticleModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.cover,
    required this.readTime,
    required this.user,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'].toString(),
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      cover: json['cover'],
      readTime: json['read_time'],
      user: UserModel.fromJson(json['utilisateurs']),
    );
  }
}


class PromoModel {
  final String id;
  final String title;
  final String caption;
  final String image;
  final String type;

  PromoModel({
    required this.id,
    required this.title,
    required this.caption,
    required this.image,
    required this.type,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'].toString(),
      title: json['title'],
      caption: json['caption'],
      image: json['image'],
      type: json['type'],
    );
  }
}


class CommunityPostModel {
  final String id;
  final String contenu;
  final UserModel user;

  CommunityPostModel({
    required this.id,
    required this.contenu,
    required this.user,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'].toString(),
      contenu: json['contenu'],
      user: UserModel.fromJson(json['utilisateurs']),
    );
  }
}

class AgendaEventModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final int billetsCount;

  AgendaEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateDebut,
    this.dateFin,
    required this.billetsCount,
  });

  factory AgendaEventModel.fromJson(Map<String, dynamic> json) {
    return AgendaEventModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'] ?? '',
      dateDebut: DateTime.parse(json['date_debut']),
      dateFin: json['date_fin'] != null ? DateTime.parse(json['date_fin']) : null,
      billetsCount: json['_count']?['billets'] ?? 0,
    );
  }
}



class FeedEventNewsResponse {
  final List<StoryModel> stories;
  final List<ClipModel> clips;
  final List<ArticleModel> articles;
  final List<PromoModel> promos;
  final List<CommunityPostModel> communityPosts;
  final List<AgendaEventModel> agenda;

  FeedEventNewsResponse({
    required this.stories,
    required this.clips,
    required this.articles,
    required this.promos,
    required this.communityPosts,
    required this.agenda,
  });

  // factory FeedEventNewsResponse.fromJson(Map<String, dynamic> json) {
  //   return FeedEventNewsResponse(
  //     stories: (json['stories'] as List)
  //         .map((e) => StoryModel.fromJson(e))
  //         .toList(),

  //     clips: (json['clips'] as List)
  //         .map((e) => ClipModel.fromJson(e))
  //         .toList(),

  //     articles: (json['articles'] as List)
  //         .map((e) => ArticleModel.fromJson(e))
  //         .toList(),

  //     promos: (json['promos'] as List)
  //         .map((e) => PromoModel.fromJson(e))
  //         .toList(),

  //     communityPosts: (json['communityPosts'] as List)
  //         .map((e) => CommunityPostModel.fromJson(e))
  //         .toList(),

  //     agenda: (json['agenda'] as List)
  //         .map((e) => AgendaEventModel.fromJson(e))
  //         .toList(),
  //   );
  // }

  factory FeedEventNewsResponse.fromJson(Map<String, dynamic> json) {
    return FeedEventNewsResponse(
      stories: (json['stories'] as List? ?? [])
          .map((e) => StoryModel.fromJson(e))
          .toList(),

      clips: (json['clips'] as List? ?? [])
          .map((e) => ClipModel.fromJson(e))
          .toList(),

      articles: (json['articles'] as List? ?? [])
          .map((e) => ArticleModel.fromJson(e))
          .toList(),

      promos: (json['promos'] as List? ?? [])
          .map((e) => PromoModel.fromJson(e))
          .toList(),

      communityPosts: (json['communityPosts'] as List? ?? [])
          .map((e) => CommunityPostModel.fromJson(e))
          .toList(),

      agenda: (json['agenda'] as List? ?? [])
          .map((e) => AgendaEventModel.fromJson(e))
          .toList(),
    );
  }

}
