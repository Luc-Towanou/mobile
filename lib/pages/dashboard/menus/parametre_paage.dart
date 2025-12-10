import 'package:event_rush_mobile/outils/set_notifs.dart';
import 'package:event_rush_mobile/outils/theme_provider.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/notifications_page.dart';
import 'package:event_rush_mobile/pages/dashboard/menus/profile_pages.dart';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParametrePage extends StatelessWidget {
  const ParametrePage({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _item(IconData icon, String title, BuildContext? context, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Naviguer vers la page correspondante
        // if (title == "Mon profil") {
        //   // Naviguer vers la page du profil
        //   Navigator.push(context!, MaterialPageRoute(builder: (context) => ProfilePages()));
        // } else if (title == "Sécurité") {
        // } else if (title == "Mode sombre") {
        //   // Changer le mode sombre

        // } else if (title == "Notifications") {
        //   // Activer ou désactiver les notifications
        // } else if (title == "Langue") {
        //   // Changer la langue
        // } else if (title == "Souscription") {
        //   // Naviguer vers la page de la souscription
        //   Navigator.push(context!, MaterialPageRoute(builder: (context) => ProfilePages(pageId: 2)));
        // } else if (title == "Statistiques") {
        //   // Naviguer vers la page des statistiques
        // } else if (title == "Aide & Support") {
        //   // Naviguer vers la page d'aide et de support
        // } else if (title == "Conditions") {
        //   // Naviguer vers la page des conditions
        // }
        if (context == null) return;

        switch (title) {

          case "Mon profil":
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePages()));
            break;

          case "Sécurité":
            _showSecurityModal(context);
            break;

          case "Mode sombre":
            DarkModeTile();
            break;

          case "Notifications":
            NotificationsTile();
            break;

          case "Langue":
            _showLanguageModal(context);
            break;

          case "Souscription":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePages(pageId: 2)));
            break;
          
          case "Statistiques":
            _showLanguageModal(context);
            break;

          case "Aide & Support":
            _showHelpModal(context);
            break;

          case "Conditions":
            _showTermsModal(context);
            break;
        }
      },
    );
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // COMPTE
          _sectionTitle("Compte"),
          _item(Icons.person, "Mon profil", context ),
          _item(Icons.lock, "Sécurité", context ),

          // APP
          _sectionTitle("Application"),
          _item(Icons.dark_mode, "Mode sombre", context ),
          _item(Icons.notifications, "Notifications", context ),
          _item(Icons.language, "Langue", context ),

          // ORGANISATEUR
          _sectionTitle("Organisateur"),
          _item(Icons.star, "Souscription", context ),
          _item(Icons.bar_chart, "Statistiques", context ),

          // LEGAL
          _sectionTitle("Support"),
          _item(Icons.help, "Aide & Support", context ),
          _item(Icons.description, "Conditions", context ),

          const SizedBox(height: 30),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
            onTap: () {
              AuthService.logout(context);
            },
          )

        ],
      ),
    );
  }
  void _showSecurityModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sécurité"),
        content: const Text(
          "Vous pouvez gérer la sécurité de votre compte ici.\n\n"
          "✔ Changer votre mot de passe\n"
          "✔ Activer l’authentification à deux facteurs\n"
          "✔ Gérer vos sessions actives"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          )
        ],
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Langue"),
        content: const Text(
          "Bientôt vous pourrez choisir votre langue :\n\n"
          "🇫🇷 Français\n"
          "🇬🇧 English"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _showHelpModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Aide & Support"),
        content: const SingleChildScrollView(
          child: Text(
            "Besoin d'aide ?\n\n"
            "• Vérifiez votre connexion Internet\n"
            "• Contactez notre équipe support\n"
            "• Consultez la FAQ\n\n"
            "Nous sommes là pour vous aider 💬"
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          )
        ],
      ),
    );
  }

  void _showTermsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Conditions d'utilisation"),
        content: const SingleChildScrollView(
          child: Text(
            "En utilisant cette application, vous acceptez :\n\n"
            "• De respecter les règles de la plateforme\n"
            "• De ne pas abuser des fonctionnalités\n"
            "• De respecter les autres utilisateurs\n\n"
            "Dernière mise à jour : 2025"
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("J'ai compris"),
          )
        ],
      ),
    );
  }

  


}

// On utilise ConsumerWidget ou Consumer pour accéder à ref.watch
class DarkModeTile extends ConsumerWidget {
  const DarkModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ici on "observe" le provider avec Riverpod
    final isDark = ref.watch(themeProvider); // bool
    final themeNotifier = ref.read(themeProvider.notifier); // accès aux actions

    return SwitchListTile(
      secondary: const Icon(Icons.dark_mode),
      title: const Text("Mode sombre"),
      value: isDark, // on relie directement au bool du provider
      onChanged: (value) {
        themeNotifier.toggleTheme(); // on déclenche l'action
      },
    );
  }
}

class NotificationsTile extends ConsumerWidget {
  const NotificationsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(notificationProvider); // bool
    final notifier = ref.read(notificationProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text("Notifications"),
      value: enabled,
      onChanged: (value) => notifier.toggle(value),
    );
  }
}

