import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  static const routeName = '/contacts';

  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Contacts'),
        ),
      ),
    );
  }
}
