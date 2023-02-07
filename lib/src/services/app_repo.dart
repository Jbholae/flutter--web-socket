import '../models/user/user.dart';

abstract class AppRepo {
  Future createUser({required User data});

  Future getAllUser({String keyword, String cursor});

  Future getUserRoom({String? cursor});

  Stream getUserMessage({int roomId});

  Future followUser({String userId});

  Future unFollowUser({String userID});
}
