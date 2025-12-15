import 'package:event_rush_mobile/outils/header_my_event.dart';
import 'package:flutter/material.dart';
import 'myevents_page.dart';


// class TicketsPage extends StatelessWidget {
//   final bool isOrganizer;
//   const TicketsPage({Key? key, required this.isOrganizer}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final colors = [
//       const Color(0xFFFA4EAB), // rose
//       const Color(0xFF7B2CBF), // violet
//       const Color(0xFFFF8C42), // orange
//       const Color(0xFF1A1A1A), // noir
//     ];

//     return Scaffold(
//       backgroundColor: colors[3],
//       appBar: AppBar(
//         title: const Text("Mes Billets"),
//         backgroundColor: colors[2],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _SectionHeader("🎟️ Mes billets", colors[0]),
//           _TicketList(fetchKey: "myTickets"),

//           if (isOrganizer) ...[
//             const SizedBox(height: 20),
//             _SectionHeader("📑 Billetterie (organisateur)", colors[1]),
//             _OrganizerTicketList(),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _TicketList extends StatelessWidget {
//   final String fetchKey;
//   const _TicketList({required this.fetchKey});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.confirmation_num, color: Colors.pink),
//             title: const Text("Billet Festival Awilé"),
//             subtitle: const Text("24 Août 2026 • Porto-Novo"),
//             trailing: ElevatedButton(
//               onPressed: () {},
//               child: const Text("Voir"),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrganizerTicketList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.confirmation_num_outlined, color: Colors.orange),
//             title: const Text("Ticket VIP - Arts de la Rue"),
//             subtitle: const Text("Prix: 5000 XOF • Stock: 20"),
//             trailing: Wrap(
//               spacing: 8,
//               children: [
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final Color color;
//   const _SectionHeader(this.title, this.color);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 18,
//         color: color,
//       ),
//     );
//   }
// }



class TicketsPage extends StatelessWidget {
  final bool isOrganizer;
  const TicketsPage({Key? key, required this.isOrganizer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("Mes Billets 🎟️"),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const FunSectionHeader(title: "Mes Pass (Achetés)", icon: Icons.qr_code_2, color: AppColors.pink),
          _UserBilletCard(eventName: "Festival Awilé", type: "Pass Standard", date: "24 Août 2026"),
          _UserBilletCard(eventName: "Concert Live", type: "VIP Gold", date: "12 Déc 2025"),

          if (isOrganizer) ...[
            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            const FunSectionHeader(title: "Gestion Billetterie", icon: Icons.sell, color: AppColors.orange),
            
            // Un conteneur pour grouper les tickets d'un évent
            _OrganizerTicketGroup(
              eventName: "Arts de la Rue",
              children: [
                _AdminTicketRow(name: "Ticket VIP", price: 5000, sold: 12, total: 20),
                _AdminTicketRow(name: "Ticket Standard", price: 2000, sold: 150, total: 500),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// --- WIDGET BILLET USER (Look "Ticket de cinéma") ---
class _UserBilletCard extends StatelessWidget {
  final String eventName;
  final String type;
  final String date;

  const _UserBilletCard({required this.eventName, required this.type, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Partie Gauche (Gradient)
          Container(
            width: 10,
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(eventName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(type, style: const TextStyle(color: AppColors.pink, fontWeight: FontWeight.w600)),
                  Text(date, style: TextStyle(color: AppColors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
          // Ligne pointillée séparatrice
          LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(8, (_) => const SizedBox(width: 1, height: 5, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)))),
              );
            },
          ),
          // QR Code simulé
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.qr_code, color: Colors.white, size: 40),
                Text("Voir", style: TextStyle(color: Colors.white54, fontSize: 10))
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- WIDGET ADMIN TICKET (Look "Dashboard") ---
class _OrganizerTicketGroup extends StatelessWidget {
  final String eventName;
  final List<Widget> children;
  const _OrganizerTicketGroup({required this.eventName, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Évent : $eventName", style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _AdminTicketRow extends StatelessWidget {
  final String name;
  final int price;
  final int sold;
  final int total;

  const _AdminTicketRow({required this.name, required this.price, required this.sold, required this.total});

  @override
  Widget build(BuildContext context) {
    double progress = total == 0 ? 0 : sold / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("$price XOF", style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white10, color: AppColors.orange, minHeight: 6),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Vendus : $sold / $total", style: const TextStyle(color: Colors.grey, fontSize: 11)),
              Row(
                children: [
                  GestureDetector(onTap: (){}, child: const Icon(Icons.edit, size: 16, color: Colors.white54)),
                  const SizedBox(width: 10),
                  GestureDetector(onTap: (){}, child: const Icon(Icons.delete, size: 16, color: Colors.redAccent)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}