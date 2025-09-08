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
    // Handle the nested VIDEO_STREAMING_APP structure
    final appData = json['VIDEO_STREAMING_APP'] as Map<String, dynamic>? ?? json;
    
    return VideoStreamingApp(
      slider: _parseSlider(appData['slider']),
      latestMovies: _parseMovies(appData['featured_movies']),
      latestShows: _parseShows(appData['web_series']),
      popularMovies: _parseMoviesFromAlbums(appData['short_movies']),
      popularShows: _parseShowsFromAlbums(appData['video_albums']),
    );
  }

  // Helper method to safely parse slider data
  static List<SliderItem> _parseSlider(dynamic sliderData) {
    if (sliderData is List) {
      return sliderData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => SliderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Helper method to safely parse movies data
  static List<Movie> _parseMovies(dynamic moviesData) {
    if (moviesData is List) {
      return moviesData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Helper method to safely parse shows data
  static List<Show> _parseShows(dynamic showsData) {
    if (showsData is List) {
      return showsData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => Show.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Helper method to parse movies from album format
  static List<Movie> _parseMoviesFromAlbums(dynamic albumsData) {
    if (albumsData is List) {
      return albumsData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => Movie.fromAlbumJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  // Helper method to parse shows from album format
  static List<Show> _parseShowsFromAlbums(dynamic albumsData) {
    if (albumsData is List) {
      return albumsData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => Show.fromAlbumJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}

class SliderItem {
  final String sliderTitle;
  final String sliderType;
  final int? sliderPostId;
  final String sliderImage;

  SliderItem({
    required this.sliderTitle,
    required this.sliderType,
    this.sliderPostId,
    required this.sliderImage,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      sliderTitle: json['slider_title'] ?? '',
      sliderType: json['slider_type'] ?? '',
      sliderPostId: json['slider_post_id'],
      sliderImage: json['slider_image'] ?? '',
    );
  }
}

class Movie {
  final int? movieId;
  final String movieTitle;
  final String moviePoster;
  final String movieDuration;
  final String movieAccess;
  final num? moviePrice;
  final String? movieUrl;
  final String? videoType;

  Movie({
    this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.movieDuration,
    required this.movieAccess,
    this.moviePrice,
    this.movieUrl,
    this.videoType,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movie_id'],
      movieTitle: json['movie_title'] ?? '',
      moviePoster: json['movie_poster'] ?? '',
      movieDuration: json['movie_duration'] ?? '',
      movieAccess: json['movie_access'] ?? '',
      moviePrice: json['price'],
      movieUrl: json['movie_url'],
      videoType: json['video_type'],
    );
  }

  // Factory constructor for album format (used by short_movies)
  factory Movie.fromAlbumJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['album_id'],
      movieTitle: json['album_title'] ?? '',
      moviePoster: json['album_poster'] ?? '',
      movieDuration: json['album_duration'] ?? '',
      movieAccess: json['album_access'] ?? '',
      moviePrice: json['price'],
      movieUrl: json['album_url'],
      videoType: json['video_type'],
    );
  }
}

class Show {
  final int? showId;
  final String showTitle;
  final String showPoster;
  final num? showPrice;

  Show({
    this.showId,
    required this.showTitle,
    required this.showPoster,
    this.showPrice,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      showId: json['show_id'],
      showTitle: json['show_title'] ?? '',
      showPoster: json['show_poster'] ?? '',
      showPrice: json['price'],
    );
  }

  // Factory constructor for album format (used by video_albums)
  factory Show.fromAlbumJson(Map<String, dynamic> json) {
    return Show(
      showId: json['album_id'],
      showTitle: json['album_title'] ?? '',
      showPoster: json['album_poster'] ?? '',
      showPrice: json['price'],
    );
  }
}
