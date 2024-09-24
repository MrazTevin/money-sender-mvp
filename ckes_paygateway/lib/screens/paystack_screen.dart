import 'package:flutter/material.dart';
import 'dart:math' as math;

class PayStackScreen extends StatelessWidget {
  final List<Contact> quickContacts = [
    Contact(name: "Add", isAddButton: true),
    Contact(name: "Brenda"),
    Contact(name: "Aisha"),
    Contact(name: "Muktar"),
  ];

  final List<Transaction> recentTransactions = [
    Transaction(name: "Peter", amount: 252.00, type: "Funds Received"),
    Transaction(name: "Kelly", amount: 412.00, type: "Funds Received"),
    Transaction(name: "Mark", amount: 300.00, type: "Funds Received"),
  ];

  PayStackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildBody(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              _buildUserAvatar(),
              const SizedBox(width: 12),
              _buildUserGreeting(),
            ],
          ),
        ),
      ),
    );
  }

  CircleAvatar _buildUserAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.brown.shade300,
      child: const Text('M', style: TextStyle(color: Colors.white)),
    );
  }

  Column _buildUserGreeting() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hello Milla 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Unlock a smart way to pay with cKES', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  SliverToBoxAdapter _buildBody() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceWidget(balance: 1252.00),
            const SizedBox(height: 24),
            const Text('Send again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Send funds to your friends', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            QuickContactsWidget(contacts: quickContacts),
            const SizedBox(height: 24),
            TransactionList(transactions: recentTransactions),
          ],
        ),
      ),
    );
  }

  BottomAppBar _buildBottomNavigationBar() {
  return BottomAppBar(
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.history, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_balance_wallet, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person, color: Colors.grey), onPressed: () {}),
        ],
      ),
    ),
  );
}
}

class BalanceWidget extends StatelessWidget {
  final double balance;

  const BalanceWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('cK ${balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Total balance', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}

class QuickContactsWidget extends StatelessWidget {
  final List<Contact> contacts;

  const QuickContactsWidget({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ContactAvatar(contact: contacts[index]),
          );
        },
      ),
    );
  }
}

class ContactAvatar extends StatelessWidget {
  final Contact contact;

  const ContactAvatar({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        contact.isAddButton
            ? _buildAddButton()
            : _buildContactAvatar(),
        const SizedBox(height: 8),
        Text(contact.name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(Icons.add, color: Colors.grey),
    );
  }

  Widget _buildContactAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      child: Text(contact.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map((transaction) => TransactionItem(transaction: transaction)).toList(),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
            child: Text(transaction.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(transaction.type, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text('cK ${transaction.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final bool isAddButton;

  Contact({required this.name, this.isAddButton = false});
}

class Transaction {
  final String name;
  final double amount;
  final String type;

  Transaction({required this.name, required this.amount, required this.type});
}