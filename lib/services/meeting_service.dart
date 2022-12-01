import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import '../models/meeting_history.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class MeetingService {
  Future<void> createOrJoinMeeting({
    required String roomId,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String? meetingUsername,
    VoidCallback? onSuccess,
    Function(String message)? onError,
  }) async {
    final String username = AuthService().currentUserUsername;
    final String? userUid = AuthService().userUid;

    User? user = AuthService().currentUser;
    if (user == null) return;
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;
      JitsiMeetingOptions jitsiMeetingOptions = JitsiMeetingOptions(
        room: roomId,
      )
        ..userDisplayName = meetingUsername ?? username
        ..userEmail = user.email
        ..userAvatarURL = user.photoURL
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;
      await JitsiMeet.joinMeeting(jitsiMeetingOptions);
      if (userUid == null) return;
      await FirestoreService().saveMeetingHistory(
        meetingHistory: MeetingHistory(
          roomId: roomId,
          userId: userUid,
          createdOn: DateTime.now().toString(),
        ),
      );
      if (onSuccess != null) onSuccess();
    } on JitsiMeetingResponse catch (error) {
      if (onError != null) onError(error.message ?? "Something went wrong");
    }
  }
}
