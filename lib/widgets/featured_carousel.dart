import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import 'shimmer_card.dart';

class FeaturedCarousel extends StatefulWidget {
  final void Function(Movie) onMovieTap;

  const FeaturedCarousel({super.key, required this.onMovieTap});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final Future<List<Movie>> _future;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _future = TmdbService.getTrendingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ShimmerCard(height: 230, borderRadius: 0);
        }
        final movies = snapshot.data!.take(8).toList();
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: movies.length,
              options: CarouselOptions(
                height: 220,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (i, _) => setState(() => _current = i),
              ),
              itemBuilder: (context, index, _) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () => widget.onMovieTap(movie),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      movie.backdropUrl != null
                          ? CachedNetworkImage(
                              imageUrl: movie.backdropUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  const ShimmerCard(height: 220, borderRadius: 0),
                              errorWidget: (_, __, ___) =>
                                  Container(color: const Color(0xFF2A2A2A)),
                            )
                          : Container(color: const Color(0xFF2A2A2A)),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xCC000000)],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFE50914), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  movie.ratingLabel,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: movies.asMap().entries.map((e) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _current == e.key ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: _current == e.key
                        ? const Color(0xFFE50914)
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
