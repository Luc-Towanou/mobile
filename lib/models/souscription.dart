class SubscriptionPlan {
  final String nom;
  final int prix;

  SubscriptionPlan({required this.nom, required this.prix});

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      nom: json['nom'] ?? 'Inconnu',
      prix: json['prix'] ?? 0,
    );
  }
}

class Subscription {
  final int id;
  final String dateDebut;
  final String dateFin;
  final String statut;
  final String? methode;
  final int montant;
  final SubscriptionPlan plan;

  Subscription({
    required this.id,
    required this.dateDebut,
    required this.dateFin,
    required this.statut,
    this.methode,
    required this.montant,
    required this.plan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      statut: json['statut'],
      montant: json['montant'],
      methode: json['methode'],
      plan: SubscriptionPlan.fromJson(json['plan']),
    );
  }
}