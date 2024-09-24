import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewForRegister extends StatefulWidget {
  final String? url;

  const WebViewForRegister({Key? key, this.url}) : super(key: key);

  @override
  State<WebViewForRegister> createState() => _WebViewForRegisterState();
}

class _WebViewForRegisterState extends State<WebViewForRegister> {
  @override
  Widget build(BuildContext context) {
    String? url = widget.url;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
