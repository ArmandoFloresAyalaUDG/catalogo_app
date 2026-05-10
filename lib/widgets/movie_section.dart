import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie.dart';
import 'movie_card.dart';
import 'shimmer_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final Future<List<Movie>> future;
  final void Function(Movie) onMovieTap;

  const MovieSection({
    super.key,
    required this.title,
    required this.future,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 5,
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ShimmerCard(width: 120, height: 200),
                  ),
                ),
              );
            }
            final movies = snapshot.data!;
            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return SizedBox(
                    width: 120,
                    child: MovieCard(
                      movie: movie,
                      compact: true,
                      onTap: () => onMovieTap(movie),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
