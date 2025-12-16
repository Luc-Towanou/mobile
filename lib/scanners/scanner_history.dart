// Page d'historique (scanner_history.dart)


import 'package:event_rush_mobile/scanners/scanner_history_skeleton_page.dart';
import 'package:event_rush_mobile/services/api_service/scanner_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'scanner_model.dart';

// class ScannerHistoryPage extends StatefulWidget {
//   final String eventId;

//   ScannerHistoryPage({required this.eventId});

//   @override
//   _ScannerHistoryPageState createState() => _ScannerHistoryPageState();
// }

// class _ScannerHistoryPageState extends State<ScannerHistoryPage> {
//   final TextEditingController _searchController = TextEditingController();
  
//   // Données simulées d'historique
//   final List<Ticket> _scannedTickets = [
//     Ticket(
//       id: 'ticket2',
//       eventId: 'event1',
//       ownerName: 'Thomas Martin',
//       type: 'Standard',
//       price: 45.00,
//       isScanned: true,
//       scannedAt: DateTime.now().subtract(Duration(minutes: 30)),
//       scannedBy: 'Jean Scanneur',
//     ),
//     Ticket(
//       id: 'ticket4',
//       eventId: 'event1',
//       ownerName: 'Sophie Lambert',
//       type: 'VIP',
//       price: 75.00,
//       isScanned: true,
//       scannedAt: DateTime.now().subtract(Duration(hours: 1)),
//       scannedBy: 'Marie Validatrice',
//     ),
//     Ticket(
//       id: 'ticket5',
//       eventId: 'event1',
//       ownerName: 'Pierre Dubois',
//       type: 'Standard',
//       price: 45.00,
//       isScanned: true,
//       scannedAt: DateTime.now().subtract(Duration(hours: 2)),
//       scannedBy: 'Jean Scanneur',
//     ),
//   ];

//   List<Ticket> get _filteredTickets {
//     if (_searchController.text.isEmpty) {
//       return _scannedTickets;
//     }
//     return _scannedTickets.where((ticket) {
//       return ticket.ownerName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
//              ticket.type.toLowerCase().contains(_searchController.text.toLowerCase());
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Barre de recherche
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Rechercher par nom ou type...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//               ),
//               onChanged: (value) => setState(() {}),
//             ),
//           ),
          
//           // En-tête
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Historique des scans',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   '${_scannedTickets.length} validations',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
          
//           // Liste des scans
//           Expanded(
//             child: _filteredTickets.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.history, size: 60, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text(
//                           'Aucun scan enregistré',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: _filteredTickets.length,
//                     itemBuilder: (context, index) {
//                       final ticket = _filteredTickets[index];
//                       return _buildScanItem(ticket);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScanItem(Ticket ticket) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(Icons.verified_user, color: Colors.green),
//         title: Text(ticket.ownerName, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Type: ${ticket.type}'),
//             if (ticket.scannedAt != null)
//               Text(
//                 'Scanné à: ${DateFormat('HH:mm').format(ticket.scannedAt!)}',
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//           ],
//         ),
//         trailing: Chip(
//           label: Text(ticket.type, style: TextStyle(color: Colors.white)),
//           backgroundColor: ticket.type == 'VIP' ? Colors.amber[700] : Colors.blue,
//         ),
//       ),
//     );
//   }
// }




class ScannerHistoryPage extends StatefulWidget {
  final String eventId;

  ScannerHistoryPage({required this.eventId});

  @override
  _ScannerHistoryPageState createState() => _ScannerHistoryPageState();
}

class _ScannerHistoryPageState extends State<ScannerHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  late ScannerService _scannerService;
  List<Ticket> _scannedTickets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scannerService = ScannerService(); // ton URL Laravel
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      final tickets = await _scannerService.fetchScannedTickets();
      setState(() {
        _scannedTickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Ticket> get _filteredTickets {
    if (_searchController.text.isEmpty) {
      return _scannedTickets;
    }
    return _scannedTickets.where((ticket) {
      return ticket.ownerName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
             ticket.type.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? ScannerHistorySkeleton() // Affiche le squelette de chargement
          : _error != null
              ? Center(child: Text("Erreur: $_error"))
              : Column(
                  children: [
                    // Barre de recherche
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher par nom ou type...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    
                    // En-tête
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Historique des scans',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_scannedTickets.length} validations',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Liste des scans
                    Expanded(
                      child: _filteredTickets.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history, size: 60, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'Aucun scan enregistré',
                                    style: TextStyle(fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredTickets.length,
                              itemBuilder: (context, index) {
                                final ticket = _filteredTickets[index];
                                return _buildScanItem(ticket);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildScanItem(Ticket ticket) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.verified_user, color: Colors.green),
        title: Text(ticket.ownerName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${ticket.type}'),
            if (ticket.scannedAt != null)
              Text(
                'Scanné à: ${DateFormat('HH:mm').format(ticket.scannedAt!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: Chip(
          label: Text(ticket.type, style: TextStyle(color: Colors.white)),
          backgroundColor: ticket.type == 'VIP' ? Colors.amber[700] : Colors.blue,
        ),
      ),
    );
  }
}