import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubeShortWidget extends StatefulWidget {
  final String shortUrl;

  const YouTubeShortWidget({super.key, required this.shortUrl});

  @override
  State<YouTubeShortWidget> createState() => _YouTubeShortWidgetState();
}

class _YouTubeShortWidgetState extends State<YouTubeShortWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.shortUrl));
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: AspectRatio(

        aspectRatio: 16 / 9,
        child: WebViewWidget(controller: _controller),
      ),
    );

  }
}
