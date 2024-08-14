import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easysplit_flutter/common/models/history/history.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/alerts/double_check_bottom_sheet.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/bills/widgets/bill_image.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/home/stores/history_store.dart';
import 'package:easysplit_flutter/modules/images/pages/full_size_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareBillPage extends StatefulWidget {
  final History? history;

  const ShareBillPage({super.key, this.history});

  @override
  State<StatefulWidget> createState() {
    return _ShareBillPageState();
  }
}

class _ShareBillPageState extends State<ShareBillPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ReceiptStore receiptStore = locator<ReceiptStore>();
  final FriendStore friendStore = locator<FriendStore>();
  final HistoryStore historyStore = locator<HistoryStore>();

  Uint8List? savedImage;

  @override
  void initState() {
    super.initState();
    _initializeReceiptLink();
    if (widget.history != null) {
      savedImage = widget.history!.imageBlob;
    }
  }

  Future<void> _initializeReceiptLink() async {
    if (widget.history != null && widget.history!.location != null) {
      final isValid = await isValidImageUrl(widget.history!.location!);
      if (isValid) {
        receiptStore.setReceiptLink(widget.history!.location);
        LogService.i('Receipt link is valid, setting receipt link');
      } else {
        receiptStore.setReceiptLink(null);
        LogService.i('Receipt link is invalid, setting receipt link as null');
      }
    } else if (widget.history != null) {
      receiptStore.setReceiptLink(null);
      LogService.i('Receipt link is null, setting receipt link as null');
    }
  }

  Future<bool> isValidImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200 &&
          response.headers['content-type']?.startsWith('image/') == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _captureAndShareImage() async {
    Uint8List? image =
        savedImage ?? await _screenshotController.capture(pixelRatio: 3.0);
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/bill_image.png';
      LogService.i('Image Path for Sharing: $imagePath');
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      final XFile xFile = XFile(imagePath);
      await Share.shareXFiles([xFile]);

      if (widget.history == null) {
        await _saveHistory(image);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture image')),
      );
      LogService.e('Failed to capture image');
    }
  }

  Future<void> _captureAndSaveImage() async {
    Uint8List? image =
        savedImage ?? await _screenshotController.capture(pixelRatio: 3.0);
    if (image != null) {
      await PhotoManager.requestPermissionExtend();
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/bill_image.png';
      LogService.i('Image Path for Saving: $imagePath');
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // unresolved issue for Android: https://github.com/fluttercandies/flutter_photo_manager/issues/1007
      // final AssetEntity? assetEntity =
      //     await PhotoManager.editor.saveImage(image, title: 'bill_image');
      final AssetEntity? assetEntity =
          await PhotoManager.editor.saveImageWithPath(
        imagePath,
        title: 'bill_image',
      );

      if (assetEntity != null) {
        receiptStore.showImageSaved();
        LogService.i('Image saved to gallery');
      } else if (mounted) {
        LogService.e('Failed to save image, assetEntity is null');
      }

      if (widget.history == null) {
        await _saveHistory(image);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture or save image')),
      );
      LogService.e('Failed to capture or save image');
    }
  }

  Future<void> _saveHistory(Uint8List image) async {
    final items = receiptStore.items.map((item) => item).toList();
    final additionalCharges =
        receiptStore.additionalCharges.map((charge) => charge).toList();
    final additionalDiscounts =
        receiptStore.additionalDiscounts.map((discount) => discount).toList();

    final selectedFriends = friendStore.friends
        .where((friend) => friend.isSelected)
        .map((friend) => {
              'name': friend.name,
              'color': friend.color.value.toRadixString(16),
            })
        .toList();

    final location = receiptStore.receiptLink;

    await historyStore.saveHistory(
      image,
      json.encode(items),
      json.encode(additionalCharges),
      json.encode(additionalDiscounts),
      receiptStore.total.toDouble(),
      json.encode(selectedFriends),
      location,
    );
  }

  void _confirmAndDeleteHistory() {
    showDoubleCheckBottomSheet(
      context,
      title: '',
      message: deleteSplitMessage,
      onConfirm: _deleteHistory,
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmButtonColor: const Color.fromRGBO(255, 59, 48, 1),
      flip: true,
    );
  }

  Future<void> _deleteHistory() async {
    if (widget.history != null) {
      await historyStore.deleteHistory(widget.history!.id);
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (savedImage == null) receiptStore.calculateImageDimensions();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(alignment: Alignment.center, children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NavigationButton(
                              pageName: savedImage != null ? 'home' : 'bill',
                              svgIconPath: savedImage != null
                                  ? 'assets/svg/close.svg'
                                  : 'assets/svg/arrow-left.svg',
                            ),
                            if (widget.history == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: const CircularIconButton(
                                    iconSize: 24,
                                    backgroundSize: 48,
                                    svgIconPath: 'assets/svg/home.svg',
                                  ),
                                  onPressed: () {
                                    context.go('/home');
                                  },
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: SvgPicture.asset(
                                    'assets/svg/edit_split.svg',
                                    width: 77,
                                    height: 38,
                                  ),
                                  onPressed: () {
                                    receiptStore.setReceiptData({
                                      'items':
                                          json.decode(widget.history!.items),
                                      'additional_charges': json.decode(
                                          widget.history!.additionalCharges),
                                      'additional_discounts': json.decode(
                                          widget.history!.additionalDiscounts),
                                      'location': receiptStore.receiptLink
                                    });
                                    context.go('/bill');
                                  },
                                ),
                              )
                          ]),
                      Observer(
                        builder: (_) {
                          if (receiptStore.receiptLink != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullSizeImagePage(
                                          imageUrl: receiptStore.receiptLink!),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: receiptStore.receiptLink!,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: savedImage != null
                            ? Image.memory(savedImage!)
                            : Screenshot(
                                controller: _screenshotController,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double maxWidth = receiptStore.imageWidth;
                                    double maxHeight = receiptStore.imageHeight;

                                    return FittedBox(
                                      fit: BoxFit.contain,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidth,
                                          maxHeight: maxHeight,
                                        ),
                                        child: BillImage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (savedImage != null && widget.history?.id != 0)
                          IconButton(
                            icon: const CircularIconButton(
                              iconSize: 24,
                              backgroundSize: 48,
                              svgIconPath: 'assets/svg/delete.svg',
                            ),
                            onPressed: _confirmAndDeleteHistory,
                          ),
                        if (savedImage != null && widget.history?.id != 0)
                          const SizedBox(width: 36.0),
                        IconButton(
                          icon: const CircularIconButton(
                            iconSize: 24,
                            backgroundSize: 48,
                            svgIconPath: 'assets/svg/share.svg',
                          ),
                          onPressed: _captureAndShareImage,
                        ),
                        const SizedBox(width: 36.0),
                        IconButton(
                          icon: const CircularIconButton(
                            iconSize: 24,
                            backgroundSize: 48,
                            svgIconPath: 'assets/svg/download.svg',
                          ),
                          onPressed: _captureAndSaveImage,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 61.0),
                ],
              ),
            ),
          ),
          Observer(
            builder: (context) {
              if (receiptStore.isImageSavedVisible) {
                return Positioned(
                  bottom: 60,
                  left: MediaQuery.of(context).size.width / 2 - 102.5,
                  child: SvgPicture.asset(
                    'assets/svg/image_saved.svg',
                    width: 210,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
