import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  String _imagePath = "";

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _cpfController.text = prefs.getString('cpf') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _imagePath = prefs.getString('imagePath') ?? '';
    });
  }

  Future<void> saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('cpf', _cpfController.text);
    prefs.setString('email', _emailController.text);
    prefs.setString('phone', _phoneController.text);
    prefs.setString('dob', _dobController.text);
    prefs.setString('imagePath', _imagePath);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _sendEmail() async {
    final String email = _emailController.text;
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      print('Não foi possível abrir o aplicativo de e-mail.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await _pickImage(ImageSource.gallery);
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _imagePath.isNotEmpty ? FileImage(File(_imagePath)) : null,
                child: _imagePath.isEmpty
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await saveProfileData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dados salvos com sucesso!'),
                  ),
                );
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
