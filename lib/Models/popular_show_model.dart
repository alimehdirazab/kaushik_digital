class PopularShowModel {
  final List<Show> shows;
  final int statusCode;

  PopularShowModel({required this.shows, required this.statusCode});

  // Factory method to create an instance from JSON
  factory PopularShowModel.fromJson(Map<String, dynamic> json) {
    return PopularShowModel(
      shows: (json['VIDEO_STREAMING_APP'] as List<dynamic>)
          .map((e) => Show.fromJson(e))
          .toList(),
      statusCode: json['status_code'] as int,
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'VIDEO_STREAMING_APP': shows.map((e) => e.toJson()).toList(),
      'status_code': statusCode,
    };
  }
}

class Show {
  final int showId;
  final String showTitle;
  final String showPoster;

  Show({
    required this.showId,
    required this.showTitle,
    required this.showPoster,
  });

  // Factory method to create an instance from JSON
  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      showId: json['show_id'] as int,
      showTitle: json['show_title'] as String,
      showPoster: json['show_poster'] as String,
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'show_id': showId,
      'show_title': showTitle,
      'show_poster': showPoster,
    };
  }
}
