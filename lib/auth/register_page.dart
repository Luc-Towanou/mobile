// 3. Page d'Inscription (register_page.dart)
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isFormValid = false;
  
  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _validateForm() {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    setState(() {
      _isFormValid = firstName.isNotEmpty && 
                     lastName.isNotEmpty &&
                     email.isNotEmpty && 
                     password.isNotEmpty && 
                     confirmPassword.isNotEmpty &&
                     email.contains('@') &&
                     password.length >= 6 &&
                     password == confirmPassword;
    });
  }
  
  // void _register() {
  //   if (_formKey.currentState!.validate()) {
      
      
      // void _register() async {
      //   if (!_formKey.currentState!.validate()) return;
      //   

      //   final nom =
      //       "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}";
      //   final email = _emailController.text.trim();
      //   final password = _passwordController.text.trim();

      //   showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (_) => const Center(child: CircularProgressIndicator()),
      //   );

      //   final result = await AuthService.register(
      //     nom: nom,
      //     email: email,
      //     password: password,
      //     passwordConfirmation: _confirmPasswordController.text.trim(),
      //   );

      //   Navigator.pop(context);

      //   if (result["status"] == 200 || result["status"] == 201) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => VerifyOtpPage(email: email),
      //       ),
      //     );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         backgroundColor: Colors.red,
      //         content: Text(result["body"]["message"] ?? "Erreur d'inscription"),
      //       ),
      //     );
      //   }
      // }
      void _register() async {
        // Implémentez votre logique d'inscription ici
        print('First Name: ${_firstNameController.text}');
        print('Last Name: ${_lastNameController.text}');
        print('Email: ${_emailController.text}');
        print('Password: ${_passwordController.text}');
        if (!_formKey.currentState!.validate()) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final nom =
              "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}";

          final result = await AuthService.register(
            nom: nom,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            passwordConfirmation: _confirmPasswordController.text.trim(),
          );

          if (mounted) Navigator.pop(context); // 🔥 close loader safely

          if (result["status"] == 200 || result["status"] == 201) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyOtpPage(
                  email: _emailController.text.trim(),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(result["body"]["message"] ?? "Erreur d'inscription"),
              ),
            );
          }
        } catch (e) {
          if (mounted) Navigator.pop(context); // 🔥 safe close
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Erreur inattendue"),
            ),
          );
        }
      }


      // Après inscription réussie, naviguez vers la page d'accueil
      // Navigator.pushReplacementNamed(context, '/home');
    
  
  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }
  void _navigateToHomePage() {
    Navigator.pushReplacementNamed(context, '/');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          
          image: DecorationImage(
            image: AssetImage('assets/images/bg_login.png'), // Même image que pour le login
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10),
                    // Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Account',
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
                      ],
                    ),
                  ),
              SizedBox(height: 10),
              Text(
                'Rejoignez-nous pour découvrir des centaines d\'événements et obtenir des alertes personnalisées.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre prénom';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isFormValid ? _register : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Créer un compte',
                          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 250, 40, 169)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          // Implémentez l'inscription avec Google
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
                  onPressed: _navigateToLogin,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: 'Sign in',
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
            ],
          ),
        ),
      ),
    );
  }
}


class VerifyOtpPage extends StatefulWidget {
  final String email;

  const VerifyOtpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final result = await AuthService.verifyOtp(
      email: widget.email,
      otp: _otpController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result["status"] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("✅ Compte vérifié avec succès"),
        ),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(result["body"]["message"] ?? "OTP invalide"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vérification du compte",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Un code a été envoyé à :\n${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  letterSpacing: 8,
                  fontSize: 22,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "------",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Vérifier le code"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}