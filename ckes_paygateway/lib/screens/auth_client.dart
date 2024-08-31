import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ZKPAuthPage extends StatefulWidget {
  const ZKPAuthPage({super.key});

  @override
  _ZKPAuthPageState createState() => _ZKPAuthPageState();
}

class _ZKPAuthPageState extends State<ZKPAuthPage> {
  String _userId = '';
  List<String> _recoveryPhrase = [];
  final List<String> _inputPhrase = List.filled(12, '');
  String _challenge = '';
  final TextEditingController _responseController = TextEditingController();

  final String _baseUrl = 'http://localhost:3000'; // Replace with your server URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZKP Authentication')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            Text('User ID: $_userId'),
            const SizedBox(height: 16),
            const Text('Recovery Phrase:'),
            Wrap(
              spacing: 8,
              children: _recoveryPhrase
                  .map((word) => Chip(label: Text(word)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Input your recovery phrase:'),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    maxLength: 20,
                    onChanged: (value) {
                      setState(() {
                        _inputPhrase[index] = value;
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getChallenge,
              child: const Text('Get Challenge'),
            ),
            const SizedBox(height: 16),
            Text('Challenge: $_challenge'),
            const SizedBox(height: 16),
            TextField(
              controller: _responseController,
              decoration: const InputDecoration(
                labelText: 'Response',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    final response = await http.post(Uri.parse('$_baseUrl/register'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _userId = data['userId'];
        _recoveryPhrase = data['recoveryPhrase'].split(' ');
      });
    } else {
      _showError('Registration failed');
    }
  }

  Future<void> _getChallenge() async {
    if (_userId.isEmpty) {
      _showError('Please register first');
      return;
    }
    final response = await http.get(Uri.parse('$_baseUrl/challenge?userId=$_userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _challenge = data['challenge'];
      });
    } else {
      _showError('Failed to get challenge');
    }
  }

  Future<void> _authenticate() async {
    if (_userId.isEmpty || _challenge.isEmpty) {
      _showError('Please register and get a challenge first');
      return;
    }
    
    // Here, you would typically use the input phrase to generate the response
    // For demonstration, we're just using the raw input from the response field
    final response = await http.post(
      Uri.parse('$_baseUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': _userId,
        'response': _responseController.text,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        _showMessage('Authentication successful');
      } else {
        _showError('Authentication failed');
      }
    } else {
      _showError('Authentication request failed');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }
}