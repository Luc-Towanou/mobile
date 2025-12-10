// 2. Page de Login (login_page.dart)
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';

import '../outils/notifications.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  
  bool _isFormValid = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  final storage = FlutterSecureStorage();


  
  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _validateForm() {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    setState(() {
      _isFormValid = email.isNotEmpty && 
                     password.isNotEmpty && 
                     email.contains('@') &&
                     password.length >= 6;
    });
  }

   void _login() async {
      setState(() {
        _isLoading = true;
      });
    try {
       if (_formKey.currentState!.validate()) {
        // Implémentez votre logique de connexion ici
        final data = await authService.login(
          _emailController.text,
          _passwordController.text,
        );
        // Si le login est réussi
        print("Login réussi : $data");
        // tu peux naviguer vers une autre page ici
        print('Email: ${_emailController.text}');
        print('Password: ${_passwordController.text}');
        print("Token: ${data["access_token"]}");
        print("Role: ${data["role"]}");
        print("Message: ${data["message"]}");

        await storage.write(key: "token", value: data["access_token"]);
        await storage.write(key: "role", value: data["role"]); 
        showSuccess(context, "${data["message"]} ! Bienvenue ${_emailController.text}, Role :${data['role']} 🎉");
        // 👉 Navigue vers la page d'accueil ici
        
        // Après connexion réussie, naviguez vers la page d'accueil
        Navigator.pushReplacementNamed(context, '/dashboard_2');
      }
      
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
  
  // void _login() async {
  //   if (_formKey.currentState!.validate()) {
  //     // Implémentez votre logique de connexion ici
  //     print('Email: ${_emailController.text}');
  //     print('Password: ${_passwordController.text}');
      
  //     // Après connexion réussie, naviguez vers la page d'accueil
  //     // Navigator.pushReplacementNamed(context, '/home');
  //   }
  // }
  
  void _navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }  
  void _navigateToLoginScanner() {
    Navigator.pushReplacementNamed(context, '/login_scanner');
  }  
  void _navigateToHomePage() {
    Navigator.pushReplacementNamed(context, '/');
  }
  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }
  void _navigateToDashboardTwo() {
    Navigator.pushReplacementNamed(context, '/dashboard_2');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_login.png'), // Remplacez par votre image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    // Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: _navigateToHomePage,
                          tooltip: 'Accueil',
                          icon: const Icon(
                            Icons.home,
                            size: 20,
                          ),
                          color: Color.fromARGB(255, 247, 23, 191),
                          // iconSize: 20.0,
                        ),
                        IconButton(
                          onPressed: _navigateToDashboard,
                          tooltip: 'Dashboard',
                          icon: const Icon(
                            Icons.dashboard,
                            size: 20,
                          ),
                          color: Color.fromARGB(255, 247, 23, 191),
                        ), 
                        IconButton(
                          onPressed: _navigateToDashboardTwo,
                          tooltip: 'Dashboard',
                          icon: const Icon(
                            Icons.data_exploration,
                            size: 20,
                          ),
                          color: Color.fromARGB(255, 247, 23, 191),
                        ), //_navigateToDashboardTwo
                      ],
                    ),
                  ),
              SizedBox(height: 10),
              Text(
                'Découvrez les centaines d\'événements, obtenez des alertes à propos de tes artistes préférés, des équipes, plays et plus - les meilleurs passes.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!value.contains('@')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),

                    // TextFormField(
                    //   controller: _passwordController,
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     labelText: 'Mot de passe',
                    //     labelStyle: TextStyle(color: Colors.white70),
                    //     filled: true,
                    //     fillColor: Colors.white.withOpacity(0.2),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     prefixIcon: Icon(Icons.lock, color: Colors.white70),
                    //   ),
                    //   style: TextStyle(color: Colors.white),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Veuillez entrer votre mot de passe';
                    //     }
                    //     if (value.length < 6) {
                    //       return 'Le mot de passe doit contenir au moins 6 caractères';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isFormValid && !_isLoading ? _login : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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

                    // SizedBox( 
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton(
                    //     onPressed: _isFormValid ? _login : null,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Se connecter',
                    //       style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 253, 55, 147)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          // Implémentez la connexion avec Google
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.g_mobiledata, color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Continue with Google',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: _navigateToRegister,
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: 'Make an account',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: _navigateToLoginScanner,
                  child: RichText(
                    text: TextSpan(
                      text: 'Are you a Scanner? ',
                      style: TextStyle(color: const Color.fromARGB(179, 255, 249, 243)),
                      children: [
                        TextSpan(
                          text: 'Log here',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 243, 240, 33),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
