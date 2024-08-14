import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class FullSizeImagePage extends StatelessWidget {
  final String imageUrl;
  final ReceiptStore receiptStore = locator<ReceiptStore>();

  FullSizeImagePage({super.key, required this.imageUrl});

  Future<void> _downloadAndSaveImage() async {
    try {
      // Request permissions
      await PhotoManager.requestPermissionExtend();

      // Get the directory to save the image
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/receipt_image.jpeg';

      // Download the image
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save the image to the temporary directory
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(response.data);

      // Save the image to the gallery
      final AssetEntity? assetEntity =
          await PhotoManager.editor.saveImageWithPath(
        imagePath,
        title: 'receipt_image',
      );
      if (assetEntity != null) {
        receiptStore.showImageSaved();
        LogService.i('Receipt image saved to gallery');
      } else {
        LogService.e('Failed to save receipt image, assetEntity is null');
      }
    } catch (e) {
      LogService.e('Error saving receipt image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 120.0),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const CircularIconButton(
                    iconSize: 24,
                    backgroundSize: 48,
                    svgIconPath: 'assets/svg/arrow-left.svg',
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const CircularIconButton(
                    iconSize: 24,
                    backgroundSize: 48,
                    svgIconPath: 'assets/svg/download.svg',
                  ),
                  onPressed: () {
                    _downloadAndSaveImage();
                  },
                )
              ],
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
        ]),
      ),
    );
  }
}
