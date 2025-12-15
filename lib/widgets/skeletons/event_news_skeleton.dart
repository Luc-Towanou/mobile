import 'package:flutter/material.dart';

class EventNewsSkeleton extends StatelessWidget {
  const EventNewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// STORIES
              _storiesSkeleton(),

              const SizedBox(height: 24),

              /// TRENDING / CLIPS
              _horizontalCardsSkeleton(),

              const SizedBox(height: 24),

              /// ARTICLES
              _articleSkeleton(),

              const SizedBox(height: 24),

              /// PROMOS
              _promoSkeleton(),

              const SizedBox(height: 24),

              /// COMMUNITY POSTS
              _communitySkeleton(),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── STORIES
  Widget _storiesSkeleton() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Column(
          children: [
            _circle(60),
            const SizedBox(height: 6),
            _line(width: 40),
          ],
        ),
      ),
    );
  }

  // ───────────────── CLIPS / EVENTS
  Widget _horizontalCardsSkeleton() {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => _rect(
          height: 220,
          width: 160,
          radius: 16,
        ),
      ),
    );
  }

  // ───────────────── ARTICLES
  Widget _articleSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(2, (_) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                _rect(height: 80, width: 100, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(width: double.infinity),
                      const SizedBox(height: 8),
                      _line(width: 150),
                      const SizedBox(height: 8),
                      _line(width: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ───────────────── PROMO
  Widget _promoSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _rect(
        height: 120,
        width: double.infinity,
        radius: 16,
      ),
    );
  }

  // ───────────────── COMMUNITY POSTS
  Widget _communitySkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(2, (_) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _circle(40),
                    const SizedBox(width: 12),
                    _line(width: 120),
                  ],
                ),
                const SizedBox(height: 12),
                _line(width: double.infinity),
                const SizedBox(height: 8),
                _line(width: double.infinity),
                const SizedBox(height: 8),
                _line(width: 180),
                const SizedBox(height: 12),
                _rect(height: 160, width: double.infinity, radius: 12),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ───────────────── HELPERS
  Widget _circle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _line({double width = 100, double height = 12}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _rect({
    required double height,
    required double width,
    double radius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
