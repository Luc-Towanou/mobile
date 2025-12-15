import 'dart:convert';

import 'package:event_rush_mobile/auth/login_page.dart';
import 'package:event_rush_mobile/pages/dashboard/paymentwebview_page.dart';
import 'package:event_rush_mobile/services/api_service/events_service.dart';
import 'package:event_rush_mobile/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:http/http.dart' as http;
// Optionnel: rating bar pour étoiles
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<Color> getDominantColor(String imageUrl) async {
  final paletteGenerator = await PaletteGenerator.fromImageProvider(
    NetworkImage(imageUrl),
  );
  return paletteGenerator.dominantColor?.color ?? Colors.blue;
}

class EventShow {
  final int id;
  final String titre;
  final String? description;
  final String affiche; // URL image
  final String dateDebutIso;
  final String? dateFinIso;
  final String lieu; // libellé
  final double latitude;
  final double longitude;
  final Organizer organizer;
  final Stats stats;
  final CommentsSummary commentsSummary;
  final List<Comment> comments;
  final List<Ticket> tickets;

  EventShow({
    required this.id,
    required this.titre,
    this.description,
    required this.affiche,
    required this.dateDebutIso,
    this.dateFinIso,
    required this.lieu,
    required this.latitude,
    required this.longitude,
    required this.organizer,
    required this.stats,
    required this.commentsSummary,
    required this.comments,
    required this.tickets,
  });

  DateTime get start => DateTime.parse(dateDebutIso).toLocal();
  DateTime? get end => dateFinIso != null ? DateTime.parse(dateFinIso!).toLocal() : null;
}

class Organizer {
  final int id;
  final String? nom;
  final String? avatarUrl;
  Organizer({required this.id, required this.nom, this.avatarUrl});
}

class Stats {
  final int vues;
  final int partages;
  int likes;
  Stats({required this.vues, required this.partages, required this.likes});
}

class CommentsSummary {
  final int total;
  final int positifs;
  final int negatifs;
  final double moyenneEtoiles; // ex: 4.2
  CommentsSummary({
    required this.total,
    required this.positifs,
    required this.negatifs,
    required this.moyenneEtoiles,
  });
}

class Comment {
  final String auteur;
  final String contenu;
  final int etoiles; // 1..5
  final DateTime date;
  Comment({required this.auteur, required this.contenu, required this.etoiles, required this.date});
}

class Ticket {
  final String id;
  final String nom;
  final String? description;
  final double prix;
  final String devise; // "XOF", "EUR"
  final int stock; // restant
  Ticket({required this.id, required this.nom, this.description, required this.prix, required this.devise, required this.stock});
}

// class EventDetailPage extends StatelessWidget {
//   final EventShow event;
//   const EventDetailPage({Key? key, required this.event}) : super(key: key);

class EventDetailPage extends StatefulWidget {
  final EventShow event;
  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final AuthService _authService = AuthService();
  late EventShow event;
  late Stats stats;
  bool isReacting = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    stats = widget.event.stats;
    

  }
  String _formatDateRange(EventShow e) {
    final f = DateFormat('EEE d MMM yyyy', 'fr_FR');
    final start = f.format(e.start);
    final end = e.end != null ? f.format(e.end!) : null;
    return end == null ? start : '$start — $end';
  }
  

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF3D2C8D),
            pinned: true,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(event.titre, style: const TextStyle(fontWeight: FontWeight.w700)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'event_${event.id}_cover',
                    child: Image.network(event.affiche, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x33000000), Color(0xAA000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.favorite_border),
              //   onPressed: () {},
              //   tooltip: 'Aimer',
              // ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.favorite_border),
                tooltip: 'Réagir',
                onSelected: (type) async {
                  if (isReacting) return;
                  isReacting = true;
                  await EventsService.react("event", event.id, type);
                  // setState(() => event.stats.likes++); // Cannot use setState in StatelessWidget
                  setState(() => stats.likes++);
                  isReacting = false;

                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'like', child: Text('👍 Like')),
                  const PopupMenuItem(value: 'love', child: Text('❤️ Love')),
                  const PopupMenuItem(value: 'haha', child: Text('😂 Haha')),
                  const PopupMenuItem(value: 'wow', child: Text('😮 Wow')),
                  const PopupMenuItem(value: 'angry', child: Text('😡 Angry')),
                ],
              ),

              // IconButton(
              //            
              //   icon: const Icon(Icons.share),
              //   onPressed: () {},
              //   tooltip: 'Partager',
              // ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  await EventsService.share('event', event.id);
                  // setState(() => event.stats.partages++);
                },
                tooltip: 'Partager',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Date + lieu
                  _InfoCard(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Color(0xFF3D2C8D)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDateRange(event),
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3D2C8D)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.place, size: 18, color: Color(0xFF3D2C8D)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            event.lieu,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF3D2C8D)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Organisateur
                  _SectionHeader(title: 'Organisateur'),
                  _OrganizerTile(organizer: event.organizer),

                  const SizedBox(height: 12),

                  // Stats
                  _SectionHeader(title: 'Statistiques'),
                  _StatsRow(stats: event.stats),

                  const SizedBox(height: 12),

                  // Description
                  if (event.description != null && event.description!.trim().isNotEmpty)
                    _InfoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('À propos de l’événement', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(
                            event.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF4A3F91)),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Carte
                  // _SectionHeader(title: 'Localisation'),
                  // _MapCard(
                  //   latitude: event.latitude,
                  //   longitude: event.longitude,
                  //   title: event.titre,
                  // ),

                  const SizedBox(height: 12),

                  // Commentaires (synthèse + liste)
                  _SectionHeader(title: 'Commentaires'),
                  _CommentsSummaryCard(summary: event.commentsSummary),
                  const SizedBox(height: 8),
                  for (final c in event.comments) _CommentTile(comment: c),

                  const SizedBox(height: 12),

                  // Billetterie
                  _SectionHeader(title: 'Billetterie'),
                  if (event.tickets.isEmpty)
                    _InfoCard(child: Text('Aucune billetterie disponible pour cet événement.'))
                  else
                    Column(
                      children: event.tickets.map((t) => _TicketTile(
                        ticket: t, 
                        onPay: () => _launchFedaPay(context, event, t),
                        afficheUrl: event.affiche, // URL de l’affiche de l’événement

                        )).toList(), 
                        // onPay: () { 
                        //   _launchFedaPay(context, event, t))).toList(),} ,

                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Intégration Fedapay (mock): remplace par ton SDK / flow réel
  void _launchFedaPay(BuildContext context, EventShow event, Ticket ticket) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Paiement FedaPay'),
        content: Text('Paiement du ticket "${ticket.nom}" — ${ticket.prix.toStringAsFixed(0)} ${ticket.devise}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Continuer')),
        ],
      ),
    );
  }
}

// ----------------------------------
// UI Components
// ----------------------------------

class _InfoCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  // const _InfoCard({Key? key, required this.child, this.color}) : super(key: key);
  _InfoCard({Key? key, required this.child, this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color ?? Color.fromARGB(255, 255, 255, 255), Color(0xFFF0ECFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFF3D2C8D)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF3D2C8D))),
      ],
    );
  }
}

class _OrganizerTile extends StatelessWidget {
  final Organizer organizer;
  const _OrganizerTile({Key? key, required this.organizer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: organizer.avatarUrl != null ? NetworkImage(organizer.avatarUrl!) : null,
            child: organizer.avatarUrl == null ? const Icon(Icons.person, color: Color(0xFF3D2C8D)) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(organizer.nom ?? "Organisateur inconnu", style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.message, size: 18),
            label: const Text('Contacter'),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Stats stats;
  const _StatsRow({Key? key, required this.stats}) : super(key: key);

  Widget _statItem(IconData icon, String label, int value, {Color color = const Color(0xFF3D2C8D)}) {
    return Expanded(
      child: _InfoCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6A5CB0))),
                Text('$value', style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statItem(Icons.visibility, 'Vues', stats.vues),
        const SizedBox(width: 8),
        _statItem(Icons.share, 'Partages', stats.partages),
        const SizedBox(width: 8),
        _statItem(Icons.favorite, 'Likes', stats.likes, color: Colors.pinkAccent),
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;
  const _MapCard({Key? key, required this.latitude, required this.longitude, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(latitude, longitude);
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: pos, zoom: 14),
          markers: {
            Marker(
              markerId: const MarkerId('event'),
              position: pos,
              infoWindow: InfoWindow(title: title),
            )
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ),
      ),
    );
  }
}

class _CommentsSummaryCard extends StatelessWidget {
  final CommentsSummary summary;
  const _CommentsSummaryCard({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posRatio = summary.total == 0 ? 0.0 : summary.positifs / summary.total;
    final negRatio = summary.total == 0 ? 0.0 : summary.negatifs / summary.total;

    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Synthèse des avis', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _BarStat(label: 'Positifs', ratio: posRatio, color: Colors.green),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BarStat(label: 'Négatifs', ratio: negRatio, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107)),
              const SizedBox(width: 6),
              Text('${summary.moyenneEtoiles.toStringAsFixed(1)} / 5'),
              const Spacer(),
              Text('Total: ${summary.total}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarStat extends StatelessWidget {
  final String label;
  final double ratio; // 0..1
  final Color color;
  const _BarStat({Key? key, required this.label, required this.ratio, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (ratio * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ($percent%)', style: const TextStyle(fontSize: 12, color: Color(0xFF6A5CB0))),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            color: color,
            backgroundColor: const Color(0xFFEDE7F6),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  const _CommentTile({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('d MMM yyyy', 'fr_FR');
    return _InfoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.auteur, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < comment.etoiles ? Icons.star : Icons.star_border,
                      size: 16,
                      color: const Color(0xFFFFC107),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(comment.contenu),
                const SizedBox(height: 6),
                Text(f.format(comment.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _TicketTile extends StatefulWidget {
  final Ticket ticket;
  final VoidCallback onPay;
  final String afficheUrl; // URL de l’affiche de l’événement

  const _TicketTile({
    Key? key,
    required this.ticket,
    required this.onPay,
    required this.afficheUrl,
  }) : super(key: key);

  @override
  State<_TicketTile> createState() => _TicketTileState();
}

class _TicketTileState extends State<_TicketTile> {
  Color? eventColor;

  @override
  void initState() {
    super.initState();
    _loadColor();
  }

  Future<void> _payWithFedaPay(BuildContext context, String ticketId) async {
    // Afficher un loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color.fromARGB(255, 243, 152, 33)),
      ),
    );
    try {
      // 1 - Récupérer le token et le verifier
      final token = await AuthService.getToken();
        if (token == null) {
        // throw Exception("Pas de token");
          print("token non trouvé : null");
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
        return; 
      }
        print("in launshPayment $ticketId");

      // 2 - Appel à ton backend pour créer la transaction
      final response = await http.post(
        Uri.parse('https://eventrush.onrender.com/api/billet/payer'),
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
          'Content-Type': 'application/json'},
        body: jsonEncode({
          'ticket_id': ticketId,
          // 'amount': widget.ticket.prix,
          // 'currency': widget.ticket.devise,
        }),
      );
      print("reponse api : ${response.body}, statut : ${response.statusCode}");
      final body = response.body;

      if (response.headers['content-type']?.contains('application/json') != true) {
        print("Réponse non JSON : $body");
        throw Exception("Le serveur n'a pas renvoyé du JSON");
      }                                               

      if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final paymentUrl = data["payment_url"];

      if (paymentUrl != null) {
        // ✅ Fermer le loader AVANT d'ouvrir la WebView
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(url: paymentUrl),
          ),
        );
      } else {
        throw Exception("Pas d'URL de paiement dans la réponse");
      }
    } else {
      throw Exception("Erreur backend : ${response.statusCode} - ${response.body}");
    }
      // final data = jsonDecode(response.body);

      // if (data['payment_url'] == null) {
      //   throw Exception("URL de paiement non trouvée");
      // }

      // final url = data['payment_url'];

      // // 2. Ouvrir FedaPay
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => PaymentWebView(url: url),
      //   ),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur paiement : $e')),
        
      );
      print('Erreur paiement : $e');
    }
  }

  Future<void> _loadColor() async {
    final color = await getDominantColor(widget.afficheUrl);
    setState(() {
      eventColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final price = '${widget.ticket.prix.toStringAsFixed(0)} ${widget.ticket.devise}';
    return _InfoCard(
      color: eventColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.ticket.nom, style: const TextStyle(fontWeight: FontWeight.w700)),
                if (widget.ticket.description != null && widget.ticket.description!.isNotEmpty)
                  Text(
                    widget.ticket.description!,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6A5CB0)),
                  ),
                const SizedBox(height: 6),
                Text('Prix: $price • Stock: ${widget.ticket.stock}'),
              ],
            ),
          ),
          // ElevatedButton.icon(
          //   onPressed: widget.ticket.stock > 0 ? widget.onPay : null,
          //   icon: const Icon(Icons.payment),
          //   label: const Text('Payer'),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: const Color(0xFF3D2C8D), // couleur dynamique
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //   ),
          // ),
          ElevatedButton.icon(
            onPressed: widget.ticket.stock > 0
                ? () => _payWithFedaPay(context, widget.ticket.id)
                : null,
            icon: const Icon(Icons.payment),
            label: const Text('Payer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D2C8D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
      
    );
  }
}


// class _TicketTile extends StatelessWidget {
//   final Ticket ticket;
//   final VoidCallback onPay;
//   const _TicketTile({Key? key, required this.ticket, required this.onPay}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final price = '${ticket.prix.toStringAsFixed(0)} ${ticket.devise}';
//     return _InfoCard(
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(ticket.nom, style: const TextStyle(fontWeight: FontWeight.w700)),
//                 if (ticket.description != null && ticket.description!.isNotEmpty)
//                   Text(ticket.description!, style: const TextStyle(fontSize: 12, color: Color(0xFF6A5CB0))),
//                 const SizedBox(height: 6),
//                 Text('Prix: $price • Stock: ${ticket.stock}'),
//               ],
//             ),
//           ),
//           ElevatedButton.icon(
//             onPressed: ticket.stock > 0 ? onPay : null,
//             icon: const Icon(Icons.payment),
//             label: const Text('Payer'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3D2C8D),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }