// import 'package:flutter/material.dart';

// // PAGE 3: SOUSCRIPTIONS
// class SubscriptionsPage extends StatelessWidget {
//   const SubscriptionsPage({super.key});

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
//                 Colors.orange.withOpacity(0.1),
//                 Colors.purple.withOpacity(0.1),
//               ],
//             ),
//           ),
//           child: const Column(
//             children: [
//               Text(
//                 'Historique des souscriptions',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Your journey as an Organizer ', //🚀
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildTimelineItem(
//                 'Organisateur PRO - 30 jours',
//                 '\$29.99',
//                 'Carte •••• 4242',
//                 '15 Jan 2024',
//                 '14 Fév 2024',
//                 true,
//                 0,
//               ),
//               _buildTimelineItem(
//                 'Organisateur BASIC - 14 jours',
//                 '\$9.99',
//                 'Carte •••• 4242',
//                 '01 Jan 2024',
//                 '14 Jan 2024',
//                 false,
//                 1,
//               ),
//               _buildTimelineItem(
//                 'Essai gratuit',
//                 'Gratuit',
//                 'Aucun',
//                 '25 Déc 2023',
//                 '31 Déc 2023',
//                 false,
//                 2,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimelineItem(
//     String title,
//     String price,
//     String paymentMethod,
//     String startDate,
//     String endDate,
//     bool isActive,
//     int index,
//   ) {
//     final colors = [Colors.pink, Colors.purple, Colors.orange];
//     final color = colors[index % colors.length];

//     return Container(
//       margin: const EdgeInsets.only(bottom: 20, left: 20),
//       child: Stack(
//         children: [
//           // Timeline line
//           Positioned(
//             left: -20,
//             top: 0,
//             bottom: 0,
//             child: Container(
//               width: 2,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.pink,
//                     Colors.purple,
//                     Colors.orange,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//           // Timeline dot
//           Positioned(
//             left: -26,
//             top: 30,
//             child: Container(
//               width: 14,
//               height: 14,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.6),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Content card
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isActive ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.1),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: isActive ? Colors.green : Colors.red,
//                         ),
//                       ),
//                       child: Text(
//                         isActive ? 'Actif' : 'Expiré',
//                         style: TextStyle(
//                           color: isActive ? Colors.green : Colors.red,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildDetailRow('Prix', price),
//                 _buildDetailRow('Méthode', paymentMethod),
//                 _buildDetailRow('Début', startDate),
//                 _buildDetailRow('Fin', endDate),
//                 const SizedBox(height: 16),
//                 if (isActive)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           color.withOpacity(0.6),
//                           color.withOpacity(0.3),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Renouveler',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             '$label : ',
//             style: const TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//           Text(
//             value,
//             style: const TextStyle(color: Colors.white, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:event_rush_mobile/models/souscription.dart';
// import 'package:event_rush_mobile/outils/format_date.dart';
// import 'package:event_rush_mobile/services/api_service/user_service.dart';
// import 'package:flutter/material.dart';
// // import 'services/profile_service.dart';
// // import 'models/subscription_model.dart';

// class SubscriptionsPage extends StatefulWidget {
//   const SubscriptionsPage({super.key});

//   @override
//   State<SubscriptionsPage> createState() => _SubscriptionsPageState();
// }

// class _SubscriptionsPageState extends State<SubscriptionsPage> {
//   final ProfileService _profileService = ProfileService();
//   List<Subscription> _subscriptions = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSubscriptions();
//   }

//   Future<void> _fetchSubscriptions() async {
//     final subs = await _profileService.getSubscriptions();
//     if (mounted) {
//       setState(() {
//         _subscriptions = subs;
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Header (Code original)
//         Container(
//           padding: const EdgeInsets.all(32),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.orange.withOpacity(0.1),
//                 Colors.purple.withOpacity(0.1),
//               ],
//             ),
//           ),
//           child: const Column(
//             children: [
//               Text(
//                 'Historique des souscriptions',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24, // Ajusté légèrement pour éviter l'overflow
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Your journey as an Organizer 🚀',
//                 style: TextStyle(color: Colors.white70, fontSize: 16),
//               ),
//             ],
//           ),
//         ),

//         // Liste Timeline Dynamique
//         Expanded(
//           child: _isLoading
//               ? const Center(child: CircularProgressIndicator(color: Colors.orange))
//               : _subscriptions.isEmpty
//                   ? const Center(child: Text("Aucun abonnement trouvé", style: TextStyle(color: Colors.white70)))
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _subscriptions.length,
//                       itemBuilder: (context, index) {
//                         final sub = _subscriptions[index];
//                         // Détermine si c'est actif (selon l'API ou la date)
//                         // Note: Ton JSON renvoie est_active: false souvent, donc on vérifie aussi la date de fin
//                         final bool isActive = sub.statut == 'actif'; 

//                         return _buildTimelineItem(
//                           planName: sub.plan.nom,
//                           amount: sub.montant,
//                           paymentMethod: sub.methode ?? 'Mobile Money',
//                           startDate: formatDate(sub.dateDebut),
//                           endDate: formatDate(sub.dateFin),
//                           isActive: isActive,
//                           index: index,
//                         );
//                       },
//                     ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimelineItem({
//     required String planName,
//     required int amount,
//     required String paymentMethod,
//     required String startDate,
//     required String endDate,
//     required bool isActive,
//     required int index,
//   }) {
//     final colors = [Colors.pink, Colors.purple, Colors.orange];
//     final color = colors[index % colors.length];

//     return Container(
//       margin: const EdgeInsets.only(bottom: 20, left: 20),
//       child: Stack(
//         clipBehavior: Clip.none, // Important pour que les points dépassent
//         children: [
//           // Ligne de la timeline
//           Positioned(
//             left: -20,
//             top: 0,
//             bottom: -20, // Étend la ligne jusqu'en bas
//             child: Container(
//               width: 2,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     color.withOpacity(0.8),
//                     colors[(index + 1) % colors.length].withOpacity(0.8),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//           // Point de la timeline
//           Positioned(
//             left: -26,
//             top: 25,
//             child: Container(
//               width: 14,
//               height: 14,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.6),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Carte de contenu
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isActive ? Colors.green.withOpacity(0.5) : Colors.white.withOpacity(0.1),
//                 width: isActive ? 1.5 : 1,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       planName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: isActive ? Colors.green : Colors.red,
//                         ),
//                       ),
//                       child: Text(
//                         isActive ? 'Actif' : 'Expiré',
//                         style: TextStyle(
//                           color: isActive ? Colors.green : Colors.red,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildDetailRow('Prix', '$amount FCFA'),
//                 _buildDetailRow('Méthode', paymentMethod),
//                 const Divider(color: Colors.white10, height: 20),
//                 _buildDetailRow('Début', startDate),
//                 _buildDetailRow('Fin', endDate),
                
//                 if (isActive) ...[
//                    const SizedBox(height: 16),
//                    InkWell(
//                      onTap: () {
//                        // Action renouveler
//                      },
//                      child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             color.withOpacity(0.8),
//                             color.withOpacity(0.4),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Renouveler',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                                      ),
//                    ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             '$label :',
//             style: const TextStyle(color: Colors.white54, fontSize: 13),
//           ),
//           Text(
//             value,
//             style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:event_rush_mobile/models/souscription.dart';
import 'package:event_rush_mobile/outils/format_date.dart';
import 'package:event_rush_mobile/services/api_service/souscription_service.dart';
import 'package:event_rush_mobile/services/api_service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// import 'services/profile_service.dart';
// import 'models/subscription_model.dart';
// import 'utils.dart'; // Pour formatDate

// 1. Modèle simple pour les Plans disponibles (Simulé pour l'instant)
class PlanModel {
  final int id;
  final String nom;
  final int prix;
  final int dureeJours;
  final String description;
  final List<String> avantages;
  final Color color;

  PlanModel({
    required this.id,
    required this.nom,
    required this.prix,
    required this.dureeJours,
    required this.description,
    required this.avantages,
    required this.color,
  });
}

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final ProfileService _profileService = ProfileService();
  List<Subscription> _history = [];
  bool _isLoading = true;

  // 2. Définition des plans disponibles (Basé sur ton JSON historique)
  final List<PlanModel> _availablePlans = [
    PlanModel(
      id: 1,
      nom: "Basique",
      prix: 2000,
      dureeJours: 10,
      description: "Pour commencer en douceur",
      avantages: ["1 événement / mois", "Support standard"],
      color: Colors.blue,
    ),
    PlanModel(
      id: 2,
      nom: "Pro",
      prix: 3000,
      dureeJours: 16,
      description: "Le choix populaire",
      avantages: ["5 événements / mois", "Statistiques avancées", "Badge Pro"],
      color: Colors.purple,
    ),
    PlanModel(
      id: 3,
      nom: "Premium",
      prix: 5000,
      dureeJours: 32,
      description: "Pour les experts",
      avantages: ["Illimité", "Support VIP 24/7", "Badge Gold", "Marketing boost"],
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final subs = await _profileService.getSubscriptions();
    if (mounted) {
      setState(() {
        _history = subs;
        _isLoading = false;
      });
    }
  }

  // Fonction appelée lors du clic sur un plan
  // void _onSubscribeTap(PlanModel plan) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: const Color(0xFF1A1A1A),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
  //     ),
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(24),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             "Confirmer l'abonnement ${plan.nom}",
  //             style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             "Montant à payer : ${plan.prix} FCFA",
  //             style: const TextStyle(color: Colors.white70, fontSize: 16),
  //           ),
  //           const SizedBox(height: 32),
  //           // Ici, tu intégreras ton moyen de paiement (Fedapay, etc.)
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 // TODO: Lancer la logique de paiement ici
                   
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text("Paiement pour ${plan.nom} lancé...")),
  //                 );
  //                 try {
  //                   print("lancement paiement...");
  //                     await launchPayment(context, plan.id); // ⚠️ Assure-toi que PlanModel a un champ id
  //                   } catch (e) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text("Erreur lors du paiement : $e")),
  //                     );
  //                   };
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: plan.color,
  //                 padding: const EdgeInsets.symmetric(vertical: 16),
  //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //               ),
  //               child: const Text("Payer maintenant", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  void _onSubscribeTap(PlanModel plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        // ⚠️ On capture le ScaffoldMessenger AVANT de fermer le BottomSheet
        final messenger = ScaffoldMessenger.of(context);

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirmer l'abonnement ${plan.nom}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Montant à payer : ${plan.prix} FCFA",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Fermer le BottomSheet
                    Navigator.pop(sheetContext);

                    try {
                      // Lancer le paiement → ouvre la WebView
                      await launchPayment(context, plan.id);

                      // ✅ Afficher le SnackBar avec le bon contexte
                      messenger.showSnackBar(
                        SnackBar(content: Text("Paiement pour ${plan.nom} lancé...")),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text("Erreur lors du paiement : $e")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Payer maintenant",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          _buildHeader(),

          const SizedBox(height: 24),
          
          // SECTION 1: CHOISIR UN PLAN (Carousel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Iconsax.flash_1, color: Colors.yellow, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Choisir un plan",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 260, // Hauteur du carrousel
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _availablePlans.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return _buildPlanCard(_availablePlans[index]);
              },
            ),
          ),

          const SizedBox(height: 32),

          // SECTION 2: HISTORIQUE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Iconsax.clock, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Historique",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
              : ListView.builder(
                  shrinkWrap: true, // Important car dans un SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Désactive le scroll interne
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final sub = _history[index];
                    // Logique pour déterminer si actif (date fin > now et est_active API)
                    // Note: J'utilise DateTime.tryParse pour la démo, assure-toi d'utiliser ton formatDate ou la logique réelle
                    bool isActive = sub.statut == 'actif'; 

                    return _buildTimelineItem(
                      planName: sub.plan.nom,
                      amount: sub.montant,
                      paymentMethod: sub.methode ?? 'Mobile Money',
                      startDate: formatDate(sub.dateDebut),
                      endDate: formatDate(sub.dateFin),
                      isActive: isActive,
                      index: index,
                    );
                  },
                ),
           const SizedBox(height: 80), // Espace pour le BottomNavBar
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.15),
            Colors.purple.withOpacity(0.15),
          ],
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Abonnements',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Booste tes capacités ',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // WIDGET: CARTE DE PLAN
  Widget _buildPlanCard(PlanModel plan) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            plan.color.withOpacity(0.2),
            plan.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: plan.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Durée
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${plan.dureeJours} jours",
              style: TextStyle(color: plan.color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            plan.nom,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "${plan.prix} FCFA",
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          // Liste des avantages (limité à 2 pour l'affichage carte)
          ...plan.avantages.take(2).map((av) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: plan.color, size: 12),
                const SizedBox(width: 6),
                Expanded(child: Text(av, style: const TextStyle(color: Colors.white70, fontSize: 10), overflow: TextOverflow.ellipsis)),
              ],
            ),
          )),
          const Spacer(),
          // Bouton Choisir
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onSubscribeTap(plan),
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 0), // Compact
              ),
              child: const Text("Choisir", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // // WIDGET: TIMELINE ITEM (Adapté pour SingleChildScrollView)
  // Widget _buildTimelineItem({
  //   required String planName,
  //   required int amount,
  //   required String paymentMethod,
  //   required String startDate,
  //   required String endDate,
  //   required bool isActive,
  //   required int index,
  // }) {
  //   final colors = [Colors.pink, Colors.purple, Colors.orange];
  //   final color = colors[index % colors.length];

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 20),
  //     child: IntrinsicHeight( // Important pour que la ligne verticale s'adapte
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           // Colonne Gauche : Ligne + Point
  //           SizedBox(
  //             width: 30,
  //             child: Stack(
  //               children: [
  //                 // Ligne
  //                 Positioned(
  //                   top: 0, bottom: 0, left: 14,
  //                   child: Container(
  //                     width: 2,
  //                     color: color.withOpacity(0.3),
  //                   ),
  //                 ),
  //                 // Point
  //                 Positioned(
  //                   top: 24, left: 8,
  //                   child: Container(
  //                     width: 14, height: 14,
  //                     decoration: BoxDecoration(
  //                       color: color,
  //                       shape: BoxShape.circle,
  //                       boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           // Colonne Droite : Carte Contenu
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.05),
  //                 borderRadius: BorderRadius.circular(16),
  //                 border: Border.all(
  //                   color: isActive ? Colors.green.withOpacity(0.5) : Colors.transparent,
  //                 ),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                    Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(planName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
  //                       if (isActive) 
  //                         Container(
  //                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                           decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
  //                           child: const Text("Actif", style: TextStyle(color: Colors.green, fontSize: 10)),
  //                         )
  //                     ],
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text("$amount FCFA • $paymentMethod", style: const TextStyle(color: Colors.white70, fontSize: 12)),
  //                   Text("Du $startDate au $endDate", style: const TextStyle(color: Colors.white30, fontSize: 10)),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // WIDGET: TIMELINE ITEM (Adapté pour SingleChildScrollView)
  Widget _buildTimelineItem({
    required String planName,
    required int amount,
    required String paymentMethod,
    required String startDate,
    required String endDate,
    required bool isActive,
    required int index,
  }) {
    // 🎨 Mapping des couleurs selon le plan
    Color _getPlanColor(String plan) {
      switch (plan.toLowerCase()) {
        case 'niv_0':
          return Colors.white; // Blanc
        case 'basique':
          return Colors.blue; // Bleu
        case 'pro':
          return Colors.purple; // Violet
        case 'premium':
          return Colors.orange; // Orange
        default:
          return Colors.pink; // fallback
      }
    }

    final color = _getPlanColor(planName);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colonne Gauche : Ligne + Point
            SizedBox(
              width: 30,
              child: Stack(
                children: [
                  // Ligne
                  Positioned(
                    top: 0, bottom: 0, left: 14,
                    child: Container(
                      width: 2,
                      color: color.withOpacity(0.3),
                    ),
                  ),
                  // Point
                  Positioned(
                    top: 24, left: 8,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Colonne Droite : Carte Contenu
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive ? Colors.green.withOpacity(0.5) : Colors.transparent,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          planName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Actif",
                              style: TextStyle(color: Colors.green, fontSize: 10),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$amount FCFA • $paymentMethod",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      "Du $startDate au $endDate",
                      style: const TextStyle(color: Colors.white30, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}