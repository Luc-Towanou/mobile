import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrganizerCard extends StatelessWidget {
  final Map<String, dynamic> payload;

  const OrganizerCard({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(
                    payload['avatar'] ?? '',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payload['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payload['category'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${payload['rating'] ?? '4.8'}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.people, size: 16),
                          const SizedBox(width: 4),
                          Text('${payload['followers'] ?? '0'} abonnés'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Suivre l'organisateur
                  },
                  child: const Text('Suivre'),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Voir le profil
                  },
                  child: const Text('Voir profil'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}