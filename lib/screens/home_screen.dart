import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Catálogo de Películas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
        ),
        itemCount: kMovies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: kMovies[index]);
        },
      ),
    );
  }
}
