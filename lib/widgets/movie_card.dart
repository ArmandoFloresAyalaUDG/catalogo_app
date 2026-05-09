import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  Color _posterColor() {
    const map = {
      'sand':   Color(0xFFD4A96A),
      'dark':   Color(0xFF2C2C3E),
      'noir':   Color(0xFF1A1A2E),
      'pastel': Color(0xFFE8C4C4),
      'blue':   Color(0xFF4A7FA5),
      'earth':  Color(0xFF7D5A50),
      'green':  Color(0xFF4A7C59),
      'grey':   Color(0xFF6B7280),
    };
    return map[movie.posterColor] ?? const Color(0xFF888888);
  }

  @override
  Widget build(BuildContext context) {
    return Container(                                    // Widget 1: Container
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(                                   // Widget 2: Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(                                       // Widget 3: Stack
            children: [
              Container(
                height: 160,
                color: _posterColor(),
                child: Center(
                  child: Icon(
                    Icons.movie,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(                          // Widget 4: Row (badge rating)
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.white),
                      const SizedBox(width: 3),
                      Text(                           // Widget 5: Text (rating)
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            child: Text(                               // Text: título
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(                                // Row: género + año
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(                         // Text: género
                    movie.genre,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                Text(                                  // Text: año
                  movie.year.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
