import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_item.dart';
import '../services/api_service.dart';

// class FeedNotifier extends StateNotifier<FeedState> {
//   final ApiService apiService;
//   final String pageType;

//   FeedNotifier({required this.apiService, required this.pageType})
//       : super(const FeedState());

//   Future<void> loadInitialFeed() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       final response = await apiService.fetchFeed(pageType);
      
//       state = state.copyWith(
//         items: response.items,
//         cursor: response.cursor,
//         hasMore: response.hasMore,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   Future<void> loadMore() async {
//     if (state.isLoading || !state.hasMore) return;

//     try {
//       state = state.copyWith(isLoading: true);
//       final response = await apiService.fetchFeed(
//         pageType,
//         cursor: state.cursor,
//       );

//       state = state.copyWith(
//         items: [...state.items, ...response.items],
//         cursor: response.cursor,
//         hasMore: response.hasMore,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   void refresh() {
//     state = const FeedState();
//     loadInitialFeed();
//   }

//   void addItem(FeedItem item) {
//     state = state.copyWith(
//       items: [item, ...state.items],
//     );
//   }

//   void removeItem(String itemId) {
//     state = state.copyWith(
//       items: state.items.where((item) => item.id != itemId).toList(),
//     );
//   }
// }

class FeedNotifier extends StateNotifier<FeedState> {
  final ApiService apiService;
  final String pageType;

  FeedNotifier({required this.apiService, required this.pageType})
      : super(const FeedState());

  Future<void> loadInitialFeed() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await apiService.fetchFeed(pageType);

      state = state.copyWith(
        items: response.items,
        cursor: response.cursor,
        hasMore: response.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    try {
      state = state.copyWith(isLoading: true);
      final response = await apiService.fetchFeed(
        pageType,
        cursor: state.cursor,
      );

      state = state.copyWith(
        items: [...state.items, ...response.items],
        cursor: response.cursor,
        hasMore: response.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void refresh() {
    state = const FeedState();
    loadInitialFeed();
  }
}


class FeedState {
  final List<FeedItem> items;
  final String? cursor;
  final bool hasMore;
  final bool isLoading;
  final String? error;

  const FeedState({
    this.items = const [],
    this.cursor,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
  });

  FeedState copyWith({
    List<FeedItem>? items,
    String? cursor,
    bool? hasMore,
    bool? isLoading,
    String? error,
  }) {
    return FeedState(
      items: items ?? this.items,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Provider pour chaque type de page
final homeFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return FeedNotifier(apiService: apiService, pageType: 'home');
  },
);

final newsFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return FeedNotifier(apiService: apiService, pageType: 'news');
  },
);

final organizersFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return FeedNotifier(apiService: apiService, pageType: 'organizers');
  },
);

final exploreFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return FeedNotifier(apiService: apiService, pageType: 'explore');
  },
);

final communityFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return FeedNotifier(apiService: apiService, pageType: 'community');
  },
);

final apiServiceProvider = Provider<ApiService>((ref) {
  // En production, récupérer le token depuis le stockage sécurisé
  return ApiService('auth_token_here');
});


// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/feed_item.dart';
// import '../services/api_service.dart';

// class FeedNotifier extends StateNotifier<FeedState> {
//   final ApiService apiService;
//   final String pageType;

//   FeedNotifier({required this.apiService, required this.pageType})
//       : super(const FeedState());

//   Future<void> loadInitialFeed() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       final response = await apiService.fetchFeed(pageType);
      
//       state = state.copyWith(
//         items: response.items,
//         cursor: response.cursor,
//         hasMore: response.hasMore,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   Future<void> loadMore() async {
//     if (state.isLoading || !state.hasMore) return;

//     try {
//       state = state.copyWith(isLoading: true);
//       final response = await apiService.fetchFeed(
//         pageType,
//         cursor: state.cursor,
//       );

//       state = state.copyWith(
//         items: [...state.items, ...response.items],
//         cursor: response.cursor,
//         hasMore: response.hasMore,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   void refresh() {
//     state = const FeedState();
//     loadInitialFeed();
//   }
// }

// class FeedState {
//   final List<FeedItem> items;
//   final String? cursor;
//   final bool hasMore;
//   final bool isLoading;
//   final String? error;

//   const FeedState({
//     this.items = const [],
//     this.cursor,
//     this.hasMore = true,
//     this.isLoading = false,
//     this.error,
//   });

//   FeedState copyWith({
//     List<FeedItem>? items,
//     String? cursor,
//     bool? hasMore,
//     bool? isLoading,
//     String? error,
//   }) {
//     return FeedState(
//       items: items ?? this.items,
//       cursor: cursor ?? this.cursor,
//       hasMore: hasMore ?? this.hasMore,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }

// // Provider pour chaque type de page
// final homeFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
//   (ref) {
//     final apiService = ref.watch(apiServiceProvider);
//     return FeedNotifier(apiService: apiService, pageType: 'home');
//   },
// );

// final newsFeedProvider = StateNotifierProvider<FeedNotifier, FeedState>(
//   (ref) {
//     final apiService = ref.watch(apiServiceProvider);
//     return FeedNotifier(apiService: apiService, pageType: 'news');
//   },
// );

// // Ajoutez des providers similaires pour les autres pages

// final apiServiceProvider = Provider<ApiService>((ref) {
//   // Récupérer le token d'authentification depuis le stockage sécurisé
//   return ApiService('auth_token_here');
// });