import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionHeaderSkeleton extends StatelessWidget {
  const SectionHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child:  Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
            SizedBox(height: 4),
            Container(
              width: 150,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

