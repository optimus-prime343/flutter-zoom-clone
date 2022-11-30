import 'package:permission_handler/permission_handler.dart';

class AudioVideoPermissionStatus {
  final bool isAudioGranted;
  final bool isVideoGranted;

  AudioVideoPermissionStatus({
    required this.isAudioGranted,
    required this.isVideoGranted,
  });
}

class PermissionService {
  Future<AudioVideoPermissionStatus> requestAudioVideo() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.videos,
    ].request();
    bool isAudioGranted =
        statuses[Permission.audio] == PermissionStatus.granted;
    bool isVideoGranted =
        statuses[Permission.videos] == PermissionStatus.granted;
    return AudioVideoPermissionStatus(
      isAudioGranted: isAudioGranted,
      isVideoGranted: isVideoGranted,
    );
  }
}
