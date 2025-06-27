class LatesMovieModel {
    final List<VideoStreamingApp>? videoStreamingApp;
    final int? statusCode;

    LatesMovieModel({
        this.videoStreamingApp,
        this.statusCode,
    });

    LatesMovieModel copyWith({
        List<VideoStreamingApp>? videoStreamingApp,
        int? statusCode,
    }) => 
        LatesMovieModel(
            videoStreamingApp: videoStreamingApp ?? this.videoStreamingApp,
            statusCode: statusCode ?? this.statusCode,
        );

    factory LatesMovieModel.fromJson(Map<String, dynamic> json) => LatesMovieModel(
        videoStreamingApp: json["VIDEO_STREAMING_APP"] == null ? [] : List<VideoStreamingApp>.from(json["VIDEO_STREAMING_APP"]!.map((x) => VideoStreamingApp.fromJson(x))),
        statusCode: json["status_code"],
    );

    Map<String, dynamic> toJson() => {
        "VIDEO_STREAMING_APP": videoStreamingApp == null ? [] : List<dynamic>.from(videoStreamingApp!.map((x) => x.toJson())),
        "status_code": statusCode,
    };
}

class VideoStreamingApp {
    final int? movieId;
    final String? movieTitle;
    final String? moviePoster;
    final String? movieDuration;
    final String? movieAccess;
    final int? price;

    VideoStreamingApp({
        this.movieId,
        this.movieTitle,
        this.moviePoster,
        this.movieDuration,
        this.movieAccess,
        this.price,
    });

    VideoStreamingApp copyWith({
        int? movieId,
        String? movieTitle,
        String? moviePoster,
        String? movieDuration,
        String? movieAccess,
        int? price,
    }) => 
        VideoStreamingApp(
            movieId: movieId ?? this.movieId,
            movieTitle: movieTitle ?? this.movieTitle,
            moviePoster: moviePoster ?? this.moviePoster,
            movieDuration: movieDuration ?? this.movieDuration,
            movieAccess: movieAccess ?? this.movieAccess,
            price: price ?? this.price,
        );

    factory VideoStreamingApp.fromJson(Map<String, dynamic> json) => VideoStreamingApp(
        movieId: json["movie_id"],
        movieTitle: json["movie_title"],
        moviePoster: json["movie_poster"],
        movieDuration: json["movie_duration"],
        movieAccess: json["movie_access"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "movie_id": movieId,
        "movie_title": movieTitle,
        "movie_poster": moviePoster,
        "movie_duration": movieDuration,
        "movie_access": movieAccess,
        "price": price,
    };
}
