//  Dashboard scanneur (scanner_dashboard.dart)

// 
import 'package:flutter/material.dart';
import 'scanner_scan.dart';
import 'scanner_history.dart';
import 'scanner_model.dart';

class ScannerDashboardPage extends StatefulWidget {
  final Scanner scanner;
  final Event event;

  ScannerDashboardPage({required this.scanner, required this.event});

  @override
  _ScannerDashboardPageState createState() => _ScannerDashboardPageState();
}

class _ScannerDashboardPageState extends State<ScannerDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildDashboardContent(),
      ScannerHistoryPage(eventId: 'event1'), // À adapter avec l'ID réel
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Changer d\'événement',
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannerPage(
                      scanner: widget.scanner,
                      event: widget.event,
                    ),
                  ),
                );
              },
              child: Icon(Icons.qr_code_scanner),
              backgroundColor: Colors.deepPurple,
            )
          : null,
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Header de bienvenue
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Bienvenue, ${widget.scanner.nom}! 🚀',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Prêt à scanner des billets pour',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.event.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // Statistiques en temps réel
          Text(
            'Statistiques en direct',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Total', '${widget.event.totalTickets}', Icons.confirmation_number)),
              Expanded(child: _buildStatCard('Scannés', '${widget.event.scannedTickets}', Icons.check_circle)),
              Expanded(child: _buildStatCard('Restants', '${widget.event.remainingTickets}', Icons.schedule)),
            ],
          ),
          SizedBox(height: 20),
          
          // Jauge de progression
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Remplissage de la salle',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          value: widget.event.progress,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      Text(
                        '${(widget.event.progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('${widget.event.scannedTickets} / ${widget.event.totalTickets} billets'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // Bouton d'action principal
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannerPage(
                      scanner: widget.scanner,
                      event: widget.event,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 24),
                  SizedBox(width: 8),
                  Text('SCANNER UN BILLET', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.deepPurple),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

