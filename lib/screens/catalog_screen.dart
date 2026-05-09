import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Catálogo',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE50914),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
        ),
        itemCount: kMovies.length,
        itemBuilder: (context, index) => MovieCard(movie: kMovies[index]),
      ),
    );
  }
}
