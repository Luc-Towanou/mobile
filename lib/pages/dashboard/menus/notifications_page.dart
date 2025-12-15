// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';


// // PAGE 2: NOTIFICATIONS
// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Header
//         Container(
//           padding: const EdgeInsets.all(32),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.pink.withOpacity(0.1),
//                 Colors.purple.withOpacity(0.1),
//               ],
//             ),
//           ),
//           child: const Column(
//             children: [
//               Text(
//                 'Notifications',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Reste connecté à tes vibes ', //✨
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Actions header
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Iconsax.notification_bing, color: Colors.white70, size: 16),
//                       SizedBox(width: 8),
//                       Text(
//                         'Tout marquer comme lu',
//                         style: TextStyle(color: Colors.white, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Iconsax.setting, color: Colors.white70, size: 20),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildNotificationSection(
//                 'Activité du compte',
//                 Colors.pink,
//                 [
//                   _buildNotificationItem(
//                     'Profil mis à jour',
//                     'Tu as modifié ta photo de profil',
//                     Iconsax.profile_circle,
//                     Colors.pink,
//                     isNew: true,
//                   ),
//                   _buildNotificationItem(
//                     'Nouvel appareil connecté',
//                     'Connexion depuis un nouveau smartphone',
//                     Iconsax.mobile,
//                     Colors.pink,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _buildNotificationSection(
//                 'EventRush Updates',
//                 Colors.purple,
//                 [
//                   _buildNotificationItem(
//                     'Nouveaux événements',
//                     'Découvre les festivals de cette semaine',
//                     Iconsax.calendar,
//                     Colors.purple,
//                     isNew: true,
//                   ),
//                   _buildNotificationItem(
//                     'Commentaires',
//                     '3 nouvelles réactions sur ton événement',
//                     Iconsax.message,
//                     Colors.purple,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _buildNotificationSection(
//                 'Paiements & souscriptions',
//                 Colors.orange,
//                 [
//                   _buildNotificationItem(
//                     'Paiement confirmé',
//                     'Ton abonnement PRO a été renouvelé',
//                     Iconsax.card,
//                     Colors.orange,
//                   ),
//                   _buildNotificationItem(
//                     'Reçu disponible',
//                     'Télécharge ton reçu pour EventFest 2024',
//                     Iconsax.receipt,
//                     Colors.orange,
//                     isNew: true,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNotificationSection(String title, Color color, List<Widget> notifications) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: color,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...notifications,
//       ],
//     );
//   }

//   Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color, {bool isNew = false}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           // Colored stripe
//           Container(
//             width: 4,
//             height: 40,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 12),
//           // Icon
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           // Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (isNew) ...[
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.pink,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           'Nouveau',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Icon(Iconsax.arrow_right_3, color: Colors.white30, size: 16),
//         ],
//       ),
//     );
//   }
// }

import 'package:event_rush_mobile/models/notification.dart';
import 'package:event_rush_mobile/outils/format_date.dart';
import 'package:event_rush_mobile/services/api_service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// Assure-toi d'importer ton service et ton modèle
// import 'services/profile_service.dart';
// import 'models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ProfileService _profileService = ProfileService();
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final notifs = await _profileService.getNotifications();
    if (mounted) {
      setState(() {
        _notifications = notifs;
        _isLoading = false;
      });
    }
  }

  // Helper pour déterminer le style selon le type de notif (optionnel selon ton JSON)
  Map<String, dynamic> _getStyleForNotification(String message) {
    if (message.toLowerCase().contains('paiement') || message.toLowerCase().contains('abonnement')) {
      return {'color': Colors.orange, 'icon': Iconsax.card};
    } else if (message.toLowerCase().contains('commentaire')) {
      return {'color': Colors.purple, 'icon': Iconsax.message};
    } else if (message.toLowerCase().contains('profil')) {
      return {'color': Colors.pink, 'icon': Iconsax.profile_circle};
    }
    return {'color': Colors.blue, 'icon': Iconsax.notification};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header (Ton code original)
        Container(
          padding: const EdgeInsets.all(32),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink.withOpacity(0.1),
                Colors.purple.withOpacity(0.1),
              ],
            ),
          ),
          child: const Column(
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Reste connecté à tes vibes ✨',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
        
        // Actions header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () 
                    async {
                      try {
                        final result = await _profileService.MarkAllRead(); // 👈 appel de ta fonction
                        debugPrint("Notifications marquées comme lues : $result");
                        // Tu peux aussi déclencher un setState ou un snackbar ici
                        // setState(() { ... });
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text("Toutes les notifications sont lues"))
                        // );
                      } catch (e) {
                        debugPrint("Erreur lors du marquage : $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erreur lors du marquage des notifications"))
                        );
                      }
                    
                    // TODO: Appel API pour tout marquer comme lu
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.notification_bing, color: Colors.white70, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Tout marquer comme lu',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Liste Dynamique
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.pink))
              : _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        final style = _getStyleForNotification(notif.message);
                        
                        return _buildNotificationItem(
                          'Notification', // Titre générique ou dérivé du type
                          notif.message,
                          style['icon'],
                          style['color'],
                          isNew: !notif.isRead,
                          date: formatDate(notif.createdAt),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.notification_bing, size: 60, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text("Aucune notification pour le moment", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color,
      {bool isNew = false, String? date}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? color.withOpacity(0.05) : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNew ? color.withOpacity(0.3) : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement haut pour gérer les longs textes
        children: [
          // Barre latérale colorée
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Icone
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (date != null)
                      Text(
                        date,
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10),
                      ),
                  ],
                ),
                if (isNew) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Nouveau',
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}