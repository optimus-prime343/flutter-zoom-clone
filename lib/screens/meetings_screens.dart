import 'package:flutter/material.dart';

class MeetingsScreen extends StatelessWidget {
  static const routeName = '/meetings';

  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Meetings'),
        ),
      ),
    );
  }
}
