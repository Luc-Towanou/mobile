import 'dart:convert';
import 'dart:io';
import 'package:event_rush_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'profile_pages.dart'; // pour revenir vers ProfilePage

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  File? _avatarFile;
  bool _loading = false;
  String? _error;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final uri = Uri.parse("https://eventrush.onrender.com/api/me/update");
    final request = http.MultipartRequest("POST", uri);
    final token = await AuthService.getToken();
    // ⚠️ ajoute ton token si besoin
    request.headers['Authorization'] = "Bearer $token";

    if (_nomCtrl.text.isNotEmpty) request.fields['nom'] = _nomCtrl.text;
    if (_emailCtrl.text.isNotEmpty) request.fields['email'] = _emailCtrl.text;
    if (_passwordCtrl.text.isNotEmpty) request.fields['password'] = _passwordCtrl.text;

    if (_avatarFile != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', _avatarFile!.path));
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(resBody);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Profil mis à jour')),
      );
      // ✅ Retour vers ProfilePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePages()),
      );
    } else {
      setState(() => _error = "Erreur: ${response.statusCode} - $resBody");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier mes informations")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickAvatar,
                    icon: const Icon(Icons.image),
                    label: const Text("Choisir un avatar"),
                  ),
                  const SizedBox(width: 12),
                  if (_avatarFile != null)
                    Text("Image sélectionnée", style: TextStyle(color: Colors.green)),
                ],
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _updateProfile,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
