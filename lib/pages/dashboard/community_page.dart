import 'package:event_rush_mobile/providers/feed_provider.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'base_feed_page.dart';

class CommunityPage extends StatelessWidget {
  final ApiService apiService;

  const CommunityPage({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BaseFeedPage(
      pageType: 'community',
      apiService: apiService,
      feedProvider: communityFeedProvider
    );
  }
}