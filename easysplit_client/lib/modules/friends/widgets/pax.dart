import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Pax extends StatelessWidget {
  final VoidCallback onTap;

  const Pax({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final friendStore = locator<FriendStore>();

    return Observer(
      builder: (_) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/users.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 4.0),
              Text(
                '${friendStore.selectedFriendsCount}',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
