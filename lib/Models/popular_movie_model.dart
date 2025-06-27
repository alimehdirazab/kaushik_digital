class PopularMovieModel {
  final List<Movie> popularMovieList;
  final int statusCode;

  PopularMovieModel({
    required this.popularMovieList,
    required this.statusCode,
  });

  factory PopularMovieModel.fromJson(Map<String, dynamic> json) {
    return PopularMovieModel(
      popularMovieList: (json['VIDEO_STREAMING_APP'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList(),
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VIDEO_STREAMING_APP':
          popularMovieList.map((movie) => movie.toJson()).toList(),
      'status_code': statusCode,
    };
  }
}

class Movie {
  final int movieId;
  final String movieTitle;
  final String moviePoster;
  final String movieDuration;
  final String movieAccess;
  final num price;

  Movie({
    required this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.movieDuration,
    required this.movieAccess,
    this.price = 0.0,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movie_id'],
      movieTitle: json['movie_title'],
      moviePoster: json['movie_poster'],
      movieDuration: json['movie_duration'],
      movieAccess: json['movie_access'],
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
      'movie_title': movieTitle,
      'movie_poster': moviePoster,
      'movie_duration': movieDuration,
      'movie_access': movieAccess,
      'price': price,
    };
  }
}
