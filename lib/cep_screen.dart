import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CepScreen extends StatefulWidget {
  const CepScreen({Key? key}) : super(key: key);

  @override
  _CepScreenState createState() => _CepScreenState();
}

class _CepScreenState extends State<CepScreen> {
  TextEditingController _cepController = TextEditingController();
  String _result = '';

  Future<void> _buscarCep() async {
    final cep = _cepController.text.trim();
    if (cep.isEmpty) {
      return;
    }

    final url = Uri.parse('https://viacep.com.br/ws/01001000/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _result = data.toString();
      });
    } else {
      setState(() {
        _result = 'Erro ao buscar CEP. Verifique o CEP digitado.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CEP',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _buscarCep,
              child: const Text('Buscar CEP'),
            ),
            const SizedBox(height: 16),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
