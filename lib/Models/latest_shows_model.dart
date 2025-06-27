class LatestShowsModel {
  final List<Show> latesShowsList;
  final int statusCode;

  LatestShowsModel({
    required this.latesShowsList,
    required this.statusCode,
  });

  factory LatestShowsModel.fromJson(Map<String, dynamic> json) {
    return LatestShowsModel(
      latesShowsList: (json['VIDEO_STREAMING_APP'] as List)
          .map((show) => Show.fromJson(show))
          .toList(),
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VIDEO_STREAMING_APP':
          latesShowsList.map((show) => show.toJson()).toList(),
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

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      showId: json['show_id'],
      showTitle: json['show_title'],
      showPoster: json['show_poster'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_id': showId,
      'show_title': showTitle,
      'show_poster': showPoster,
    };
  }
}
