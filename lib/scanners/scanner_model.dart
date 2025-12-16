//  Modèles de données (scanner_model.dart)


class Scanner {
  final String id;
  // final String name;
  final String nom;
  final String? email;
  final String? avatar; // "avatar": null,
  final String? role; // "role": "scanneur"
  final List<String> assignedEvents;

  Scanner({
    required this.id,
    // required this.name,
    required this.nom,
    this.email,
    this.avatar,
    this.role,
    required this.assignedEvents,
  });
}

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final int totalTickets;
  final int scannedTickets;
  final String imageUrl;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.totalTickets,
    required this.scannedTickets,
    required this.imageUrl,
  });

  double get progress => totalTickets > 0 ? scannedTickets / totalTickets : 0;
  int get remainingTickets => totalTickets - scannedTickets;
}

class Ticket {
  final String id;
  final String eventId;
  final String ownerName;
  final String type;
  final double price;
  final bool isScanned;
  final DateTime? scannedAt;
  final String scannedBy;

  Ticket({
    required this.id,
    required this.eventId,
    required this.ownerName,
    required this.type,
    required this.price,
    required this.isScanned,
    this.scannedAt,
    required this.scannedBy,
  });
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'].toString(),
      eventId: json['event_id'].toString(),
      ownerName: json['owner_name'] ?? '',
      type: json['type'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isScanned: json['is_scanned'] ?? true,
      scannedAt: json['scanned_at'] != null
          ? DateTime.parse(json['scanned_at'])
          : null,
      scannedBy: json['scanned_by'].toString(),
    );
  }
}

class ScanResult {
  final bool success;
  final String message;
  final Ticket? ticket;
  final DateTime timestamp;

  ScanResult({
    required this.success,
    required this.message,
    this.ticket,
    required this.timestamp,
  });
}

