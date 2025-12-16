import 'package:event_rush_mobile/models/myevent_dto.dart';
import 'package:event_rush_mobile/outils/header_my_event.dart';
import 'package:event_rush_mobile/services/api_service/events_service.dart';
import 'package:flutter/material.dart';
// import 'package:../../../outils/header_my_event';
// import 'package:../base_feed_page';
import 'package:dio/dio.dart';


// class MyEventsPage extends StatelessWidget {
//   final bool isOrganizer;
//   const MyEventsPage({Key? key, required this.isOrganizer}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final colors = [
//       const Color(0xFFFA4EAB), // rose
//       const Color(0xFF7B2CBF), // violet
//       const Color(0xFFFF8C42), // orange
//       const Color(0xFF1A1A1A), // noir
//     ];

//     return Scaffold(
//       backgroundColor: colors[3],
//       appBar: AppBar(
//         title: const Text("Mes Événements"),
//         backgroundColor: colors[1],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _SectionHeader("⭐ Favoris / Suivis", colors[0]),
//           _EventList(fetchKey: "favorites"),

//           const SizedBox(height: 20),
//           _SectionHeader("🎟️ Billets achetés", colors[2]),
//           _EventList(fetchKey: "purchased"),

//           if (isOrganizer) ...[
//             const SizedBox(height: 20),
//             _SectionHeader("📌 Mes événements", colors[1]),
//             _OrganizerEventList(),
//             const SizedBox(height: 20),
//             _SectionHeader("➕ Créer un événement", colors[0]),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: colors[0],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onPressed: () {
//                 // Naviguer vers page création
//               },
//               icon: const Icon(Icons.add),
//               label: const Text("Nouvel événement"),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final Color color;
//   const _SectionHeader(this.title, this.color);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 18,
//         color: color,
//       ),
//     );
//   }
// }

// class _EventList extends StatelessWidget {
//   final String fetchKey;
//   const _EventList({required this.fetchKey});

//   @override
//   Widget build(BuildContext context) {
//     // Ici tu branches ton FutureBuilder qui appelle l’API
//     return Column(
//       children: [
//         Card(
//           color: Colors.white,
//           child: ListTile(
//             leading: const Icon(Icons.event, color: Colors.purple),
//             title: const Text("Festival Awilé"),
//             subtitle: const Text("Porto-Novo • 24-30 Août 2026"),
//             trailing: ElevatedButton(
//               onPressed: () {},
//               child: const Text("Voir"),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrganizerEventList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.event_available, color: Colors.orange),
//             title: const Text("Arts de la Rue"),
//             subtitle: const Text("Abomey-Calavi • 11-16 Février 2026"),
//             trailing: Wrap(
//               spacing: 8,
//               children: [
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.visibility)),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



class MyEventsPage extends StatelessWidget {
  final bool isOrganizer;
  MyEventsPage({Key? key, required this.isOrganizer}) : super(key: key);
  final service = EventsService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isOrganizer ? 2 : 1,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          title: Text(
            "Mes Événements ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, foreground: Paint()..shader = AppColors.mainGradient.createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
          ),
          bottom: isOrganizer
              ? const TabBar(
                  indicatorColor: AppColors.pink,
                  labelColor: AppColors.pink,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "Moi (Participant)"),
                    Tab(text: "Mon Espace Orga"),
                  ],
                )
              : null,
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(), // Scroll rebondissant "fun"
          children: [
            // TAB 1: Participant
            _ParticipantView(service: service,),
            
            // TAB 2: Organisateur (affiché seulement si isOrganizer est true)
            if (isOrganizer) _OrganizerView(service: service,),
          ],
        ),
      ),
    );
  }
}

// class _ParticipantView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: const [
//         FunSectionHeader(title: "Favoris & Suivis", icon: Icons.favorite, color: AppColors.pink),
//         _EventCard(
//           title: "Festival Awilé",
//           date: "24-30 Août 2026",
//           location: "Porto-Novo",
//           imageUrl: "https://via.placeholder.com/150", // Placeholder
//           isFavorite: true,
//         ),
//         SizedBox(height: 10),
//         FunSectionHeader(title: "Je participe", icon: Icons.confirmation_num, color: AppColors.orange),
//         _EventCard(
//           title: "Concert Cotonou",
//           date: "12 Déc 2025",
//           location: "Fidjrossè",
//           imageUrl: "https://via.placeholder.com/150",
//           tag: "Billet acheté",
//         ),
//       ],
//     );
//   }
// }

class _ParticipantView extends StatelessWidget {
  final EventsService service;

  const _ParticipantView({required this.service});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyEventsResponse>(
      future: service.fetchMyEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Nothing here 👀"));
        }

        final data = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (data.favoris.isNotEmpty) ...[
              const FunSectionHeader(
                title: "Favoris",
                icon: Icons.favorite,
                color: AppColors.pink,
              ),
              ...data.favoris.map((e) => _EventCard(
                    title: e.title,
                    date: e.date,
                    location: e.location,
                    imageUrl: e.image,
                    isFavorite: true,
                  )),
              const SizedBox(height: 20),
            ],

            if (data.participations.isNotEmpty) ...[
              const FunSectionHeader(
                title: "Je participe",
                icon: Icons.confirmation_num,
                color: AppColors.orange,
              ),
              ...data.participations.map((e) => _EventCard(
                    title: e.title,
                    date: e.date,
                    location: e.location,
                    imageUrl: e.image,
                    tag: "Billet acheté",
                  )),
            ],
          ],
        );
      },
    );
  }
}


// class _OrganizerView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         // Bouton Création Fun
//         Container(
//           decoration: BoxDecoration(
//             gradient: AppColors.mainGradient,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [BoxShadow(color: AppColors.pink.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () { /* Naviguer vers création */ },
//               borderRadius: BorderRadius.circular(20),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
//                     SizedBox(width: 10),
//                     Text("Créer un événement", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         const FunSectionHeader(title: "Mes Événements gérés", icon: Icons.dashboard, color: AppColors.purple),
//         _EventCard(
//           title: "Arts de la Rue",
//           date: "11-16 Février 2026",
//           location: "Abomey-Calavi",
//           imageUrl: "https://via.placeholder.com/150",
//           isEditable: true,
//         ),
//       ],
//     );
//   }
// }

  class _OrganizerView extends StatelessWidget {
  final EventsService service;

  const _OrganizerView({required this.service});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyEventsResponse>(
      future: service.fetchMyEvents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.organisateur;

        if (events.isEmpty) {
          return const Center(
            child: Text("No managed events yet "),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const FunSectionHeader(
              title: "Mes Événements gérés",
              icon: Icons.dashboard,
              color: AppColors.purple,
            ),
            ...events.map((e) => _EventCard(
                  title: e.title,
                  date: e.date,
                  location: e.location,
                  imageUrl: e.image,
                  isEditable: true,
                )),
          ],
        );
      },
    );
  }
}


// --- WIDGET CARTE ÉVÉNEMENT AMÉLIORÉE ---
class _EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final bool isFavorite;
  final bool isEditable;
  final String? tag;

  const _EventCard({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    this.isFavorite = false,
    this.isEditable = false,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // Image Cover
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.grey[800], // Placeholder couleur
                  image: const DecorationImage(image: NetworkImage("https://picsum.photos/400/200"), fit: BoxFit.cover), // Image random pour le fun
                ),
              ),
              if (tag != null)
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(20)),
                    child: Text(tag!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          // Contenu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      // Row(
                      //   children: [
                      //     Icon(Icons.calendar_today, size: 12, color: AppColors.grey),
                      //     const SizedBox(width: 4),
                      //     Text(date, style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      //     const SizedBox(width: 10),
                      //     Icon(Icons.location_on, size: 12, color: AppColors.grey),
                      //     const SizedBox(width: 4),
                      //     Text(location, style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              date,
                              style: TextStyle(color: AppColors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis, // coupe proprement
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.location_on, size: 12, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              location,
                              style: TextStyle(color: AppColors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                if (isEditable)
                   IconButton(icon: const Icon(Icons.settings, color: AppColors.purple), onPressed: () {}),
                if (!isEditable)
                   ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.white.withOpacity(0.1),
                       shape: const CircleBorder(),
                       padding: const EdgeInsets.all(12),
                     ),
                     onPressed: (){},
                     child: const Icon(Icons.arrow_forward, color: Colors.white),
                   )
              ],
            ),
          ),
        ],
      ),
    );
  }
}