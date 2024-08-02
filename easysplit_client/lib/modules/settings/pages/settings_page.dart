import 'package:easysplit_flutter/common/stores/app_store.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/settings/pages/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final AppStore _appStore = locator<AppStore>();

  @override
  void initState() {
    super.initState();
    _appStore.fetchAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: NavigationButton(
                  pageName: 'home',
                  svgIconPath: 'assets/svg/arrow-left.svg',
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  iconBackgroundColor: Theme.of(context).colorScheme.shadow,
                ),
              ),
              const SizedBox(height: 54),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/icon_name.svg',
                    width: 207,
                    height: 132,
                  ),
                ),
              ),
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: const Color.fromRGBO(245, 245, 245, 1),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WebViewPage(
                                    url:
                                        'https://tealseed.com/products/#EasySplit',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'About EasySplit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Color.fromRGBO(60, 60, 67, 0.1),
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     context.go('/home');
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.all(16.0),
                          //     alignment: Alignment.centerLeft,
                          //     child: const Text(
                          //       'Privacy & User agreement',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const Divider(
                          //   color: Color.fromRGBO(60, 60, 67, 0.1),
                          //   height: 1,
                          //   indent: 16,
                          //   endIndent: 16,
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WebViewPage(
                                    url: 'https://tealseed.com/easysplit-faq/',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'EasySplit FAQ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Observer(
                        builder: (_) => Text(
                          'V${_appStore.appVersion}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(60, 60, 67, 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 67),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
