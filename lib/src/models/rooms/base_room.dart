import '../index.dart';

class BaseRoom extends Indexable {
  int id;
  String? name;
  bool isPrivate;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  BaseRoom({
    required this.id,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.deletedAt,
  }) : super(id);

  factory BaseRoom.fromJson(Map<String, dynamic> json) {
    return BaseRoom(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
      isPrivate: json['is_private'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'updated_at': updatedAt,
      'id': id,
      'name': name,
      'is_private': isPrivate,
    };
  }
}
