import 'package:flutter/material.dart';
import 'myevents_page.dart';

class TicketsPage extends StatelessWidget {
  final bool isOrganizer;
  const TicketsPage({Key? key, required this.isOrganizer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFA4EAB), // rose
      const Color(0xFF7B2CBF), // violet
      const Color(0xFFFF8C42), // orange
      const Color(0xFF1A1A1A), // noir
    ];

    return Scaffold(
      backgroundColor: colors[3],
      appBar: AppBar(
        title: const Text("Mes Billets"),
        backgroundColor: colors[2],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader("🎟️ Mes billets", colors[0]),
          _TicketList(fetchKey: "myTickets"),

          if (isOrganizer) ...[
            const SizedBox(height: 20),
            _SectionHeader("📑 Billetterie (organisateur)", colors[1]),
            _OrganizerTicketList(),
          ],
        ],
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final String fetchKey;
  const _TicketList({required this.fetchKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.confirmation_num, color: Colors.pink),
            title: const Text("Billet Festival Awilé"),
            subtitle: const Text("24 Août 2026 • Porto-Novo"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Voir"),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrganizerTicketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.confirmation_num_outlined, color: Colors.orange),
            title: const Text("Ticket VIP - Arts de la Rue"),
            subtitle: const Text("Prix: 5000 XOF • Stock: 20"),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: color,
      ),
    );
  }
}