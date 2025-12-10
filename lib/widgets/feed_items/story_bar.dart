import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryBar extends StatelessWidget {
  final Map<String, dynamic> payload;

  const StoryBar({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final stories = payload['stories'] ?? [];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Container(
            width: 80,
            margin: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == stories.length - 1 ? 16 : 8,
            ),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: story['image'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  story['name'] ?? '',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}