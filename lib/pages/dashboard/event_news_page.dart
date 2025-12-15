import 'package:event_rush_mobile/models/event_news.dart';
import 'package:event_rush_mobile/services/api_service.dart';
import 'package:event_rush_mobile/widgets/skeletons/event_news_skeleton.dart';
import 'package:flutter/material.dart';

/// EventRush – News / Status-like Feed
/// --------------------------------------------------------------
/// A long, scroll-only, content-rich feed inspired by WhatsApp Status,
/// Instagram Explore, and editorial magazines.
/// 
/// Design goals:
/// - One single page to binge-scroll
/// - Visual, modular sections (stories, trending events, media, promos, social, stats, agenda, lifestyle, fun)
/// - No external packages required (pure Flutter)
/// - Ready to drop into a BottomNavigationBar tab
/// 
/// 🇫🇷 Les commentaires sont bilingues pour la clarté.
/// 🇬🇧 Comments are bilingual for clarity.
class NewsFeedPage extends StatefulWidget {
  final ApiService apiService;
  
  const NewsFeedPage({super.key, required this.apiService,});
  


  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final _scrollController = ScrollController();
  bool _isLoading = true;
  String? _error;
  FeedEventNewsResponse? _feed;
  // --- Mock data (replace with API data) ---
  // final List<_Story> stories = List.generate(
  //   12,
  //   (i) => _Story(
  //     username: 'Org ${i + 1}',
  //     imageUrl: 'https://picsum.photos/seed/story$i/400/700',
  //     isVerified: i % 3 == 0,
  //   ),
  // );
  // final stories = _feed!.stories.map<_Story>((s) {
  //   return _Story(
  //     username: s['utilisateur']['nom'],
  //     imageUrl: s['media_path'],
  //     isVerified: s['utilisateur']['role'] == 'organisateur',
  //   );
  // }).toList();


  // final List<_EventCard> trendingEvents = List.generate(
  //   10,
  //   (i) => _EventCard(
  //     title: 'Soirée Afrobeat Vol. ${i + 1}',
  //     subtitle: 'Cotonou • Ven 20:${10 + i}',
  //     imageUrl: 'https://picsum.photos/seed/event$i/800/600',
  //     likes: 120 + i * 7,
  //     priceFrom: 3500 + i * 500,
  //   ),
  // );
  // final trendingEvents = _feed!.trendingEvents.map<_EventCard>((e) {
  //   return _EventCard(
  //     title: e['title'],
  //     subtitle: e['subtitle'],
  //     imageUrl: e['image'],
  //     likes: e['likes'],
  //     priceFrom: e['price_from'],
  //   );
  // }).toList();


  // final List<_Article> articles = [
  //   _Article(
  //     title: '5 tips pour profiter d’un festival comme un pro',
  //     excerpt: 'Hydrate-toi, planifie tes sets, shoes confort et vibe positive...',
  //     imageUrl: 'https://picsum.photos/seed/article1/800/500',
  //     readTime: '3 min',
  //   ),
  //   _Article(
  //     title: 'Top 10 des salles à Cotonou',
  //     excerpt: 'Du cosy intimiste à l’aréna qui claque, voici notre sélection...',
  //     imageUrl: 'https://picsum.photos/seed/article2/800/500',
  //     readTime: '5 min',
  //   ),
  //   _Article(
  //     title: 'Interview: DJ Kossi parle de son nouveau set',
  //     excerpt: 'Un mélange d’Afro-house, Amapiano et surprises pour chauffer la nuit...',
  //     imageUrl: 'https://picsum.photos/seed/article3/800/500',
  //     readTime: '4 min',
  //   ),
  // ];

  // final List<_CommunityPost> community = List.generate(
  //   8,
  //   (i) => _CommunityPost(
  //     user: 'Membre ${i + 1}',
  //     text: 'J’ai adoré l’event d’hier !🔥 Ambiance de fou et son nickel.',
  //     imageUrl: i % 2 == 0 ? 'https://picsum.photos/seed/post$i/900/700' : null,
  //     timeAgo: '${i + 1}h',
  //     reactions: 10 + i * 3,
  //     comments: 2 + i,
  //   ),
  // );

  // final community = _feed!.communityPosts.map<_CommunityPost>((p) {
  //   return _CommunityPost(
  //     user: p['utilisateur']['nom'],
  //     text: p['contenu'],
  //     imageUrl: p['image'],
  //     timeAgo: p['time_ago'],
  //     reactions: p['reactions_count'],
  //     comments: p['comments_count'],
  //   );
  // }).toList(); 


  // final List<_AgendaItem> agenda = [
  //   _AgendaItem('Concert live – Marina', 'Jeudi 21:00', '3 km'),
  //   _AgendaItem('Battle de danse', 'Vendredi 19:30', '2 km'),
  //   _AgendaItem('Comedy Night', 'Samedi 20:00', '4 km'),
  //   _AgendaItem('Open Mic', 'Dimanche 18:00', '1 km'),
  // ];

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    try {
      final data = await widget.apiService.fetcheventnewsFeed();

      setState(() {
        _feed = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }
    if (_isLoading) {
      return const EventNewsSkeleton();
    }
    // return EventNewsPage(data: feed);

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Erreur de chargement 😢\n$_error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    // Initialize lists after _feed is loaded
    final List<_Story> stories = _feed!.stories.map<_Story>((s) {
      
      return _Story(
        username: s.user.nom,
        imageUrl: s.mediaPath,
        isVerified: s.user.role == 'organisateur',
      );
    }).toList();
  print ("stories : ${stories},"); 
    // Assuming you have a trendingEvents list in FeedEventNewsResponse
    // For now, using mock data if _feed.trendingEvents is not available
    // final List<_EventCard> trendingEvents = List.generate(
    //   10,
    //   (i) => _EventCard(
    //     title: 'Soirée Afrobeat Vol. ${i + 1}',
    //     subtitle: 'Cotonou • Ven 20:${10 + i}',
    //     imageUrl: 'https://picsum.photos/seed/event$i/800/600',
    //     likes: 120 + i * 7,
    //     priceFrom: 3500 + i * 500,
    //   ),
    // );
    final List<_EventCard> $trendingEvents = _feed!.clips.map<_EventCard>((s) {
        return _EventCard(
          title: s.description.isNotEmpty
              ? s.description
              : 'Événement en vedette',
          subtitle: s.user.nom,
          imageUrl: s.mediaPath,
          likes: 0,       // à brancher plus tard
          priceFrom: 0,   // idem (pricing)
        );
      }).toList();

      final List<_ClipModel> $clips = _feed!.clips.map<_ClipModel>((c) {
        return _ClipModel(
          id: c.id,
          description: c.description,
          type: c.type,
          mediaPath: c.mediaPath,
          eventId: c.eventId,
          user: c.user,
        );
      }).toList();


    final List<_Article> articles = _feed!.articles.map<_Article>((s) {
        return _Article(
          title: s.title,
          excerpt: s.excerpt,
          imageUrl: s.cover,
          readTime: s.readTime,
        );
      }).toList();

    final List<_CommunityPost> community = _feed!.communityPosts.map<_CommunityPost>((p) {
      return _CommunityPost(
        user: p.user.nom, 
        text: p.contenu, 
        imageUrl: null, 
        timeAgo: '2h', 
        reactions: 0, 
        comments: 0); // Adjust as per your CommunityPostModel
    }).toList();

    List<_AgendaItem> agenda = _feed!.agenda.map<_AgendaItem>((s) {
        return _AgendaItem(
          s.title,
          '${s.dateDebut.day}/${s.dateDebut.month} ${s.dateDebut.hour}:${s.dateDebut.minute}', // Format date as string
          '${s.billetsCount} billets', // Convert int to string

          // s.description,
          // s.billetsCount,
          // s.dateDebut,
          // 'Ce soir • 19h',
          // '2 km',
        );
      }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // SliverAppBar collapsible (stories-like header stays sleek on scroll)
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 110,
            surfaceTintColor: theme.colorScheme.surface,
            title: const Text('News'),
            
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
                tooltip: 'Search / Rechercher',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune),
                tooltip: 'Filter / Filtrer',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: _StoriesBar(stories: stories),
              ),
            ),
          ),

          _SectionHeaderSliver(
            icon: Icons.flash_on,
            title: 'Tendances près de toi',
            subtitle: 'Top events basés sur likes & vues',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _TrendingCarousel(items: $trendingEvents)),

          _SectionHeaderSliver(
            icon: Icons.smart_display,
            title: 'Clips & Highlights',
            subtitle: 'Moments forts et teasers vidéo',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _ShortsReel(clips: $clips)),

          _SectionHeaderSliver(
            icon: Icons.new_releases,
            title: 'Actus & Articles',
            subtitle: 'Édito EventRush et culture locale',
            onSeeAll: () {},
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
              
          //     (context, index) => _ArticleCard(article: articles[index % articles.length]),
          //     childCount: 6,
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (articles.isEmpty) {
                  return const Center(child: Text("Aucun article disponible"));
                }
                return _ArticleCard(article: articles[index % articles.length]);
              },
              childCount: articles.isEmpty ? 1 : 6,
            ),
          ),

          _SectionHeaderSliver(
            icon: Icons.card_giftcard,
            title: 'Promos & Exclus',
            subtitle: 'Codes promo, tirages, partenaires',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _PromoBelt()),

          _SectionHeaderSliver(
            icon: Icons.groups_2,
            title: 'Communauté',
            subtitle: 'Posts, réactions, mini-reviews',
            onSeeAll: () {},
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) 
              // => _CommunityCard(post: community[index % community.length]),
              // childCount: 6,

              {
                if (community.isEmpty) {
                  return const Center(child: Text("Rien au niveau de la communauté"));
                }
                return _CommunityCard(post: community[index % community.length]);
              },
              childCount: articles.isEmpty ? 1 : 6,
            ),
          ),

          _SectionHeaderSliver(
            icon: Icons.insights,
            title: 'Tes stats',
            subtitle: 'Résumé personnel & badges',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _PersonalStatsCard()),

          _SectionHeaderSliver(
            icon: Icons.event,
            title: 'Agenda rapide',
            subtitle: 'Cette semaine autour de toi',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _AgendaList(items: agenda)),

          _SectionHeaderSliver(
            icon: Icons.mood,
            title: 'Lifestyle & Inspiration',
            subtitle: 'Citations, backstage, culture',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _LifestyleMosaic()),

          _SectionHeaderSliver(
            icon: Icons.sports_esports,
            title: 'Quiz & Sondages',
            subtitle: 'Joue et donne ton avis',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(child: _PollAndQuizCard()),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// UI WIDGETS
// =============================================================

class _StoriesBar extends StatelessWidget {
  const _StoriesBar({required this.stories});
  final List<_Story> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) return const _AddStoryButton();
          final s = stories[index - 1];
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.blueAccent],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: Image.network(s.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  if (s.isVerified)
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.verified, size: 16, color: Colors.blue),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 72,
                child: Text(
                  s.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _AddStoryButton extends StatelessWidget {
  const _AddStoryButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, size: 28),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            'Ajouter',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ],
    );
  }
}

class _TrendingCarousel extends StatelessWidget {
  const _TrendingCarousel({required this.items});
  final List<_EventCard> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final e = items[i];
          return SizedBox(
            width: 280,
            child: _EventPreviewCard(event: e),
          );
        },
      ),
    );
  }
}

class _EventPreviewCard extends StatelessWidget {
  const _EventPreviewCard({required this.event});
  final _EventCard event;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(event.imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text('${event.likes} likes', style: const TextStyle(color: Colors.white)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Dès ${event.priceFrom} FCFA', style: const TextStyle(color: Colors.white)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  event.subtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ShortsReel extends StatelessWidget {
  final List<_ClipModel> clips;

  const _ShortsReel({super.key, required this.clips});
  
  @override
  Widget build(BuildContext context) {
    // Faux "shorts" row using PageView for swipeable mini-cards.
    return SizedBox(
      height: 220,
      child: PageView.builder(
        // controller: PageController(viewportFraction: 0.86),
        // itemBuilder: (context, index) {
        //   return Padding(
        //     padding: const EdgeInsets.only(right: 10),
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(20),
        //       child: Stack(
        //         fit: StackFit.expand,
        //         children: [
        //           Image.network('https://picsum.photos/seed/short$index/900/600', fit: BoxFit.cover),
        //           Align(
        //             alignment: Alignment.bottomLeft,
        //             child: Container(
        //               padding: const EdgeInsets.all(12),
        //               decoration: const BoxDecoration(
        //                 gradient: LinearGradient(
        //                   begin: Alignment.bottomCenter,
        //                   end: Alignment.topCenter,
        //                   colors: [Colors.black87, Colors.transparent],
        //                 ),
        //               ),
        //               child: const Text('Highlight • 0:20', style: TextStyle(color: Colors.white)),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   );
        // },
         controller: PageController(viewportFraction: 0.86),
          itemCount: clips.length, // ✅ important
          itemBuilder: (context, index) {
            final clip = clips[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ✅ utiliser mediaPath du clip
                    Image.network(clip.mediaPath, fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                        child: Text(
                          clip.description.isNotEmpty 
                            ? clip.description 
                            : 'Highlight',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final _Article article;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.network(
                  article.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(article.excerpt, maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(article.readTime, style: TextStyle(color: cs.primary)),
                          const Spacer(),
                          Icon(Icons.bookmark_border, color: cs.outline),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBelt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 140,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        children: [
          _PromoCard(
            title: 'Gagne ton billet 🎉',
            caption: 'Scroll & participe au tirage',
            icon: Icons.celebration,
            color: cs.primaryContainer,
          ),
          const SizedBox(width: 12),
          _PromoCard(
            title: '-20% sur concerts',
            caption: 'Code: VIBE20',
            icon: Icons.local_activity,
            color: cs.secondaryContainer,
          ),
          const SizedBox(width: 12),
          _PromoCard(
            title: 'Happy Hour',
            caption: 'Bars partenaires près de toi',
            icon: Icons.local_bar,
            color: cs.tertiaryContainer ?? cs.secondaryContainer,
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.title, required this.caption, required this.icon, required this.color});
  final String title;
  final String caption;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        color: color,
        elevation: 0.6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.black.withOpacity(0.08),
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(caption),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.post});
  final _CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 22, backgroundImage: NetworkImage('https://picsum.photos/seed/user/200/200')),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.user, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(post.timeAgo, style: TextStyle(color: cs.outline)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                ],
              ),
              const SizedBox(height: 10),
              Text(post.text),
              if (post.imageUrl != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(post.imageUrl!, fit: BoxFit.cover),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.favorite_border, color: cs.primary),
                  const SizedBox(width: 6),
                  Text('${post.reactions}'),
                  const SizedBox(width: 18),
                  const Icon(Icons.chat_bubble_outline),
                  const SizedBox(width: 6),
                  Text('${post.comments}'),
                  const Spacer(),
                  const Icon(Icons.share_outlined),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonalStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights, color: cs.primary),
                  const SizedBox(width: 8),
                  const Text('Ton mois en chiffres', style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StatPill(label: 'Événements', value: '3'),
                  _StatPill(label: 'Favoris', value: '12'),
                  _StatPill(label: 'Badges', value: '2'),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: 0.6, minHeight: 8, borderRadius: BorderRadius.circular(10)),
              const SizedBox(height: 6),
              Text('Défi du mois: 5 events (60%)', style: TextStyle(color: cs.outline)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}

class _AgendaList extends StatelessWidget {
  const _AgendaList({required this.items});
  final List<_AgendaItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (a) => ListTile(
              leading: const Icon(Icons.event_available),
              title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${a.time} • ${a.distance}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          )
          .toList(),
    );
  }
}

class _LifestyleMosaic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simple mosaic using GridView inside fixed height; good for moodboard / inspiration
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SizedBox(
        height: 260,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, i) => ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network('https://picsum.photos/seed/life$i/400/400', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _PollAndQuizCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.poll, color: cs.primary),
                  const SizedBox(width: 8),
                  const Text('Sondage rapide', style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Quel type d’événement veux-tu ce week-end ?'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ChoiceChip(label: 'Concert'),
                  _ChoiceChip(label: 'Comedy'),
                  _ChoiceChip(label: 'Soirée club'),
                  _ChoiceChip(label: 'Open mic'),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.quiz, color: cs.primary),
                  const SizedBox(width: 8),
                  const Text('Mini Quiz', style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 10),
              const Text('À quel BPM moyen tourne l’Amapiano ?'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _AnswerButton('100–110'),
                  const SizedBox(width: 8),
                  _AnswerButton('111–120'),
                  const SizedBox(width: 8),
                  _AnswerButton('121–130'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatefulWidget {
  const _AnswerButton(this.label);
  final String label;

  @override
  State<_AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<_AnswerButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => setState(() => selected = !selected),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(widget.label),
      ),
    );
  }
}

class _ChoiceChip extends StatefulWidget {
  const _ChoiceChip({required this.label});
  final String label;

  @override
  State<_ChoiceChip> createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<_ChoiceChip> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.label),
      selected: selected,
      onSelected: (v) => setState(() => selected = v),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _SectionHeaderSliver extends StatelessWidget {
  const _SectionHeaderSliver({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onSeeAll,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
        child: Row(
          children: [
            Icon(icon, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: cs.outline)),
                ],
              ),
            ),
            TextButton(onPressed: onSeeAll, child: const Text('Tout voir')),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// DATA MODELS (lightweight / demo only)
// =============================================================

class _Story {
  final String username;
  final String imageUrl;
  final bool isVerified;
  _Story({required this.username, required this.imageUrl, this.isVerified = false});
}

class _EventCard {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int likes;
  final int priceFrom;
  _EventCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.likes,
    required this.priceFrom,
  });
}

class _Article {
  final String title;
  final String excerpt;
  final String imageUrl;
  final String readTime;
  _Article({required this.title, required this.excerpt, required this.imageUrl, required this.readTime});
}

class _CommunityPost {
  final String user;
  final String text;
  final String? imageUrl;
  final String timeAgo;
  final int reactions;
  final int comments;
  _CommunityPost({
    required this.user,
    required this.text,
    this.imageUrl,
    required this.timeAgo,
    required this.reactions,
    required this.comments,
  });
}

class _AgendaItem {
  final String title;
  final String time;
  final String distance;
  _AgendaItem(this.title, this.time, this.distance);
}

class _ClipModel {
  final String id;
  final String description;
  final String type;
  final String mediaPath;
  final String eventId;
  final UserModel user;

  _ClipModel({
    required this.id,
    required this.description,
    required this.type,
    required this.mediaPath,
    required this.eventId,
    required this.user,
  });
}