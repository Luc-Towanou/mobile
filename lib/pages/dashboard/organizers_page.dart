import 'package:flutter/material.dart';
import 'package:event_rush_mobile/providers/feed_provider.dart';
import '../../services/api_service.dart';
import 'base_feed_page.dart';

class OrganizersPage extends StatelessWidget {
  final ApiService apiService;

  const OrganizersPage({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BaseFeedPage(
      pageType: 'organizers',
      apiService: apiService,
      feedProvider: organizersFeedProvider
    );
  }
}