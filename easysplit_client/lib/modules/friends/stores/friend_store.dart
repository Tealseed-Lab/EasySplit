import 'package:easysplit_flutter/common/models/friends/friend.dart';
import 'package:easysplit_flutter/common/repositories/interfaces/friends_repository.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'friend_store.g.dart';

@LazySingleton()
class FriendStore = FriendStoreBase with _$FriendStore;

abstract class FriendStoreBase with Store {
  static const int maximumFriends = 20;
  static const int maximumSelectedFriends = 8;

  final FriendsRepository _friendsRepository;

  FriendStoreBase(this._friendsRepository) {
    loadFriends();
  }

  @observable
  ObservableList<Friend> friends = ObservableList<Friend>();

  @observable
  int? currentlySwipedFriendId;

  @observable
  String nameInput = '';

  @computed
  int get selectedFriendsCount =>
      friends.where((friend) => friend.isSelected).length;

  @computed
  int get friendsCount => friends.length;

  @action
  Future<void> loadFriends() async {
    try {
      LogService.i('Loading friends');
      final loadedFriends = await _friendsRepository.getFriends();
      friends = ObservableList.of(loadedFriends);
    } catch (e) {
      LogService.e('Failed to load friends: $e');
    }
  }

  @action
  void setNameInput(String input) {
    nameInput = input;
  }

  @action
  Future<void> addFriend(String name, Color color) async {
    final int currentTime = DateTime.now().microsecondsSinceEpoch;
    final bool isSelected = selectedFriendsCount < maximumSelectedFriends;
    LogService.i('Adding friend $name');

    final newFriendData = {
      'id': 0, // placeholder
      'name': name,
      'color': color.value.toRadixString(16),
      'created_at': currentTime,
      'is_selected': isSelected ? 1 : 0,
    };
    final id =
        await _friendsRepository.addFriend(Friend.fromJson(newFriendData));
    final newFriend = Friend(
      id: id,
      name: name,
      color: color,
      createdAt: currentTime,
      isSelected: isSelected,
    );
    friends.insert(0, newFriend);
    resetCurrentlySwipedFriendId();
    nameInput = '';
  }

  @action
  Future<void> removeFriend(int id) async {
    LogService.i('Removing friend $id');
    friends = ObservableList.of(friends.where((friend) => friend.id != id));
    await _friendsRepository.removeFriend(id);
  }

  @action
  Future<bool> toggleSelection(int id) async {
    final friend = getFriendById(id);
    resetCurrentlySwipedFriendId();
    LogService.i('Toggling selection for friend $id');

    if (friend != null) {
      if (selectedFriendsCount < maximumSelectedFriends || friend.isSelected) {
        friend.isSelected = !friend.isSelected;
        friends = ObservableList.of(friends);
        await _friendsRepository.updateFriend(friend);
        return true;
      }
    }
    return false;
  }

  @action
  void setCurrentlySwipedFriendId(int? id) {
    currentlySwipedFriendId = id;
    friends = ObservableList.of(friends);
  }

  Friend? getFriendById(int id) {
    try {
      return friends.firstWhere((friend) => friend.id == id);
    } catch (e) {
      LogService.e('Friend not found: $id');
      return null;
    }
  }

  @action
  void resetCurrentlySwipedFriendId() {
    currentlySwipedFriendId = null;
  }

  Color get nextFriendColor {
    final usedColors = friends.map((friend) => friend.color).toSet();
    return firendColorList.firstWhere(
      (color) => !usedColors.contains(color),
      orElse: () => firendColorList[0],
    );
  }
}
