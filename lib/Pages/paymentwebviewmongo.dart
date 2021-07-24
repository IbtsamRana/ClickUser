import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentDoneWebView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentDoneState();
  }
}

class PaymentDoneState extends State<PaymentDoneWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  var url = '';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> datar = ModalRoute.of(context).settings.arguments;
    setState(() {
      url = datar['url'];
    });

    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: WebView(
          initialUrl: '$url',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            JavascriptChannel(
                name: 'MessageInvoker',
                onMessageReceived: (s) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(s.message),
                  ));
                }),
          ].toSet(),
        ),
      ),
    );
  }
}
