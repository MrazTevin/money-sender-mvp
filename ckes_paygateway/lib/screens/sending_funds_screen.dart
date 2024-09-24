import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SendFundsScreen extends StatefulWidget {
  const SendFundsScreen({super.key});

  @override
  _SendFundsScreenState createState() => _SendFundsScreenState();
}

class _SendFundsScreenState extends State<SendFundsScreen> {
  String amount = '1,252.00';
  final NumberFormat formatter = NumberFormat("#,##0.00", "en_US");

  void updateAmount(String digit) {
    setState(() {
      String newAmount = amount.replaceAll(',', '') + digit;
      amount = formatter.format(double.parse(newAmount));
    });
  }

  void backspace() {
    setState(() {
      if (amount.length > 1) {
        String newAmount = amount.replaceAll(',', '');
        newAmount = newAmount.substring(0, newAmount.length - 1);
        amount = formatter.format(double.parse(newAmount));
      } else {
        amount = '0.00';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sending Funds',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Handle close action
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      child: const Text('P'),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peter', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Wallet address', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '₭',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    amount,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    ...List.generate(9, (index) => 
                      NumberButton(
                        number: (index + 1).toString(),
                        onPressed: () => updateAmount((index + 1).toString()),
                      )
                    ),
                    NumberButton(number: '0', onPressed: () => updateAmount('0')),
                    BackspaceButton(onPressed: backspace),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Handle continue action
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Continue', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;

  const NumberButton({super.key, required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      onPressed: onPressed,
      child: Text(number, style: const TextStyle(fontSize: 24, color: Colors.black)),
    );
  }
}

class BackspaceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackspaceButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      onPressed: onPressed,
      child: const Icon(Icons.backspace, color: Colors.black),
    );
  }
}