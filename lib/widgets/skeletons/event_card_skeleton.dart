import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image bannière
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Container(
                    width: double.infinity,
                    height: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),

                  // Date + Lieu
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description courte
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 220,
                    height: 14,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Boutons / Actions
                  Row(
                    children: [
                      Container(
                        width: 90,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 90,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}