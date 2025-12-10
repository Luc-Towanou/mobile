//base_feed_page.dart
import 'package:event_rush_mobile/providers/feed_provider.dart';
import 'package:event_rush_mobile/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/feed_item.dart';
import '../../widgets/bottom_loader.dart';
import '../../widgets/feed_items/event_card.dart';
import '../../widgets/feed_items/article_card.dart';
import '../../widgets/feed_items/section_header.dart';
import '../../widgets/feed_items/promo_card.dart';
import '../../widgets/feed_items/organizer_card.dart';
import '../../widgets/feed_items/story_bar.dart';
import '../../widgets/skeletons/event_card_skeleton.dart';
import '../../widgets/skeletons/article_card_skeleton.dart';
import '../../widgets/skeletons/section_header_skeleton.dart';
import '../../widgets/error_state.dart';
import '../../widgets/empty_state.dart';

class BaseFeedPage extends ConsumerStatefulWidget {
  final StateNotifierProvider<FeedNotifier, FeedState> feedProvider;

  const BaseFeedPage({
    super.key,
    required this.feedProvider, required ApiService apiService, required String pageType,
  });

  @override
  ConsumerState<BaseFeedPage> createState() => _BaseFeedPageState();
}

class _BaseFeedPageState extends ConsumerState<BaseFeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Charger le flux initial si nécessaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(widget.feedProvider);
      if (state.items.isEmpty && !state.isLoading) {
        ref.read(widget.feedProvider.notifier).loadInitialFeed();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.65) {
      ref.read(widget.feedProvider.notifier).loadMore();
    }
  }

  Widget _buildFeedItem(FeedItem item) {
    switch (item.type) {
      case 'section_header':
        return SectionHeader(
          title: item.payload['title'],
          subtitle: item.payload['subtitle'],
        );
      case 'event':
        return EventCard(payload: item.payload);
      case 'article':
        return ArticleCard(payload: item.payload);
      case 'promo':
        return PromoCard(payload: item.payload);
      case 'organizer':
        return OrganizerCard(payload: item.payload);
      case 'story_bar':
        return StoryBar(payload: item.payload);
      default:
        return Container(); // Type non reconnu
    }
  }

  Widget _buildSkeleton(int index) {
    switch (index % 3) {
      case 0:
        return const EventCardSkeleton();
      case 1:
        return const ArticleCardSkeleton();
      case 2:
        return const SectionHeaderSkeleton();
      default:
        return const EventCardSkeleton();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(widget.feedProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.feedProvider.notifier).refresh();
        },
        child: _buildBody(feedState),
      ),
    );
  }

  Widget _buildBody(FeedState state) {
    if (state.error != null && state.items.isEmpty) {
      return ErrorState(
        message: state.error!,
        onRetry: () => ref.read(widget.feedProvider.notifier).loadInitialFeed(),
      );
    }

    if (state.items.isEmpty && !state.isLoading) {
      return EmptyState(
        title: 'Aucun contenu',
        message: 'Il n\'y a pas encore de contenu à afficher ici.',
        buttonText: 'Actualiser',
        onButtonPressed: () => ref.read(widget.feedProvider.notifier).refresh(),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {if (index < state.items.length) {
                return _buildFeedItem(state.items[index]);
              } else if (state.hasMore) {
                return const BottomLoader();
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text("Vous avez tout vu !"),
                  ),
                );
              }
            },
            childCount: state.hasMore
                ? state.items.length + 1
                : state.items.length + 1,
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import '../models/feed_item.dart';
// import '../services/api_service.dart';
// import '../widgets/bottom_loader.dart';
// import '../widgets/feed_items/event_card.dart';
// import '../widgets/feed_items/article_card.dart';
// import '../widgets/feed_items/section_header.dart';
// import '../widgets/feed_items/promo_card.dart';
// import '../widgets/feed_items/organizer_card.dart';
// import '../widgets/feed_items/story_bar.dart';
// import '../widgets/skeletons/event_card_skeleton.dart';
// import '../widgets/skeletons/article_card_skeleton.dart';
// import '../widgets/skeletons/section_header_skeleton.dart';

// class BaseFeedPage extends StatefulWidget {
//   final String pageType;
//   final ApiService apiService;

//   const BaseFeedPage({
//     super.key,
//     required this.pageType,
//     required this.apiService,
//   });

//   @override
//   State<BaseFeedPage> createState() => _BaseFeedPageState();
// }

// class _BaseFeedPageState extends State<BaseFeedPage> {
//   final ScrollController _scrollController = ScrollController();
//   final List<FeedItem> _feedItems = [];
//   String? _cursor;
//   bool _isLoading = false;
//   bool _hasMore = true;
//   bool _isFirstLoad = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialFeed();
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadInitialFeed() async {
//     try {
//       setState(() => _isLoading = true);
//       final response = await widget.apiService.fetchFeed(widget.pageType);
      
//       setState(() {
//         _feedItems.addAll(response.items);
//         _cursor = response.cursor;
//         _hasMore = response.hasMore;
//         _isLoading = false;
//         _isFirstLoad = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       // Gérer l'erreur
//     }
//   }

//   Future<void> _loadMore() async {
//     if (_isLoading || !_hasMore) return;

//     try {
//       setState(() => _isLoading = true);
//       final response = await widget.apiService.fetchFeed(
//         widget.pageType,
//         cursor: _cursor,
//       );

//       setState(() {
//         _feedItems.addAll(response.items);
//         _cursor = response.cursor;
//         _hasMore = response.hasMore;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       // Gérer l'erreur
//     }
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.65) {
//       _loadMore();
//     }
//   }

//   Widget _buildFeedItem(FeedItem item) {
//     switch (item.type) {
//       case 'section_header':
//         return SectionHeader(
//           title: item.payload['title'],
//           subtitle: item.payload['subtitle'],
//         );
//       case 'event':
//         return EventCard(payload: item.payload);
//       case 'article':
//         return ArticleCard(payload: item.payload);
//       case 'promo':
//         return PromoCard(payload: item.payload);
//       case 'organizer':
//         return OrganizerCard(payload: item.payload);
//       case 'story_bar':
//         return StoryBar(payload: item.payload);
//       default:
//         return Container(); // Type non reconnu
//     }
//   }

//   Widget _buildSkeleton(int index) {
//     // Alterner les squelettes pour une meilleure apparence
//     switch (index % 3) {
//       case 0:
//         return const EventCardSkeleton();
//       case 1:
//         return const ArticleCardSkeleton();
//       case 2:
//         return const SectionHeaderSkeleton();
//       default:
//         return const EventCardSkeleton();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isFirstLoad
//           ? ListView.builder(
//               itemCount: 6,
//               itemBuilder: (context, index) => _buildSkeleton(index),
//             )
//           : CustomScrollView(controller: _scrollController,
//               slivers: [
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       if (index < _feedItems.length) {
//                         return _buildFeedItem(_feedItems[index]);
//                       } else if (_hasMore) {
//                         return const BottomLoader();
//                       } else {
//                         return const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 32.0),
//                           child: Center(
//                             child: Text("Vous avez tout vu !"),
//                           ),
//                         );
//                       }
//                     },
//                     childCount: _hasMore
//                         ? _feedItems.length + 1
//                         : _feedItems.length + 1,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }