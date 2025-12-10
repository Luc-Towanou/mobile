import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ArticleCardSkeleton extends StatelessWidget {
  const ArticleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Container(
                        width: 80,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}