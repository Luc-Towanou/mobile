// Page de sélection d'événement (scanner_event_selection.dart)


import 'package:flutter/material.dart';
import 'scanner_dashboard.dart';
import 'scanner_login.dart';
import 'scanner_model.dart';

class EventSelectionPage extends StatefulWidget {
  final Scanner scanner;
  final List<Event> events; // ✅ on passe les vrais events à la page

  EventSelectionPage({required this.scanner, required this.events});

  @override
  _EventSelectionPageState createState() => _EventSelectionPageState();
}

class _EventSelectionPageState extends State<EventSelectionPage> {
  // Données simulées d'événements
  final List<Event> _events = [
    Event(
      id: 'event1',
      name: 'Afro Beats Night 🎶',
      date: DateTime.now().add(Duration(days: 1)),
      location: 'Salle de Concert Central',
      totalTickets: 500,
      scannedTickets: 127,
      imageUrl: 'https://picsum.photos/400/300?random=music',
    ),
    Event(
      id: 'event2',
      name: 'Festival Tech 2023 💻',
      date: DateTime.now().add(Duration(days: 3)),
      location: 'Centre de Convention',
      totalTickets: 300,
      scannedTickets: 89,
      imageUrl: 'https://picsum.photos/400/300?random=tech',
    ),
    Event(
      id: 'event3',
      name: 'Concert Jazz Lounge 🎷',
      date: DateTime.now().add(Duration(days: 5)),
      location: 'Club Jazz Lounge',
      totalTickets: 150,
      scannedTickets: 45,
      imageUrl: 'https://picsum.photos/400/300?random=jazz',
    ),
    Event(
      id: 'event4',
      name: 'Exposition Art Moderne 🎨',
      date: DateTime.now().add(Duration(days: 7)),
      location: 'Galerie Nationale',
      totalTickets: 200,
      scannedTickets: 67,
      imageUrl: 'https://picsum.photos/400/300?random=art',
    ),
  ];


  List<Event> get _assignedEvents {
    return widget.events
        .where((event) => widget.scanner.assignedEvents.contains(event.id))
        .toList(); 
  } 

  // List<Event> get _assignedEvents {
  //   return _events.where((event) => widget.scanner.assignedEvents.contains(event.id)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Événements'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScannerLoginPage(),
            ),),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Bonjour, ${widget.scanner.nom}! 👋',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choisissez un événement à scanner',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _assignedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aucun événement assigné',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _assignedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _assignedEvents[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Stack(
        children: [
          // Image de fond avec overlay
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ),
          
          // Contenu
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                      SizedBox(width: 4),
                      Text(
                        '${event.date.day}/${event.date.month}/${event.date.year}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.location_on, size: 16, color: Colors.white70),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: event.progress,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${event.scannedTickets}/${event.totalTickets} billets',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '${(event.progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScannerDashboardPage(
                              scanner: widget.scanner,
                              event: event,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Commencer le scan', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

