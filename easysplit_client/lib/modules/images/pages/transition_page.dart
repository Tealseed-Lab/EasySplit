import 'dart:io';

import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/images/stores/image_store.dart';
import 'package:easysplit_flutter/modules/images/stores/process_store.dart';
import 'package:easysplit_flutter/modules/images/widgets/animated_waiting_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';

class TransitioningPage extends StatefulWidget {
  final String imagePath;
  final String? fromPage;

  const TransitioningPage({super.key, required this.imagePath, this.fromPage});

  @override
  State<StatefulWidget> createState() {
    return _TransitioningPageState();
  }
}

class _TransitioningPageState extends State<TransitioningPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ProcessStore _processStore = ProcessStore();
  final ImageStore _imageStore = locator<ImageStore>();
  final ReceiptStore _receiptStore = locator<ReceiptStore>();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 0.8).animate(_controller);
    _uploadImage();
    Future.delayed(const Duration(seconds: 4), () {
      _processStore.setShowAnimationBar(false);
    });
  }

  Future<void> _uploadImage() async {
    try {
      LogService.i("Scanning the image");
      final success = await _imageStore.uploadImage(File(widget.imagePath));
      if (!mounted) return;
      if (success) {
        LogService.i("Uploading image succeeded. Navigating to /bill.");
        _navigateToNextPage('/bill');
      } else {
        if (_imageStore.noTextDetected) {
          LogService.i("No text detected. Navigating to /no-text-error.");
          _navigateToErrorPage('/no-text-error');
        } else {
          LogService.e("Uploading image failed. Navigating to /network-error.");
          _navigateToErrorPage('/network-error');
        }
      }
    } catch (e) {
      LogService.e("Error uploading image: $e. Navigating to /network-error.");
      if (mounted) {
        _navigateToErrorPage('/network-error');
      }
    }
  }

  void _navigateToNextPage(String route) {
    _controller.stop();
    context.go(route);
  }

  void _navigateToErrorPage(String route) {
    _controller.stop();
    _receiptStore.setEmptyReceiptData();
    context.go(route,
        extra: {'imagePath': widget.imagePath, 'fromPage': widget.fromPage});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 48, 8, 48),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Observer(
                      builder: (_) {
                        if (_processStore.showAnimationBar) {
                          return Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    0,
                                    _animation.value *
                                            MediaQuery.of(context).size.height *
                                            2 -
                                        MediaQuery.of(context).size.height,
                                  ),
                                  child: child,
                                );
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: double.infinity,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        spreadRadius: 40,
                                        blurRadius: 100,
                                        offset: const Offset(0, -40),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                    Observer(
                      builder: (_) {
                        if (!_processStore.showAnimationBar &&
                            !_processStore.showConnectionError &&
                            !_processStore.noTextDetected) {
                          return Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/processing.json',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedWaitingText(
                                    baseTexts: processingTexts,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          widget.fromPage != null
              ? Container(
                  padding: const EdgeInsets.all(16.0),
                  child: NavigationButton(
                    pageName: widget.fromPage!,
                    backgroundColor: Colors.transparent,
                  ),
                )
              : IconButton(
                  padding: const EdgeInsets.only(top: 56, left: 16),
                  icon: CircularIconButton(
                    iconSize: 24,
                    backgroundSize: 48,
                    backgroundColor: Theme.of(context).colorScheme.shadow,
                    svgIconPath: 'assets/svg/arrow-left.svg',
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
        ],
      ),
    );
  }
}
