import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tmdb_service.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/movie_section.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  void _goToDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  'CineHub',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE50914),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              FeaturedCarousel(
                onMovieTap: (movie) => _goToDetail(context, movie),
              ),
              MovieSection(
                title: 'Tendencias',
                future: TmdbService.getTrendingMovies(),
                onMovieTap: (movie) => _goToDetail(context, movie),
              ),
              MovieSection(
                title: 'Populares',
                future: TmdbService.getPopularMovies(),
                onMovieTap: (movie) => _goToDetail(context, movie),
              ),
              MovieSection(
                title: 'Mejor Calificadas',
                future: TmdbService.getTopRatedMovies(),
                onMovieTap: (movie) => _goToDetail(context, movie),
              ),
              MovieSection(
                title: 'Próximos Estrenos',
                future: TmdbService.getUpcomingMovies(),
                onMovieTap: (movie) => _goToDetail(context, movie),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
