import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import 'auth_service.dart';

class MeetingService {
  Future<void> createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    VoidCallback? onSuccess,
    Function(String message)? onError,
  }) async {
    User? user = AuthService().currentUser;
    if (user == null) return;
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;
      JitsiMeetingOptions jitsiMeetingOptions = JitsiMeetingOptions(
        room: roomName,
      )
        ..userDisplayName = user.displayName
        ..userEmail = user.email
        ..userAvatarURL = user.photoURL
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;
      await JitsiMeet.joinMeeting(jitsiMeetingOptions);
      if (onSuccess != null) onSuccess();
    } on JitsiMeetingResponse catch (error) {
      if (onError != null) onError(error.message ?? "Something went wrong");
    }
  }
}
