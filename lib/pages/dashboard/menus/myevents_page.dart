import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  final bool isOrganizer;
  const MyEventsPage({Key? key, required this.isOrganizer}) : super(key: key);

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
        title: const Text("Mes Événements"),
        backgroundColor: colors[1],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader("⭐ Favoris / Suivis", colors[0]),
          _EventList(fetchKey: "favorites"),

          const SizedBox(height: 20),
          _SectionHeader("🎟️ Billets achetés", colors[2]),
          _EventList(fetchKey: "purchased"),

          if (isOrganizer) ...[
            const SizedBox(height: 20),
            _SectionHeader("📌 Mes événements", colors[1]),
            _OrganizerEventList(),
            const SizedBox(height: 20),
            _SectionHeader("➕ Créer un événement", colors[0]),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors[0],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Naviguer vers page création
              },
              icon: const Icon(Icons.add),
              label: const Text("Nouvel événement"),
            ),
          ],
        ],
      ),
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

class _EventList extends StatelessWidget {
  final String fetchKey;
  const _EventList({required this.fetchKey});

  @override
  Widget build(BuildContext context) {
    // Ici tu branches ton FutureBuilder qui appelle l’API
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.event, color: Colors.purple),
            title: const Text("Festival Awilé"),
            subtitle: const Text("Porto-Novo • 24-30 Août 2026"),
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

class _OrganizerEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.event_available, color: Colors.orange),
            title: const Text("Arts de la Rue"),
            subtitle: const Text("Abomey-Calavi • 11-16 Février 2026"),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.visibility)),
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
