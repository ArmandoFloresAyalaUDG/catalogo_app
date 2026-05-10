import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/movie_details.dart';
import '../providers/favorites_provider.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_section.dart';
import '../widgets/shimmer_card.dart';
import 'video_play_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final Future<MovieDetails> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = TmdbService.getMovieDetails(widget.movie.id);
  }

  void _goToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: FutureBuilder<MovieDetails>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          final details = snapshot.data;
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, movie, details),
              SliverToBoxAdapter(
                child: details == null
                    ? _buildShimmerContent()
                    : _buildContent(context, movie, details),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Movie movie, MovieDetails? details) {
    final backdropUrl = movie.backdropUrl;
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF131313),
      foregroundColor: Colors.white,
      actions: [
        Consumer<FavoritesProvider>(
          builder: (context, provider, _) {
            final isFav = provider.isFavorite(movie.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.bookmark_rounded : Icons.bookmark_outline,
                color: isFav ? const Color(0xFFE50914) : Colors.white,
              ),
              onPressed: () => provider.toggleFavorite(movie),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            backdropUrl != null
                ? CachedNetworkImage(
                    imageUrl: backdropUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ShimmerCard(height: double.infinity, borderRadius: 0),
                    errorWidget: (_, __, ___) =>
                        Container(color: const Color(0xFF2A2A2A)),
                  )
                : Container(color: const Color(0xFF2A2A2A)),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF131313)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerCard(width: 100, height: 150),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerCard(height: 24, width: double.infinity),
                    const SizedBox(height: 8),
                    ShimmerCard(height: 16, width: 120),
                    const SizedBox(height: 8),
                    ShimmerCard(height: 16, width: 80),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ShimmerCard(height: 16, width: 200),
          const SizedBox(height: 8),
          ShimmerCard(height: 80, width: double.infinity),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, Movie movie, MovieDetails details) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: movie.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: movie.posterUrl!,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 150,
                        color: const Color(0xFF2A2A2A),
                        child: const Icon(Icons.movie,
                            color: Colors.white24, size: 32),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      details.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color(0xFFE50914), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          details.ratingLabel,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 12),
                        if (details.year > 0)
                          Text(
                            details.year.toString(),
                            style: const TextStyle(color: Colors.white54),
                          ),
                      ],
                    ),
                    if (details.formattedRuntime.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule,
                              size: 14, color: Colors.white54),
                          const SizedBox(width: 4),
                          Text(
                            details.formattedRuntime,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (details.genres.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: details.genres
                  .map(
                    (g) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFE50914).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        g.name,
                        style: const TextStyle(
                            color: Color(0xFFE50914),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                  .toList(),
            ),
          if (details.tagline != null && details.tagline!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              '"${details.tagline}"',
              style: GoogleFonts.montserrat(
                color: Colors.white54,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (details.overview.isNotEmpty) ...[
            Text(
              'Sinopsis',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              details.overview,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.6),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayScreen(
                    movieId: movie.id,
                    movieTitle: details.title,
                  ),
                ),
              ),
              icon: const Icon(Icons.play_circle_filled, size: 22),
              label: Text(
                'Reproducir',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          MovieSection(
            title: 'Recomendaciones',
            future: TmdbService.getRecommendations(movie.id),
            onMovieTap: _goToDetail,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
