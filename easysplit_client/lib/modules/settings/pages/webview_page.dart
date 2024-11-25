import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final Color? headerColor;

  const WebViewPage({
    super.key,
    required this.url,
    this.headerColor,
  });

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
      backgroundColor: widget.headerColor ?? Colors.white,
      body: Stack(children: [
        Column(
          children: [
            const SizedBox(height: 104),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
        Positioned(
          top: 56,
          left: 16,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircularIconButton(
              iconSize: 24,
              backgroundSize: 48,
              backgroundColor: Theme.of(context).colorScheme.shadow,
              svgIconPath: "assets/svg/close.svg",
            ),
          ),
        ),
      ]),
    );
  }
}
