import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          Container(
            color: const Color(0xFFF9F9F9),
            height: 50,
          ),
          Positioned(
            top: 62,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircularIconButton(
                iconSize: 24,
                backgroundSize: 48,
                backgroundColor: Theme.of(context).colorScheme.shadow,
                svgIconPath: "assets/svg/arrow-left.svg",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
