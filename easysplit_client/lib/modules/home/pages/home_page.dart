import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:easysplit_flutter/common/repositories/interfaces/guide_repository.dart';
import 'package:easysplit_flutter/common/services/interfaces/image_service.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/services/shake_detector_service.dart';
import 'package:easysplit_flutter/common/stores/guide_store.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/utils/logs/log_utils.dart';
import 'package:easysplit_flutter/common/widgets/alerts/double_check_bottom_sheet.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle.dart';
import 'package:easysplit_flutter/modules/home/stores/history_store.dart';
import 'package:easysplit_flutter/modules/images/stores/image_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final GuideStore _guideStore = locator<GuideStore>();
  final ImageStore _imageStore = locator<ImageStore>();
  final ReceiptStore _receiptStore = locator<ReceiptStore>();
  final FriendStore _friendStore = locator<FriendStore>();
  final HistoryStore _historyStore = locator<HistoryStore>();
  late ShakeDetectorService _shakeDetector;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetectorService(onShake: _onShake);
    _shakeDetector.start();
    _historyStore.loadLastHistory();
  }

  @override
  void dispose() {
    _shakeDetector.dispose();
    super.dispose();
  }

  Future<void> _onShake() async {
    try {
      final logFile = await LogService.packetLogFiles();
      if (logFile != null && mounted) {
        showShareDialog(context, File(logFile));
      }
    } catch (e) {
      LogService.e("Error during shake event: $e");
    }
  }

  Future<void> _checkGalleryPermission() async {
    var galleryStatus = await Permission.photos.status;
    if (galleryStatus.isDenied) {
      galleryStatus = await Permission.photos.request();
    }

    if (galleryStatus.isGranted || galleryStatus.isLimited) {
      await _uploadImageFromSource(ReceiptImageSource.gallery);
    } else {
      _showPermissionBottomSheet(
        photoLibraryPermissionTitle,
        photoLibraryPermissionMessage,
        onConfirm: () => AppSettings.openAppSettings(),
      );
    }
  }

  Future<void> _uploadImageFromSource(ReceiptImageSource source) async {
    try {
      final file = await _imageStore.pickImageFromSource(source);
      if (file != null && mounted) {
        LogService.i(
            "Navigating to /transition with image path: ${file.path}, fromPage: home");
        context.go('/transition',
            extra: {'imagePath': file.path, 'fromPage': 'home'});
      }
    } catch (e) {
      LogService.e("Error uploading image from source: $e");
    }
  }

  void _showPermissionBottomSheet(String title, String message,
      {required VoidCallback onConfirm}) {
    if (!mounted) return;
    showDoubleCheckBottomSheet(
      context,
      title: title,
      message: message,
      onConfirm: onConfirm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: NavigationButton(
                    pageName: 'settings',
                    svgIconPath: 'assets/svg/settings.svg',
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    iconBackgroundColor: Theme.of(context).colorScheme.shadow,
                  ),
                ),
                Observer(
                  builder: (_) {
                    final lastHistory = _historyStore.lastHistory;
                    return GestureDetector(
                      onTap:
                          lastHistory != null && lastHistory.deletedAt == null
                              ? () {
                                  context.go('/shareBill', extra: lastHistory);
                                }
                              : null,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.shadow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              historyTitle,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            if (lastHistory != null &&
                                lastHistory.deletedAt == null)
                              Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image:
                                            MemoryImage(lastHistory.imageBlob),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${lastHistory.total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('dd MMM yyyy HH:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                lastHistory.createdAt)),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          for (var friend in json
                                              .decode(lastHistory.friendsList))
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: ColorCircle(
                                                size: 24,
                                                text: (friend['name'] as String)
                                                    .substring(0, 1),
                                                color: Color(int.parse(
                                                    friend['color'],
                                                    radix: 16)),
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/empty_history.svg',
                                        width: 48,
                                        height: 48,
                                      ),
                                      const Text(
                                        noHistoryText,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromRGBO(
                                                33, 78, 92, 0.18)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.go('/friends');
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.shadow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            diningFriendsTitle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Observer(
                            builder: (_) => Text(
                              _friendStore.friendsCount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          SvgPicture.asset(
                            'assets/svg/chevron_right.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 17),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: CircularIconButton(
                                      iconSize: 24,
                                      backgroundSize: 55,
                                      svgIconPath: 'assets/svg/edit.svg',
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    onPressed: () {
                                      if (_guideStore.homeGuideState ==
                                          GuideState.notViewed) {
                                        _guideStore.setHomeGuideViewed();
                                      }
                                      _receiptStore.setEmptyReceiptData();
                                      context.go('/bill');
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(width: 40),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: CircularIconButton(
                                  iconSize: 60,
                                  backgroundSize: 96,
                                  svgIconPath: 'assets/svg/scan.svg',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  if (_guideStore.homeGuideState ==
                                      GuideState.notViewed) {
                                    _guideStore.setHomeGuideViewed();
                                  }
                                  context.go('/camera');
                                },
                              ),
                              const SizedBox(width: 40),
                              Column(
                                children: [
                                  const SizedBox(height: 17),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: CircularIconButton(
                                      iconSize: 24,
                                      backgroundSize: 55,
                                      svgIconPath: 'assets/svg/picture.svg',
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    onPressed: () async {
                                      if (_guideStore.homeGuideState ==
                                          GuideState.notViewed) {
                                        _guideStore.setHomeGuideViewed();
                                      }
                                      await _checkGalleryPermission();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 46),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Observer(
            builder: (_) {
              if (_guideStore.homeGuideState == GuideState.notViewed) {
                return Positioned(
                  bottom: 120.5,
                  left: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      'assets/svg/guide_home.svg',
                      width: MediaQuery.of(context).size.width - 60,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
