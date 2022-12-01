// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MeetingHistory {
  final String roomId;
  final String userId;
  final String createdOn;

  MeetingHistory({
    required this.roomId,
    required this.userId,
    required this.createdOn,
  });

  MeetingHistory copyWith({
    String? roomId,
    String? userId,
    String? createdOn,
  }) {
    return MeetingHistory(
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'userId': userId,
      'createdOn': createdOn,
    };
  }

  factory MeetingHistory.fromMap(Map<String, dynamic> map) {
    return MeetingHistory(
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      createdOn: map['createdOn'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingHistory.fromJson(String source) =>
      MeetingHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MeetingHistory(roomId: $roomId, userId: $userId, createdOn: $createdOn)';

  @override
  bool operator ==(covariant MeetingHistory other) {
    if (identical(this, other)) return true;

    return other.roomId == roomId &&
        other.userId == userId &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode => roomId.hashCode ^ userId.hashCode ^ createdOn.hashCode;
}
