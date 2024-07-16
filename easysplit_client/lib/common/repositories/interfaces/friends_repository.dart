import 'package:easysplit_flutter/common/models/friends/friend.dart';

abstract class FriendsRepository {
  Future<List<Friend>> getFriends();
  Future<int> addFriend(Friend friend);
  Future<void> removeFriend(int id);
  Future<void> updateFriend(Friend friend);
}
