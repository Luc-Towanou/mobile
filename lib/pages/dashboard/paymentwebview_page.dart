import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class PaymentWebView extends StatelessWidget {
  final String url;

  const PaymentWebView({super.key, required this.url,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement sécurisé')),
      body: WebViewWidget(
        // initialUrl: url,
        // javascriptMode: JavascriptMode.unrestricted,
        // navigationDelegate: (nav) {
        //   if (nav.url.contains('success')) {
        //     Navigator.pop(context, true);
        //   }
        //   if (nav.url.contains('cancel')) {
        //     Navigator.pop(context, false);
        //   }
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('success')) Navigator.pop(context, true);
                if (request.url.contains('cancel')) Navigator.pop(context, false);
          return NavigationDecision.navigate;
        },
      ),
    )
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
