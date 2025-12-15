import 'package:event_rush_mobile/outils/notifications.dart';
import 'package:event_rush_mobile/pages/event_detail_page.dart';
import 'package:event_rush_mobile/services/api_service/events_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:decimal/decimal.dart';

// import '../outils/notifications.dart';
// import '../services/api_service/events_service.dart';


class EventPage extends StatefulWidget {
  @override
  
  _EventPageState createState() => _EventPageState();
}




class _EventPageState extends State<EventPage> {
  
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  bool _isDateFormatInitialized = false;
  void _navigateToHomePage() {
    Navigator.pushReplacementNamed(context, '/');
  }
  final EventsService eventsService = EventsService();

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialiser le formatage des dates
  //   initializeDateFormatting('fr_FR', null).then((_) {
  //     setState(() {
  //       _isDateFormatInitialized = true;
  //     });
  //   });
  //   _fetchEvents();
  // }
  @override
    void initState() {
      super.initState();

      initializeDateFormatting('fr_FR', null).then((_) {
        if (!mounted) return;
        setState(() {
          _isDateFormatInitialized = true;
        });
      });

      _fetchEvents();
    }



  // final List<Event> _events = [];
  //   Future<void> _fetchEvents() async {
  //     try {
  //     final List<Event> events = await eventsService.index();
  //     print("Événements récupérés : ${events.length}");
  //     setState(() {
  //       _events.clear();
  //       _events.addAll(events);
  //     });
  //   } catch (e) {
  //     print("Erreur de récupération des événements : $e");

  //     // ➡️ Relancer après 5 secondes
  //     Future.delayed(const Duration(seconds: 5), _fetchEvents);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Erreur de connexion")),
  //     );
  //     showError(context, "Récupération échouée 😕.");
  //   }
    
  // }
  final List<Event> _events = [];
  bool _isFetching = false;

  Future<void> _fetchEvents() async {
    if (!mounted || _isFetching) return;

    _isFetching = true;

    try {
      final List<Event> events = await eventsService.index();
      debugPrint("Événements récupérés : ${events.length}");

      if (!mounted) return;

      setState(() {
        _events
          ..clear()
          ..addAll(events);
      });

    } catch (e) {
      debugPrint("Erreur de récupération des événements : $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion")),
      );

      showError(context, "Récupération échouée 😕.");

      // 🔥 SAFE retry après 5 secondes
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) _fetchEvents();
      });

    } finally {
      _isFetching = false;
    }
  }



  List<Event> get _filteredEvents {
    return _events.where((event) {
      final searchMatch = _searchController.text.isEmpty ||
          event.titre.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          event.category!.toLowerCase().contains(_searchController.text.toLowerCase());
      
      final dateMatch = _selectedDate == null ||
          (event.dateDebut.year == _selectedDate!.year &&
           event.dateDebut.month == _selectedDate!.month &&
           event.dateDebut.day == _selectedDate!.day);
      
      return searchMatch && dateMatch;
    }).toList();
  }

  int get totalEvents => _events.length;
  int get upcomingEvents => _events.where((e) => e.dateDebut.isAfter(DateTime.now())).length;
  int get soldOutEvents => _events.where((e) => e.availableTickets == 0).length;
  double get averagePrice {
    final paidEvents = _events.where((e) => e.price! > 0);
    if (paidEvents.isEmpty) return 0;
    return paidEvents.map((e) => e.price).reduce((a, b) => a! + b!)! / paidEvents.length;
  }

  Future<void> _selectDate(BuildContext context) async {
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
      if (!_isDateFormatInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   // onPressed: () => Navigator.of(context).pop(), //_navigateToHomePage
        //   onPressed: _navigateToHomePage,
          
        // ),
        title: Text('Événements'),
        backgroundColor: Color.fromARGB(255, 109, 34, 80),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Section de statistiques
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatistic('Total', totalEvents.toString(), Icons.event,),
                _buildStatistic('À venir', upcomingEvents.toString(), Icons.upcoming),
                _buildStatistic('Complet', soldOutEvents.toString(), Icons.lock),
                _buildStatistic('Prix Moy', '${averagePrice.toStringAsFixed(0)}€', Icons.attach_money),
              ],
            ),
          ),
          
          // Zone de recherche et filtre
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un événement...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDate(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 183, 58, 135),
                          side: BorderSide(color: Color.fromARGB(255, 183, 58, 141)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 18),
                            SizedBox(width: 5),
                            Text(_selectedDate == null 
                                ? 'Choisir une date' 
                                : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (_selectedDate != null)
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Effacer'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Liste des événements
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Aucun événement trouvé',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 30),
                        const SizedBox(
                                width: 50,
                                height: 50,
                                // child: SpinKitThreeBounce( //3 point horizontaux
                                // child: SpinKitWave( // des barres comme si on jouait de la musique
                                child: SpinKitSpinningLines	 (  // SpinKitFadingCube
                                  // strokeWidth: 2,
                                  size: 50,
                                  color: Color.fromARGB(255, 219, 61, 193),  
                                ),
                              )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchEvents,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];
                        return _buildEventCard(event);
                      },
                    ),
                  ),
                // ListView.builder(
                //     padding: EdgeInsets.symmetric(horizontal: 16),
                //     itemCount: _filteredEvents.length,
                //     itemBuilder: (context, index) {
                //       final event = _filteredEvents[index];
                //       return _buildEventCard(event);
                //     },
                //   ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color.fromARGB(255, 183, 58, 135), size: 24),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 183, 58, 135).withOpacity(0.5),)),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // Widget _buildEventCard(Event event) {
  //   // final percentageSold = ((event.totalTickets! - event.availableTickets!) / event.totalTickets!) * 100;
  //   final percentageSold = (event.totalTickets != null && event.totalTickets! > 0)
  //   ? ((event.totalTickets! - (event.availableTickets ?? 0)) / event.totalTickets!) * 100
  //   : 0.0;
    
  //   return Card(
  //     margin: EdgeInsets.only(bottom: 16),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     elevation: 3,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         // Image de l'événement
  //         ClipRRect(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  //           child: Image.network(
  //             event.affiche_url,
  //             height: 150,
  //             fit: BoxFit.cover,
  //             loadingBuilder: (context, child, loadingProgress) {
  //               if (loadingProgress == null) return child;
  //               return Container(
  //                 height: 150,
  //                 color: Colors.grey[200],
  //                 child: Center(
  //                   // child: CircularProgressIndicator()
  //                   child: const SizedBox(
  //                               width: 50,
  //                               height: 50,
  //                               // child: SpinKitThreeBounce( //3 point horizontaux
  //                               // child: SpinKitWave( // des barres comme si on jouait de la musique
  //                               child: SpinKitPulse (  // SpinKitFadingCube
  //                                 // strokeWidth: 2,
  //                                 size: 20,
  //                                 color: Color.fromARGB(255, 17, 134, 17),
  //                               ),
  //                             )
  //                   ),
  //               );
  //             },
  //             errorBuilder: (context, error, stackTrace) {
  //               return Container(
  //                 height: 150,
  //                 color: Colors.grey[200],
  //                 child: Icon(Icons.error, color: Colors.grey),
  //               );
  //             },
  //           ),
  //         ),
          
  //         // Contenu de la carte
  //         Padding(
  //           padding: EdgeInsets.all(16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Titre et catégorie
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       event.titre,
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                     decoration: BoxDecoration(
  //                       color: Colors.deepPurple.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Text(
  //                       event.category ?? 'Inconnu', 
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.deepPurple,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
                
  //               SizedBox(height: 10),
                
  //               // Date
  //               Row(
  //                 children: [
  //                   Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
  //                   SizedBox(width: 8),
  //                   Text(
  //                     DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(event.dateDebut),
  //                     style: TextStyle(fontSize: 14),
  //                   ),
  //                 ],
  //               ),
                
  //               SizedBox(height: 8),
                
  //               // Lieu
  //               Row(
  //                 children: [
  //                   Icon(Icons.location_on, size: 16, color: Colors.deepPurple),
  //                   SizedBox(width: 8),
  //                   Expanded(
  //                     child: Text(
  //                       event.lieu,
  //                       style: TextStyle(fontSize: 14),
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ],
  //               ),
                
  //               SizedBox(height: 12),
                
  //               // Prix et disponibilité
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     event.price! > 0 ? '${event.price?.toStringAsFixed(2)}€' : 'Gratuit',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.deepPurple,
  //                     ),
  //                   ),
  //                   Text(
  //                     '${event.availableTickets} places restantes',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: event.availableTickets! < 50 ? Colors.orange : Colors.green,
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                     decoration: BoxDecoration(
  //                       color: event.statusColor.withValues(alpha: 0.3),//Colors.deepPurple.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Text(
  //                       event.status, 
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: event.statusColor,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
                
  //               SizedBox(height: 10),
                
  //               // Barre de progression pour les billets vendus
  //               LinearProgressIndicator(
  //                 value: (percentageSold.isNaN || percentageSold.isInfinite) 
  //                     ? 0 
  //                     : percentageSold / 100,
  //                 backgroundColor: Colors.grey[200],
  //                 valueColor: AlwaysStoppedAnimation<Color>(
  //                   percentageSold > 90 ? Colors.red : Colors.green,
  //                 ),
  //                 minHeight: 6,
  //                 borderRadius: BorderRadius.circular(3),
  //               ),

  //               // LinearProgressIndicator(
  //               //   value: percentageSold / 100,
  //               //   backgroundColor: Colors.grey[200],
  //               //   valueColor: AlwaysStoppedAnimation<Color>(
  //               //     percentageSold > 90 ? Colors.red : Colors.green,
  //               //   ),
  //               //   minHeight: 6,
  //               //   borderRadius: BorderRadius.circular(3),
  //               // ),
                
  //               SizedBox(height: 5),
                
  //               // Pourcentage de vente
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: Text(
  //                   '${percentageSold.toStringAsFixed(0)}% vendus',
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEventCard(Event event) {
    // Calcul du pourcentage (inchangé)
    final percentageSold = (event.totalTickets != null && event.totalTickets! > 0)
        ? ((event.totalTickets! - (event.availableTickets ?? 0)) / event.totalTickets!) * 100
        : 0.0;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      // 1. IMPORTANT : Ceci assure que l'effet de clic reste dans les bords arrondis
      clipBehavior: Clip.antiAlias, 
      
      // 2. InkWell rend le tout cliquable
      child: InkWell(
        onTap: () async {
           print("lunch pressing ... : ${event.toJson()}");
          final service = EventsService();
          print("lunch try ... : " + event.id);
          try {
            print("lunch service ... : ");
            final evenement = await service.fetchEventById(int.parse(event.id.toString()));
            // final event = await service.fetchEventById(119);
            print("Login réussi : $evenement");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(event: evenement),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Impossible de charger l'événement : " + (event.titre?.toString() ?? '')),
              )
              
            );
            print("fetching échoué : $e");
          }
          // // Navigation vers la page de détails
          // Navigator.push(
          //   context, // Assurez-vous que 'context' est accessible ici (c'est le cas si vous êtes dans un State)
          //   MaterialPageRoute(
          //     builder: (context) => EventDetailPage(event: _mapEventToEventShow(event)), 
          //   ),
          // );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image de l'événement
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                event.affiche_url,
                height: 150,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Center(
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: SpinKitPulse(
                          size: 20,
                          color: Color.fromARGB(255, 17, 134, 17),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Icon(Icons.error, color: Colors.grey),
                  );
                },
              ),
            ),
            
            // Contenu de la carte
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et catégorie
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.titre,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.category ?? 'Inconnu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(event.dateDebut),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Lieu
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.lieu,
                          style: TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Prix et disponibilité
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.price! > 0 ? '${event.price?.toStringAsFixed(2)}€' : 'Gratuit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        '${event.availableTickets} places restantes',
                        style: TextStyle(
                          fontSize: 14,
                          color: event.availableTickets! < 50 ? Colors.orange : Colors.green,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: event.statusColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.status,
                          style: TextStyle(
                            fontSize: 15,
                            color: event.statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Barre de progression
                  LinearProgressIndicator(
                    value: (percentageSold.isNaN || percentageSold.isInfinite)
                        ? 0
                        : percentageSold / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentageSold > 90 ? Colors.red : Colors.green,
                    ),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  
                  SizedBox(height: 5),
                  
                  // Pourcentage de vente
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${percentageSold.toStringAsFixed(0)}% vendus',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Event {
  final String id;
  final String titre; 
  final String description;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String lieu;
  final String affiche_url;
  final String? statut;
  final double? latitude;  //Decimal?
  final double? longitude;  //Decimal?
  final double? price;
  final int? availableTickets;
  final int? totalTickets;
  final int? points;
  final String? category;

  Event({
    required this.id,
    required this.titre,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.lieu,
    required this.affiche_url,
    this.statut,
    this.latitude,
    this.longitude,
    this.points,
    this.price,
    this.availableTickets,
    this.totalTickets,
    this.category,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'].toString(),
    titre: json['titre'] ?? '',
    description: json['description'] ?? '',
    lieu: json['lieu'] ?? '',
    // 👇 utilise "affiche" (pas affiche_url)
    affiche_url: json['affiche_url'] ?? '',
    dateDebut: json['date_debut'] != null 
        ? DateTime.parse(json['date_debut']) 
        : DateTime.now(),
    dateFin: json['date_fin'] != null 
        ? DateTime.parse(json['date_fin']) 
        : DateTime.now(),
    // 👇 pas de price dans la réponse → par défaut 0
    price: (json['price'] != null) 
        ? double.tryParse(json['price'].toString()) 
        : 0,
    // 👇 ces champs n’existent pas → fallback sur 0
    availableTickets: json['nombre_places_restantes'] ?? 0,
    totalTickets: json['nombre_places_total'] ?? 0,
    category: json['category'], // ⚠️ pas présent non plus dans ta réponse
    statut: json['statut'] ?? '',
    // 👇 convertir en double si dispo
    latitude: json['latitude'] != null 
        ? double.tryParse(json['latitude'].toString()) 
        : null,
    longitude: json['longitude'] != null 
        ? double.tryParse(json['longitude'].toString()) 
        : null,
    points: json['points'] ?? 0,
  );
}
// recuperer le statut de l'evenement par rapport à now 
String get status {
  final now = DateTime.now();
  if (now.isAfter(this.dateFin)) return "Passé";
  if (now.isAfter(this.dateDebut) && now.isBefore(this.dateFin)) return "En cours";
  return "A venir";
}
// couleur en fonction du statut de l'evenement
Color get statusColor {
  final now = DateTime.now();
  if (now.isAfter(this.dateFin)) return Colors.grey;
  if (now.isAfter(this.dateDebut) && now.isBefore(this.dateFin)) return Colors.green;
  return Colors.deepPurple;
}


  // // 👉 Constructeur fromJson
  // factory Event.fromJson(Map<String, dynamic> json) {
  //   return Event(
  //     id: json['id'].toString(),
  //     titre: json['titre'] ?? '',
  //     description: json['description'] ?? '',
  //     lieu: json['lieu'] ?? '',
  //     affiche_url: json['affiche_url'] ?? '',
  //     dateDebut: json['date_debut'] != null 
  //         ? DateTime.parse(json['date_debut']) 
  //         : DateTime.now(),
  //     dateFin: json['date_fin'] != null 
  //         ? DateTime.parse(json['date_fin']) 
  //         : DateTime.now(),
  //     price: (json['price'] != null) 
  //         ? double.tryParse(json['price'].toString()) 
  //         : 0,
  //     availableTickets: json['nombre_places_restantes'] ?? 0,
  //     totalTickets: json['nombre_places_total'] ?? 0,
  //     category: json['category'],
  //     statut: json['statut'] ?? '',
  //     latitude: json['latitude'],
  //     longitude: json['longitude'],
  //     points: json['points'] ?? 0,
  //   );
  // }


  // (optionnel) pour envoyer vers l’API
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
      'lieu': lieu,
      'affiche_url': affiche_url,
      'price': price,
      'available_tickets': availableTickets,
      'total_tickets': totalTickets,
      'category': category,
    };
  }

  

  
  // final List<Event> _events = [
  //   Event(
  //     title: "Festival de Musique",
  //     date: DateTime.now().add(Duration(days: 5)),
  //     location: "Parc Central",
  //     image: "https://picsum.photos/400/300?random=1",
  //     price: 45.00,
  //     availableTickets: 150,
  //     totalTickets: 500,
  //     category: "Musique",
  //   ),
  //   Event(
  //     title: "Exposition d'Art Moderne",
  //     date: DateTime.now().add(Duration(days: 12)),
  //     location: "Galerie Nationale",
  //     image: "https://picsum.photos/400/300?random=2",
  //     price: 20.00,
  //     availableTickets: 75,
  //     totalTickets: 200,
  //     category: "Art",
  //   ),
  //   Event(
  //     title: "Conférence Tech",
  //     date: DateTime.now().add(Duration(days: 8)),
  //     location: "Centre de Convention",
  //     image: "https://picsum.photos/400/300?random=3",
  //     price: 85.00,
  //     availableTickets: 42,
  //     totalTickets: 300,
  //     category: "Technologie",
  //   ),
  //   Event(
  //     title: "Match de Basketball",
  //     date: DateTime.now().add(Duration(days: 3)),
  //     location: "Stade Municipal",
  //     image: "https://picsum.photos/400/300?random=4",
  //     price: 35.00,
  //     availableTickets: 210,
  //     totalTickets: 1000,
  //     category: "Sport",
  //   ),
  //   Event(
  //     title: "Concert Jazz",
  //     date: DateTime.now().add(Duration(days: 15)),
  //     location: "Théâtre Royal",
  //     image: "https://picsum.photos/400/300?random=5",
  //     price: 55.00,
  //     availableTickets: 30,
  //     totalTickets: 150,
  //     category: "Musique",
  //   ),
  //   Event(
  //     title: "Séminaire Bien-être",
  //     date: DateTime.now().add(Duration(days: 20)),
  //     location: "Espace Zen",
  //     image: "https://picsum.photos/400/300?random=6",
  //     price: 30.00,
  //     availableTickets: 85,
  //     totalTickets: 100,
  //     category: "Santé",
  //   ),
  //   Event(
  //     title: "Festival Gastronomique",
  //     date: DateTime.now().add(Duration(days: 7)),
  //     location: "Place du Marché",
  //     image: "https://picsum.photos/400/300?random=7",
  //     price: 15.00,
  //     availableTickets: 180,
  //     totalTickets: 400,
  //     category: "Nourriture",
  //   ),
  //   Event(
  //     title: "Spectacle de Danse",
  //     date: DateTime.now().add(Duration(days: 10)),
  //     location: "Opéra City",
  //     image: "https://picsum.photos/400/300?random=8",
  //     price: 40.00,
  //     availableTickets: 25,
  //     totalTickets: 120,
  //     category: "Danse",
  //   ),
  //   Event(
  //     title: "Tournoi d'Echecs",
  //     date: DateTime.now().add(Duration(days: 18)),
  //     location: "Club d'Echecs",
  //     image: "https://picsum.photos/400/300?random=9",
  //     price: 10.00,
  //     availableTickets: 60,
  //     totalTickets: 80,
  //     category: "Jeux",
  //   ),
  //   Event(
  //     title: "Projection de Film",
  //     date: DateTime.now().add(Duration(days: 6)),
  //     location: "Cinéma Paradis",
  //     image: "https://picsum.photos/400/300?random=10",
  //     price: 12.00,
  //     availableTickets: 95,
  //     totalTickets: 200,
  //     category: "Cinéma",
  //   ),
  //   Event(
  //     title: "Atelier Photographie",
  //     date: DateTime.now().add(Duration(days: 14)),
  //     location: "Studio Photo",
  //     image: "https://picsum.photos/400/300?random=11",
  //     price: 75.00,
  //     availableTickets: 15,
  //     totalTickets: 20,
  //     category: "Atelier",
  //   ),
  //   Event(
  //     title: "Convention Jeux Vidéo",
  //     date: DateTime.now().add(Duration(days: 25)),
  //     location: "Centre d'Exposition",
  //     image: "https://picsum.photos/400/300?random=12",
  //     price: 50.00,
  //     availableTickets: 320,
  //     totalTickets: 800,
  //     category: "Gaming",
  //   ),
  //   Event(
  //     title: "Course de Charity",
  //     date: DateTime.now().add(Duration(days: 30)),
  //     location: "Parc des Sports",
  //     image: "https://picsum.photos/400/300?random=13",
  //     price: 25.00,
  //     availableTickets: 250,
  //     totalTickets: 500,
  //     category: "Sport",
  //   ),
  //   Event(
  //     title: "Foire Artisanale",
  //     date: DateTime.now().add(Duration(days: 9)),
  //     location: "Place du Village",
  //     image: "https://picsum.photos/400/300?random=14",
  //     price: 0.00,
  //     availableTickets: 999,
  //     totalTickets: 999,
  //     category: "Artisanat",
  //   ),
  //   Event(
  //     title: "Spectacle de Magie",
  //     date: DateTime.now().add(Duration(days: 16)),
  //     location: "Salle de Spectacle",
  //     image: "https://picsum.photos/400/300?random=15",
  //     price: 28.00,
  //     availableTickets: 45,
  //     totalTickets: 150,
  //     category: "Divertissement",
  //   ),
  // ];
}
