import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import '../services/meeting_service.dart';
import 'custom_button.dart';

class JoinMeetingBottomsheet extends StatefulWidget {
  final String username;
  const JoinMeetingBottomsheet({
    super.key,
    required this.username,
  });

  @override
  State<JoinMeetingBottomsheet> createState() =>
      _MeetingIdAndNameInputBottomSheet();
}

class _MeetingIdAndNameInputBottomSheet extends State<JoinMeetingBottomsheet> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _meetingUsername = TextEditingController();

  bool _enableAudio = false;
  bool _enableVideo = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _roomIdController.dispose();
    _meetingUsername.dispose();
    JitsiMeet.removeAllListeners();
    super.dispose();
  }

  @override
  void initState() {
    _meetingUsername.value = TextEditingValue(text: widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double paddingBottom = MediaQuery.of(context).viewInsets.bottom;

    void handleMeetingIdAndNameSubmit() async {
      if (_formKey.currentState!.validate()) {
        String roomId = _roomIdController.text;
        String meetingUserName = _meetingUsername.text;
        await MeetingService().createOrJoinMeeting(
          roomId: roomId,
          meetingUsername: meetingUserName,
          isAudioMuted: !_enableAudio,
          isVideoMuted: !_enableVideo,
        );
      }
      Navigator.of(context).pop();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: paddingBottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _roomIdController,
              validator: ValidationBuilder()
                  .required()
                  .minLength(12)
                  .maxLength(12)
                  .build(),
              decoration: const InputDecoration(
                hintText: 'Enter Room ID',
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _meetingUsername,
              validator: ValidationBuilder().required().minLength(4).build(),
              decoration: const InputDecoration(
                hintText: 'Enter Username',
              ),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Join Meeting',
              onPressed: handleMeetingIdAndNameSubmit,
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            SwitchListTile.adaptive(
              title: const Text('Enable Audio'),
              value: _enableAudio,
              onChanged: (value) {
                setState(() => _enableAudio = value);
              },
            ),
            SwitchListTile.adaptive(
              title: const Text('Enable Video'),
              value: _enableVideo,
              onChanged: (value) {
                setState(() => _enableVideo = value);
              },
            )
          ],
        ),
      ),
    );
  }
}
