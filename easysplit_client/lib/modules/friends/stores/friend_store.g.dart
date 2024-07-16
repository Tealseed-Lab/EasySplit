// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendStore on FriendStoreBase, Store {
  Computed<int>? _$selectedFriendsCountComputed;

  @override
  int get selectedFriendsCount => (_$selectedFriendsCountComputed ??=
          Computed<int>(() => super.selectedFriendsCount,
              name: 'FriendStoreBase.selectedFriendsCount'))
      .value;
  Computed<int>? _$friendsCountComputed;

  @override
  int get friendsCount =>
      (_$friendsCountComputed ??= Computed<int>(() => super.friendsCount,
              name: 'FriendStoreBase.friendsCount'))
          .value;

  late final _$friendsAtom =
      Atom(name: 'FriendStoreBase.friends', context: context);

  @override
  ObservableList<Friend> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(ObservableList<Friend> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  late final _$currentlySwipedFriendIdAtom =
      Atom(name: 'FriendStoreBase.currentlySwipedFriendId', context: context);

  @override
  int? get currentlySwipedFriendId {
    _$currentlySwipedFriendIdAtom.reportRead();
    return super.currentlySwipedFriendId;
  }

  @override
  set currentlySwipedFriendId(int? value) {
    _$currentlySwipedFriendIdAtom
        .reportWrite(value, super.currentlySwipedFriendId, () {
      super.currentlySwipedFriendId = value;
    });
  }

  late final _$nameInputAtom =
      Atom(name: 'FriendStoreBase.nameInput', context: context);

  @override
  String get nameInput {
    _$nameInputAtom.reportRead();
    return super.nameInput;
  }

  @override
  set nameInput(String value) {
    _$nameInputAtom.reportWrite(value, super.nameInput, () {
      super.nameInput = value;
    });
  }

  late final _$loadFriendsAsyncAction =
      AsyncAction('FriendStoreBase.loadFriends', context: context);

  @override
  Future<void> loadFriends() {
    return _$loadFriendsAsyncAction.run(() => super.loadFriends());
  }

  late final _$addFriendAsyncAction =
      AsyncAction('FriendStoreBase.addFriend', context: context);

  @override
  Future<void> addFriend(String name, Color color) {
    return _$addFriendAsyncAction.run(() => super.addFriend(name, color));
  }

  late final _$removeFriendAsyncAction =
      AsyncAction('FriendStoreBase.removeFriend', context: context);

  @override
  Future<void> removeFriend(int id) {
    return _$removeFriendAsyncAction.run(() => super.removeFriend(id));
  }

  late final _$toggleSelectionAsyncAction =
      AsyncAction('FriendStoreBase.toggleSelection', context: context);

  @override
  Future<bool> toggleSelection(int id) {
    return _$toggleSelectionAsyncAction.run(() => super.toggleSelection(id));
  }

  late final _$FriendStoreBaseActionController =
      ActionController(name: 'FriendStoreBase', context: context);

  @override
  void setNameInput(String input) {
    final _$actionInfo = _$FriendStoreBaseActionController.startAction(
        name: 'FriendStoreBase.setNameInput');
    try {
      return super.setNameInput(input);
    } finally {
      _$FriendStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentlySwipedFriendId(int? id) {
    final _$actionInfo = _$FriendStoreBaseActionController.startAction(
        name: 'FriendStoreBase.setCurrentlySwipedFriendId');
    try {
      return super.setCurrentlySwipedFriendId(id);
    } finally {
      _$FriendStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetCurrentlySwipedFriendId() {
    final _$actionInfo = _$FriendStoreBaseActionController.startAction(
        name: 'FriendStoreBase.resetCurrentlySwipedFriendId');
    try {
      return super.resetCurrentlySwipedFriendId();
    } finally {
      _$FriendStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
friends: ${friends},
currentlySwipedFriendId: ${currentlySwipedFriendId},
nameInput: ${nameInput},
selectedFriendsCount: ${selectedFriendsCount},
friendsCount: ${friendsCount}
    ''';
  }
}
