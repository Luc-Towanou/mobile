import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// class PaymentWebView extends StatelessWidget {
//   final String checkoutUrl;

//   const PaymentWebView({Key? key, required this.checkoutUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final WebViewController controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(checkoutUrl));
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Paiement FedaPay"),
//         backgroundColor: Colors.black,
//       ),
//       // body: WebView(
//       //   initialUrl: checkoutUrl,
//       //   javascriptMode: JavascriptMode.unrestricted,
//       body: WebViewWidget(
//         controller: controller,
//       ),
//     );
//   }
// }

class PaymentWebView extends StatelessWidget {
  final String checkoutUrl;

  const PaymentWebView({Key? key, required this.checkoutUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement FedaPay"),
        backgroundColor: Colors.black,
      ),
      // body: WebView(
      //   initialUrl: checkoutUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   navigationDelegate: (NavigationRequest request) {
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
          // 🔎 Ici on détecte les redirections
          if (request.url.contains("/success")) {
            Navigator.pop(context); // Ferme la WebView
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Paiement réussi !")),
            );
            return NavigationDecision.prevent;
          }
          if (request.url.contains("/cancel") || request.url.contains("/failed")) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ Paiement annulé ou échoué.")),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
            )
        )..loadRequest(Uri.parse(checkoutUrl)),
      ),
    );
  }
}
