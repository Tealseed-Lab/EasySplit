import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/sample/pages/sample_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easysplit_flutter/common/stores/guide_store.dart';

class SampleHelpCard extends StatelessWidget {
  const SampleHelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    final guideStore = locator<GuideStore>();
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SamplePage()));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(13, 170, 220, 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  helpCardTitle,
                  style: TextStyle(
                    color: Color(0xFF0DAADC),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    guideStore.dismissSampleHelp();
                  },
                  child: SvgPicture.asset(
                    'assets/svg/help_dismiss.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                text: helpCardDesc1,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF0DAADC),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.375,
                ),
                children: [
                  TextSpan(
                    text: helpCardDesc2,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: helpCardDesc3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
