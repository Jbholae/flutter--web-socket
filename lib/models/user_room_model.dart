class UserRoom {
  String? id;
  String? userId;
  String? roomId;
  UserRoom({
    this.id,
    this.roomId,
    this.userId,
  });

  factory UserRoom.fromJson(Map<String, dynamic> json) {
    return UserRoom(
      id: json['id'],
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}
