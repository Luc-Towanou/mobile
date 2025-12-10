// Page de scan (scanner_scan.dart)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scanner_model.dart';

class ScannerPage extends StatefulWidget {
  final Scanner scanner;
  final Event event;

  ScannerPage({required this.scanner, required this.event});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  ScanResult? _lastScanResult;
  bool _isProcessing = false;

  // Simuler tickets (dans ton vrai code → requête API / DB)
  final List<Ticket> _mockTickets = [
    Ticket(
      id: 'ticket1',
      eventId: 'event1',
      ownerName: 'Marie Dupont',
      type: 'VIP',
      price: 75.00,
      isScanned: false,
      scannedBy: '',
    ),
    Ticket(
      id: 'ticket2',
      eventId: 'event1',
      ownerName: 'Thomas Martin',
      type: 'Standard',
      price: 45.00,
      isScanned: true,
      scannedAt: DateTime.now().subtract(Duration(minutes: 30)),
      scannedBy: 'scanneur1',
    ),
  ];

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return; // éviter double scan
    _isProcessing = true;

    final barcode = capture.barcodes.first;
    final code = barcode.rawValue ?? "";

    if (code.isEmpty) {
      setState(() {
        _lastScanResult = ScanResult(
          success: false,
          message: "QR code invalide",
          timestamp: DateTime.now(),
        );
      });
      _isProcessing = false;
      return;
    }

    // Exemple : chercher ticket par ID = code
    final ticket = _mockTickets.firstWhere(
      (t) => t.id == code,
      orElse: () => Ticket(
        id: 'unknown',
        eventId: '',
        ownerName: 'Inconnu',
        type: '',
        price: 0,
        isScanned: false,
        scannedBy: '',
      ),
    );

    if (ticket.id == 'unknown') {
      setState(() {
        _lastScanResult = ScanResult(
          success: false,
          message: "Billet introuvable ❌",
          timestamp: DateTime.now(),
        );
      });
      HapticFeedback.heavyImpact();
    } else if (ticket.isScanned) {
      setState(() {
        _lastScanResult = ScanResult(
          success: false,
          message: "Billet déjà scanné ❌",
          timestamp: DateTime.now(),
        );
      });
      HapticFeedback.heavyImpact();
    } else {
      setState(() {
        _lastScanResult = ScanResult(
          success: true,
          message: "Billet validé ✅",
          ticket: ticket,
          timestamp: DateTime.now(),
        );
      });
      HapticFeedback.lightImpact();
    }

    await Future.delayed(Duration(seconds: 2)); // petite pause
    _isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _lastScanResult == null
        ? Colors.white
        : _lastScanResult!.success
            ? Colors.green
            : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner de billets"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Caméra en live
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(onDetect: _onDetect),

                // Cadre visuel
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                Positioned(
                  bottom: 30,
                  child: Text(
                    "Placez le QR code dans le cadre",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Résultat
          if (_lastScanResult != null)
            Container(
              padding: EdgeInsets.all(16),
              color: _lastScanResult!.success
                  ? Colors.green[50]
                  : Colors.red[50],
              child: Column(
                children: [
                  Icon(
                    _lastScanResult!.success
                        ? Icons.check_circle
                        : Icons.error,
                    color: _lastScanResult!.success
                        ? Colors.green
                        : Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _lastScanResult!.message,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _lastScanResult!.success
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  if (_lastScanResult!.success &&
                      _lastScanResult!.ticket != null)
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          _lastScanResult!.ticket!.ownerName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Type: ${_lastScanResult!.ticket!.type}'),
                        Text(
                          'Validé à: ${DateFormat("HH:mm").format(_lastScanResult!.timestamp)}',
                        ),
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


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'scanner_model.dart';

// class ScannerPage extends StatefulWidget {
//   final Scanner scanner;
//   final Event event;

//   ScannerPage({required this.scanner, required this.event});

//   @override
//   _ScannerPageState createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   bool _isScanning = false;
//   ScanResult? _lastScanResult;

//   // Données simulées de billets
//   final List<Ticket> _mockTickets = [
//     Ticket(
//       id: 'ticket1',
//       eventId: 'event1',
//       ownerName: 'Marie Dupont',
//       type: 'VIP',
//       price: 75.00,
//       isScanned: false,
//       scannedBy: '',
//     ),
//     Ticket(
//       id: 'ticket2',
//       eventId: 'event1',
//       ownerName: 'Thomas Martin',
//       type: 'Standard',
//       price: 45.00,
//       isScanned: true,
//       scannedAt: DateTime.now().subtract(Duration(minutes: 30)),
//       scannedBy: 'scanneur1',
//     ),
//     Ticket(
//       id: 'ticket3',
//       eventId: 'event1',
//       ownerName: 'Julie Leroy',
//       type: 'VIP',
//       price: 75.00,
//       isScanned: false,
//       scannedBy: '',
//     ),
//   ];

//   Future<void> _simulateScan() async {
//     setState(() {
//       _isScanning = true;
//       _lastScanResult = null;
//     });

//     // Simulation du processus de scan
//     await Future.delayed(Duration(seconds: 1));

//     // Trouver un billet non scanné au hasard
//     final unscannedTickets = _mockTickets.where((t) => !t.isScanned).toList();
//     final randomTicket = unscannedTickets.isNotEmpty 
//         ? unscannedTickets[0] 
//         : _mockTickets[0];

//     final ScanResult result;
    
//     if (randomTicket.isScanned) {
//       // Billet déjà scanné
//       result = ScanResult(
//         success: false,
//         message: 'Billet déjà scanné',
//         timestamp: DateTime.now(),
//       );
//       // Vibration pour erreur
//       HapticFeedback.heavyImpact();
//     } else {
//       // Billet valide
//       result = ScanResult(
//         success: true,
//         message: 'Billet validé avec succès',
//         ticket: randomTicket,
//         timestamp: DateTime.now(),
//       );
//       // Vibration pour succès
//       HapticFeedback.lightImpact();
//     }

//     setState(() {
//       _isScanning = false;
//       _lastScanResult = result;
//     });

//     // Mise à jour simulée du billet
//     if (result.success && result.ticket != null) {
//       setState(() {
//         // Marquer le billet comme scanné (simulation)
//         final index = _mockTickets.indexWhere((t) => t.id == result.ticket!.id);
//         if (index != -1) {
//           _mockTickets[index] = Ticket(
//             id: _mockTickets[index].id,
//             eventId: _mockTickets[index].eventId,
//             ownerName: _mockTickets[index].ownerName,
//             type: _mockTickets[index].type,
//             price: _mockTickets[index].price,
//             isScanned: true,
//             scannedAt: DateTime.now(),
//             scannedBy: widget.scanner.name,
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scanner de billets'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Column(
//         children: [
//           // Vue caméra simulée
//           Expanded(
//             child: Container(
//               color: Colors.black,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Caméra simulée
//                   Icon(Icons.videocam, size: 60, color: Colors.white24),
                  
//                   // Cadre de scan
//                   Container(
//                     width: 250,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: _isScanning 
//                             ? Colors.blue 
//                             : (_lastScanResult?.success == true 
//                                 ? Colors.green 
//                                 : (_lastScanResult?.success == false 
//                                     ? Colors.red 
//                                     : Colors.white)),
//                         width: 4,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
                  
//                   // Animation de scan
//                   if (_isScanning)
//                     Container(
//                       width: 250,
//                       height: 4,
//                       color: Colors.blue,
//                     ),
                  
//                   // Instructions
//                   Positioned(
//                     bottom: 30,
//                     child: Text(
//                       'Positionnez le QR code dans le cadre',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // Résultat du scan
//           if (_lastScanResult != null)
//             Container(
//               padding: EdgeInsets.all(16),
//               color: _lastScanResult!.success ? Colors.green[50] : Colors.red[50],
//               child: Column(
//                 children: [
//                   Icon(
//                     _lastScanResult!.success ? Icons.check_circle : Icons.error,
//                     color: _lastScanResult!.success ? Colors.green : Colors.red,
//                     size: 40,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     _lastScanResult!.message,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: _lastScanResult!.success ? Colors.green : Colors.red,
//                     ),
//                   ),
//                   if (_lastScanResult!.success && _lastScanResult!.ticket != null)
//                     Column(
//                       children: [
//                         SizedBox(height: 16),
//                         Text(
//                           _lastScanResult!.ticket!.ownerName,
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text('Type: ${_lastScanResult!.ticket!.type}'),
//                         Text('Validé à: ${DateFormat('HH:mm').format(_lastScanResult!.timestamp)}'),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _isScanning ? null : _simulateScan,
//         child: _isScanning 
//             ? CircularProgressIndicator(color: Colors.white)
//             : Icon(Icons.qr_code_scanner),
//         backgroundColor: Colors.deepPurple,
//       ),
//     );
//   }
// }


