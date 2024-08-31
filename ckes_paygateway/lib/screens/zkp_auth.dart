import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ZkpAuthScreen extends StatefulWidget {
  const ZkpAuthScreen({super.key});

  @override
  _ZkpAuthScreenState createState() => _ZkpAuthScreenState();
}

class _ZkpAuthScreenState extends State<ZkpAuthScreen> {
  final _secretController = TextEditingController();
  String _commitment = '';
  String _response = '';
  String _statusMessage = '';

  // These should ideally be fetched securely from a trusted source
  static final BigInt p = BigInt.parse('115792089237316195423570985008687907853269984665640564039457584007908834671663');
  static final BigInt g = BigInt.parse('2');

  Future<void> _register() async {
    setState(() => _statusMessage = 'Registering...');
    try {
      final secret = BigInt.parse(_secretController.text);
      final r = _generateRandomValue();

      // Step 1: Compute commitment A = g^r mod p
      final A = g.modPow(r, p);

      // Step 2: Send commitment A to the backend for registration
      final response = await http.post(
        Uri.parse('localhost:3000/register'),
        body: json.encode({'commitment': A.toString()}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _commitment = A.toString();
          _statusMessage = 'Registration successful';
        });
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      setState(() => _statusMessage = 'Registration failed: $e');
    }
  }

  Future<void> _authenticate() async {
    setState(() => _statusMessage = 'Authenticating...');
    try {
      final secret = BigInt.parse(_secretController.text);
      final r = _generateRandomValue();

      // Step 3: Get challenge from the server
      final challengeResponse = await http.get(
        Uri.parse('localhost:3000/challenge'),
      );

      if (challengeResponse.statusCode == 200) {
        final challenge = BigInt.parse(json.decode(challengeResponse.body)['challenge']);

        // Step 4: Compute response s = r + challenge * secret mod p
        final s = (r + (challenge * secret)) % p;

        // Step 5: Send response to the backend for verification
        final verificationResponse = await http.post(
          Uri.parse('localhost:3000/authenticate'),
          body: json.encode({'response': s.toString()}),
          headers: {'Content-Type': 'application/json'},
        );

        if (verificationResponse.statusCode == 200) {
          setState(() {
            _response = s.toString();
            _statusMessage = 'Authentication successful';
          });
        } else {
          throw Exception('Authentication failed: ${verificationResponse.body}');
        }
      } else {
        throw Exception('Failed to get challenge: ${challengeResponse.body}');
      }
    } catch (e) {
      setState(() => _statusMessage = 'Authentication failed: $e');
    }
  }

  BigInt _generateRandomValue() {
    final rng = Random.secure();
    return BigInt.from(rng.nextInt(p.toInt() - 1)) + BigInt.one;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZKP Auth Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _secretController,
              decoration: const InputDecoration(labelText: 'Enter your secret'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Authenticate'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (_commitment.isNotEmpty)
              Text('Commitment: $_commitment', style: const TextStyle(fontSize: 12)),
            if (_response.isNotEmpty)
              Text('Response: $_response', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _secretController.dispose();
    super.dispose();
  }
}