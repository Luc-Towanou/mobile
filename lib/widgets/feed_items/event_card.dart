import 'dart:math';

import 'package:event_rush_mobile/pages/event_detail_page.dart';
import 'package:event_rush_mobile/services/api_service/events_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> payload;

  const EventCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: payload['affiche'],
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                height: 180,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                height: 180,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payload['titre'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Row(
                //   children: [
                //     const Icon(Icons.calendar_today, size: 16),
                //     const SizedBox(width: 4),
                //     Text(payload['date_debut']),
                //   ],
                // ),
                // 👉 Ici on utilise FunDateRow
                FunDateRow(
                  isoStart: payload['date_debut'],
                  isoEnd: payload['date_fin'], // optionnel
                ),
                const SizedBox(height: 4),
                // Row(
                //   children: [
                //     const Icon(Icons.location_on, size: 16),
                //     const SizedBox(width: 4),
                //     Text(payload['lieu'] ?? ''),
                //   ],
                // ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    // Expanded(
                    //   child: Text(
                    //     payload['lieu'] ?? '',
                    //     overflow: TextOverflow.ellipsis, // coupe le texte si trop long
                    //     maxLines: 1,
                    //   ),
                    // ),
                    Flexible(
                      child: Text(
                        payload['lieu'] ?? '',
                        overflow: TextOverflow.fade, // ou ellipsis
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    ElevatedButton(
                      onPressed: () async {
                        print("lunch pressing ... : $payload");
                        final service = EventsService();
                        print("lunch try ... : " + payload['id']);
                        try {
                          print("lunch service ... : $payload");
                          final event = await service.fetchEventById(int.parse(payload['id'].toString()));
                          // final event = await service.fetchEventById(119);
                          print("Login réussi : $event");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailPage(event: event),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Impossible de charger l'événement : " + (payload['titre']?.toString() ?? '')),
                            )
                            
                          );
                          print("fetching échoué : $e");
                        }
                      },
                      
                      child: const Text('Acheter'),
                    ),

                    // Text(
                    //   '${payload['price']} FCFA',
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class FunDateRow extends StatelessWidget {
  final String isoStart; // e.g. "2026-02-11T00:00:00.000Z"
  final String? isoEnd;  // optionnel

  const FunDateRow({
    Key? key,
    required this.isoStart,
    this.isoEnd,
  }) : super(key: key);

  DateTime _parse(String v) {
    // Parse ISO et garde en local (évite décalage si timezone)
    final dt = DateTime.parse(v);
    return dt.toLocal();
  }

  String _format(DateTime dt) {
    final fmt = DateFormat('EEE d MMM yyyy', 'fr_FR'); // Mer 11 fév 2026
    return fmt.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final start = _parse(isoStart);
    final end = isoEnd != null ? _parse(isoEnd!) : null;

    final dateText = end == null
        ? _format(start)
        : '${_format(start)} — ${_format(end)}';

    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEEE8FA), Color(0xFFD7C8F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const Text('🎉 ', style: TextStyle(fontSize: 14)),
              Text(
                dateText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D2C8D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// data : {
//   id: 129, 
//   titre: Musique Trad. & Moderne - Bohicon, 
//   description: Rencontres entre artistes traditionnels et musiciens contemporains., 
//   lieu: Place publique, Bohicon, 
//   date_debut: 2025-10-19, 
//   date_fin: 2025-10-22, 
//   statut: brouillon, 
//   latitude: 7.16000000, 
//   longitude: 2.07000000, 
//   distance: null, 
//   affiche_url: https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=1400&q=80, 
//   photos: [], 
//   organisateur: {
//     id: 2, 
//     nom_entreprise: null, 
//     logo: null, 
//     utilisateur: {
//       id: 2, nom: 
//       Merveille, 
//       email: merveille@gmail.com}}, 
//   tickets: [], 
//   nombre_types_ticket: 0, 
//   nombre_places_total: 0, 
//   nombre_places_restantes: 0, 
//   tags: [], 
//   stats: {
//     vues: 4, 
//     favoris: 0, 
//     partages: 0, 
//     achats: 0}, 
//   commentaires: [{
//     id: 435, 
//     contenu: hello, 
//     note: null, 
//     date: 2025-09-24T16:58:10.000000Z, 
//     utilisateur: {
//       id: 2, 
//       nom: Merveille}}, {
//     id: 441, 
//     contenu: cc, 
//     note: null, 
//     date: 2025-09-24T17:11:10.000000Z, 
//     utilisateur: {
//       id: 2, 
//       nom: Merveille}}, {
//     id: 443, 
//     contenu: cc, 
//     note: null, 
//     date: 2025-09-24T17:13:08.000000Z,
//     utilisateur: {
//       id: 2, no