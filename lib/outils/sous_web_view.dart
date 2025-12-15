import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// // class PaymentWebView extends StatelessWidget {
// //   final String checkoutUrl;

// //   const PaymentWebView({Key? key, required this.checkoutUrl}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final WebViewController controller = WebViewController()
// //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //       ..loadRequest(Uri.parse(checkoutUrl));
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Paiement FedaPay"),
// //         backgroundColor: Colors.black,
// //       ),
// //       // body: WebView(
// //       //   initialUrl: checkoutUrl,
// //       //   javascriptMode: JavascriptMode.unrestricted,
// //       body: WebViewWidget(
// //         controller: controller,
// //       ),
// //     );
// //   }
// // }

// class PaymentWebView extends StatelessWidget {
//   final String checkoutUrl;

//   const PaymentWebView({Key? key, required this.checkoutUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Paiement FedaPay"),
//         backgroundColor: Colors.black,
//       ),
//       // body: WebView(
//       //   initialUrl: checkoutUrl,
//       //   javascriptMode: JavascriptMode.unrestricted,
//       //   navigationDelegate: (NavigationRequest request) {
//       body: WebViewWidget(
//         controller: WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onNavigationRequest: (NavigationRequest request) {
//           // 🔎 Ici on détecte les redirections
//           if (request.url.contains("/success")) {
//             Navigator.pop(context); // Ferme la WebView
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("✅ Paiement réussi !")),
//             );
//             return NavigationDecision.prevent;
//           }
//           if (request.url.contains("/cancel") || request.url.contains("/failed")) {
//             Navigator.pop(context);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("❌ Paiement annulé ou échoué.")),
//             );
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//             )
//         )..loadRequest(Uri.parse(checkoutUrl)),
//       ),
//     );
//   }
// }

class PaymentWebView extends StatefulWidget {
  final String checkoutUrl;
  const PaymentWebView({Key? key, required this.checkoutUrl}) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  bool _isLoading = true;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // onPageStarted: (_) => setState(() => _isLoading = true),
          onPageStarted: (url) {
            debugPrint("FedaPay - Page started: $url");

            setState(() => _isLoading = true);
          },

          onPageFinished: (url) {
            debugPrint("FedaPay - Page finished: $url");
            setState(() => _isLoading = false);
          },
          // onPageFinished: (_) => setState(() => _isLoading = false),
          // final uri = Uri.parse(url);
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("FedaPay - Navigation: ${request.url}");
            final uri = Uri.parse(request.url);
            debugPrint("Status: ${uri.queryParameters['status']}");
            debugPrint("Transaction ID: ${uri.queryParameters['id']}");
            debugPrint("Reference: ${uri.queryParameters['reference']}");
            if (request.url.contains("success") || request.url.contains("approved")) {
              debugPrint("✅ Paiement réussi: ${request.url}");
              Navigator.pop(context);
               // ✅ Popup fun pendant 2 secondes
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 60),
                        SizedBox(height: 10),
                        Text(
                          "Paiement validé ",
                          style: TextStyle(color: Color.fromARGB(255, 240, 149, 209), fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // ✅ Auto-fermeture après 2 secondes
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context, rootNavigator: true).pop();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Paiement réussi !")),
              );
              return NavigationDecision.prevent;
            }
            if (request.url.contains("/cancel") || request.url.contains("/failed")) {
              debugPrint("❌ Paiement annulé: ${request.url}");
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ Paiement annulé ou échoué.")),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paiement FedaPay"), backgroundColor: Colors.black),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color.fromARGB(255, 243, 33, 198)),
            ),
        ],
      ),
    );
  }
}
