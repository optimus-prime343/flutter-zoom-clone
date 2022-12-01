import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_clone/models/meeting_history.dart';
import 'package:flutter_zoom_clone/services/firestore_service.dart';
import 'package:intl/intl.dart';

class MeetingsHistoryScreen extends StatelessWidget {
  static const routeName = '/meetings';

  const MeetingsHistoryScreen({super.key});

  List<MeetingHistory> generateMeetingsHistoryList(
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    if (!snapshot.hasData) return [];
    return snapshot.data!.docs
        .map((e) => MeetingHistory.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meetings History'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().getMeetingsHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            final List<MeetingHistory> meetingsHistory =
                generateMeetingsHistoryList(snapshot);
            return ListView.builder(
              itemBuilder: (context, index) {
                MeetingHistory meetingHistory = meetingsHistory[index];
                final meetingCreatedOn = DateFormat.yMMMd()
                    .format(DateTime.parse(meetingHistory.createdOn))
                    .toString();
                return ListTile(
                  title: Text('Room Name : ${meetingHistory.roomId}'),
                  subtitle: Text('Joined On : $meetingCreatedOn'),
                );
              },
              itemCount: meetingsHistory.length,
            );
          },
        ),
      ),
    );
  }
}
