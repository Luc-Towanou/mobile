import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> payload;

  const ArticleCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (payload['img'] != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: CachedNetworkImage(
                imageUrl: payload['img'],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  height: 150,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payload['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  payload['excerpt'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${payload['read_time'] ?? 5} min de lecture'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Naviguer vers l'article complet
                      },
                      child: const Text('Lire plus'),
                    ),
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