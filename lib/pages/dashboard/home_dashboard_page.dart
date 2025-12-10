import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/feed_provider.dart';
import '../../services/api_service.dart';
import 'base_feed_page.dart';

class HomePage extends StatelessWidget {
  final ApiService apiService;
  const HomePage({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BaseFeedPage(
      pageType: 'home',
      apiService: apiService,
      feedProvider: homeFeedProvider);
  }
}


// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'base_feed_page.dart';

// class HomePage extends StatelessWidget {
//   final ApiService apiService;

//   const HomePage({super.key, required this.apiService});

//   @override
//   Widget build(BuildContext context) {
//     return BaseFeedPage(
//       pageType: 'home',
//       apiService: apiService,
//     );
//   }
// }