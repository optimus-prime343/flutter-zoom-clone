import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';

import '../services/auth_service.dart';
import '../services/meeting_service.dart';
import '../services/permission_service.dart';
import '../utils/show_snackbar.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/join_meeting_bottomsheet.dart';

class MeetAndChatScreen extends StatelessWidget {
  static const routeName = '/meet-and-chat';
  const MeetAndChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleCreateMeeting() async {
      AudioVideoPermissionStatus audioVideoPermissionStatus =
          await PermissionService().requestAudioVideo();
      String roomId = await nanoid(12);
      await MeetingService().createOrJoinMeeting(
        roomId: roomId,
        isAudioMuted: audioVideoPermissionStatus.isAudioGranted,
        isVideoMuted: audioVideoPermissionStatus.isVideoGranted,
        onError: (message) {
          showSnackbar(context, message);
        },
      );
    }

    void handleJoinMeeting() {
      String username = AuthService().currentUserUsername;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return JoinMeetingBottomsheet(
            username: username,
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meet & Chat'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    text: 'New Meeting',
                    icon: Icons.video_call,
                    onTap: handleCreateMeeting,
                  ),
                  CustomIconButton(
                    onTap: handleJoinMeeting,
                    icon: Icons.add_box,
                    text: 'Join Meeting',
                  ),
                  CustomIconButton(
                    onTap: () {},
                    icon: Icons.schedule,
                    text: 'Schedule',
                  ),
                  CustomIconButton(
                    onTap: () {},
                    icon: Icons.screen_share,
                    text: 'Share screen',
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Create or join a meeting with just a click',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
