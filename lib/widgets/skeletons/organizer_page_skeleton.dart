import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const SkeletonBox({
    required this.height,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
    );
  }
}

Widget organizerSkeletonCard({bool featured = false}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SkeletonBox(
                height: 60,
                width: 60,
                borderRadius: BorderRadius.circular(30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 14, width: 160),
                    SizedBox(height: 8),
                    SkeletonBox(height: 12, width: 120),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (featured) ...[
            const SkeletonBox(height: 12),
            const SizedBox(height: 6),
            const SkeletonBox(height: 12),
            const SizedBox(height: 16),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              SkeletonBox(height: 30, width: 50),
              SkeletonBox(height: 30, width: 50),
              SkeletonBox(height: 30, width: 50),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget postSkeletonCard() {
  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SkeletonBox(
          height: 180,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 14, width: 180),
              SizedBox(height: 6),
              SkeletonBox(height: 12, width: 240),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: const [
              SkeletonBox(height: 12, width: 40),
              SizedBox(width: 16),
              SkeletonBox(height: 12, width: 40),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget statisticsSkeleton() {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        SkeletonBox(height: 30, width: 60),
        SkeletonBox(height: 30, width: 60),
        SkeletonBox(height: 30, width: 60),
      ],
    ),
  );
}

class OrganizersPageSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisateurs & Actualités'),
        backgroundColor: const Color.fromARGB(255, 109, 34, 80),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: SkeletonBox(height: 18, width: 220),
            ),

            organizerSkeletonCard(featured: true),

            const Padding(
              padding: EdgeInsets.all(16),
              child: SkeletonBox(height: 18, width: 200),
            ),

            ...List.generate(3, (_) => organizerSkeletonCard()),

            const SizedBox(height: 12),

            statisticsSkeleton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
