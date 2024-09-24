import 'package:flutter/material.dart';

class ContactSearchScreen extends StatefulWidget {
  const ContactSearchScreen({super.key});

  @override
  _ContactSearchScreenState createState() => _ContactSearchScreenState();
}

class _ContactSearchScreenState extends State<ContactSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Contact> _contacts = [
    Contact(name: 'Peter', address: 'peter@example.com'),
    Contact(name: 'Wallace', address: 'wallace@example.com'),
    Contact(name: 'Mary', address: 'mary@example.com'),
    Contact(name: 'John', address: 'john@example.com'),
  ];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = _contacts;
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the screen
        child: Column(
          children: [
            const SizedBox(height: 40), // Move the search bar down
            // Search field
            TextField(
              controller: _searchController,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: 'Search Contacts',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterContacts('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade400), // Border color
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16), // Space between search field and list
            Expanded(
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(_filteredContacts[index].name[0]),
                    ),
                    title: Text(_filteredContacts[index].name),
                    subtitle: Text(_filteredContacts[index].address),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contact {
  final String name;
  final String address;

  Contact({required this.name, required this.address});
}