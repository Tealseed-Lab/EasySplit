import 'package:flutter/material.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:go_router/go_router.dart';
import 'package:easysplit_flutter/modules/sample/stores/sample_help_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<StatefulWidget> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  final SampleHelpStore _sampleHelpStore = locator<SampleHelpStore>();

  Future<void> onImageTap(String samplePath) async {
    final XFile? picture = await _sampleHelpStore.pickSamplePicture(samplePath);
    if (picture != null && mounted) {
      LogService.i(
          "Navigating to /transition with image path: ${picture.path}, fromPage: sample");
      context.push('/transition', extra: {'imagePath': picture.path});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 56.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    icon: CircularIconButton(
                      iconSize: 24,
                      backgroundSize: 48,
                      backgroundColor: Theme.of(context).colorScheme.shadow,
                      svgIconPath: 'assets/svg/close.svg',
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 96),
              const SizedBox(
                width: 260,
                height: 84,
                child: Text(
                  selectSampleReceiptTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () =>
                            onImageTap('assets/png/sample_receipt1.png'),
                        child: Container(
                          height: 264,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image:
                                  AssetImage('assets/png/sample_receipt1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: GestureDetector(
                        onTap: () =>
                            onImageTap('assets/png/sample_receipt2.png'),
                        child: Container(
                          height: 264,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image:
                                  AssetImage('assets/png/sample_receipt2.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
