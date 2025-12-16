// profile_pages.dart
import 'package:event_rush_mobile/models/user.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/edit_profile_page.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/notifications_page.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/souscription_page.dart';
import 'package:event_rush_mobile/services/api_service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key, this.pageId});

  final int? pageId; 
  
  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  // int _currentIndex =  0;
  late int _currentIndex;

  final List<Widget> _pages = [
    const ProfilePage(),
    const NotificationsPage(),
    const SubscriptionsPage(),
  ];
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageId ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // fe 610600110420
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.withOpacity(0.8), // .withValues()
            Colors.purple.withOpacity(0.8),
            Colors.orange.withOpacity(0.8),
          ],
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.notification),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.card),
            label: 'Abonnements',
          ),
        ],
      ),
    );
  }
}

// PAGE 1: PROFIL
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = await _profileService.getUserProfile();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.pink));
    }

    if (_user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Erreur de chargement", style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: _fetchUserData,
              child: const Text("Réessayer"),
            )
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Hero Section
          _buildHeroSection(_user!),
          const SizedBox(height: 24),
          // Infos personnelles
          _buildPersonalInfoCard(_user!),
          const SizedBox(height: 16),
          // Sécurité
          _buildSecurityCard(),
          const SizedBox(height: 16),
          // Actions rapides
          _buildQuickActions(),
          const SizedBox(height: 16),
          // Paramètres d'affichage
          _buildDisplaySettings(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Widget _buildHeroSection() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(32),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           const Color(0xFFEC4899),
  //           const Color(0xFF8B5CF6),
  //           const Color(0xFFF59E0B),
  //         ],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: const BorderRadius.only(
  //         bottomLeft: Radius.circular(32),
  //         bottomRight: Radius.circular(32),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         // Avatar avec glow
  //         Container(
  //           padding: const EdgeInsets.all(4),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.pink.withOpacity(0.6),
  //                 blurRadius: 20,
  //                 spreadRadius: 4,
  //               ),
  //               BoxShadow(
  //                 color: Colors.purple.withOpacity(0.4),
  //                 blurRadius: 30,
  //                 spreadRadius: 2,
  //               ),
  //             ],
  //           ),
  //           child: CircleAvatar(
  //             radius: 50,
  //             backgroundColor: Colors.white,
  //             child: CircleAvatar(
  //               radius: 46,
  //               backgroundImage: NetworkImage(
  //                   'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face'),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         const Text(
  //           'Alexandre Martin',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         const Text(
  //           'alex.martin@eventrush.com',
  //           style: TextStyle(
  //             color: Colors.white70,
  //             fontSize: 16,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: const Text(
  //             'Organisateur PRO ', //🎟️
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeroSection(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.pink.withOpacity(0.6), blurRadius: 20, spreadRadius: 4),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 46,
                // Utilisation de l'avatar API ou une image par défaut
                backgroundImage: NetworkImage(
                  user.avatar ?? 'https://via.placeholder.com/150', 
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.nom, // Nom dynamique
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email, // Email dynamique
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Rôle : ${user.role.toUpperCase()}', // Rôle dynamique
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (user.points > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${user.points} Points',
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            )
          ]
        ],
      ),
    );
  }

  // Widget _buildPersonalInfoCard(User user) {
  //   return _buildGlassCard(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Iconsax.user, color: Colors.white70, size: 20),
  //             SizedBox(width: 8),
  //             Text(
  //               'Informations personnelles',
  //               style: TextStyle(
  //                   color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildInfoRow('Nom complet', user.nom),
  //         _buildInfoRow('Email', user.email),
  //         _buildInfoRow('Statut Compte', user.souscriptionActive == true  ? "Premium Actif" : "Standard"),
  //         _buildInfoRow('Téléphone', 'Inconnu'),
  //         _buildInfoRow('Membre depuis', user.createdAt!.toLocal().toString().split(' ')[0]),

  //         const SizedBox(height: 16),
  //         // ... Le reste du bouton modifier reste identique
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(vertical: 12),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             gradient: LinearGradient(
  //               colors: [
  //                 Colors.pink.withOpacity(0.6),
  //                 Colors.purple.withOpacity(0.6),
  //               ],
  //             ),
  //           ),
  //           child: const Center(
  //             child: Text(
  //               'Modifier mes informations',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildPersonalInfoCard(User user) {
  return _buildGlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Iconsax.user, color: Colors.white70, size: 20),
            SizedBox(width: 8),
            Text(
              'Informations personnelles',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Nom complet', user.nom),
        _buildInfoRow('Email', user.email),
        _buildInfoRow('Statut Compte',
            user.souscriptionActive == true ? "Premium Actif" : "Standard"),
        _buildInfoRow('Téléphone', 'Inconnu'),
        _buildInfoRow(
            'Membre depuis', user.createdAt!.toLocal().toString().split(' ')[0]),

        const SizedBox(height: 16),

        // ✅ Bouton cliquable
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.pink.withOpacity(0.6),
                  Colors.purple.withOpacity(0.6),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'Modifier mes informations',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  // Widget _buildPersonalInfoCard() {
  //   return _buildGlassCard(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Iconsax.user, color: Colors.white70, size: 20),
  //             SizedBox(width: 8),
  //             Text(
  //               'Informations personnelles',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildInfoRow('Nom complet', 'Alexandre Martin'),
  //         _buildInfoRow('Email', 'alex.martin@eventrush.com'),
  //         _buildInfoRow('Téléphone', '+33 6 12 34 56 78'),
  //         _buildInfoRow('Membre depuis', '15 Jan 2024'),
  //         const SizedBox(height: 16),
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(vertical: 12),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             gradient: LinearGradient(
  //               colors: [
  //                 Colors.pink.withOpacity(0.6),
  //                 Colors.purple.withOpacity(0.6),
  //               ],
  //             ),
  //           ),
  //           child: const Center(
  //             child: Text(
  //               'Modifier mes informations',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSecurityCard() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Iconsax.security, color: Colors.white70, size: 20),
              SizedBox(width: 8),
              Text(
                'Sécurité',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSecurityRow('Modifier le mot de passe', Iconsax.key),
          _buildSecurityRow('Authentification à deux facteurs', Iconsax.shield_tick),
          _buildSecurityRow('Déconnexion', Iconsax.logout, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions rapides',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton('Mes tickets 🎫', Colors.pink),
              _buildActionButton('Devenir organisateur ', Colors.purple), //🚀
              _buildActionButton('Événements publiés', Colors.orange),
              _buildActionButton('Favoris ❤️', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisplaySettings() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Affichage',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingSwitch('Mode sombre', true),
          _buildSettingSwitch('Thème dynamique', false),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          // Text(
          //   value,
          //   style: const TextStyle(color: Colors.white, fontSize: 14),
          // ),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildSecurityRow(String text, IconData icon, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isLogout ? Colors.red : Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isLogout ? Colors.red : Colors.white,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(
            Iconsax.arrow_right_3,
            color: isLogout ? Colors.red : Colors.white70,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(String text, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: (val) {},
            activeColor: Colors.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            'Langue',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Spacer(),
          const Text(
            'Français',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Icon(Iconsax.arrow_down_1, color: Colors.white70, size: 16),
        ],
      ),
    );
  }
}
