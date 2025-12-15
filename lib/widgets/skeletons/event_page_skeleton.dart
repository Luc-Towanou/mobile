import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPageSkeleton extends StatelessWidget {
  const EventPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _SkeletonBox(width: 120, height: 20),
        backgroundColor: const Color.fromARGB(255, 109, 34, 80),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Statistiques (squelette)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _SkeletonStat(),
                _SkeletonStat(),
                _SkeletonStat(),
                _SkeletonStat(),
              ],
            ),
          ),

          // Barre de recherche + filtres (squelette)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(child: _SkeletonBox(height: 44)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(child: _SkeletonBox(height: 40)),
                    SizedBox(width: 10),
                    _SkeletonBox(width: 90, height: 40),
                  ],
                ),
              ],
            ),
          ),

          // Liste d'items (squelette)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => const _SkeletonEventCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonStat extends StatelessWidget {
  const _SkeletonStat();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SkeletonCircle(size: 24),
        SizedBox(height: 5),
        _SkeletonBox(width: 40, height: 16),
        SizedBox(height: 4),
        _SkeletonBox(width: 50, height: 12),
      ],
    );
  }
}

class _SkeletonEventCard extends StatelessWidget {
  const _SkeletonEventCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          const _SkeletonBox(height: 150),

          // Contenu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Titre + catégorie
                Row(
                  children: const [
                    Expanded(child: _SkeletonBox(height: 20)),
                    SizedBox(width: 10),
                    _SkeletonBox(width: 70, height: 20),
                  ],
                ),
                const SizedBox(height: 12),

                // Date
                Row(
                  children: const [
                    _SkeletonCircle(size: 16),
                    SizedBox(width: 8),
                    _SkeletonBox(width: 160, height: 14),
                  ],
                ),
                const SizedBox(height: 8),

                // Lieu
                Row(
                  children: const [
                    _SkeletonCircle(size: 16),
                    SizedBox(width: 8),
                    Expanded(child: _SkeletonBox(height: 14)),
                  ],
                ),
                const SizedBox(height: 12),

                // Prix + disponibilité + statut
                Row(
                  children: const [
                    _SkeletonBox(width: 80, height: 16),
                    Spacer(),
                    _SkeletonBox(width: 120, height: 14),
                    SizedBox(width: 10),
                    _SkeletonBox(width: 70, height: 24),
                  ],
                ),
                const SizedBox(height: 10),

                // Barre de progression
                const _SkeletonBox(height: 6),
                const SizedBox(height: 6),

                // Pourcentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    _SkeletonBox(width: 80, height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  const _SkeletonBox({this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return _Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      highlightColor: highlightColor,
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;
  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return _Shimmer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: baseColor,
          shape: BoxShape.circle,
        ),
      ),
      highlightColor: highlightColor,
    );
  }
}

/// Shimmer léger sans dépendance externe (Tween + AnimatedOpacity)
class _Shimmer extends StatefulWidget {
  final Widget child;
  final Color highlightColor;
  const _Shimmer({required this.child, required this.highlightColor});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final opacity = 0.3 + (_controller.value * 0.5); // 0.3 → 0.8
        return Stack(
          children: [
            child!,
            Opacity(
              opacity: opacity,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.highlightColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
