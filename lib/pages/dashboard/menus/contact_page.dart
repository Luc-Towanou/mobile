import 'package:flutter/material.dart';

/// EventRush – Contact Page (serious, trustworthy, M3) 
/// ---------------------------------------------------- 
/// Goals: /// - Professional yet warm design 
/// - Clear contact channels (email, phone, WhatsApp placeholder)
/// - Self-service first (FAQ, quick links), then contact form 
/// - Accessible, responsive, no external packages required 
/// - Ready to mount in a BottomNavigationBar or as a standalone route 
/// 🇫🇷 Commentaires partiellement en français. 
/// 🇬🇧 Partially in English. 

class ContactPage extends StatefulWidget { 
  const ContactPage({super.key});

  @override State<ContactPage> createState() => _ContactPageState(); 
}

class _ContactPageState extends State<ContactPage> { final _formKey = GlobalKey<FormState>(); final _nameCtrl = TextEditingController(); final _emailCtrl = TextEditingController(); final _subjectCtrl = TextEditingController(); final _messageCtrl = TextEditingController(); String _topic = 'Support Billetterie'; bool _consent = false; bool _submitting = false;
  void _navigateToHomePage() {
    Navigator.pushReplacementNamed(context, '/');
  }

@override void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _subjectCtrl.dispose(); _messageCtrl.dispose(); super.dispose(); }

@override Widget build(BuildContext context) { final cs = Theme.of(context).colorScheme; final text = Theme.of(context).textTheme;

return Scaffold(
  appBar: AppBar(
    leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // onPressed: () => Navigator.of(context).pop(), //_navigateToHomePage
          onPressed: _navigateToHomePage,
          
        ),
    title: const Text('Contact • EventRush'),
  ),
  body: SafeArea(
    child: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Besoin d\'aide ?', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Nous répondons vite — généralement sous 24h ouvrées. \nSelect a topic below or write to us. ',
                  style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Row(
                      children: const [
                        TopicChip(label: "Billetterie", icon: Icons.confirmation_num),
                        SizedBox(width: 8),
                        TopicChip(label: "Organisateurs", icon: Icons.group),
                      ],
                    ),
                    // _TopicChip(label: 'Support Billetterie', selected: _topic == 'Support Billetterie', onTap: () => setState(() => _topic = 'Support Billetterie')),
                    // _TopicChip(label: 'Organisateurs', selected: _topic == 'Organisateurs', onTap: () => setState(() => _topic = 'Organisateurs')),
                    // _TopicChip(label: 'Compte & Connexion', selected: _topic == 'Compte & Connexion', onTap: () => setState(() => _topic = 'Compte & Connexion')),
                    // _TopicChip(label: 'Paiements & Remboursements', selected: _topic == 'Paiements & Remboursements', onTap: () => setState(() => _topic = 'Paiements & Remboursements')),
                    // _TopicChip(label: 'Partenariats', selected: _topic == 'Partenariats', onTap: () => setState(() => _topic = 'Partenariats')),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Quick contact channels
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _ContactCard(
                    icon: Icons.mail_outline,
                    title: 'Email',
                    subtitle: 'support@eventrush.app',
                    caption: 'Réponse: < 24h ouvrées',
                    onTap: () {
                      // TIP: integrate url_launcher to open mailto:
                      // launchUrl(Uri.parse('mailto:support@eventrush.app?subject=Support EventRush'))
                      _copyToClipboard(context, 'support@eventrush.app');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ContactCard(
                    icon: Icons.call_outlined,
                    title: 'Téléphone',
                    subtitle: '+229 00 00 00 00',
                    caption: 'Lun–Ven 9:00–18:00',
                    onTap: () {
                      _copyToClipboard(context, '+22900000000');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _ContactCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Messages',
                    subtitle: 'WhatsApp / In‑app',
                    caption: 'Prochainement disponible',
                    onTap: () {},
                    disabled: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ContactCard(
                    icon: Icons.location_on_outlined,
                    title: 'Adresse',
                    subtitle: 'Cotonou, BJ',
                    caption: 'Bureau EventRush',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),

        // FAQ
        _SectionHeader(title: 'FAQ rapide', subtitle: 'Self‑service — les questions les plus fréquentes'),
        SliverToBoxAdapter(child: _FaqList()),

        // Contact form
        _SectionHeader(title: 'Écrire au support', subtitle: 'Nous revenons vers toi rapidement'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: _ContactForm(
              formKey: _formKey,
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              subjectCtrl: _subjectCtrl,
              messageCtrl: _messageCtrl,
              topic: _topic,
              consent: _consent,
              submitting: _submitting,
              onConsentChanged: (v) => setState(() => _consent = v ?? false),
              onSubmit: _handleSubmit,
            ),
          ),
        ),

        // Service level / legal
        _SectionHeader(title: 'Délais & conformité', subtitle: 'SLA, confidentialité, données'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: _ServiceLevelCard(),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    ),
  ),
);

}

Future<void> _handleSubmit() async { FocusScope.of(context).unfocus(); if (!_formKey.currentState!.validate()) return; if (!_consent) { _showSnack('Veuillez accepter la politique de confidentialité.'); return; } setState(() => _submitting = true);

// Simulate network
await Future.delayed(const Duration(seconds: 1));

setState(() => _submitting = false);
_formKey.currentState!.reset();
_consent = false;

_showSnack('Message envoyé. Merci ! / Message sent. Thank you!');

}

void _showSnack(String text) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(text)), ); }

void _copyToClipboard(BuildContext context, String value) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Copié: $value')), ); } }

// ----------------------------- UI bits ----------------------------- 

class _SectionHeader extends StatelessWidget { 
  const _SectionHeader({required this.title, required this.subtitle}); 
  final String title; final String subtitle; 
  @override Widget build(BuildContext context) { 
    final cs = Theme.of(context).colorScheme; 
    return SliverToBoxAdapter( 
      child: Padding( 
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8), 
        child: Row( 
          children: [ 
            Icon(Icons.info_outline, color: cs.primary), 
            const SizedBox(width: 8), Expanded( 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ 
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), 
                  const SizedBox(height: 2), 
                  Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant)
                  ), 
                ], 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}

class _ContactCard extends StatelessWidget { 
  const _ContactCard({ required this.icon, required this.title, required this.subtitle, required this.caption, required this.onTap, this.disabled = false, }); final IconData icon; final String title; final String subtitle; final String caption; final VoidCallback onTap; final bool disabled;

@override Widget build(BuildContext context) { final cs = Theme.of(context).colorScheme; return Opacity( opacity: disabled ? 0.6 : 1, child: Card( elevation: 0.8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: InkWell( borderRadius: BorderRadius.circular(20), onTap: disabled ? null : onTap, child: Padding( padding: const EdgeInsets.all(16), child: Row( children: [ CircleAvatar( radius: 26, backgroundColor: cs.primaryContainer, child: Icon(icon, color: cs.onPrimaryContainer), ), const SizedBox(width: 12), Expanded( child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant)), const SizedBox(height: 4), Text(caption, style: TextStyle(color: cs.onSurfaceVariant)), ], ), ), const Icon(Icons.chevron_right), ], ), ), ), ), ); } }

class _FaqList extends StatelessWidget {
   final faqs = const [ 
    ( 'Je n\'ai pas reçu mon billet', 
    'Vérifie dans tes spams et assure-toi que l\'adresse mail sur ton compte est correcte. Sinon, contacte le support avec la référence de commande.' 
    ), 
    ( 'Problème de paiement', 
    'Les paiements peuvent prendre quelques minutes. Si débité sans billet, envoie le justificatif et la référence pour vérification.' 
    ), 
    ( 'Comment devenir organisateur ?',
      'Crée un compte, demande le rôle Organisateur dans les paramètres, puis complète la vérification KYC. Nous te recontactons rapidement.' 
    ), 
    ( 'Scanner de billets ne marche pas', 
      'Assure-toi d\'avoir autorisé l\'accès à la caméra et que le QR est net. Mets l\'app à jour si nécessaire.' 
    ),
  ];

const _FaqList({super.key});

@override Widget build(BuildContext context) { final cs = Theme.of(context).colorScheme; return Padding( padding: const EdgeInsets.symmetric(horizontal: 16), child: Card( elevation: 0.8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Padding( padding: const EdgeInsets.symmetric(vertical: 8), child: Column( children: [ for (final (q, a) in faqs) Theme( data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: ExpansionTile( leading: Icon(Icons.help_outline, color: cs.primary), title: Text(q, style: const TextStyle(fontWeight: FontWeight.w700)), children: [ Padding( padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: Align( alignment: Alignment.centerLeft, child: Text(a), ), ) ], ), ), ], ), ), ), ); } }

class _ContactForm extends StatelessWidget { const _ContactForm({ required this.formKey, required this.nameCtrl, required this.emailCtrl, required this.subjectCtrl, required this.messageCtrl, required this.topic, required this.consent, required this.submitting, required this.onConsentChanged, required this.onSubmit, });

final GlobalKey<FormState> formKey; final TextEditingController nameCtrl; final TextEditingController emailCtrl; final TextEditingController subjectCtrl; final TextEditingController messageCtrl; final String topic; final bool consent; final bool submitting; final ValueChanged<bool?> onConsentChanged; final VoidCallback onSubmit;

@override Widget build(BuildContext context) { final cs = Theme.of(context).colorScheme; return Card( elevation: 0.8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Padding( padding: const EdgeInsets.all(16), child: Form( key: formKey, child: Column( children: [ _TextField( controller: nameCtrl, label: 'Nom complet / Full name', textInputAction: TextInputAction.next, validator: (v) => (v == null || v.trim().length < 2) ? 'Nom invalide' : null, ), _TextField( controller: emailCtrl, label: 'Email', keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, validator: (v) => _emailValid(v) ? null : 'Email invalide', ), _TextField( controller: subjectCtrl, label: 'Sujet', textInputAction: TextInputAction.next, validator: (v) => (v == null || v.trim().isEmpty) ? 'Sujet requis' : null, ), Align( alignment: Alignment.centerLeft, child: Padding( padding: const EdgeInsets.only(top: 8, bottom: 4), child: Text('Sujet / Topic détecté: $topic', style: TextStyle(color: cs.onSurfaceVariant)), ), ), _TextField( controller: messageCtrl, label: 'Message', maxLines: 6, validator: (v) => (v == null || v.trim().length < 10) ? 'Minimum 10 caractères' : null, ), const SizedBox(height: 8), Row( crossAxisAlignment: CrossAxisAlignment.start, children: [ Checkbox(value: consent, onChanged: onConsentChanged), Expanded( child: Text( "J'accepte que mes données soient utilisées pour traiter ma demande (Privacy Policy).", style: TextStyle(color: cs.onSurfaceVariant), ), ), ], ), const SizedBox(height: 8), SizedBox( width: double.infinity, child: FilledButton.icon( onPressed: submitting ? null : onSubmit, icon: submitting ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded), label: Text(submitting ? 'Envoi…' : 'Envoyer'), ), ), ], ), ), ), ); }

bool _emailValid(String? v) { if (v == null) return false; final p = RegExp(r'^\S+@\S+.\S+$'); return p.hasMatch(v.trim()); } }

class _TextField extends StatelessWidget { const _TextField({ required this.controller, required this.label, this.keyboardType, this.textInputAction, this.validator, this.maxLines = 1, });

final TextEditingController controller; final String label; final TextInputType? keyboardType; final TextInputAction? textInputAction; final String? Function(String?)? validator; final int maxLines;

@override Widget build(BuildContext context) { return Padding( padding: const EdgeInsets.only(bottom: 12), child: TextFormField( controller: controller, keyboardType: keyboardType, textInputAction: textInputAction, validator: validator, maxLines: maxLines, decoration: InputDecoration( labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), ), ), ); } }

class _ServiceLevelCard extends StatelessWidget { 
  @override Widget build(BuildContext context) { 
    final cs = Theme.of(context).colorScheme; 
    return Card( 
      elevation: 0.8, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      child: Padding( 
        padding: const EdgeInsets.all(16), 
        child: Column( crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Row( children: [ 
              Icon(Icons.speed_outlined, color: cs.primary), 
              const SizedBox(width: 8), 
              const Text('Service Level (SLA)', style: TextStyle(fontWeight: FontWeight.w800)),
              ], 
            ), 
            const SizedBox(height: 8), 
            const Text('• Réponse initiale: sous 24h ouvrées\n• Résolution: 1–3 jours selon complexité\n• Urgences billetterie: priorisées les jours d\'événement'), 
            const Divider(height: 24), 
            Row( children: [ 
              Icon(Icons.verified_user_outlined, color: cs.primary), 
              const SizedBox(width: 8), 
              const Text('Confidentialité & Données', style: TextStyle(fontWeight: FontWeight.w800)), 
              ], 
            ), 
            const SizedBox(height: 8), 
            const Text( "Tes données sont utilisées uniquement pour traiter ta demande et améliorer nos services. Tu peux demander l'effacement à tout moment.", 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}

class TopicChip extends StatelessWidget { 
  // const TopicChip({required this.label, required this.selected, required this.onTap}); 
  final String label; // final bool selected; final VoidCallback onTap; 
  final IconData icon;

 const TopicChip({Key? key, required this.label, required this.icon, }) : super(key: key);

  @override 
   Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        // action
      },
      // onSelected: () => onTap()
    );
  }


  // Widget build(BuildContext context) { 
  //   return ChoiceChip( 
  //     label: Text(label), 
  //     selected: selected, 
  //     onSelected: () => onTap(), 
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
  //   ); 
  // } 
}