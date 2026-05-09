class Movie {
  final String title;
  final String genre;
  final int year;
  final double rating;
  final String posterColor;

  const Movie({
    required this.title,
    required this.genre,
    required this.year,
    required this.rating,
    required this.posterColor,
  });
}

const List<Movie> kMovies = [
  Movie(title: 'Dune: Part Two',       genre: 'Sci-Fi',   year: 2024, rating: 8.5, posterColor: 'sand'),
  Movie(title: 'Oppenheimer',          genre: 'Drama',    year: 2023, rating: 8.9, posterColor: 'dark'),
  Movie(title: 'The Batman',           genre: 'Acción',   year: 2022, rating: 7.8, posterColor: 'noir'),
  Movie(title: 'Poor Things',          genre: 'Fantasía', year: 2023, rating: 8.0, posterColor: 'pastel'),
  Movie(title: 'Past Lives',           genre: 'Romance',  year: 2023, rating: 7.9, posterColor: 'blue'),
  Movie(title: 'Killers of the Moon',  genre: 'Western',  year: 2023, rating: 7.6, posterColor: 'earth'),
  Movie(title: 'Godzilla x Kong',      genre: 'Acción',   year: 2024, rating: 6.3, posterColor: 'green'),
  Movie(title: 'Civil War',            genre: 'Thriller', year: 2024, rating: 7.1, posterColor: 'grey'),
];
