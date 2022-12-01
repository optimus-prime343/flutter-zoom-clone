import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_zoom_clone/services/auth_service.dart';

import '../models/meeting_history.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> saveUserInfo({required UserCredential userCredential}) async {
    User? user = userCredential.user;
    if (user != null && userCredential.additionalUserInfo!.isNewUser) {
      await _firebaseFirestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'photoURL': user.photoURL,
        },
      );
    }
  }

  Future<void> saveMeetingHistory({
    required MeetingHistory meetingHistory,
    Function(String message)? onError,
  }) async {
    try {
      await _firebaseFirestore
          .collection('meetings')
          .doc(meetingHistory.roomId)
          .set(
        {
          'roomId': meetingHistory.roomId,
          'userId': meetingHistory.userId,
          'createdOn': meetingHistory.createdOn,
        },
      );
    } catch (e) {
      if (onError != null) onError(e.toString());
    }
  }

  Stream<QuerySnapshot> getMeetingsHistory() {
    final String? userUid = AuthService().userUid;
    if (userUid == null) return const Stream.empty();
    return _firebaseFirestore
        .collection('meetings')
        .where('userId', isEqualTo: userUid)
        .snapshots();
  }
}
