import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import 'custom_button.dart';

class MeetingIdAndNameInputBottomSheet extends StatefulWidget {
  final String username;
  final Function(String id, String name) onMeetingIdAndNameInputComplete;
  const MeetingIdAndNameInputBottomSheet({
    super.key,
    required this.username,
    required this.onMeetingIdAndNameInputComplete,
  });

  @override
  State<MeetingIdAndNameInputBottomSheet> createState() =>
      _MeetingIdAndNameInputBottomSheet();
}

class _MeetingIdAndNameInputBottomSheet
    extends State<MeetingIdAndNameInputBottomSheet> {
  final TextEditingController _meetingIdController = TextEditingController();
  final TextEditingController _meetingNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _meetingIdController.dispose();
    _meetingNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.username);
    _meetingNameController.value = TextEditingValue(text: widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double paddingBottom = MediaQuery.of(context).viewInsets.bottom;

    void handleMeetingIdAndNameSubmit() {
      if (_formKey.currentState!.validate()) {
        String meetingId = _meetingIdController.text;
        String meetingName = _meetingNameController.text;
        widget.onMeetingIdAndNameInputComplete(meetingId, meetingName);
        Navigator.of(context).pop();
      }
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
              controller: _meetingIdController,
              validator: ValidationBuilder()
                  .required()
                  .minLength(12)
                  .maxLength(12)
                  .build(),
              decoration: const InputDecoration(
                hintText: 'Enter Meeting ID',
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _meetingNameController,
              validator: ValidationBuilder().required().minLength(4).build(),
              decoration: const InputDecoration(
                hintText: 'Enter Meeting Name',
              ),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Join Meeting',
              onPressed: handleMeetingIdAndNameSubmit,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
