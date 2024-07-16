import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/common/widgets/toasts/toast_widget.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendsPage extends StatefulWidget {
  final double? scrollPosition;

  const FriendsPage({
    super.key,
    this.scrollPosition,
  });

  @override
  State<StatefulWidget> createState() {
    return _FriendsPageState();
  }
}

class _FriendsPageState extends State<FriendsPage> with WidgetsBindingObserver {
  final _friendStore = locator<FriendStore>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final double deleteButtonWidth = 83.0;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_friendStore.friends.isEmpty) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });

    _nameController.addListener(() {
      _friendStore.setNameInput(_nameController.text);
    });
  }

  void _addFriend() {
    final trimmedName = _nameController.text.trim();
    if (trimmedName.isNotEmpty) {
      if (_friendStore.friendsCount < FriendStoreBase.maximumFriends) {
        _friendStore.addFriend(
          trimmedName,
          _friendStore.nextFriendColor,
        );
        _nameController.clear();
      } else {
        _showToast(maximumFriendsToast);
      }
      _focusNode.unfocus();
    }
  }

  void _showToast(String message) {
    _overlayEntry?.remove();

    _overlayEntry = _createOverlayEntry(message);
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 1), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  OverlayEntry _createOverlayEntry(String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 60.0,
        left: 0,
        right: 0,
        child: Center(
          child: ToastWidget(
            text: message,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _friendStore.resetCurrentlySwipedFriendId();
    _nameController.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigationButton(
                  pageName: 'bill',
                  svgIconPath: 'assets/svg/arrow-left.svg',
                  extra: {'scrollPosition': widget.scrollPosition}),
              Container(
                height: 54,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Observer(
                      builder: (_) => ColorCircle(
                        size: 24,
                        color: _friendStore.nextFriendColor,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Observer(
                      builder: (_) => Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: TextField(
                              focusNode: _friendStore.friends.isEmpty
                                  ? _focusNode
                                  : null,
                              controller: _nameController,
                              onSubmitted: (value) {
                                _addFriend();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Type something ...',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(60, 60, 67, 0.3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              cursorColor:
                                  const Color.fromRGBO(13, 170, 220, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Observer(
                builder: (_) {
                  final friends = _friendStore.friends.toList();

                  return Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: friends.length,
                              itemBuilder: (context, index) {
                                final friend = friends[index];
                                final isSwiped =
                                    _friendStore.currentlySwipedFriendId ==
                                        friend.id;

                                return Column(
                                  children: [
                                    if (index > 0)
                                      const Divider(
                                        color: Color.fromRGBO(60, 60, 67, 0.1),
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                    Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.white,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _friendStore
                                                      .removeFriend(friend.id);
                                                },
                                                child: Container(
                                                  width: deleteButtonWidth,
                                                  color: Colors.red,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onHorizontalDragUpdate: (details) {
                                            if (details.primaryDelta! < -7) {
                                              _friendStore
                                                  .setCurrentlySwipedFriendId(
                                                      friend.id);
                                            }
                                            if (details.primaryDelta! > 7) {
                                              _friendStore
                                                  .setCurrentlySwipedFriendId(
                                                      null);
                                            }
                                          },
                                          onHorizontalDragEnd: (details) {
                                            if (details.primaryVelocity! > 7) {
                                              _friendStore
                                                  .setCurrentlySwipedFriendId(
                                                      null);
                                            }
                                          },
                                          child: Observer(
                                            builder: (_) => AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              transform:
                                                  Matrix4.translationValues(
                                                isSwiped
                                                    ? -deleteButtonWidth
                                                    : 0,
                                                0,
                                                0,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: ListTile(
                                                onTap: () async {
                                                  final success =
                                                      await _friendStore
                                                          .toggleSelection(
                                                              friend.id);
                                                  if (!success) {
                                                    _showToast(
                                                        maximumSelectedFriendsToast);
                                                  }
                                                },
                                                leading: ColorCircle(
                                                  size: 24,
                                                  color: friend.color,
                                                ),
                                                title: Text(friend.name),
                                                trailing: Observer(
                                                  builder: (_) {
                                                    return SvgPicture.asset(
                                                      friend.isSelected
                                                          ? 'assets/svg/checkbox-checked.svg'
                                                          : 'assets/svg/checkbox-unchecked.svg',
                                                      width: 22,
                                                      height: 22,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
