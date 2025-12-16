// Page de connexion (scanner_login.dart)


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'scanner_dashboard.dart';

import '../outils/notifications.dart';
import '../services/auth_service.dart';

import 'scanner_event_selection.dart';
import 'scanner_model.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ScannerLoginPage extends StatefulWidget {
  @override
  _ScannerLoginPageState createState() => _ScannerLoginPageState();
}

class _ScannerLoginPageState extends State<ScannerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _passwordController = TextEditingController();
  final _qrController = TextEditingController();
  final AuthService authService = AuthService();

  bool _isNomValid = false;
  bool _isFormValid = false;
  bool _obscurePassword = true;
  
  bool _isLoading = false;
  bool _useQRLogin = false;

  @override
  void initState() {
    super.initState();
    _nomController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }
  
  @override
  void dispose() {
    _nomController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _validateForm() {
    final nom = _nomController.text;
    final password = _passwordController.text;
    final regex = RegExp(r'^[A-Za-z0-9]{6}[0-9]{4}$');
    
    setState(() {
      _isNomValid = regex.hasMatch(nom);
      _isFormValid =  nom.isNotEmpty &&
                      password.isNotEmpty &&
                      _isNomValid &&
                      password.length >= 6;
    });

    // setState(() {
    //   _isFormValid = nom.isNotEmpty && 
    //                  password.isNotEmpty && 
    //                  nom.contains('@') &&
    //                  password.length >= 6;
    // });
  }


  

  // Données simulées (à remplacer par votre authentification réelle)
  final List<Scanner> _mockScanners = [
    Scanner(
      id: '1',
      // name: 'Jean Scanneur',
      nom: 'scanneur@eventrush.com',
      // email: null,
      assignedEvents: ['event1', 'event2', 'event3'],
    ),
    Scanner(
      id: '2',
      // name: 'Marie Validatrice',
      nom: 'marie@eventrush.com',
      // email: null,
      assignedEvents: ['event1', 'event4'],
    ),
  ];

  void _login() async {
      setState(() {
        _isLoading = true;
      });
    try {
      // 1️⃣ Login pour récupérer le token
      final loginData = await authService.loginScanners(
        _nomController.text,
        _passwordController.text,
      );

      final token = loginData["access_token"];
      print("Token: $token");

      // 2️⃣ Récupérer le profil du scanner
      final userData = await authService.getScannerProfile(token);
      print("Scanner: $userData");

      // 3️⃣ Récupérer les événements du scanner
      // final eventsDataRaw = await authService.getScannreEvents(token);
      final result = await authService.getScannreEvents(token);
      print("Events RAW: $result");

      // 🔥 Extraire la vraie liste d’événements (eventsDataRaw[0])
      // List<dynamic> eventsList = [];
      // if (eventsDataRaw is List && eventsDataRaw.isNotEmpty) {
      //   eventsList = List<dynamic>.from(eventsDataRaw[0]);
      // }
      List<dynamic> eventsList = [];
        // if (eventsDataRaw is List && eventsDataRaw.isNotEmpty) {
        //   if (eventsDataRaw[0] is Map) {
        //     eventsList = List<dynamic>.from(eventsDataRaw);
        //   } else {
        //     print("Pas d'événements : ${eventsDataRaw[0]}");
        //   }
        // }
        if (result["success"] == true) {
          List<dynamic> eventslist = result["events"];
          int total = result["total"];
          print("Événements récupérés: $eventslist (total: $total)");
          // print("EventsList: $events");
          // print("EventsList total: $total");

          // 4️⃣ Construire l’objet Scanner

          final scanner = Scanner(
            id: userData['id'].toString(),
            // name: userData['nom'], // tu peux mettre un vrai champ name si dispo
            nom: userData['nom'],
            email: userData['email'],
            assignedEvents: List<String>.from(
              eventslist.map((e) => e['id'].toString()),
            ),
          );
          print("Scanneur: $scanner");

          final events = eventslist.map((e) => Event(
                  id: e['id'].toString(),
                  name: e['titre'],
                  date: DateTime.parse(e['date_debut']),
                  location: e['lieu'],
                  totalTickets: e['nbr_achat'], // ou autre champ
                  scannedTickets: 0, // à calculer si dispo
                  imageUrl: e['affiche'] ?? 'https://picsum.photos/400/300',
                )).toList();
              print("Events compte: ${events.length}");

          // 5️⃣ Navigation vers la page de sélection
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EventSelectionPage(
                scanner: scanner,
                events: events
                ),
            ),
          );
        } else {
          print("Erreur: ${result["message"]} (code: ${result["status"]})");
        }
      

      
      //  if (_formKey.currentState!.validate()) {
      //   print('Email: ${_nomController.text}');

      //   // 1️⃣ Login pour récupérer le token
      //   // Implémentez votre logique de connexion ici
      //   final loginData  = await authService.loginScanners(
      //     _nomController.text,
      //     _passwordController.text,
      //   );
      //   // Si le login est réussi
      //   print("Login réussi : $loginData ");
      //   // tu peux naviguer vers une autre page ici
      //   print('Email: ${_nomController.text}');
      //   print('Password: ${_passwordController.text}');
      //   print("Token: ${loginData ["access_token"]}");
      //   print("Role: ${loginData ["role"]}");
      //   print("Message: ${loginData ["message"]}");


      //   final token = loginData["access_token"];
      //   print("Token: $token");

      //   final eventsDataRaw = await authService.getScannerEvents(token);

      //     // Vérifie que c’est une liste et prends le premier élément
      //     List<dynamic> eventsList = [];
      //     if (eventsDataRaw is List && eventsDataRaw.isNotEmpty) {
      //       eventsList = List<dynamic>.from(eventsDataRaw[0]); // ✅ c’est la vraie liste d’événements
      //     }


      //   // 2️⃣ Récupérer les infos du scanner
      //   final userData = await authService.getScannerProfile(token);
      //   print("Scanner: $userData");


      //   // 3️⃣ Récupérer les événements assignés au scanner
      //   final eventsData = await authService.getScannerEvents(token);
      //   print("Events: $eventsData");

      //   // 4️⃣ Créer un objet Scanner avec les infos récupérées
      //   final scanner = Scanner(
      //     id: userData['id'].toString(),
      //     // name: userData['name'],
      //     nom: userData['nom'],
      //     email: userData['email'],
      //     avatar: userData['avatar'],
      //     role: userData['role'],
      //     assignedEvents: List<String>.from(eventsData.map((e) => e['id'])),
      //   );

      //   // // 5️⃣ Naviguer vers la page de sélection
      //   // Navigator.pushReplacement(
      //   //   context,
      //   //   MaterialPageRoute(
      //   //     builder: (_) => EventSelectionPage(scanner: scanner),
      //   //   ),
      //   // );

      //   // await storage.write(key: "token", value: data["access_token"]);
      //   // await storage.write(key: "role", value: data["role"]); 
      //   showSuccess(context, "${loginData ["message"]} ! Bienvenue ${userData['name']}, Role :${loginData ['role']} 🎉");
      //   // 👉 Navigue vers la page d'accueil ici
        
      //   // Après connexion réussie, naviguez vers la page d'accueil
      //   MaterialPageRoute(builder: (context) => EventSelectionPage(scanner: scanner));
      //   // Navigator.pushReplacementNamed(context, '/dashboard_2');
      // }
      
      // tu peux naviguer vers une autre page ici
    } catch (e) {
      print("Erreur login : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion")),
      );
      // Si le login échoue
      showError(context, "Identifiants incorrects 😕\nVérifie ton email et ton mot de passe.");
    }  finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _login() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isLoading = true);
      
  //     // Simulation de délai de connexion
  //     await Future.delayed(Duration(seconds: 1));
      
  //     final nom = _nomController.text;
  //     final password = _passwordController.text;
      
  //     // Vérification simple (à remplacer par votre logique d'authentification)
  //     // final scanner = _mockScanners.firstWhere(
  //     //   (s) => s.nom == nom && password == 'scanner123',
  //     //   orElse: () => Scanner(id: '', name: '', nom: '', assignedEvents: []),
  //     // );
      
  //     if (scanner.id.isNotEmpty) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => EventSelectionPage(scanner: scanner)),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Identifiants incorrects')),
  //       );
  //     }
      
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.keyboard_return_rounded),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            tooltip: 'Retour login user',
          ),
        
      ),
      backgroundColor: Colors.deepPurple[50],
      
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 80),
              // Header
              Icon(Icons.qr_code_scanner, size: 80, color: Colors.deepPurple),
              SizedBox(height: 20),
              Text(
                'Espace Scanneur',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Connectez-vous pour commencer à scanner',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              
              // Toggle QR/nom
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _useQRLogin = false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_useQRLogin ? Colors.deepPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'nom',
                              style: TextStyle(
                                color: !_useQRLogin ? Colors.white : Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _useQRLogin = true),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _useQRLogin ? Colors.deepPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'QR Code',
                              style: TextStyle(
                                color: _useQRLogin ? Colors.white : Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              
              // Formulaire de connexion
              Form(
                key: _formKey,
                child: _useQRLogin ? _buildQRLogin() : _buildnomLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildnomLogin() {
    return Column(
      children: [
        TextFormField(
          controller: _nomController,
          decoration: InputDecoration(
            labelText: 'nom',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          // keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            UpperCaseTextFormatter(), // 👈 Custom formatter ci-dessous
          ],
          validator: (value) {
            final regex = RegExp(r'^[A-Za-z0-9]{6}[0-9]{4}$');
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre nom';
            }
            if (!regex.hasMatch(value)) {
              return 'Format invalide : 6 caractères + 4 chiffres';
            }
            return null;
          //   if (value == null || value.isEmpty) return 'Veuillez entrer votre nom';
          //   if (!value.contains('@')) return 'nom invalide';
          //   return null;
          // },
            // setState(() {
            //   _isNomValid = _nomRegex.hasMatch(value);
            //   _isFormValid = _isNomValid && password.length >= 6;
            // });
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Veuillez entrer votre mot de passe';
            if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
            return null;
          },
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isFormValid && !_isLoading ? _login : null, //(){ 
              // if (_isFormValid) {
              //   // Soumettre le formulaire
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Formulaire valide 🎉')),
              //   );
              //   _login;
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Veuillez corriger les erreurs ❌')),
              //   );
              // }
            //},
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid ? Colors.deepPurple : Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                            ? const SizedBox(
                                width: 50,
                                height: 50,
                                // child: SpinKitThreeBounce( //3 point horizontaux
                                // child: SpinKitWave( // des barres comme si on jouait de la musique
                                child: SpinKitPulse (  // SpinKitFadingCube
                                  // strokeWidth: 2,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 253, 55, 147),
                                ),
                              ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Mot de passe par défaut: scanner123',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildQRLogin() {
    return Column(
      children: [
        Text(
          'Scannez votre QR code d\'accès',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _qrController,
          decoration: InputDecoration(
            labelText: 'Ou entrez le code manuellement',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Simulation de connexion QR
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => EventSelectionPage(scanner: _mockScanners[0])),
              // );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Valider le code', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
