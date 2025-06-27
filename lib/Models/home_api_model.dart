class VideoStreamingApp {
  final List<SliderItem> slider;
  final List<Movie> latestMovies;
  final List<Show> latestShows;
  final List<Movie> popularMovies;
  final List<Show> popularShows;

  VideoStreamingApp({
    required this.slider,
    required this.latestMovies,
    required this.latestShows,
    required this.popularMovies,
    required this.popularShows,
  });

  factory VideoStreamingApp.fromJson(Map<String, dynamic> json) {
    return VideoStreamingApp(
      slider: (json['slider'] as List)
          .map((item) => SliderItem.fromJson(item))
          .toList(),
      latestMovies: (json['latest_movies'] as List)
          .map((item) => Movie.fromJson(item))
          .toList(),
      latestShows: (json['latest_shows'] as List)
          .map((item) => Show.fromJson(item))
          .toList(),
      popularMovies: (json['popular_movies'] as List)
          .map((item) => Movie.fromJson(item))
          .toList(),
      popularShows: (json['popular_shows'] as List)
          .map((item) => Show.fromJson(item))
          .toList(),
    );
  }
}

class SliderItem {
  final String sliderTitle;
  final String sliderType;
  final int sliderPostId;
  final String sliderImage;

  SliderItem({
    required this.sliderTitle,
    required this.sliderType,
    required this.sliderPostId,
    required this.sliderImage,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      sliderTitle: json['slider_title'],
      sliderType: json['slider_type'],
      sliderPostId: json['slider_post_id'],
      sliderImage: json['slider_image'],
    );
  }
}

class Movie {
  final int movieId;
  final String movieTitle;
  final String moviePoster;
  final String movieDuration;
  final String movieAccess;
  final num? moviePrice;

  Movie({
    required this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.movieDuration,
    required this.movieAccess,
    this.moviePrice,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movie_id'],
      movieTitle: json['movie_title'],
      moviePoster: json['movie_poster'],
      movieDuration: json['movie_duration'],
      movieAccess: json['movie_access'],
      moviePrice: json['price'],
    );
  }
}

class Show {
  final int showId;
  final String showTitle;
  final String showPoster;
  final num? showPrice;

  Show({
    required this.showId,
    required this.showTitle,
    required this.showPoster,
    this.showPrice,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      showId: json['show_id'],
      showTitle: json['show_title'],
      showPoster: json['show_poster'],
      showPrice: json['price'],
    );
  }
}
