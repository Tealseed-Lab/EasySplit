import 'dart:io';
import 'dart:typed_data';

import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/bills/widgets/bill_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareBillPage extends StatefulWidget {
  const ShareBillPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShareBillPageState();
  }
}

class _ShareBillPageState extends State<ShareBillPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ReceiptStore receiptStore = locator<ReceiptStore>();

  Future<void> _captureAndShareImage() async {
    Uint8List? image = await _screenshotController.capture(pixelRatio: 3.0);
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/bill_image.png';
      LogService.i('Image Path for Sharing: $imagePath');
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      final XFile xFile = XFile(imagePath);
      await Share.shareXFiles([xFile]);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture image')),
      );
      LogService.e('Failed to capture image');
    }
  }

  Future<void> _captureAndSaveImage() async {
    Uint8List? image = await _screenshotController.capture(pixelRatio: 3.0);
    if (image != null) {
      await PhotoManager.requestPermissionExtend();
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/bill_image.png';
      LogService.i('Image Path for Saving: $imagePath');
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      final AssetEntity? assetEntity =
          await PhotoManager.editor.saveImage(image, title: 'bill_image');
      if (assetEntity != null) {
        receiptStore.showImageSaved();
        LogService.i('Image saved to gallery');
      } else if (mounted) {
        LogService.e('Failed to save image, assetEntity is null');
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture or save image')),
      );
      LogService.e('Failed to capture or save image');
    }
  }

  @override
  Widget build(BuildContext context) {
    receiptStore.calculateImageDimensions();

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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: NavigationButton(
                      pageName: 'bill',
                      svgIconPath: 'assets/svg/close.svg',
                      confirmMessage: null,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Screenshot(
                          controller: _screenshotController,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double maxWidth = receiptStore.imageWidth;
                              double maxHeight = receiptStore.imageHeight;

                              if (maxWidth <= 0 || maxHeight <= 0) {
                                return const Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              }

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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 124.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const CircularIconButton(
                            iconSize: 24,
                            backgroundSize: 48,
                            svgIconPath: 'assets/svg/share.svg',
                          ),
                          onPressed: _captureAndShareImage,
                        ),
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
