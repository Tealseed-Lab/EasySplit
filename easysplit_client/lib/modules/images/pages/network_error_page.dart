import 'dart:io';

import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NetworkErrorPage extends StatelessWidget {
  final String imagePath;
  final String fromPage;

  const NetworkErrorPage({
    super.key,
    required this.imagePath,
    required this.fromPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Container(
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
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/network.svg',
                            width: 90,
                            height: 90,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            connectionFailedText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: networkErrorPrompt,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: networkErrorTextRetry,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.go('/transition', extra: {
                                        'imagePath': imagePath,
                                        'fromPage': fromPage
                                      });
                                    },
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            orText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              context.go('/bill');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                manualEnterBillPrompt,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: NavigationButton(
              pageName: fromPage,
              backgroundColor: Colors.transparent,
            ),
          )
        ]));
  }
}
