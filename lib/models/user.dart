import 'package:intl/intl.dart';

class User {
  final int id;
  final String nom;
  final String email;
  final String? avatar;
  final String role;
  final String statutCompte;
  final bool estActif;
  final bool emailVerifie;
  final int points;
  final bool? souscriptionActive;
  final DateFormat? createdAt = DateFormat('dd/MM/yyyy');


  User({
    required this.id,
    required this.nom,
    required this.email,
    this.avatar,
    required this.role,
    required this.statutCompte,
    required this.estActif,
    required this.emailVerifie,
    required this.points,
    this.souscriptionActive,
    // this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      avatar: json['avatar'],
      role: json['role'],
      statutCompte: json['statut_compte'],
      estActif: json['est_actif'],
      emailVerifie: json['email_verifie'],
      points: json['points']?? 0,
      // Gérer le null et convertir en bool
      souscriptionActive: json['souscription_actived'] ?? false,
      // createdAt: DateFormat('dd/MM/yyyy') ?? DateFormat('dd/MM/yyyy'),
    );
  }
}
