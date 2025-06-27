class Show {
  final int showId;
  final String showName;
  final String showInfo;
  final String imdbRating;
  final String showPoster;
  final String showLang;
  final List<Genre> genreList;
  final List<Season> seasonList;
  final List<RelatedShow> relatedShows;

  Show({
    required this.showId,
    required this.showName,
    required this.showInfo,
    required this.imdbRating,
    required this.showPoster,
    required this.showLang,
    required this.genreList,
    required this.seasonList,
    required this.relatedShows,
  });

  // Factory method to parse JSON
  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      showId: json['show_id'],
      showName: json['show_name'],
      showInfo: json['show_info'],
      imdbRating: (json['imdb_rating']),
      showPoster: json['show_poster'],
      showLang: json['show_lang'],
      genreList: (json['genre_list'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      seasonList: (json['season_list'] as List)
          .map((season) => Season.fromJson(season))
          .toList(),
      relatedShows: (json['related_shows'] as List)
          .map((related) => RelatedShow.fromJson(related))
          .toList(),
    );
  }
}

class Genre {
  final String genreId;
  final String genreName;

  Genre({required this.genreId, required this.genreName});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      genreId: json['genre_id'],
      genreName: json['genre_name'],
    );
  }
}

class Season {
  final int seasonId;
  final String seasonName;
  final String seasonPoster;

  Season({
    required this.seasonId,
    required this.seasonName,
    required this.seasonPoster,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonId: json['season_id'],
      seasonName: json['season_name'],
      seasonPoster: json['season_poster'],
    );
  }
}

class RelatedShow {
  final int showId;
  final String showTitle;
  final String showPoster;

  RelatedShow({
    required this.showId,
    required this.showTitle,
    required this.showPoster,
  });

  factory RelatedShow.fromJson(Map<String, dynamic> json) {
    return RelatedShow(
      showId: json['show_id'],
      showTitle: json['show_title'],
      showPoster: json['show_poster'],
    );
  }
}













// class Show {
//   final int showId;
//   final String showName;
//   final String showInfo;
//   final double imdbRating;
//   final String showPoster;
//   final String showLang;
//   final List<Genre> genreList;
//   final List<Season> seasonList;
//   final List<RelatedShow> relatedShows;

//   Show({
//     required this.showId,
//     required this.showName,
//     required this.showInfo,
//     required this.imdbRating,
//     required this.showPoster,
//     required this.showLang,
//     required this.genreList,
//     required this.seasonList,
//     required this.relatedShows,
//   });

//   factory Show.fromJson(Map<String, dynamic> json) {
//     return Show(
//       showId: json['show_id'],
//       showName: json['show_name'],
//       showInfo: json['show_info'],
//       imdbRating: (json['imdb_rating'] as num).toDouble(),
//       showPoster: json['show_poster'],
//       showLang: json['show_lang'],
//       genreList: (json['genre_list'] as List)
//           .map((item) => Genre.fromJson(item))
//           .toList(),
//       seasonList: (json['season_list'] as List)
//           .map((item) => Season.fromJson(item))
//           .toList(),
//       relatedShows: (json['related_shows'] as List)
//           .map((item) => RelatedShow.fromJson(item))
//           .toList(),
//     );
//   }
// }

// class Genre {
//   final int genreId;
//   final String genreName;

//   Genre({required this.genreId, required this.genreName});

//   factory Genre.fromJson(Map<String, dynamic> json) {
//     return Genre(
//       genreId: json['genre_id'],
//       genreName: json['genre_name'],
//     );
//   }
// }

// class Season {
//   final int seasonId;
//   final String seasonName;
//   final String seasonPoster;

//   Season(
//       {required this.seasonId,
//       required this.seasonName,
//       required this.seasonPoster});

//   factory Season.fromJson(Map<String, dynamic> json) {
//     return Season(
//       seasonId: json['season_id'],
//       seasonName: json['season_name'],
//       seasonPoster: json['season_poster'],
//     );
//   }
// }

// class RelatedShow {
//   final int showId;
//   final String showTitle;
//   final String showPoster;

//   RelatedShow(
//       {required this.showId,
//       required this.showTitle,
//       required this.showPoster});

//   factory RelatedShow.fromJson(Map<String, dynamic> json) {
//     return RelatedShow(
//       showId: json['show_id'],
//       showTitle: json['show_title'],
//       showPoster: json['show_poster'],
//     );
//   }
// }
