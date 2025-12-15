// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class OrganizersPage extends StatefulWidget {
//   @override
//   _OrganizersPageState createState() => _OrganizersPageState();
// }

// class _OrganizersPageState extends State<OrganizersPage> {
//   int? _expandedOrganizerId;
//   int? _expandedPostId;

//   void _navigateToHomePage() {
//     Navigator.pushReplacementNamed(context, '/');
//   }

//   // Données des organisateurs
//   final List<Organizer> _organizers = [
//     Organizer(
//       id: 1,
//       name: "Festival Horizon",
//       image: "https://picsum.photos/400/300?random=10",
//       description: "Organisateur de festivals de musique et d'événements culturels depuis 2010. Nous créons des expériences mémorables à travers la France.",
//       rating: 4.8,
//       eventsCount: 47,
//       followers: 12500,
//       points: 9850,
//       posts: [
//         Post(
//           id: 101,
//           title: "Nouveau Festival Annoncé!",
//           subtitle: "Horizon 2023 sera le plus grand événement de l'année",
//           content: "Nous sommes ravis d'annoncer notre nouveau festival Horizon 2023 qui se tiendra du 15 au 17 juillet au Parc des Expositions. Au programme: 30 artistes internationaux, des food trucks, des activités et bien plus encore!\n\nLes billets seront en vente à partir de lundi prochain. Restez connectés!",
//           image: "https://picsum.photos/600/400?random=101",
//           date: DateTime.now().subtract(Duration(days: 2)),
//           likes: 245,
//           comments: [
//             Comment(
//               user: "Marie L.",
//               text: "J'adore cet organisateur! Toujours des événements incroyables!",
//               date: DateTime.now().subtract(Duration(hours: 5)),
//             ),
//             Comment(
//               user: "Thomas D.",
//               text: "Je ne peux pas attendre! L'année dernière c'était génial!",
//               date: DateTime.now().subtract(Duration(hours: 3)),
//             ),
//           ],
//         ),
//         Post(
//           id: 102,
//           title: "Appel aux Bénévoles",
//           subtitle: "Rejoignez notre équipe pour le festival Horizon",
//           content: "Nous recherchons des bénévoles passionnés pour nous aider à faire du festival Horizon 2023 un succès. En échange de votre aide, vous recevrez un accès gratuit au festival, des repas et une expérience unique!\n\nContactez-nous à volunteers@festivalhorizon.fr pour plus d'informations.",
//           image: "https://picsum.photos/600/400?random=102",
//           date: DateTime.now().subtract(Duration(days: 5)),
//           likes: 178,
//           comments: [
//             Comment(
//               user: "Julie M.",
//               text: "Je suis intéressée! Combien d'heures par jour?",
//               date: DateTime.now().subtract(Duration(days: 4)),
//             ),
//           ],
//         ),
//       ],
//     ),
//     Organizer(
//       id: 2,
//       name: "Art & Culture Paris",
//       image: "https://picsum.photos/400/300?random=20",
//       description: "Promouvoir l'art sous toutes ses formes à Paris et en région parisienne. Expositions, vernissages et rencontres artistiques.",
//       rating: 4.6,
//       eventsCount: 32,
//       followers: 8900,
//       points: 7650,
//       posts: [
//         Post(
//           id: 201,
//           title: "Exposition Street Art",
//           subtitle: "Découvrez les nouveaux talents du street art parisien",
//           content: "Notre nouvelle exposition met en lumière 15 artistes émergents de la scène street art parisienne. Du 10 juin au 15 juillet à la Galerie Urbaine.\n\nVernissage le 9 juin à 18h avec performance live de deux artistes!",
//           image: "https://picsum.photos/600/400?random=201",
//           date: DateTime.now().subtract(Duration(days: 1)),
//           likes: 192,
//           comments: [
//             Comment(
//               user: "Luc T.",
//               text: "Le street art mérite vraiment plus de reconnaissance!",
//               date: DateTime.now().subtract(Duration(hours: 10)),
//             ),
//           ],
//         ),
//       ],
//     ),
//     Organizer(
//       id: 3,
//       name: "Sports Events FR",
//       image: "https://picsum.photos/400/300?random=30",
//       description: "Organisateur d'événements sportifs partout en France. Marathons, trails, compétitions et challenges pour tous les niveaux.",
//       rating: 4.7,
//       eventsCount: 28,
//       followers: 11200,
//       points: 8320,
//       posts: [
//         Post(
//           id: 301,
//           title: "Marathon de Paris 2023",
//           subtitle: "Inscriptions ouvertes pour l'édition 2023",
//           content: "Les inscriptions pour le Marathon de Paris 2023 sont officiellement ouvertes! Relevez le défi le 15 octobre prochain sur un parcours revisité avec de nouvelles surprises.\n\nÉconomisez 10% avec le code EARLYBIRD valable jusqu'au 30 juin.",
//           image: "https://picsum.photos/600/400?random=301",
//           date: DateTime.now().subtract(Duration(days: 3)),
//           likes: 321,
//           comments: [
//             Comment(
//               user: "Pierre A.",
//               text: "J'ai participé l'année dernière, organisation impeccable!",
//               date: DateTime.now().subtract(Duration(days: 2)),
//             ),
//             Comment(
//               user: "Sophie M.",
//               text: "Quel est le délai pour les remboursements en cas d'empêchement?",
//               date: DateTime.now().subtract(Duration(days: 1)),
//             ),
//           ],
//         ),
//         Post(
//           id: 302,
//           title: "Nouveau Trail en Montagne",
//           subtitle: "Découvrez notre nouveau trail dans les Alpes",
//           content: "Nous lançons un nouveau trail de 25km avec 1500m de dénivelé positif dans le massif des Alpes. Date prévue: 12 août 2023.\n\nInscriptions limitées à 500 participants pour préserver l'environnement naturel.",
//           image: "https://picsum.photos/600/400?random=302",
//           date: DateTime.now().subtract(Duration(days: 7)),
//           likes: 154,
//           comments: [],
//         ),
//       ],
//     ),
//     Organizer(
//       id: 4,
//       name: "Gastronomy Events",
//       image: "https://picsum.photos/400/300?random=40",
//       description: "Événements culinaires, dégustations, rencontres avec des chefs et ateliers de cuisine pour les gastronomes.",
//       rating: 4.9,
//       eventsCount: 19,
//       followers: 7600,
//       points: 6980,
//       posts: [
//         Post(
//           id: 401,
//           title: "Festival des Saveurs",
//           subtitle: "La 5ème édition revient plus goûteuse que jamais",
//           content: "Le Festival des Saveurs revient pour sa 5ème édition du 20 au 22 octobre. Plus de 50 exposants, des chefs étoilés, des ateliers et des démonstrations culinaires.\n\nBillets en prévente à partir de demain!",
//           image: "https://picsum.photos/600/400?random=401",
//           date: DateTime.now().subtract(Duration(days: 4)),
//           likes: 287,
//           comments: [
//             Comment(
//               user: "Antoine C.",
//               text: "J'ai hâte! L'année dernière c'était délicieux!",
//               date: DateTime.now().subtract(Duration(days: 3)),
//             ),
//           ],
//         ),
//       ],
//     ),
//     Organizer(
//       id: 5,
//       name: "Tech Conference FR",
//       image: "https://picsum.photos/400/300?random=50",
//       description: "Conférences, meetups et workshops sur les technologies émergentes, l'innovation et le digital.",
//       rating: 4.5,
//       eventsCount: 23,
//       followers: 6800,
//       points: 6120,
//       posts: [
//         Post(
//           id: 501,
//           title: "Conférence IA 2023",
//           subtitle: "Les dernières avancées en intelligence artificielle",
//           content: "Notre conférence annuelle sur l'IA revient les 15 et 16 novembre. Au programme: keynotes de chercheurs renommés, workshops techniques et networking.\n\nEarly bird tickets disponibles avec 20% de réduction cette semaine seulement!",
//           image: "https://picsum.photos/600/400?random=501",
//           date: DateTime.now().subtract(Duration(days: 6)),
//           likes: 203,
//           comments: [
//             Comment(
//               user: "Marc D.",
//               text: "Quels sont les orateurs confirmés cette année?",
//               date: DateTime.now().subtract(Duration(days: 5)),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ];

//   // Trouver l'organisateur avec le plus de points
//   Organizer get featuredOrganizer {
//     return _organizers.reduce((a, b) => a.points > b.points ? a : b);
//   }

//   // Autres organisateurs (sans le featured)
//   List<Organizer> get otherOrganizers {
//     return _organizers.where((o) => o.id != featuredOrganizer.id).toList();
//   }

//   void _toggleOrganizerExpansion(int organizerId) {
//     setState(() {
//       if (_expandedOrganizerId == organizerId) {
//         _expandedOrganizerId = null;
//         _expandedPostId = null;
//       } else {
//         _expandedOrganizerId = organizerId;
//       }
//     });
//   }

//   void _togglePostExpansion(int postId) {
//     setState(() {
//       if (_expandedPostId == postId) {
//         _expandedPostId = null;
//       } else {
//         _expandedPostId = postId;
//       }
//     });
//   }

//   void _closeAllSections() {
//     setState(() {
//       _expandedOrganizerId = null;
//       _expandedPostId = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // leading: IconButton(
//         //   icon: Icon(Icons.arrow_back),
//         //   // onPressed: () => Navigator.of(context).pop(), //_navigateToHomePage
//         //   onPressed: _navigateToHomePage,
          
//         // ),
//         title: Text('Organisateurs & Actualités'),
//         backgroundColor: const Color.fromARGB(255, 109, 34, 80),
//         elevation: 0,
//       ),
//       floatingActionButton: _expandedOrganizerId != null
//           ? FloatingActionButton(
//               onPressed: _closeAllSections,
//               child: Icon(Icons.close),
//               backgroundColor: Color.fromARGB(255, 253, 166, 35),
//             )
//           : null,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Organisateur vedette
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Organisateur à la une',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 243, 47, 168),
//                 ),
//               ),
//             ),
//             _buildOrganizerCard(featuredOrganizer, true),
            
//             // Autres organisateurs
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Tous les organisateurs',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 243, 47, 168),
//                 ),
//               ),
//             ),
//             ...otherOrganizers.map((organizer) => _buildOrganizerCard(organizer, false)),
            
//             // Section statistiques
//             _buildStatisticsSection(),
            
//             // Section citation inspirante
//             _buildQuoteSection(),
            
//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrganizerCard(Organizer organizer, bool isFeatured) {
//     final isExpanded = _expandedOrganizerId == organizer.id;
    
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         children: [
//           // Header de l'organisateur
//           ListTile(
//             leading: CircleAvatar(
//               radius: 30,
//               backgroundImage: NetworkImage(organizer.image),
//             ),
//             title: Text(
//               organizer.name,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: isFeatured ? 18 : 16,
//                 color: isFeatured ? Colors.deepPurple : Colors.black,
//               ),
//             ),
//             subtitle: Text(
//               '${organizer.eventsCount} événements • ${organizer.followers} abonnés',
//               style: TextStyle(fontSize: 12),
//             ),
//             trailing: isFeatured
//                 ? Chip(
//                     label: Text('À la une', style: TextStyle(color: Colors.white)),
//                     backgroundColor: Colors.amber[700],
//                   )
//                 : IconButton(
//                     icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
//                     onPressed: () => _toggleOrganizerExpansion(organizer.id),
//                   ),
//             onTap: () => _toggleOrganizerExpansion(organizer.id),
//           ),
          
//           // Description (toujours visible pour l'organisateur vedette)
//           if (isFeatured || isExpanded) 
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Text(
//                 organizer.description,
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//             ),
          
//           // Stats de l'organisateur
//           if (isFeatured || isExpanded)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildOrganizerStat(Icons.star, '${organizer.rating}', 'Note'),
//                   _buildOrganizerStat(Icons.emoji_events, '${organizer.points}', 'Points'),
//                   _buildOrganizerStat(Icons.event, '${organizer.eventsCount}', 'Événements'),
//                 ],
//               ),
//             ),
          
//           // Posts de l'organisateur (seulement si développé)
//           if (isExpanded) 
//             ...organizer.posts.map((post) => _buildPostCard(post)).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrganizerStat(IconData icon, String value, String label) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: Colors.deepPurple),
//         SizedBox(height: 4),
//         Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
//       ],
//     );
//   }

//   Widget _buildPostCard(Post post) {
//     final isExpanded = _expandedPostId == post.id;
    
//     return Container(
//       margin: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey[200]!),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Image du post
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//             child: Image.network(
//               post.image,
//               height: 180,
//               fit: BoxFit.cover,
//             ),
//           ),
          
//           // Titre et sous-titre
//           ListTile(
//             title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(post.subtitle),
//             trailing: Text(DateFormat('dd/MM/yy').format(post.date)),
//             onTap: () => _togglePostExpansion(post.id),
//           ),
          
//           // Contenu développé
//           if (isExpanded) 
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Text(
//                 post.content,
//                 style: TextStyle(fontSize: 14),
//               ),
//             ),
          
//           // Interactions (likes, commentaires)
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: [
//                 Icon(Icons.favorite_border, size: 16, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Text('${post.likes}'),
//                 SizedBox(width: 16),
//                 Icon(Icons.comment, size: 16, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Text('${post.comments.length}'),
//                 Spacer(),
//                 if (!isExpanded)
//                   TextButton(
//                     onPressed: () => _togglePostExpansion(post.id),
//                     child: Text('Voir plus'),
//                   ),
//               ],
//             ),
//           ),
          
//           // Section commentaires (seulement si développé)
//           if (isExpanded) 
//             _buildCommentsSection(post),
//         ],
//       ),
//     );
//   }

//   Widget _buildCommentsSection(Post post) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Commentaires (${post.comments.length})',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
          
//           // Liste des commentaires
//           Container(
//             height: 150,
//             child: ListView.builder(
//               itemCount: post.comments.length,
//               itemBuilder: (context, index) {
//                 final comment = post.comments[index];
//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: CircleAvatar(
//                     radius: 16,
//                     child: Text(comment.user[0]),
//                   ),
//                   title: Text(comment.user, style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text(comment.text),
//                   trailing: Text(DateFormat('dd/MM').format(comment.date)),
//                 );
//               },
//             ),
//           ),
          
//           // Champ pour ajouter un commentaire
//           TextField(
//             decoration: InputDecoration(
//               hintText: 'Ajouter un commentaire...',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {},
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatisticsSection() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.deepPurple[50],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Statistiques de la communauté',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildCommunityStat('${_organizers.length}', 'Organisateurs'),
//               _buildCommunityStat('${_organizers.fold(0, (sum, o) => sum + o.eventsCount)}', 'Événements'),
//               _buildCommunityStat('${_organizers.fold(0, (sum, o) => sum + o.followers)}', 'Abonnés'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCommunityStat(String value, String label) {
//     return Column(
//       children: [
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
//         SizedBox(height: 4),
//         Text(label, style: TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildQuoteSection() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.amber[50],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.lightbulb_outline, size: 30, color: Colors.amber),
//           SizedBox(height: 8),
//           Text(
//             '"La culture ne s\'hérite pas, elle se conquiert." - André Malraux',
//             style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Rejoignez notre communauté de passionnés!',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class Organizer {
// //   final int id;
// //   final String name;
// //   final String image;
// //   final String description;
// //   final double rating;
// //   final int eventsCount;
// //   final int followers;
// //   final int points;
// //   final List<Post> posts;

// //   Organizer.fromJson(Map<String, dynamic> json)
// //       : id = json['id'],
// //         name = json['title'],
// //         subtitle = json['subtitle'],
// //         content = json['content'],
// //         image = json['image'],
// //         date = DateTime.parse(json['date']),
// //         likes = json['likes'],
// //         comments = (json['comments'] as List)
// //             .map((c) => CommentModel.fromJson(c))
// //             .toList();
//   // Organizer({
//   //   required this.id,
//   //   required this.name,
//   //   required this.image,
//   //   required this.description,
//   //   required this.rating,
//   //   required this.eventsCount,
//   //   required this.followers,
//   //   required this.points,
//   //   required this.posts,
//   // });
// // }

// class Post {
//   final int id;
//   final String title;
//   final String subtitle;
//   final String content;
//   final String image;
//   final DateTime date;
//   final int likes;
//   final List<Comment> comments;

//   Post.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         title = json['title'],
//         subtitle = json['subtitle'],
//         content = json['content'],
//         image = json['image'],
//         date = DateTime.parse(json['date']),
//         likes = json['likes'],
//         comments = (json['comments'] as List)
//             .map((c) => Comment.fromJson(c))
//             .toList();
// }
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
//         name = json['name'],
//         image = json['image'],
//         description = json['description'],
//         rating = (json['rating'] as num).toDouble(),
//         eventsCount = json['events_count'],
//         followers = json['followers'],
//         points = json['points'],
//         posts = (json['posts'] as List)
//             .map((p) => Post.fromJson(p))
//             .toList();
// }


// // c

// class Comment {
//   final String user;
//   final String text;
//   final DateTime date;

//   Comment.fromJson(Map<String, dynamic> json)
//       : user = json['user'],
//         text = json['text'],
//         date = DateTime.parse(json['date']);

//   // Comment({
//   //   required this.user,
//   //   required this.text,
//   //   required this.date,
//   // });
// }

// class OrganizersHubResponse {
//   final Organizer featured;
//   final List<Organizer> organizers;
//   final Map<String, dynamic> stats;
//   final Map<String, dynamic> quote;

//   OrganizersHubResponse.fromJson(Map<String, dynamic> json)
//       : featured = Organizer.fromJson(json['featured']),
//         organizers = (json['organizers'] as List)
//             .map((o) => Organizer.fromJson(o))
//             .toList(),
//         stats = json['statistics'],
//         quote = json['quote'];
// }
