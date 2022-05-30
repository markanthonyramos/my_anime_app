class Anime {
  final int animeId;
  final String title;
  final String coverImageUrl;
  final int totalSeasons;

  Anime({
    required this.animeId,
    required this.title,
    required this.totalSeasons,
    required this.coverImageUrl,
  });

  factory Anime.fromJson(Map json) {
    return Anime(
        animeId: json['anime_id'],
        title: json['title'],
        coverImageUrl: json['cover_image_url'],
        totalSeasons: json['total_seasons']);
  }

  static List<Anime> parseAnimeJsonList(List json) {
    return json.map((animeJson) {
      return Anime.fromJson(animeJson);
    }).toList();
  }
}
