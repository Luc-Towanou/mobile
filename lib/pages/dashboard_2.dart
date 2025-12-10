
import 'package:event_rush_mobile/pages/dashboard/community_page.dart';
import 'package:event_rush_mobile/pages/dashboard/event_news_page.dart';
import 'package:event_rush_mobile/pages/dashboard/events_page.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/parametre_paage.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/profile_pages.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/billets_page.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/myevents_page.dart';
import 'package:event_rush_mobile/pages/dashboard/explore_page.dart';
import 'package:event_rush_mobile/pages/dashboard/home_dashboard_page.dart';
import 'package:event_rush_mobile/pages/dashboard/news_page.dart';
import 'package:event_rush_mobile/pages/dashboard/orga_page.dart';
import 'package:event_rush_mobile/providers/user_provider.dart';
import 'package:event_rush_mobile/services/api_service.dart';
import 'package:event_rush_mobile/services/api_service/user_service.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui'; // pour l'effet blur

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  late final ApiService apiService;
  final UserService userService = UserService();


  //avatare
  bool _isLoadingAvatar = true;
  String? _avatarUrl;
  String? _firstName;
  String? _lastName;
  String? _role;

  String _getInitials() {
    String first = (_firstName != null && _firstName!.isNotEmpty)
        ? _firstName![0]
        : '';
    String last = (_lastName != null && _lastName!.isNotEmpty)
        ? _lastName![0]
        : '';

    String initials = (first + last).toUpperCase();
    return initials.isNotEmpty ? initials : "U";
  }

  @override
  void initState() {
    super.initState();
    // En production, récupérer le token d'authentification depuis le stockage sécurisé
    apiService = ApiService('auth_token_here');
    _loadUserProfile();
      // final userAsync = ref.watch(userProvider);

  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoadingAvatar = true);

    try {
      final user = await userService.getMe(); // à adapter à ton backend

      setState(() {
        print ("user: avatar_url : ${user.avatar}");
        print ("user: first_name : ${user.nom}");
        print ("user: role : ${user.role}");
        _avatarUrl = user.avatar;
        _firstName = user.nom;
        _lastName = user.email;
        _role = user.role;
      });
    } catch (e) {
      debugPrint("Erreur avatar: $e");
    } finally {
      setState(() => _isLoadingAvatar = false);
    }
  }
  
  final List<Widget> _pages = [
    Center(child: Text("Accueil")),
    Center(child: Text("Actualités")),
    Center(child: Text("Explorer")),
    Center(child: Text("Organisateurs")),
    Center(child: Text("Communauté")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [ //_pages,
              HomePage(apiService: apiService),
              OrganizersPage(),
              EventPage(),
              CommunityPage(apiService: apiService),
              NewsFeedPage(apiService: apiService),
            ],
          ),

          // Avatar flottant avec animation
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => _showAnimatedMenu(context),
              // child: Hero(
              //   tag: "userAvatar",
              //   child: CircleAvatar(
              //     radius: 26,
              //     backgroundColor: Colors.blueAccent,
              //     child: const Icon(Icons.person, color: Colors.white),
              //   ),
              // ),
              child: Hero(
                tag: "userAvatar",
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: (!_isLoadingAvatar && _avatarUrl != null)
                      ? NetworkImage(_avatarUrl!)
                      : null,
                  child: _isLoadingAvatar
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : (_avatarUrl == null
                          ? Text(
                              _getInitials(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null),
                ),
                ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Actualités'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorer'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Organisateurs'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Communauté'),
        ],
      ),
    );
  }

  void _showAnimatedMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Menu",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 80, right: 20),
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _menuItem(Icons.event, "Événements", Colors.pink),
                        _menuItem(Icons.confirmation_num, "Mes billets", Colors.orange),
                        _menuItem(Icons.person, "Profil", Colors.blue),
                        // _menuItem(Icons.notifications, "Notifications", Colors.purple),
                        // _menuItem(Icons.credit_card, "Souscription", Colors.teal),
                        _menuItem(Icons.settings, "Paramètres", Colors.grey),
                        const Divider(color: Colors.white54),
                        _menuItem(Icons.logout, "Déconnexion", Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, -0.2), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: () async {
        // Navigator.pop(context);
        // TODO: Naviguer vers la page correspondante
        if (title == "Événements") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyEventsPage( isOrganizer: true,)));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePages));
        } else if (title == "Mes billets") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TicketsPage(isOrganizer: true, )));
          // Naviguer vers la page des billets
        } else if (title == "Profil") {
          // Naviguer vers la page du profil
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePages()));
        } else if (title == "Notifications") {
          // Naviguer vers la page des notifications
        } else if (title == "Souscription") {
          // Naviguer vers la page de la souscription
        } else if (title == "Paramètres") {
          // Naviguer vers la page des paramètres
            Navigator.push(context, MaterialPageRoute(builder: (_) => ParametrePage()));
        } else if (title == "Déconnexion") {
          // Déconnexion
          await AuthService.logout(context);
        }
      },
    );
  }
}
